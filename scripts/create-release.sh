#!/bin/bash

# Script de Creación de Releases para Travel Planner
# Este script ayuda a crear un nuevo release siguiendo versionado semántico

set -e

# Colores para la salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin Color

# Funciones para imprimir salida coloreada
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Verificar si estamos en la rama main o develop
current_branch=$(git branch --show-current)
if [[ "$current_branch" != "main" && "$current_branch" != "develop" ]]; then
    print_error "Debes estar en la rama 'main' o 'develop' para crear un release."
    print_info "Rama actual: $current_branch"
    exit 1
fi

# Verificar si el directorio de trabajo está limpio
if ! git diff-index --quiet HEAD --; then
    print_error "El directorio de trabajo no está limpio. Por favor confirma o guarda tus cambios."
    exit 1
fi

# Obtener versión actual de app/build.gradle.kts
current_version=$(grep 'versionName = ' app/build.gradle.kts | sed 's/.*versionName = "\(.*\)".*/\1/')
print_info "Versión actual: $current_version"

# Sugerir próxima versión basada en versionado semántico
IFS='.' read -r -a version_parts <<< "$current_version"
major="${version_parts[0]}"
minor="${version_parts[1]}"
patch="${version_parts[2]}"

suggested_patch="$major.$minor.$((patch + 1))"
suggested_minor="$major.$((minor + 1)).0"
suggested_major="$((major + 1)).0.0"

echo ""
print_info "Próximas versiones sugeridas:"
echo "  1. Release de parche (correcciones): $suggested_patch"
echo "  2. Release menor (nuevas funcionalidades): $suggested_minor"
echo "  3. Release mayor (cambios incompatibles): $suggested_major"
echo "  4. Versión personalizada"

echo ""
read -p "Elige tipo de versión (1-4): " version_choice

case $version_choice in
    1)
        new_version="$suggested_patch"
        ;;
    2)
        new_version="$suggested_minor"
        ;;
    3)
        new_version="$suggested_major"
        ;;
    4)
        read -p "Introduce versión personalizada (ej., 0.2.0): " new_version
        ;;
    *)
        print_error "Opción inválida. Saliendo."
        exit 1
        ;;
esac

# Validar formato de versión (verificación básica)
if ! [[ $new_version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    print_error "Formato de versión inválido. Usa versionado semántico (ej., 1.0.0)"
    exit 1
fi

print_info "Creando release para la versión: $new_version"

# Confirmar creación del release
echo ""
read -p "¿Quieres proceder con crear el release v$new_version? (s/N): " confirm
if [[ ! $confirm =~ ^[SsYy]$ ]]; then
    print_warning "Creación de release cancelada."
    exit 0
fi

# Actualizar versión en build.gradle.kts
print_info "Actualizando versión en app/build.gradle.kts..."
sed -i "s/versionName = \".*\"/versionName = \"$new_version\"/" app/build.gradle.kts

# Verificar si CHANGELOG.md tiene entrada para esta versión
if ! grep -q "## \[$new_version\]" CHANGELOG.md; then
    print_warning "No se encontró entrada para la versión $new_version en CHANGELOG.md"
    print_info "Por favor actualiza CHANGELOG.md con notas del release antes de proceder."
    echo ""
    read -p "¿Has actualizado CHANGELOG.md? (s/N): " changelog_updated
    if [[ ! $changelog_updated =~ ^[SsYy]$ ]]; then
        print_error "Por favor actualiza CHANGELOG.md y ejecuta este script de nuevo."
        # Revertir cambio de versión
        sed -i "s/versionName = \"$new_version\"/versionName = \"$current_version\"/" app/build.gradle.kts
        exit 1
    fi
fi

# Confirmar cambio de versión
print_info "Confirmando cambio de versión..."
git add app/build.gradle.kts CHANGELOG.md
git commit -m "chore: actualizar versión a v$new_version

- Versión de app actualizada a $new_version
- CHANGELOG.md actualizado con notas del release"

# Crear y subir tag
print_info "Creando tag v$new_version..."
git tag -a "v$new_version" -m "Release v$new_version

$(sed -n "/## \[$new_version\]/,/## \[/p" CHANGELOG.md | sed '$d' | tail -n +2)"

print_info "Subiendo cambios y tag al remoto..."
git push origin "$current_branch"
git push origin "v$new_version"

print_success "¡Release v$new_version creado exitosamente!"
print_info "GitHub Actions ahora construirá el APK y creará el release."
print_info "Verifica la pestaña Actions en tu repositorio de GitHub para el progreso de construcción."

echo ""
print_info "Detalles del release:"
echo "  - Versión: v$new_version"
echo "  - Rama: $current_branch"
echo "  - Tag: v$new_version"
echo "  - La construcción estará disponible en: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\(.*\)\.git/\1/')/releases/tag/v$new_version"
