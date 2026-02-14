# Dotfiles - Configuración Personal

Repositorio de configuración personal gestionado con [Chezmoi](https://www.chezmoi.io/).

## 🚀 Instalación Rápida

```bash
# Instalar chezmoi
brew install chezmoi

# Clonar e inicializar estos dotfiles
chezmoi init --apply joemay/dotfiles
```

## 📁 Scripts Personalizados

Todos los scripts están en `~/.local/bin/` y se sincronizan automáticamente.

### Scripts de Desarrollo

#### `dev-nvim`
Crea una sesión de tmux con Neovim personalizado y Claude Code.

```bash
# Uso básico
dev-nvim

# Con nombre de sesión personalizado
dev-nvim mi-proyecto
```

**Layout:**
- **75% superior**: Neovim personalizado
- **25% inferior**: Claude Code CLI

---

#### `dev-session`
Crea una sesión de tmux con LazyVim y Claude Code.

```bash
# Uso básico
dev-session

# Con nombre de sesión personalizado
dev-session mi-proyecto
```

**Layout:**
- **75% superior**: LazyVim (NVIM_APPNAME=nvim-lazyvim)
- **25% inferior**: Claude Code CLI

---

### Scripts de Docker/Colima

#### `docker-cleanup`
Limpieza segura de recursos Docker sin afectar contenedores en ejecución.

```bash
# Ejecutar limpieza
docker-cleanup
```

**Qué limpia:**
- ✅ Contenedores detenidos
- ✅ Imágenes sin etiqueta (dangling)
- ✅ Redes no utilizadas
- ✅ Caché de build

**Qué NO limpia:**
- ❌ Contenedores en ejecución
- ❌ Imágenes con etiqueta en uso
- ❌ Volúmenes (debes limpiarlos manualmente si es necesario)

---

#### `docker-monitor`
Monitorea el uso de Docker y alerta cuando supera el umbral configurado.

```bash
# Ver estado actual manualmente
docker-monitor --manual

# Instalar monitoreo automático diario
docker-monitor --install-cron
```

**Configuración:**
- **Límite**: 3GB
- **Umbral de alerta**: 80% (2.4GB)
- **Frecuencia**: Diaria (9:00 AM)

**Características:**
- 🔔 Notificación nativa de macOS con botón "Limpiar ahora"
- 📊 Muestra uso actual vs límite configurado
- ⚡ Ejecuta `docker-cleanup` automáticamente al hacer clic

**Instalación del cronjob:**
```bash
docker-monitor --install-cron

# Verificar que está instalado
crontab -l
```

---

### Scripts de Utilidades

#### `force-quit-app.sh`
Fuerza el cierre de una aplicación por nombre.

```bash
# Uso
force-quit-app.sh "Nombre de la App"
```

---

#### `focus-app.sh`
Enfoca/trae al frente una aplicación por nombre.

```bash
# Uso
focus-app.sh "Nombre de la App"
```

---

#### `kill-app.sh`
Termina una aplicación por nombre (más suave que force-quit).

```bash
# Uso
kill-app.sh "Nombre de la App"
```

---

#### `iterm2-color-manager.sh`
Gestiona esquemas de color en iTerm2.

```bash
# Ver ayuda
iterm2-color-manager.sh --help
```

---

## 🔧 Configuración

### Archivos gestionados

| Archivo | Descripción |
|---------|-------------|
| `.zshrc` | Configuración de Zsh |
| `.zprofile` | Perfil de Zsh (login) |
| `.gitconfig` | Configuración de Git |
| `.gitignore_global` | Gitignore global |
| `.tmux.conf` | Configuración de Tmux |
| `.config/nvim/` | Configuración de Neovim |

### Dependencias recomendadas

```bash
# Herramientas esenciales
brew install tmux neovim git

# Para Docker/Colima
brew install colima docker docker-compose

# Para Claude Code
npm install -g @anthropic-ai/claude-code

# LazyVim (opcional)
git clone https://github.com/LazyVim/starter ~/.config/nvim-lazyvim
```

## 📝 Comandos útiles de Chezmoi

```bash
# Ver estado
chezmoi status

# Agregar nuevo archivo
chezmoi add ~/.config/nuevo-archivo

# Editar archivo gestionado
chezmoi edit ~/.zshrc

# Aplicar cambios
chezmoi apply

# Ver diferencias
chezmoi diff

# Actualizar desde repositorio
chezmoi update

# Ver directorio fuente
chezmoi source-path
```

## 🔄 Sincronización entre máquinas

### Primera vez en una nueva Mac:

```bash
# 1. Instalar chezmoi
brew install chezmoi

# 2. Inicializar desde GitHub
chezmoi init --apply joemay/dotfiles

# 3. Instalar cronjob de monitoreo Docker
docker-monitor --install-cron
```

### Hacer cambios y subirlos:

```bash
# Editar archivo
chezmoi edit ~/.zshrc

# Aplicar cambios locales
chezmoi apply

# Commit y push
cd ~/.local/share/chezmoi
git add .
git commit -m "Descripción del cambio"
git push
```

## 📦 Estructura del repositorio

```
.
├── dot_local/bin/          # Scripts ejecutables
│   ├── executable_dev-nvim
│   ├── executable_dev-session
│   ├── executable_docker-cleanup
│   └── executable_docker-monitor
├── dot_config/             # Configuraciones
│   ├── nvim/              # Neovim
│   ├── shell-functions/   # Funciones de shell
│   └── iterm2-colors/     # Colores de iTerm2
├── dot_gitconfig
├── dot_gitignore_global
├── dot_tmux.conf
├── dot_zprofile
├── dot_zshrc
└── README.md
```

## ⚠️ Notas importantes

- Los scripts en `dot_local/bin/` usan el prefijo `executable_` para que Chezmoi los haga ejecutables automáticamente
- Los archivos con prefijo `private_` tienen permisos 600 (solo lectura/escritura para el propietario)
- El monitor de Docker requiere que estés en macOS para las notificaciones nativas

## 🤝 Contribuciones

Este es un repositorio personal, pero si encuentras útil algo aquí, ¡siéntete libre de usarlo!

## 📄 Licencia

MIT - Haz lo que quieras con esto 😉
