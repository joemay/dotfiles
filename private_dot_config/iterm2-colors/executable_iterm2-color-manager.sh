#!/bin/bash
# iTerm2 Color Manager
# Gestiona colores de pestañas basado en configuración YAML

CONFIG_FILE="${HOME}/.config/iterm2-colors/config.yml"

# Función para cambiar el color del tab
iterm2_set_tab_color() {
    echo -ne "\033]6;1;bg;red;brightness;$1\a"
    echo -ne "\033]6;1;bg;green;brightness;$2\a"
    echo -ne "\033]6;1;bg;blue;brightness;$3\a"
}

# Función para resetear el color del tab
iterm2_reset_tab_color() {
    echo -ne "\033]6;1;bg;*;default\a"
}

# Función para cambiar el título del tab
iterm2_set_tab_title() {
    echo -ne "\033]0;$1\007"
}

# Función para parsear YAML simple (sin dependencias externas)
# Busca el color correspondiente al directorio actual
get_color_for_directory() {
    local current_dir="$1"
    local in_directories=0
    local current_path=""
    local color=""

    while IFS= read -r line; do
        # Detectar sección de directorios
        if [[ "$line" =~ ^directories: ]]; then
            in_directories=1
            continue
        fi

        # Salir de la sección si encontramos otra sección principal
        if [[ "$line" =~ ^[a-z]+: ]] && [[ ! "$line" =~ ^directories: ]]; then
            in_directories=0
            continue
        fi

        if [[ $in_directories -eq 1 ]]; then
            # Buscar path
            if [[ "$line" =~ path:\ \"(.+)\" ]] || [[ "$line" =~ path:\ \'(.+)\' ]]; then
                current_path="${BASH_REMATCH[1]}"
            fi

            # Buscar color
            if [[ "$line" =~ color:\ \[([0-9]+),\ ([0-9]+),\ ([0-9]+)\] ]]; then
                color="${BASH_REMATCH[1]} ${BASH_REMATCH[2]} ${BASH_REMATCH[3]}"

                # Convertir pattern a regex bash
                local pattern="${current_path//\*/.*}"

                # Verificar si el directorio actual coincide con el patrón
                if [[ "$current_dir" =~ $pattern ]]; then
                    echo "$color"
                    return 0
                fi

                # Resetear para la siguiente entrada
                current_path=""
                color=""
            fi
        fi
    done < "$CONFIG_FILE"

    echo ""
    return 1
}

# Función para obtener color de un programa
get_color_for_program() {
    local program_name="$1"
    local in_programs=0
    local current_name=""
    local color=""
    local found_name=0

    while IFS= read -r line; do
        # Detectar sección de programas
        if [[ "$line" =~ ^programs: ]]; then
            in_programs=1
            continue
        fi

        # Salir de la sección si encontramos otra sección principal
        if [[ "$line" =~ ^[a-z]+: ]] && [[ ! "$line" =~ ^programs: ]]; then
            in_programs=0
            continue
        fi

        if [[ $in_programs -eq 1 ]]; then
            # Detectar nueva entrada (línea que empieza con "  - name:")
            if [[ "$line" =~ ^[[:space:]]*-[[:space:]]+name: ]]; then
                # Resetear si empezamos una nueva entrada
                if [[ $found_name -eq 1 ]] && [[ "$program_name" != "$current_name" ]]; then
                    current_name=""
                    color=""
                    found_name=0
                fi
            fi

            # Buscar name
            if [[ "$line" =~ name:[[:space:]]+\"([^\"]+)\" ]]; then
                current_name="${BASH_REMATCH[1]}"
                if [[ "$program_name" == "$current_name" ]]; then
                    found_name=1
                fi
            fi

            # Buscar color (solo si ya encontramos el name correcto)
            if [[ $found_name -eq 1 ]] && [[ "$line" =~ color:[[:space:]]+\[([0-9]+),[[:space:]]+([0-9]+),[[:space:]]+([0-9]+)\] ]]; then
                color="${BASH_REMATCH[1]} ${BASH_REMATCH[2]} ${BASH_REMATCH[3]}"
                echo "$color"
                return 0
            fi
        fi
    done < "$CONFIG_FILE"

    echo ""
    return 1
}

# Función para obtener emoji de un programa
get_emoji_for_program() {
    local program_name="$1"
    local in_programs=0
    local current_name=""
    local emoji=""
    local found_name=0

    while IFS= read -r line; do
        # Detectar sección de programas
        if [[ "$line" =~ ^programs: ]]; then
            in_programs=1
            continue
        fi

        # Salir de la sección si encontramos otra sección principal
        if [[ "$line" =~ ^[a-z]+: ]] && [[ ! "$line" =~ ^programs: ]]; then
            in_programs=0
            continue
        fi

        if [[ $in_programs -eq 1 ]]; then
            # Detectar nueva entrada (línea que empieza con "  - name:")
            if [[ "$line" =~ ^[[:space:]]*-[[:space:]]+name: ]]; then
                # Resetear si empezamos una nueva entrada
                if [[ $found_name -eq 1 ]] && [[ "$program_name" != "$current_name" ]]; then
                    current_name=""
                    emoji=""
                    found_name=0
                fi
            fi

            # Buscar name
            if [[ "$line" =~ name:[[:space:]]+\"([^\"]+)\" ]]; then
                current_name="${BASH_REMATCH[1]}"
                if [[ "$program_name" == "$current_name" ]]; then
                    found_name=1
                fi
            fi

            # Buscar emoji (solo si ya encontramos el name correcto)
            if [[ $found_name -eq 1 ]] && [[ "$line" =~ emoji:[[:space:]]+\"([^\"]+)\" ]]; then
                emoji="${BASH_REMATCH[1]}"
                echo "$emoji"
                return 0
            fi
        fi
    done < "$CONFIG_FILE"

    echo ""
    return 1
}

# Aplicar color para directorio
apply_color_for_directory() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        return 1
    fi

    local color_values
    color_values=$(get_color_for_directory "$PWD")

    if [[ -n "$color_values" ]]; then
        read -r r g b <<< "$color_values"
        iterm2_set_tab_color "$r" "$g" "$b"
        return 0
    else
        iterm2_reset_tab_color
        return 1
    fi
}

# Aplicar color y título para programa
apply_color_for_program() {
    local program="$1"
    local custom_title="$2"  # Título personalizado opcional

    if [[ ! -f "$CONFIG_FILE" ]]; then
        return 1
    fi

    local color_values
    color_values=$(get_color_for_program "$program")

    local emoji_value
    emoji_value=$(get_emoji_for_program "$program")

    # Aplicar color si se encuentra
    if [[ -n "$color_values" ]]; then
        read -r r g b <<< "$color_values"
        iterm2_set_tab_color "$r" "$g" "$b"
    fi

    # Aplicar título con emoji si se encuentra
    if [[ -n "$emoji_value" ]]; then
        if [[ -n "$custom_title" ]]; then
            iterm2_set_tab_title "$emoji_value $custom_title"
        else
            iterm2_set_tab_title "$emoji_value $program"
        fi
        return 0
    fi

    return 1
}

# Exportar funciones para uso en zsh
export -f iterm2_set_tab_color 2>/dev/null || true
export -f iterm2_reset_tab_color 2>/dev/null || true
export -f iterm2_set_tab_title 2>/dev/null || true
export -f get_color_for_directory 2>/dev/null || true
export -f get_color_for_program 2>/dev/null || true
export -f get_emoji_for_program 2>/dev/null || true
export -f apply_color_for_directory 2>/dev/null || true
export -f apply_color_for_program 2>/dev/null || true
