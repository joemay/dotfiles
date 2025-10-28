# iTerm2 Tab Color Manager

Sistema de gestión de colores y emojis de pestañas de iTerm2 basado en YAML.

## 📍 Ubicación de archivos

- **Configuración**: `~/.config/iterm2-colors/config.yml`
- **Script manager**: `~/.config/iterm2-colors/iterm2-color-manager.sh`
- **Integración**: `~/.zshrc` (automático)

## 🎨 Cómo funciona

El sistema cambia automáticamente el color y título de las pestañas de iTerm2 basándose en:

1. **Directorio actual**: Detecta patrones en la ruta del directorio y cambia el color
2. **Programa ejecutado**: Detecta qué programa estás ejecutando y cambia:
   - **Color** de la pestaña
   - **Título** de la pestaña con un **emoji** identificador

## ⚙️ Configuración

### Agregar color para un directorio

Edita `~/.config/iterm2-colors/config.yml`:

```yaml
directories:
  - path: "/ruta/completa/al/proyecto"
    color: [255, 200, 100]  # RGB (0-255)
    description: "Descripción del proyecto"
```

### Usar patrones con wildcard

```yaml
  - path: "*/nombre-carpeta*"
    color: [100, 150, 255]
    description: "Cualquier carpeta que contenga 'nombre-carpeta'"
```

### Agregar color y emoji para un programa

```yaml
programs:
  - name: "docker"
    color: [33, 150, 243]   # Color de la pestaña
    emoji: "🐳"              # Emoji en el título
    description: "Docker commands"
```

## 🎨 Colores RGB predefinidos

- **Rojo**: [255, 100, 100]
- **Verde**: [100, 255, 100]
- **Azul**: [100, 100, 255]
- **Amarillo**: [255, 200, 100]
- **Naranja**: [255, 150, 100]
- **Púrpura**: [139, 69, 255]
- **Cyan**: [100, 200, 255]
- **Rosa**: [255, 100, 200]

## 😀 Emojis sugeridos por categoría

### Editores y desarrollo
- ✏️ Editor de texto (nvim, vim)
- 💻 IDE
- 📝 Markdown editor

### IA y asistentes
- 🤖 Claude Code, AI tools
- 🧠 Machine learning
- ✨ AI assistants

### Herramientas de desarrollo
- 🐳 Docker
- 📦 Package managers (npm, yarn)
- 🔀 Git, control de versiones
- 🟢 Node.js, JavaScript runtime

### Lenguajes de programación
- 🐍 Python
- ☕ Java
- 🦀 Rust
- 🐹 Go
- 💎 Ruby

### Bases de datos
- 🗄️ Bases de datos SQL
- 💾 Redis, cache
- 🍃 MongoDB

### Sistemas y DevOps
- 🔐 SSH, conexiones seguras
- 🖥️ Terminal multiplexers (tmux)
- 📊 Monitoring (htop, top)
- ⚙️ Configuración
- 🚀 Deploy, CI/CD

## 🔄 Aplicar cambios

Después de editar `config.yml`:

```bash
source ~/.zshrc
```

O simplemente abre una nueva pestaña en iTerm2.

## 📝 Ejemplos de configuración

### Proyectos específicos

```yaml
directories:
  - path: "/Users/joseluis/Dev/mi-proyecto"
    color: [255, 100, 100]  # Rojo
    description: "Mi proyecto importante"

  - path: "/Users/joseluis/Dev/cliente-*"
    color: [100, 255, 100]  # Verde para cualquier proyecto de cliente
    description: "Proyectos de clientes"
```

### Programas adicionales con emojis

```yaml
programs:
  - name: "python"
    color: [255, 213, 79]
    emoji: "🐍"
    description: "Python REPL"

  - name: "node"
    color: [104, 160, 99]
    emoji: "🟢"
    description: "Node.js"

  - name: "docker"
    color: [33, 150, 243]
    emoji: "🐳"
    description: "Docker CLI"

  - name: "claude"
    color: [255, 150, 100]
    emoji: "🤖"
    description: "Claude Code AI"
```

**Resultado**: Cuando ejecutes `python`, la pestaña se pondrá amarilla y mostrará "🐍 python" como título.

## 🛠️ Solución de problemas

### Los colores no cambian

1. Verifica que estés usando iTerm2 (no funciona en Terminal.app)
2. Recargar configuración: `source ~/.zshrc`
3. Verifica sintaxis del YAML: https://www.yamllint.com/

### Debugging

Para ver qué color se aplicaría a un directorio:

```bash
source ~/.config/iterm2-colors/iterm2-color-manager.sh
get_color_for_directory "/ruta/al/directorio"
```

## 💡 Tips

- Los patrones se evalúan en orden - el primero que coincida se aplica
- Usa rutas absolutas para proyectos específicos
- Usa wildcards `*` para patrones más flexibles
- Los valores RGB van de 0 a 255
