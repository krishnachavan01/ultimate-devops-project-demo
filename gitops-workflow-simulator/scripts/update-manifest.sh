#!/bin/bash
# =============================================================
# update-manifest.sh
# Updates the image tag in a deployment.yaml file
# Usage: ./update-manifest.sh <manifest_path> <new_version>
# =============================================================

MANIFEST_PATH="$1"
NEW_VERSION="$2"

if [ -z "$MANIFEST_PATH" ] || [ -z "$NEW_VERSION" ]; then
  echo "❌ Usage: $0 <manifest_path> <new_version>"
  exit 1
fi

echo "📝 Updating manifest: $MANIFEST_PATH"
echo "🏷️  New image tag: $NEW_VERSION"

# Use sed to replace the image tag line (core GitOps pattern!)
sed -i.bak "s|image: krishnachavan01/gitops-simulator-app:.*|image: krishnachavan01/gitops-simulator-app:${NEW_VERSION}|g" "$MANIFEST_PATH"

echo "✅ Manifest updated successfully!"
echo ""
echo "--- Updated image line ---"
grep "image:" "$MANIFEST_PATH"
