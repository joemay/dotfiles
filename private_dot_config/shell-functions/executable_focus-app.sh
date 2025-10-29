#!/usr/bin/env zsh
# focus-app.sh
# Fuzzy finder para cambiar/enfocar aplicaciones abiertas en macOS

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

    # Si se seleccionó una app, activarla
    if [[ -n "$selected" ]]; then
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
