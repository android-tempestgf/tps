# Release Process

This document outlines the release process for the Travel Planner Android application, including automated builds and GitHub releases.

## Overview

The project uses **semantic versioning** (SemVer) for releases:
- **v0.x.x**: Initial development releases (pre-release)
- **v1.x.x**: Stable releases
- **Patch** (x.x.1): Bug fixes
- **Minor** (x.1.x): New features (backward compatible)
- **Major** (1.x.x): Breaking changes

## Automated Release Workflow

### GitHub Actions Workflow

The release process is automated using GitHub Actions (`.github/workflows/release.yml`):

1. **Triggered by**: 
   - Git tag push (e.g., `git push origin v0.1.0`)
   - Manual workflow dispatch from GitHub Actions UI

2. **Build Process**:
   - Sets up Android SDK and JDK 17
   - Builds both Release and Debug APKs
   - Optionally signs APKs (if keystore secrets are configured)
   - Generates SHA256 checksums
   - Creates GitHub release with downloadable assets

3. **Release Assets**:
   - `travel-planner-vX.X.X-release.apk` - Production APK
   - `travel-planner-vX.X.X-debug.apk` - Debug APK
   - `checksums.txt` - SHA256 checksums for verification

### Pre-release vs Stable Releases

- **Pre-release**: Versions starting with `0.` or containing `alpha`, `beta`, `rc`
- **Stable**: Versions starting with `1.` or higher without pre-release identifiers

## Creating a Release

### Method 1: Using Release Scripts (Recommended)

#### On Linux/macOS:
```bash
# Make script executable (first time only)
chmod +x scripts/create-release.sh

# Run the release script
./scripts/create-release.sh
```

#### On Windows:
```cmd
# Run the release script
scripts\create-release.bat
```

The script will:
1. Check that you're on `main` or `develop` branch
2. Verify working directory is clean
3. Show current version and suggest next versions
4. Update `app/build.gradle.kts` with new version
5. Commit changes and create a git tag
6. Push tag to trigger automated build

### Method 2: Manual Process

1. **Update Version**:
   ```kotlin
   // In app/build.gradle.kts
   versionName = "0.2.0"  // Update to new version
   ```

2. **Update CHANGELOG.md**:
   ```markdown
   ## [0.2.0] - 2025-01-09
   
   ### Added
   - New feature descriptions
   
   ### Changed
   - Changed feature descriptions
   
   ### Fixed
   - Bug fix descriptions
   ```

3. **Commit and Tag**:
   ```bash
   git add app/build.gradle.kts CHANGELOG.md
   git commit -m "chore: bump version to v0.2.0"
   git tag -a v0.2.0 -m "Release v0.2.0"
   git push origin develop  # or main
   git push origin v0.2.0
   ```

### Method 3: GitHub Actions Manual Trigger

1. Go to GitHub Actions in your repository
2. Select "Build and Release Android App" workflow
3. Click "Run workflow"
4. Enter the version (e.g., `v0.1.0`)
5. Click "Run workflow"

## APK Signing (Optional)

To enable APK signing for production releases, add these secrets to your GitHub repository:

1. Go to Settings → Secrets and variables → Actions
2. Add the following repository secrets:
   - `KEYSTORE_FILE`: Base64-encoded keystore file (`base64 -w 0 your-keystore.jks`)
   - `KEYSTORE_PASSWORD`: Keystore password
   - `KEY_ALIAS`: Key alias name
   - `KEY_PASSWORD`: Key password

## Release Checklist

Before creating a release:

- [ ] All tests pass
- [ ] Code review completed (for major releases)
- [ ] CHANGELOG.md updated with release notes
- [ ] Version number follows semantic versioning
- [ ] Working directory is clean (no uncommitted changes)
- [ ] On correct branch (`main` for stable, `develop` for pre-release)

## Release Notes

Release notes are automatically generated from CHANGELOG.md. Ensure your changelog entries are well-formatted:

```markdown
## [X.X.X] - YYYY-MM-DD

### Added
- New features and capabilities

### Changed
- Changes to existing functionality

### Deprecated
- Features that will be removed in future versions

### Removed
- Features that have been removed

### Fixed
- Bug fixes

### Security
- Security-related fixes
```

## Troubleshooting

### Build Failures

1. **Gradle Build Fails**:
   - Check Java version (should be JDK 17)
   - Verify Android SDK is properly set up
   - Check for dependency conflicts

2. **APK Signing Fails**:
   - Verify keystore secrets are correctly configured
   - Check keystore file is valid and base64-encoded correctly

3. **Release Creation Fails**:
   - Ensure GitHub token has proper permissions
   - Check if tag already exists
   - Verify release workflow syntax

### Version Conflicts

If you accidentally create a release with the wrong version:

1. **Delete the tag**:
   ```bash
   git tag -d v0.1.0           # Delete locally
   git push origin :v0.1.0     # Delete on remote
   ```

2. **Delete the GitHub release** (if created)
3. **Fix the version** and create a new release

## Monitoring Releases

- **GitHub Actions**: Monitor build progress in the Actions tab
- **GitHub Releases**: View all releases in the Releases section
- **APK Downloads**: Track download statistics in GitHub insights

## Security Considerations

- Keep keystore files and passwords secure
- Use repository secrets for sensitive information
- Regularly audit access to repository secrets
- Consider using different keystores for debug/release builds

## Future Improvements

- Add automated testing before release
- Implement code signing verification
- Add release candidate (RC) workflow
- Integrate with app stores (Google Play Store)
- Add crash reporting and analytics tracking
