# Proceso de Releases - Travel Planner

Este documento describe el proceso completo para crear releases de la aplicación Travel Planner, incluyendo construcción automatizada y releases de GitHub.

## Visión General

El proyecto utiliza **versionado semántico** (SemVer) para los releases:
- **v0.x.x**: Releases de desarrollo inicial (pre-release)
- **v1.x.x**: Releases estables
- **Patch** (x.x.1): Correcciones de errores
- **Minor** (x.1.x): Nuevas funcionalidades (compatibles hacia atrás)
- **Major** (1.x.x): Cambios incompatibles

## Flujo de Trabajo de Release Automatizado

### Workflow de GitHub Actions

El proceso de release está automatizado usando GitHub Actions (`.github/workflows/release.yml`):

1. **Activado por**: 
   - Push de tag de Git (ej., `git push origin v0.1.0`)
   - Dispatch manual de workflow desde la UI de GitHub Actions

2. **Proceso de Construcción**:
   - Configura Android SDK y JDK 17
   - Construye APKs de Release y Debug
   - Opcionalmente firma APKs (si los secretos de keystore están configurados)
   - Genera checksums SHA256
   - Crea release de GitHub con assets descargables

3. **Assets del Release**:
   - `travel-planner-vX.X.X-release.apk` - APK de producción
   - `travel-planner-vX.X.X-debug.apk` - APK de debug
   - `checksums.txt` - Checksums SHA256 para verificación

### Pre-releases vs Releases Estables

- **Pre-release**: Versiones que empiezan con `0.` o contienen `alpha`, `beta`, `rc`
- **Estable**: Versiones que empiezan con `1.` o superior sin identificadores de pre-release

## Crear un Release

### Método 1: Usando Scripts de Release (Recomendado)

#### En Linux/macOS:
```bash
# Hacer el script ejecutable (solo la primera vez)
chmod +x scripts/create-release.sh

# Ejecutar el script de release
./scripts/create-release.sh
```

#### En Windows:
```cmd
# Ejecutar el script de release
scripts\create-release.bat
```

El script realizará:
1. Verificar que estés en la rama `main` o `develop`
2. Verificar que el directorio de trabajo esté limpio
3. Mostrar la versión actual y sugerir próximas versiones
4. Actualizar `app/build.gradle.kts` con la nueva versión
5. Confirmar cambios y crear un tag de git
6. Subir el tag para activar la construcción automatizada

### Método 2: Proceso Manual

1. **Actualizar Versión**:
   ```kotlin
   // En app/build.gradle.kts
   versionName = "0.2.0"  // Actualizar a nueva versión
   ```

2. **Actualizar CHANGELOG.md**:
   ```markdown
   ## [0.2.0] - 2025-01-09
   
   ### Añadido
   - Descripciones de nuevas funcionalidades
   
   ### Cambiado
   - Descripciones de funcionalidades modificadas
   
   ### Corregido
   - Descripciones de correcciones de errores
   ```

3. **Confirmar y Etiquetar**:
   ```bash
   git add app/build.gradle.kts CHANGELOG.md
   git commit -m "chore: actualizar versión a v0.2.0"
   git tag -a v0.2.0 -m "Release v0.2.0"
   git push origin develop  # o main
   git push origin v0.2.0
   ```

### Método 3: Activación Manual de GitHub Actions

1. Ve a GitHub Actions en tu repositorio
2. Selecciona el workflow "Build and Release Android App"
3. Haz clic en "Run workflow"
4. Introduce la versión (ej., `v0.1.0`)
5. Haz clic en "Run workflow"

## Firma de APK (Opcional)

Para habilitar la firma de APK para releases de producción, añade estos secretos a tu repositorio de GitHub:

1. Ve a Settings → Secrets and variables → Actions
2. Añade los siguientes secretos del repositorio:
   - `KEYSTORE_FILE`: Archivo keystore codificado en base64 (`base64 -w 0 tu-keystore.jks`)
   - `KEYSTORE_PASSWORD`: Contraseña del keystore
   - `KEY_ALIAS`: Nombre del alias de la clave
   - `KEY_PASSWORD`: Contraseña de la clave

## Lista de Verificación para Release

Antes de crear un release:

- [ ] Todas las pruebas pasan
- [ ] Revisión de código completada (para releases mayores)
- [ ] CHANGELOG.md actualizado con notas del release
- [ ] Número de versión sigue versionado semántico
- [ ] Directorio de trabajo limpio (sin cambios sin confirmar)
- [ ] En la rama correcta (`main` para estable, `develop` para pre-release)

## Notas de Release

Las notas de release se generan automáticamente desde CHANGELOG.md. Asegúrate de que tus entradas de changelog estén bien formateadas:

```markdown
## [X.X.X] - YYYY-MM-DD

### Añadido
- Nuevas funcionalidades y capacidades

### Cambiado
- Cambios a funcionalidades existentes

### Obsoleto
- Funcionalidades que serán removidas en versiones futuras

### Removido
- Funcionalidades que han sido removidas

### Corregido
- Correcciones de errores

### Seguridad
- Correcciones relacionadas con seguridad
```

## Solución de Problemas

### Fallos de Construcción

1. **Fallo de Gradle Build**:
   - Verificar versión de Java (debería ser JDK 17)
   - Verificar que Android SDK esté configurado correctamente
   - Verificar conflictos de dependencias

2. **Fallo de Firma de APK**:
   - Verificar que los secretos de keystore estén configurados correctamente
   - Verificar que el archivo keystore sea válido y esté codificado en base64 correctamente

3. **Fallo de Creación de Release**:
   - Asegurar que el token de GitHub tenga permisos apropiados
   - Verificar si el tag ya existe
   - Verificar sintaxis del workflow de release

### Conflictos de Versión

Si accidentalmente creas un release con la versión incorrecta:

1. **Eliminar el tag**:
   ```bash
   git tag -d v0.1.0           # Eliminar localmente
   git push origin :v0.1.0     # Eliminar en remoto
   ```

2. **Eliminar el release de GitHub** (si fue creado)
3. **Corregir la versión** y crear un nuevo release

## Monitoreo de Releases

- **GitHub Actions**: Monitorear progreso de construcción en la pestaña Actions
- **GitHub Releases**: Ver todos los releases en la sección Releases
- **Descargas de APK**: Seguir estadísticas de descarga en insights de GitHub

## Consideraciones de Seguridad

- Mantener archivos keystore y contraseñas seguros
- Usar secretos de repositorio para información sensible
- Auditar regularmente acceso a secretos de repositorio
- Considerar usar keystores diferentes para builds debug/release

## Mejoras Futuras

- Añadir pruebas automatizadas antes del release
- Implementar verificación de firma de código
- Añadir workflow de candidato a release (RC)
- Integrar con tiendas de apps (Google Play Store)
- Añadir seguimiento de crashes y analytics

---

*Documento actualizado: Enero 2025*  
*Versión: 1.0*  
*Proyecto: Travel Planner Scaffolding (TPS)*
