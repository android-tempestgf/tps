#!/bin/bash

# Travel Planner Release Creation Script
# This script helps create a new release following semantic versioning

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if we're on the main or develop branch
current_branch=$(git branch --show-current)
if [[ "$current_branch" != "main" && "$current_branch" != "develop" ]]; then
    print_error "You must be on the 'main' or 'develop' branch to create a release."
    print_info "Current branch: $current_branch"
    exit 1
fi

# Check if working directory is clean
if ! git diff-index --quiet HEAD --; then
    print_error "Working directory is not clean. Please commit or stash your changes."
    exit 1
fi

# Get current version from app/build.gradle.kts
current_version=$(grep 'versionName = ' app/build.gradle.kts | sed 's/.*versionName = "\(.*\)".*/\1/')
print_info "Current version: $current_version"

# Suggest next version based on semantic versioning
IFS='.' read -r -a version_parts <<< "$current_version"
major="${version_parts[0]}"
minor="${version_parts[1]}"
patch="${version_parts[2]}"

suggested_patch="$major.$minor.$((patch + 1))"
suggested_minor="$major.$((minor + 1)).0"
suggested_major="$((major + 1)).0.0"

echo ""
print_info "Suggested next versions:"
echo "  1. Patch release (bug fixes): $suggested_patch"
echo "  2. Minor release (new features): $suggested_minor"
echo "  3. Major release (breaking changes): $suggested_major"
echo "  4. Custom version"

echo ""
read -p "Choose version type (1-4): " version_choice

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
        read -p "Enter custom version (e.g., 0.2.0): " new_version
        ;;
    *)
        print_error "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Validate version format (basic check)
if ! [[ $new_version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    print_error "Invalid version format. Use semantic versioning (e.g., 1.0.0)"
    exit 1
fi

print_info "Creating release for version: $new_version"

# Confirm release creation
echo ""
read -p "Do you want to proceed with creating release v$new_version? (y/N): " confirm
if [[ ! $confirm =~ ^[Yy]$ ]]; then
    print_warning "Release creation cancelled."
    exit 0
fi

# Update version in build.gradle.kts
print_info "Updating version in app/build.gradle.kts..."
sed -i "s/versionName = \".*\"/versionName = \"$new_version\"/" app/build.gradle.kts

# Check if CHANGELOG.md has entry for this version
if ! grep -q "## \[$new_version\]" CHANGELOG.md; then
    print_warning "No entry found for version $new_version in CHANGELOG.md"
    print_info "Please update CHANGELOG.md with release notes before proceeding."
    echo ""
    read -p "Have you updated CHANGELOG.md? (y/N): " changelog_updated
    if [[ ! $changelog_updated =~ ^[Yy]$ ]]; then
        print_error "Please update CHANGELOG.md and run this script again."
        # Revert version change
        sed -i "s/versionName = \"$new_version\"/versionName = \"$current_version\"/" app/build.gradle.kts
        exit 1
    fi
fi

# Commit version change
print_info "Committing version change..."
git add app/build.gradle.kts CHANGELOG.md
git commit -m "chore: bump version to v$new_version

- Updated app version to $new_version
- Updated CHANGELOG.md with release notes"

# Create and push tag
print_info "Creating tag v$new_version..."
git tag -a "v$new_version" -m "Release v$new_version

$(sed -n "/## \[$new_version\]/,/## \[/p" CHANGELOG.md | sed '$d' | tail -n +2)"

print_info "Pushing changes and tag to remote..."
git push origin "$current_branch"
git push origin "v$new_version"

print_success "Release v$new_version created successfully!"
print_info "GitHub Actions will now build the APK and create the release."
print_info "Check the Actions tab in your GitHub repository for build progress."

echo ""
print_info "Release details:"
echo "  - Version: v$new_version"
echo "  - Branch: $current_branch"
echo "  - Tag: v$new_version"
echo "  - Build will be available at: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\(.*\)\.git/\1/')/releases/tag/v$new_version"
