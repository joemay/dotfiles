# iTerm2 Tab Color Manager

Sistema de gestión de colores de pestañas de iTerm2 basado en YAML.

## 📍 Ubicación de archivos

- **Configuración**: `~/.config/iterm2-colors/config.yml`
- **Script manager**: `~/.config/iterm2-colors/iterm2-color-manager.sh`
- **Integración**: `~/.zshrc` (automático)

## 🎨 Cómo funciona

El sistema cambia automáticamente el color de las pestañas de iTerm2 basándose en:

1. **Directorio actual**: Detecta patrones en la ruta del directorio y cambia el color de la pestaña
2. **Programa ejecutado**: Detecta qué programa estás ejecutando y cambia el color de la pestaña

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

### Agregar color para un programa

```yaml
programs:
  - name: "docker"
    color: [33, 150, 243]   # Color de la pestaña (RGB 0-255)
    description: "Docker commands"
```

Nota: El campo `emoji` en el YAML es opcional y actualmente no se usa, solo se aplica el color.

## 🎨 Colores RGB predefinidos

- **Rojo**: [255, 100, 100]
- **Verde**: [100, 255, 100]
- **Azul**: [100, 100, 255]
- **Amarillo**: [255, 200, 100]
- **Naranja**: [255, 150, 100]
- **Púrpura**: [139, 69, 255]
- **Cyan**: [100, 200, 255]
- **Rosa**: [255, 100, 200]

## 🎨 Sugerencias de colores por tipo de herramienta

### Editores y desarrollo
- **Púrpura oscuro** [139, 69, 255] - Editores (nvim, vim)
- **Azul** [100, 100, 255] - IDEs

### IA y herramientas
- **Naranja** [255, 150, 100] - AI tools (Claude, aider)
- **Amarillo** [255, 200, 100] - Configuración

### Contenedores y paquetes
- **Azul Docker** [33, 150, 243] - Docker
- **Rojo npm** [203, 56, 55] - npm
- **Azul Yarn** [44, 142, 187] - yarn

### Lenguajes
- **Amarillo Python** [255, 213, 79] - Python
- **Verde Node** [104, 160, 99] - Node.js

### Git y control de versiones
- **Rojo Git** [240, 80, 50] - Git, LazyGit

### Bases de datos
- **Azul PostgreSQL** [51, 103, 145] - PostgreSQL
- **Azul MySQL** [0, 117, 143] - MySQL
- **Rojo Redis** [220, 50, 47] - Redis

### Sistemas
- **Cyan** [100, 200, 255] - SSH
- **Verde** [30, 215, 96] - tmux
- **Púrpura** [200, 100, 255] - Monitoring (htop)

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

### Programas adicionales

```yaml
programs:
  - name: "python"
    color: [255, 213, 79]
    description: "Python REPL"

  - name: "node"
    color: [104, 160, 99]
    description: "Node.js"

  - name: "docker"
    color: [33, 150, 243]
    description: "Docker CLI"

  - name: "claude"
    color: [255, 150, 100]
    description: "Claude Code AI"
```

**Resultado**: Cuando ejecutes `python`, la pestaña se pondrá amarilla.

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
