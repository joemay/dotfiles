#!/usr/bin/env zsh
# focus-app.sh
# Fuzzy finder para cambiar/enfocar aplicaciones y sus ventanas en macOS

focus_app() {
    # Obtener lista de aplicaciones abiertas (sin apps de background)
    local apps=$(osascript -e 'tell application "System Events" to get name of (processes where background only is false)' 2>/dev/null)

    if [[ -z "$apps" ]]; then
        echo "Error: No se pudieron obtener las aplicaciones abiertas"
        return 1
    fi

    # Convertir la lista separada por comas a líneas y eliminar duplicados
    # Usar sed para separar solo por ", " (coma + espacio) para no romper nombres con espacios
    # También filtrar algunos procesos helper comunes
    apps=$(echo "$apps" | sed 's/, /\n/g' | \
           grep -v "^app_mode_loader$" | \
           grep -v "Helper$" | \
           grep -v "^$" | \
           sort -u)

    # Mostrar en fzf con preview y opciones
    local selected=$(echo "$apps" | fzf \
        --prompt="Focus app ❯ " \
        --height=50% \
        --border=rounded \
        --border-label=" Running Applications " \
        --preview="echo '🎯 Press ENTER to focus:\n\n   {}'" \
        --preview-window=up:5:wrap \
        --color="border:#89b4fa,label:#cba6f7,preview-border:#89b4fa" \
        --header="ESC to cancel")

    # Si se seleccionó una app
    if [[ -n "$selected" ]]; then
        # Contar cuántas ventanas tiene la aplicación
        local window_count=$(osascript 2>/dev/null << EOF
tell application "System Events"
    tell process "$selected"
        count windows
    end tell
end tell
EOF
)

        # Si tiene más de 1 ventana, ofrecer selector de ventanas
        if [[ "$window_count" -gt 1 ]]; then
            echo "App has $window_count windows. Fetching window list..."

            # Obtener lista de ventanas con sus títulos
            local windows=$(osascript 2>/dev/null << EOF
tell application "System Events"
    tell process "$selected"
        set windowList to ""
        repeat with w in windows
            set windowTitle to name of w
            set windowList to windowList & windowTitle & "\n"
        end repeat
        return windowList
    end tell
end tell
EOF
)

            # Si se pudieron obtener las ventanas, mostrar selector
            if [[ -n "$windows" ]]; then
                local selected_window=$(echo "$windows" | fzf \
                    --prompt="Select window ❯ " \
                    --height=50% \
                    --border=rounded \
                    --border-label=" $selected - Windows " \
                    --preview="echo '🪟 Window:\n\n   {}'" \
                    --preview-window=up:5:wrap \
                    --color="border:#89b4fa,label:#cba6f7,preview-border:#89b4fa" \
                    --header="ESC to activate app without selecting window")

                # Si se seleccionó una ventana específica
                if [[ -n "$selected_window" ]]; then
                    echo "Focusing window: $selected_window"
                    osascript 2>/dev/null << EOF
tell application "System Events"
    tell process "$selected"
        set frontmost to true
        perform action "AXRaise" of (first window whose name is "$selected_window")
    end tell
end tell
EOF
                    if [[ $? -eq 0 ]]; then
                        echo "✓ Successfully focused window: $selected_window"
                        return 0
                    else
                        echo "⚠ Falling back to activating app"
                    fi
                else
                    echo "No window selected, activating app..."
                fi
            fi
        fi

        # Activar la aplicación (fallback o cuando solo hay 1 ventana)
        echo "Switching to: $selected"
        osascript -e "tell application \"$selected\" to activate" 2>/dev/null

        if [[ $? -eq 0 ]]; then
            echo "✓ Successfully focused: $selected"
        else
            echo "✗ Failed to focus: $selected"
            return 1
        fi
    else
        echo "Cancelled"
        return 0
    fi
}

# Ejecutar la función
focus_app "$@"
