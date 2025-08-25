# CI Pipeline Setup Guide

This guide explains how to set up and use the CI (Continuous Integration) pipeline for the Dynamox iOS app.

## Overview

The CI pipeline consists of one main workflow:
- **iOS CI/CD** (`ios-ci.yml`) - Builds, tests, and validates code quality

## Prerequisites

### 1. GitHub Repository Setup
- Ensure your project is pushed to a GitHub repository
- Enable GitHub Actions in your repository settings
- Set up branch protection rules for `main` and `develop` branches

## Setup Steps

### Step 1: Push to GitHub

```bash
git add .
git commit -m "Add CI workflow"
git push origin main
```

### Step 2: Verify Workflow

1. Go to your GitHub repository
2. Click on the "Actions" tab
3. You should see the "iOS CI/CD" workflow
4. The workflow will automatically run on your next push

## How It Works

### Continuous Integration (CI)
- **Triggers**: Every push to `main`/`develop` branches and pull requests
- **Actions**:
  - Builds the project
  - Runs unit tests
  - Runs UI tests
  - Performs code quality checks
  - Uploads build artifacts

## Usage

### Running CI Manually
1. Go to Actions tab in GitHub
2. Select "iOS CI/CD" workflow
3. Click "Run workflow"
4. Choose branch and click "Run workflow"

### Monitoring Builds
- Check the Actions tab to see workflow status
- Green checkmark = success
- Red X = failure (click to see detailed logs)
- Download build artifacts if needed

## Customization

### Adding Code Quality Tools

#### SwiftLint
1. Add SwiftLint to your project
2. Uncomment the SwiftLint step in `ios-ci.yml`
3. Configure `.swiftlint.yml` in your project root

#### Code Coverage
1. Enable code coverage in Xcode
2. Use tools like `xcov` or `slather` to generate reports
3. Update the coverage step in the workflow

## Troubleshooting

### Common Issues

#### Build Failures
- Check Xcode version compatibility
- Verify CocoaPods dependencies
- Check that all dependencies are properly installed

#### Test Failures
- Ensure all tests pass locally
- Check simulator compatibility
- Verify test scheme configuration

### Debugging
- Check workflow logs in GitHub Actions
- Download build artifacts for inspection
- Use local builds to verify configuration

## Best Practices

1. **Branch Strategy**: Use feature branches and merge via pull requests
2. **Testing**: Ensure all tests pass before merging to main
3. **Monitoring**: Regularly review workflow performance and logs
4. **Local Testing**: Always test locally before pushing

## Future Enhancements

When you're ready to add deployment later, you can:
- Add TestFlight deployment workflow
- Set up App Store deployment
- Configure code signing automation
- Add release management

## Support

For issues with the CI pipeline:
1. Check GitHub Actions logs
2. Verify configuration files
3. Test locally with similar commands
4. Ensure all dependencies are properly configured
