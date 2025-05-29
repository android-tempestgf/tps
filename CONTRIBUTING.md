# Contributing to Travel Planner

¡Gracias por tu interés en contribuir al proyecto Travel Planner! Este documento describe las convenciones y procesos que seguimos para mantener un código de calidad y un flujo de trabajo ordenado.

## Tabla de Contenidos
1. [Estrategia de Branching](#estrategia-de-branching)
2. [Configuración del Entorno](#configuración-del-entorno)
3. [Flujo de Trabajo](#flujo-de-trabajo)
4. [Convenciones de Commits](#convenciones-de-commits)
5. [Pull Requests](#pull-requests)
6. [Estándares de Código](#estándares-de-código)
7. [Testing](#testing)
8. [Estado de Implementación](#-estado-de-implementación)

## Estrategia de Branching

Seguimos el modelo **Git Flow** para organizar nuestro desarrollo:

### Ramas Principales

- **`main`**: 
  - Contiene el código en producción
  - Solo acepta merges desde `release/*` y `hotfix/*`
  - Siempre debe estar en un estado deployable
  - Protegida contra push directo

- **`develop`**: 
  - Rama de integración principal
  - Contiene las últimas características desarrolladas
  - Base para todas las ramas `feature/*`
  - Se integra a `main` a través de ramas `release/*`

### Ramas de Trabajo

- **`feature/<ticket-id>-<descripcion>`**: 
  - Para nuevas funcionalidades
  - Se crean desde `develop`
  - Se integran de vuelta a `develop` via Pull Request
  - Ejemplos: `feature/TPS-123-trip-creation`, `feature/TPS-456-user-preferences`

- **`bugfix/<ticket-id>-<descripcion>`**: 
  - Para corrección de bugs no críticos
  - Se crean desde `develop`
  - Se integran de vuelta a `develop` via Pull Request
  - Ejemplos: `bugfix/TPS-789-fix-date-picker`, `bugfix/TPS-101-navigation-issue`

- **`hotfix/<version>-<descripcion>`**: 
  - Para correcciones críticas en producción
  - Se crean desde `main`
  - Se integran tanto a `main` como a `develop`
  - Ejemplos: `hotfix/1.0.1-critical-crash`, `hotfix/1.0.2-security-fix`

- **`release/<version>`**: 
  - Para preparar una nueva versión
  - Se crean desde `develop`
  - Solo se permiten bug fixes menores
  - Se integran a `main` y `develop`
  - Ejemplos: `release/1.1.0`, `release/2.0.0`

### Diagrama de Flujo

```mermaid
gitgraph
    commit id: "Initial"
    branch develop
    checkout develop
    commit id: "Setup"
    
    branch feature/trip-creation
    checkout feature/trip-creation
    commit id: "Add Trip model"
    commit id: "Implement UI"
    
    checkout develop
    merge feature/trip-creation
    commit id: "Integrate feature"
    
    branch release/1.0.0
    checkout release/1.0.0
    commit id: "Version bump"
    commit id: "Bug fixes"
    
    checkout main
    merge release/1.0.0
    commit id: "Release 1.0.0"
    tag: "v1.0.0"
    
    checkout develop
    merge release/1.0.0
```

## Configuración del Entorno

### Requisitos Previos
- Android Studio Arctic Fox o superior
- JDK 11 o superior
- Git configurado con tu usuario y email

### Configuración Inicial
```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/tps.git
cd tps

# Configurar Git Flow (opcional, pero recomendado)
git flow init

# Crear y cambiar a la rama develop
git checkout -b develop origin/develop
```

## Flujo de Trabajo

### Para Nuevas Funcionalidades

1. **Asegúrate de estar en `develop` actualizada**:
   ```bash
   git checkout develop
   git pull origin develop
   ```

2. **Crea una nueva rama feature**:
   ```bash
   git checkout -b feature/TPS-123-descripcion-corta
   ```

3. **Desarrolla tu funcionalidad**:
   - Realiza commits frecuentes y descriptivos
   - Asegúrate de que los tests pasen
   - Sigue los estándares de código

4. **Finaliza la feature**:
   ```bash
   git push origin feature/TPS-123-descripcion-corta
   ```

5. **Crea un Pull Request** hacia `develop`

### Para Bug Fixes

1. **Desde `develop`** (bugs no críticos):
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b bugfix/TPS-456-fix-descripcion
   ```

2. **Desde `main`** (hotfixes críticos):
   ```bash
   git checkout main
   git pull origin main
   git checkout -b hotfix/1.0.1-fix-critico
   ```

### Para Releases

1. **Crear rama release desde `develop`**:
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b release/1.1.0
   ```

2. **Actualizar versión y preparar release**:
   - Actualizar `versionName` y `versionCode` en `build.gradle.kts`
   - Actualizar `CHANGELOG.md`
   - Solo bug fixes menores permitidos

3. **Finalizar release**:
   ```bash
   # Merge a main
   git checkout main
   git merge release/1.1.0
   git tag -a v1.1.0 -m "Release version 1.1.0"
   
   # Merge de vuelta a develop
   git checkout develop
   git merge release/1.1.0
   ```

## Convenciones de Commits

Seguimos el estándar **Conventional Commits**:

### Formato
```
<tipo>[scope opcional]: <descripción>

[cuerpo opcional]

[footer opcional]
```

### Tipos
- **`feat`**: Nueva funcionalidad
- **`fix`**: Corrección de bug
- **`docs`**: Cambios en documentación
- **`style`**: Cambios de formato (no afectan lógica)
- **`refactor`**: Refactorización de código
- **`test`**: Adición o modificación de tests
- **`chore`**: Tareas de mantenimiento
- **`ci`**: Cambios en CI/CD
- **`perf`**: Mejoras de rendimiento

### Ejemplos
```bash
feat(trip): add trip creation functionality
fix(navigation): resolve back button issue in trip details
docs(readme): update installation instructions
test(trip): add unit tests for trip repository
chore(deps): update compose version to 1.5.0
```

### Scopes Sugeridos
- `trip`: Funcionalidades relacionadas con viajes
- `activity`: Gestión de actividades
- `ui`: Cambios en interfaz de usuario
- `navigation`: Sistema de navegación
- `data`: Capa de datos
- `api`: Servicios web
- `test`: Testing

## Pull Requests

### Requisitos
- [ ] **Título descriptivo** siguiendo convenciones de commits
- [ ] **Descripción detallada** del cambio y su propósito
- [ ] **Tests actualizados** y pasando
- [ ] **Documentación actualizada** si es necesario
- [ ] **Screenshots** si hay cambios visuales
- [ ] **Sin merge conflicts** con la rama destino

### Template
```markdown
## Descripción
Breve descripción de los cambios realizados.

## Tipo de cambio
- [ ] Bug fix (cambio que corrige un issue)
- [ ] Nueva funcionalidad (cambio que añade funcionalidad)
- [ ] Breaking change (fix o feature que causa que funcionalidad existente no funcione como se esperaba)
- [ ] Cambio de documentación

## ¿Cómo se ha probado?
Describe las pruebas que has realizado para verificar tus cambios.

## Screenshots (si aplica)
Incluye screenshots de los cambios visuales.

## Checklist
- [ ] Mi código sigue las convenciones de estilo del proyecto
- [ ] He realizado una auto-revisión de mi código
- [ ] He comentado mi código, particularmente en áreas difíciles de entender
- [ ] He realizado los cambios correspondientes en la documentación
- [ ] Mis cambios no generan nuevas advertencias
- [ ] He añadido tests que prueban que mi fix es efectivo o que mi feature funciona
- [ ] Los tests unitarios nuevos y existentes pasan localmente con mis cambios
```

### Proceso de Revisión
1. **Auto-revisión**: Revisa tu propio código antes de crear el PR
2. **Asignación**: Asigna al menos un revisor
3. **Feedback**: Responde a comentarios constructivamente
4. **Aprobación**: Requiere al menos una aprobación para merge
5. **Merge**: Solo el autor o maintainer puede hacer merge

## Estándares de Código

### Kotlin
- Seguir [Kotlin Coding Conventions](https://kotlinlang.org/docs/coding-conventions.html)
- Usar `ktlint` para formateo automático
- Máximo 120 caracteres por línea
- Usar nombres descriptivos para variables y funciones

### Jetpack Compose
- Un `@Composable` por archivo cuando sea posible
- Usar `remember` para estado local
- Preferir `LazyColumn` sobre `Column` con `verticalScroll`
- Usar `@Preview` para todas las composables

### Arquitectura
- Seguir patrón MVVM
- Repository pattern para acceso a datos
- Inyección de dependencias con Hilt
- Testing con JUnit 4 y Compose Testing

## Testing

### Requisitos
- **Cobertura mínima**: 80% para lógica de negocio
- **Unit tests**: Para ViewModels, Repositories, y casos de uso
- **Integration tests**: Para base de datos y API calls
- **UI tests**: Para flujos críticos de usuario

### Comandos
```bash
# Ejecutar todos los tests
./gradlew test

# Ejecutar tests con cobertura
./gradlew testDebugUnitTestCoverage

# Ejecutar tests de UI
./gradlew connectedAndroidTest
```

## ✅ Estado de Implementación

### Estructura de Branches Implementada

✅ **`main`**: Rama de producción protegida
✅ **`develop`**: Rama de integración principal establecida  
✅ **Workflow demostrado**: Feature branch `feature/TPS-001-cleanup-project-files` creada, desarrollada y mergeada correctamente

### Herramientas de Workflow Implementadas

✅ **GitHub Actions**:
- Validación de nombres de ramas
- Validación de mensajes de commit (Conventional Commits)
- Validación de target branches para PRs
- Lint y testing automático
- Escaneo de seguridad
- Protección contra push directo a main

✅ **Templates de GitHub**:
- Template de Pull Request con checklist completo
- Template de Feature Request
- Template de Bug Report
- Issue templates con etiquetas y prioridades

✅ **Documentación**:
- CHANGELOG.md siguiendo Keep a Changelog
- Guías detalladas de workflow
- Ejemplos de comandos Git
- Convenciones de código y testing

### Ejemplo de Uso Completado

El workflow ha sido demostrado exitosamente:

1. ✅ Creación de rama `develop` desde `main`
2. ✅ Creación de feature branch: `feature/TPS-001-cleanup-project-files`
3. ✅ Desarrollo con commits siguiendo Conventional Commits
4. ✅ Merge con `--no-ff` preservando historial de branches
5. ✅ Limpieza de feature branch después del merge
6. ✅ Push de cambios a repositorio remoto

---

*Documento actualizado: Mayo 2025*  
*Versión: 2.0*
