# OpenCode Agents - Directorio de Agentes

Este directorio contiene agentes personalizados para OpenCode.

## Agentes Disponibles

| Agente | Descripción |
|--------|-------------|
| `commit-only.md` | Crea commits de git sin hacer push |
| `repo-doctor.md` | Realiza verificación rápida de salud del repositorio |
| `secrets-guard.md` | Escanea cambios para detectar secretos antes de commit |
| `spell-checker-es.md` | Detecta y corrige errores de ortografía en español |
| `test-runner-smart.md` | Detecta el stack del proyecto y ejecuta tests |

---

## Instalación del Agente de Ortografía en Español

### Resumen de la instalación

Se creó el agente `spell-checker-es.md` que utiliza **hunspell** con diccionario en español.

### Componentes instalados

| Componente | Path |
|------------|------|
| **hunspell** (binario) | `/opt/homebrew/bin/hunspell` |
| **Diccionario español** | `~/Library/Spelling/es_ES.dic` |
| **Archivo aff (reglas)** | `~/Library/Spelling/es_ES.aff` |
| **Agente** | `~/.config/opencode/agent/spell-checker-es.md` |

### Cómo se instaló

1. **hunspell** via Homebrew:
   ```bash
   brew install hunspell
   ```

2. **Diccionario español**:
   - Descargado del repositorio oficial de LibreOffice
   - Ubicado en `~/Library/Spelling/` (ubicación estándar para hunspell en macOS)

### Verificación

Para verificar que hunspell funciona con español:
```bash
echo "palabra" | hunspell -d es_ES
```

### Uso del agente

El agente `spell-checker-es` puede:
- Escanear archivos específicos o todo el proyecto
- Detectar errores de ortografía en español
- Proponer y aplicar correcciones

---

## Estructura de los agentes

Cada agente sigue el formato:

```yaml
---
description: Descripción breve
mode: subagent
permission:
  edit: allow
  bash:
    "comando*": allow/deny
---
# Instrucciones del agente
```

- **description**: Breve descripción de lo que hace el agente
- **mode**: `subagent` indica que es un subagente
- **permission**: Define qué comandos puede ejecutar
