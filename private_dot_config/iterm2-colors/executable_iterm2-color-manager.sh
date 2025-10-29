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
            if [[ "$line" =~ path:[[:space:]]+\"([^\"]+)\" ]]; then
                # En zsh, capturar inmediatamente antes de que se sobrescriba
                current_path="$match[1]"
            fi

            # Buscar color (usar variable para evitar problemas con [] en zsh)
            local color_pattern='color:.*\[([0-9]+), ([0-9]+), ([0-9]+)\]'
            if [[ "$line" =~ $color_pattern ]]; then
                # En zsh, capturar inmediatamente
                local r="${match[1]}"
                local g="${match[2]}"
                local b="${match[3]}"
                color="$r $g $b"

                # Convertir pattern a regex
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
            # Buscar name
            if [[ "$line" =~ name:\ \"(.+)\" ]] || [[ "$line" =~ name:\ \'(.+)\' ]]; then
                current_name="$match[1]"
            fi

            # Buscar color (usar variable para evitar problemas con [] en zsh)
            local color_pattern='color:.*\[([0-9]+), ([0-9]+), ([0-9]+)\]'
            if [[ "$line" =~ $color_pattern ]]; then
                local r="${match[1]}"
                local g="${match[2]}"
                local b="${match[3]}"
                color="$r $g $b"

                # Verificar si el programa coincide
                if [[ "$program_name" == "$current_name" ]]; then
                    echo "$color"
                    return 0
                fi

                # Resetear para la siguiente entrada
                current_name=""
                color=""
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

# Aplicar color para programa
apply_color_for_program() {
    local program="$1"

    if [[ ! -f "$CONFIG_FILE" ]]; then
        return 1
    fi

    local color_values
    color_values=$(get_color_for_program "$program")

    if [[ -n "$color_values" ]]; then
        read -r r g b <<< "$color_values"
        iterm2_set_tab_color "$r" "$g" "$b"
        return 0
    fi

    return 1
}

# Las funciones en zsh están disponibles automáticamente cuando se hace source
# No se necesita exportarlas como en bash
