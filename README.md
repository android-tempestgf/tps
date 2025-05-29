# Travel Planner 🌍

[![Release](https://img.shields.io/github/v/release/android-tempestgf/tps?include_prereleases)](https://github.com/android-tempestgf/tps/releases)
[![Build Status](https://github.com/android-tempestgf/tps/workflows/Build%20and%20Release%20Android%20App/badge.svg)](https://github.com/android-tempestgf/tps/actions)
[![License](https://img.shields.io/github/license/android-tempestgf/tps)](LICENSE)

Una aplicación móvil Android moderna para planificar viajes, gestionar itinerarios y preferencias de usuario, desarrollada con Jetpack Compose y siguiendo las mejores prácticas de desarrollo.

## 🚀 Características

- **Interfaz Moderna**: Desarrollada con Jetpack Compose y Material Design 3
- **Arquitectura Sólida**: Patrón MVVM con separación clara de responsabilidades
- **Multiplataforma**: Android nativo con Kotlin
- **CI/CD Automatizado**: Releases automatizados con GitHub Actions
- **Documentación Completa**: Arquitectura y procesos bien documentados

## 📱 Capturas de Pantalla

*Próximamente: Capturas de pantalla de la aplicación*

## 🏗️ Arquitectura

El proyecto utiliza arquitectura **MVVM (Model-View-ViewModel)** con las siguientes capas:

- **UI Layer**: Jetpack Compose con Material Design 3
- **Presentation Layer**: ViewModels para gestión de estado
- **Domain Layer**: Lógica de negocio y casos de uso
- **Data Layer**: Repositorios y fuentes de datos

Para más detalles, consulta la [documentación de arquitectura](docs/design.md).

## 🛠️ Tecnologías Utilizadas

### Core
- **Kotlin**: Lenguaje principal
- **Android SDK**: Plataforma (minSdk: 31, targetSdk: 35)
- **Gradle con Kotlin DSL**: Sistema de build

### UI
- **Jetpack Compose**: Framework declarativo para UI
- **Material Design 3**: Sistema de diseño moderno
- **Compose BOM**: Gestión de versiones
- **ConstraintLayout**: Layouts avanzados

### Architecture
- **Lifecycle Runtime KTX**: Gestión del ciclo de vida
- **Activity Compose**: Integración con Compose

### Testing
- **JUnit 4**: Testing unitario
- **Espresso**: Testing de UI
- **Compose Testing**: Testing específico para Compose

## 📥 Descargas

### Últimas Versiones

- [**v0.1.0** - Release Inicial](https://github.com/android-tempestgf/tps/releases/tag/v0.1.0) *(Enero 2025)*
  - APK de Release para producción
  - APK de Debug para desarrollo
  - Checksums SHA256 incluidos

### Instalación

1. Descarga el APK desde [Releases](https://github.com/android-tempestgf/tps/releases)
2. Habilita "Fuentes desconocidas" en configuración de Android
3. Instala el APK descargado
4. ¡Disfruta planificando tus viajes!

## 🔧 Desarrollo

### Prerrequisitos

- **Android Studio**: Hedgehog (2023.1.1) o superior
- **JDK**: 17 o superior
- **Android SDK**: Level 31-35
- **Git**: Para control de versiones

### Configuración del Proyecto

```bash
# 1. Clonar el repositorio
git clone https://github.com/android-tempestgf/tps.git
cd tps

# 2. Abrir con Android Studio
# File → Open → Seleccionar la carpeta del proyecto

# 3. Sincronizar dependencias
# Android Studio hará esto automáticamente

# 4. Ejecutar en dispositivo/emulador
# Hacer clic en Run (▶️) o Shift+F10
```

### Estructura del Proyecto

```
app/
├── src/main/
│   ├── java/com/tempestgf/tps/     # Código fuente principal
│   │   ├── MainActivity.kt         # Actividad principal
│   │   ├── AboutActivity.kt        # Pantalla "Acerca de"
│   │   ├── TermsActivity.kt        # Términos y condiciones
│   │   └── ui/theme/               # Configuración del tema
│   └── res/                        # Recursos de la aplicación
├── build.gradle.kts                # Configuración de build
docs/
├── design.md                       # Documentación de arquitectura
└── release-process.md              # Proceso de releases
scripts/
├── create-release.sh               # Script de release (Linux/macOS)
└── create-release.bat              # Script de release (Windows)
```

## 🚀 Contribuir

¡Las contribuciones son bienvenidas! Por favor lee nuestra [guía de contribución](CONTRIBUTING.md) para conocer el proceso.

### Flujo de Trabajo

1. **Fork** el repositorio
2. **Crear** una rama feature: `git checkout -b feature/nueva-funcionalidad`
3. **Desarrollar** siguiendo las guías de estilo
4. **Commit** usando [Conventional Commits](https://conventionalcommits.org/)
5. **Push** a tu fork: `git push origin feature/nueva-funcionalidad`
6. **Crear** un Pull Request

### Guías de Estilo

- **Kotlin**: Seguir [guías oficiales de Kotlin](https://kotlinlang.org/docs/coding-conventions.html)
- **Compose**: Usar principios de UI declarativa
- **Git**: Conventional Commits para mensajes descriptivos
- **Documentación**: Mantener docs actualizadas

### Tipos de Contribuciones

- 🐛 **Bug fixes**: Correcciones de errores
- ✨ **Features**: Nuevas funcionalidades
- 📚 **Docs**: Mejoras en documentación
- 🎨 **UI/UX**: Mejoras de interfaz
- ⚡ **Performance**: Optimizaciones
- 🧪 **Tests**: Añadir o mejorar pruebas

## 📋 Roadmap

### v0.2.0 - Funcionalidades Básicas
- [ ] Gestión de viajes (crear, editar, eliminar)
- [ ] Planificación de itinerarios
- [ ] Persistencia de datos local
- [ ] Configuración de preferencias

### v0.3.0 - Funcionalidades Avanzadas
- [ ] Sincronización en la nube
- [ ] Compartir viajes
- [ ] Notificaciones
- [ ] Modo offline

### v1.0.0 - Release Estable
- [ ] Testing completo
- [ ] Optimizaciones de rendimiento
- [ ] Documentación finalizada
- [ ] Publicación en Play Store

## 📄 Licencia

Este proyecto está licenciado bajo la licencia descrita en [LICENSE](LICENSE).

## 👨‍💻 Autor

**Guillem Farriols Segura**
- GitHub: [@android-tempestgf](https://github.com/android-tempestgf)

## 🤝 Soporte

Si tienes preguntas o necesitas ayuda:

1. **Issues**: [Crear un issue](https://github.com/android-tempestgf/tps/issues/new)
2. **Discussions**: [Iniciar una discusión](https://github.com/android-tempestgf/tps/discussions)
3. **Documentation**: Consultar [docs/](docs/)

## ⭐ Reconocimientos

- [Jetpack Compose](https://developer.android.com/jetpack/compose) - Framework de UI
- [Material Design 3](https://m3.material.io/) - Sistema de diseño
- [GitHub Actions](https://github.com/features/actions) - CI/CD

---

*Última actualización: Enero 2025*  
*Versión: v0.1.0*
