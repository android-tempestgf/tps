---
name: Pull Request
about: Submit changes for review
title: '[TYPE]: Brief description of changes'
labels: ''
assignees: ''
---

## 📋 Descripción

Describe brevemente los cambios realizados y el problema que resuelven.

**Relacionado con:** #(issue number)

## 🔄 Tipo de cambio

- [ ] 🐛 Bug fix (cambio que corrige un issue)
- [ ] ✨ Nueva funcionalidad (cambio que añade funcionalidad)
- [ ] 💥 Breaking change (fix o feature que causa que funcionalidad existente no funcione como se esperaba)
- [ ] 📚 Cambio de documentación
- [ ] 🎨 Mejora de UI/UX
- [ ] ⚡ Mejora de rendimiento
- [ ] 🔧 Refactorización
- [ ] 🧪 Añadir tests

## 🧪 ¿Cómo se ha probado?

Describe las pruebas que has realizado para verificar tus cambios:

- [ ] Tests unitarios
- [ ] Tests de integración
- [ ] Tests manuales
- [ ] Tests en dispositivos físicos
- [ ] Tests en emulador

**Configuración de pruebas:**
- Dispositivo: [ej. Pixel 6]
- Versión Android: [ej. Android 13]
- Versión de la app: [ej. 1.2.0]

## 📱 Screenshots (si aplica)

| Antes | Después |
|-------|---------|
| ![antes](url) | ![después](url) |

## ✅ Checklist

### Código
- [ ] Mi código sigue las convenciones de estilo del proyecto
- [ ] He realizado una auto-revisión de mi código
- [ ] He comentado mi código, particularmente en áreas difíciles de entender
- [ ] No hay warnings de lint sin resolver

### Testing
- [ ] He añadido tests que prueban que mi fix es efectivo o que mi feature funciona
- [ ] Los tests unitarios nuevos y existentes pasan localmente con mis cambios
- [ ] He probado en al menos un dispositivo/emulador

### Documentación
- [ ] He realizado los cambios correspondientes en la documentación
- [ ] He actualizado CHANGELOG.md si es necesario
- [ ] He actualizado README.md si es necesario

### Git
- [ ] Mi branch sigue la convención de naming: `feature/TPS-123-description`
- [ ] Mis commits siguen el formato conventional: `type(scope): description`
- [ ] No hay merge conflicts con la rama destino
- [ ] He probado que mi branch se puede mergear limpiamente

## 🔍 Notas para el revisor

Incluye cualquier información adicional que pueda ayudar al revisor:
- Puntos específicos en los que te gustaría feedback
- Decisiones de implementación que tomaste
- Áreas que podrían necesitar atención especial

## 📋 Definition of Done

- [ ] Funcionalidad implementada según especificaciones
- [ ] Código revisado y aprobado por al menos un desarrollador
- [ ] Tests añadidos y pasando
- [ ] Documentación actualizada
- [ ] Sin regresiones en funcionalidad existente
- [ ] Compatible con versiones Android soportadas (API 31-35)
