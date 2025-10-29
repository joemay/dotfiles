# Shell Functions

Colección de funciones de shell para gestión de aplicaciones en macOS con fuzzy finder.

## 📁 Scripts disponibles

### 🎯 focus-app.sh
Selector fuzzy para cambiar/enfocar aplicaciones abiertas.

**Uso:**
```bash
fa                    # Alias corto
focus-app.sh         # Comando completo
```

**Características:**
- Lista todas las aplicaciones abiertas (sin apps de background)
- Búsqueda fuzzy con fzf
- Preview de la aplicación seleccionada
- Activa/enfoca la app al presionar ENTER

---

### ⚠️ kill-app.sh
Selector fuzzy para cerrar aplicaciones gracefully.

**Uso:**
```bash
ka                   # Alias corto
kill-app.sh         # Comando completo
```

**Características:**
- Lista aplicaciones abiertas
- Cierre graceful (permite guardar cambios)
- Confirmación antes de cerrar
- Usa AppleScript quit

---

### 💀 force-quit-app.sh
Selector fuzzy para forzar cierre de aplicaciones (kill -9).

**Uso:**
```bash
fqa                  # Alias corto
force-quit-app.sh   # Comando completo
```

**Características:**
- Forzar cierre inmediato
- ⚠️ No guarda cambios
- Doble confirmación
- Útil para apps que no responden

---

## 🔧 Requisitos

- **macOS** (usa AppleScript y System Events)
- **fzf** - Fuzzy finder (instalado via Homebrew)
- **zsh** - Shell por defecto en macOS

## 📦 Instalación

Los scripts están en `~/.config/shell-functions/` y se cargan automáticamente en `.zshrc`.

## 🎨 Personalización

Cada script usa colores diferentes en fzf para identificación visual:
- **focus-app**: Azul (focus/navegación)
- **kill-app**: Rojo/Amarillo (advertencia)
- **force-quit-app**: Rojo intenso (peligro)

## 🚀 Tips

- Usa `fa` para cambio rápido de apps
- `ka` cuando una app no responde pero quieres guardar
- `fqa` solo cuando la app está congelada y no responde

## 🔗 Integración futura

Para hotkey global (abrir desde cualquier app), considera:
- **Hammerspoon** (gratis, potente)
- **Raycast** (launcher con scripts)
- **BetterTouchTool** (comercial)
