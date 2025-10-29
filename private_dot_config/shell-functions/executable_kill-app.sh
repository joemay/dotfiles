#!/usr/bin/env zsh
# kill-app.sh
# Fuzzy finder para cerrar aplicaciones abiertas gracefully en macOS

kill_app() {
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
        --prompt="Quit app ❯ " \
        --height=50% \
        --border=rounded \
        --border-label=" Close Application " \
        --preview="echo '⚠️  Press ENTER to quit:\n\n   {}'" \
        --preview-window=up:5:wrap \
        --color="border:#f38ba8,label:#f9e2af,preview-border:#f38ba8" \
        --header="ESC to cancel")

    # Si se seleccionó una app, cerrarla
    if [[ -n "$selected" ]]; then
        # Confirmación
        echo -n "Are you sure you want to quit '$selected'? [y/N] "
        read -r confirm

        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            echo "Closing: $selected"
            osascript -e "tell application \"$selected\" to quit" 2>/dev/null

            if [[ $? -eq 0 ]]; then
                echo "✓ Successfully quit: $selected"
            else
                echo "✗ Failed to quit: $selected (app may not respond to quit command)"
                return 1
            fi
        else
            echo "Cancelled"
            return 0
        fi
    else
        echo "Cancelled"
        return 0
    fi
}

# Ejecutar la función
kill_app "$@"
