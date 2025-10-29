#!/usr/bin/env zsh
# force-quit-app.sh
# Fuzzy finder para forzar cierre de aplicaciones en macOS (kill -9)

force_quit_app() {
    # Obtener lista de aplicaciones abiertas (sin apps de background)
    local apps=$(osascript -e 'tell application "System Events" to get name of (processes where background only is false)' 2>/dev/null)

    if [[ -z "$apps" ]]; then
        echo "Error: No se pudieron obtener las aplicaciones abiertas"
        return 1
    fi

    # Convertir la lista separada por comas a líneas
    apps=$(echo "$apps" | tr ', ' '\n' | sort)

    # Mostrar en fzf con preview y opciones
    local selected=$(echo "$apps" | fzf \
        --prompt="Force quit ❯ " \
        --height=50% \
        --border=rounded \
        --border-label=" Force Quit Application " \
        --preview="echo '💀 Press ENTER to force quit:\n\n   {}\n\n⚠️  WARNING: Unsaved changes will be lost!'" \
        --preview-window=up:7:wrap \
        --color="border:#f38ba8,label:#eba0ac,preview-border:#f38ba8" \
        --header="ESC to cancel | Force quit = kill -9")

    # Si se seleccionó una app, forzar cierre
    if [[ -n "$selected" ]]; then
        # Confirmación fuerte
        echo -n "⚠️  FORCE QUIT '$selected'? This will kill the process immediately! [y/N] "
        read -r confirm

        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            echo "Force quitting: $selected"

            # Obtener el PID del proceso
            local pid=$(pgrep -x "$selected" | head -1)

            if [[ -n "$pid" ]]; then
                kill -9 "$pid" 2>/dev/null

                if [[ $? -eq 0 ]]; then
                    echo "✓ Successfully force quit: $selected (PID: $pid)"
                else
                    echo "✗ Failed to force quit: $selected"
                    return 1
                fi
            else
                echo "✗ Could not find process: $selected"
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
force_quit_app "$@"
