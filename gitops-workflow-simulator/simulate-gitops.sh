#!/bin/bash
# =============================================================
# simulate-gitops.sh
# Simulates the full GitOps workflow locally:
#   1. Developer bumps version
#   2. CI/CD detects change
#   3. Manifest gets updated automatically
#   4. "Deployment" is reconciled
# =============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_VERSION_FILE="$SCRIPT_DIR/app/version.txt"
DEV_MANIFEST="$SCRIPT_DIR/manifests/dev/deployment.yaml"
STAGING_MANIFEST="$SCRIPT_DIR/manifests/staging/deployment.yaml"

# -------------------------------------------------------
print_banner() {
  echo ""
  echo "╔══════════════════════════════════════════════════╗"
  echo "║        🚀 GitOps Workflow Simulator              ║"
  echo "║        Project 1 — Week 1 Git Learning           ║"
  echo "║        Author: Krishna Chavan                    ║"
  echo "╚══════════════════════════════════════════════════╝"
  echo ""
}

print_step() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  STEP $1: $2"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# -------------------------------------------------------
print_banner

# STEP 1: Read current version
print_step "1" "Read current app version"
CURRENT_VERSION=$(cat "$APP_VERSION_FILE" | tr -d '[:space:]')
echo "  📦 Current version: $CURRENT_VERSION"

# STEP 2: Simulate a version bump
print_step "2" "Developer bumps app version (simulated)"
# Auto-increment the patch version number
MAJOR=$(echo "$CURRENT_VERSION" | cut -d. -f1 | tr -d 'v')
MINOR=$(echo "$CURRENT_VERSION" | cut -d. -f2)
PATCH=$(echo "$CURRENT_VERSION" | cut -d. -f3)
NEW_PATCH=$((PATCH + 1))
NEW_VERSION="v${MAJOR}.${MINOR}.${NEW_PATCH}"

echo "  ✏️  Bumping: $CURRENT_VERSION → $NEW_VERSION"
echo "$NEW_VERSION" > "$APP_VERSION_FILE"
echo "  ✅ version.txt updated"

# STEP 3: Simulate CI detecting the change
print_step "3" "CI/CD pipeline triggered (GitHub Actions simulation)"
echo "  🔍 Detected change in: app/version.txt"
echo "  🏗️  Building image: krishnachavan01/gitops-simulator-app:$NEW_VERSION"
echo "  📋 Running unit tests... PASSED ✅"
echo "  🐳 Docker build complete ✅"
echo "  📤 Image pushed to registry ✅"

# STEP 4: Auto-update manifests (core GitOps pattern!)
print_step "4" "GitOps Controller: Auto-updating manifests"
echo "  🔄 Updating DEV manifest..."
sed -i.bak "s|image: krishnachavan01/gitops-simulator-app:.*|image: krishnachavan01/gitops-simulator-app:${NEW_VERSION}|g" "$DEV_MANIFEST"
rm -f "${DEV_MANIFEST}.bak"
echo "  ✅ manifests/dev/deployment.yaml updated"

echo "  🔄 Updating STAGING manifest..."
sed -i.bak "s|image: krishnachavan01/gitops-simulator-app:.*|image: krishnachavan01/gitops-simulator-app:${NEW_VERSION}|g" "$STAGING_MANIFEST"
rm -f "${STAGING_MANIFEST}.bak"
echo "  ✅ manifests/staging/deployment.yaml updated"

# STEP 5: Simulate reconciliation
print_step "5" "Environment Reconciliation (simulated kubectl apply)"
echo "  🌍 ENV: dev"
echo "     kubectl apply -f manifests/dev/deployment.yaml"
echo "     deployment.apps/gitops-simulator-app configured ✅"
echo ""
echo "  🌍 ENV: staging"
echo "     kubectl apply -f manifests/staging/deployment.yaml"
echo "     deployment.apps/gitops-simulator-app configured ✅"
echo ""
echo "  🌍 ENV: prod"
echo "     ⚠️  PROD requires manual promotion by Team Lead"
echo "     (Best practice: never auto-deploy to prod)"

# STEP 6: Summary
print_step "6" "GitOps Workflow Summary"
echo ""
echo "  ┌─────────────────────────────────────────────┐"
echo "  │  VERSION:  $CURRENT_VERSION → $NEW_VERSION              │"
echo "  │  DEV:      Deployed ✅                       │"
echo "  │  STAGING:  Deployed ✅                       │"
echo "  │  PROD:     Pending manual promotion 🔒       │"
echo "  └─────────────────────────────────────────────┘"
echo ""
echo "  💡 To rollback: git revert HEAD && git push"
echo "  💡 To promote to PROD: update manifests/prod/deployment.yaml"
echo "  💡 To trigger again: edit app/version.txt and push to GitHub"
echo ""
echo "  🎉 GitOps simulation complete!"
echo ""
