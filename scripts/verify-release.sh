#!/bin/bash

# Script de Verificación de Release - Travel Planner
# Este script verifica el estado de un release y sus assets

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

# Función para verificar si gh CLI está instalado
check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        print_error "GitHub CLI (gh) no está instalado"
        print_info "Instala GitHub CLI desde: https://cli.github.com/"
        return 1
    fi
    return 0
}

# Función para verificar autenticación con GitHub
check_gh_auth() {
    if ! gh auth status &> /dev/null; then
        print_error "No estás autenticado con GitHub CLI"
        print_info "Ejecuta: gh auth login"
        return 1
    fi
    return 0
}

# Función para listar releases
list_releases() {
    print_info "📦 Releases disponibles:"
    echo ""
    
    if check_gh_cli && check_gh_auth; then
        gh release list --limit 10
    else
        print_warning "Usando git para listar tags..."
        git tag -l --sort=-version:refname | head -10
    fi
}

# Función para verificar un release específico
verify_release() {
    local version="$1"
    
    if [[ -z "$version" ]]; then
        read -p "Introduce la versión del release a verificar (ej. v0.1.0): " version
    fi
    
    print_info "🔍 Verificando release $version..."
    echo ""
    
    if check_gh_cli && check_gh_auth; then
        # Verificar si el release existe
        if gh release view "$version" &> /dev/null; then
            print_success "Release $version encontrado"
            
            # Mostrar información del release
            echo ""
            print_info "📋 Información del release:"
            gh release view "$version"
            
            echo ""
            print_info "📁 Assets del release:"
            gh release view "$version" --json assets --jq '.assets[] | "\(.name) (\(.size) bytes)"'
            
            # Verificar workflow runs
            echo ""
            print_info "🔄 Últimas ejecuciones del workflow:"
            gh run list --workflow=release.yml --limit 5
            
        else
            print_error "Release $version no encontrado"
            return 1
        fi
    else
        # Verificación básica con git
        if git rev-parse "$version" &> /dev/null; then
            print_success "Tag $version encontrado"
            
            # Mostrar información del tag
            echo ""
            print_info "📋 Información del tag:"
            git show "$version" --no-patch --format="Autor: %an%nFecha: %ad%nMensaje: %s%n%n%b"
        else
            print_error "Tag $version no encontrado"
            return 1
        fi
    fi
}

# Función para descargar assets de un release
download_release() {
    local version="$1"
    
    if [[ -z "$version" ]]; then
        read -p "Introduce la versión del release a descargar (ej. v0.1.0): " version
    fi
    
    if ! check_gh_cli || ! check_gh_auth; then
        print_error "GitHub CLI es requerido para descargar assets"
        return 1
    fi
    
    print_info "📥 Descargando assets del release $version..."
    
    # Crear directorio de descarga
    local download_dir="downloads/$version"
    mkdir -p "$download_dir"
    
    # Descargar assets
    cd "$download_dir"
    if gh release download "$version" 2>/dev/null; then
        print_success "Assets descargados en: $download_dir"
        
        # Mostrar archivos descargados
        echo ""
        print_info "📁 Archivos descargados:"
        ls -la
        
        # Verificar checksums si existe el archivo
        if [[ -f "checksums.txt" ]]; then
            echo ""
            print_info "✅ Verificando checksums..."
            if sha256sum -c checksums.txt 2>/dev/null; then
                print_success "Todos los checksums son correctos"
            else
                print_warning "Algunos checksums no coinciden"
            fi
        fi
    else
        print_error "Error al descargar assets del release $version"
        return 1
    fi
    
    cd - > /dev/null
}

# Función para verificar el estado del workflow
check_workflow_status() {
    print_info "🔄 Verificando estado de workflows..."
    echo ""
    
    if check_gh_cli && check_gh_auth; then
        # Últimas ejecuciones del workflow de release
        print_info "📊 Últimas ejecuciones del workflow de release:"
        gh run list --workflow=release.yml --limit 5
        
        echo ""
        print_info "📊 Últimas ejecuciones de PR workflow:"
        gh run list --workflow=pr-workflow.yml --limit 5
        
        # Verificar si hay workflows en ejecución
        local running_workflows=$(gh run list --status=in_progress --limit 1 --json conclusion | jq length)
        if [[ "$running_workflows" -gt 0 ]]; then
            print_warning "Hay workflows en ejecución actualmente"
        else
            print_success "No hay workflows en ejecución"
        fi
    else
        print_warning "GitHub CLI requerido para verificar workflows"
    fi
}

# Función para mostrar el menú principal
show_menu() {
    echo ""
    echo "========================================"
    echo "  Travel Planner - Verificador de Releases"
    echo "========================================"
    echo ""
    echo "1. Listar todos los releases"
    echo "2. Verificar un release específico"
    echo "3. Descargar assets de un release"
    echo "4. Verificar estado de workflows"
    echo "5. Salir"
    echo ""
}

# Función principal
main() {
    # Verificar que estamos en un repositorio git
    if ! git rev-parse --git-dir &> /dev/null; then
        print_error "No estás en un repositorio git"
        exit 1
    fi
    
    while true; do
        show_menu
        read -p "Selecciona una opción (1-5): " choice
        
        case $choice in
            1)
                list_releases
                ;;
            2)
                verify_release
                ;;
            3)
                download_release
                ;;
            4)
                check_workflow_status
                ;;
            5)
                print_info "¡Hasta luego!"
                exit 0
                ;;
            *)
                print_error "Opción inválida. Por favor selecciona 1-5."
                ;;
        esac
        
        echo ""
        read -p "Presiona Enter para continuar..."
    done
}

# Ejecutar función principal si el script se ejecuta directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
