#!/bin/zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOCAL_PROPS="$PROJECT_ROOT/android/local.properties"
CREDENTIALS="$PROJECT_ROOT/.playstore.env"

# ── Load Flutter SDK from local.properties ────────────────────────────────────
if [[ ! -f "$LOCAL_PROPS" ]]; then
  echo "Error: android/local.properties not found"
  exit 1
fi

FLUTTER_SDK=$(grep "^flutter.sdk=" "$LOCAL_PROPS" | cut -d'=' -f2)
FLUTTER="$FLUTTER_SDK/bin/flutter"

if [[ ! -x "$FLUTTER" ]]; then
  echo "Error: flutter binary not found at $FLUTTER"
  exit 1
fi

# ── Load Play Store credentials ───────────────────────────────────────────────
if [[ ! -f "$CREDENTIALS" ]]; then
  echo "Error: .playstore.env not found. Copy .playstore.env.example and fill in your credentials."
  exit 1
fi

source "$CREDENTIALS"

if [[ -z "$PLAY_SERVICE_ACCOUNT_JSON" || -z "$PLAY_PACKAGE_NAME" || -z "$PLAY_TRACK" ]]; then
  echo "Error: PLAY_SERVICE_ACCOUNT_JSON, PLAY_PACKAGE_NAME, and PLAY_TRACK must be set in .playstore.env"
  exit 1
fi

if [[ ! -f "$PLAY_SERVICE_ACCOUNT_JSON" ]]; then
  echo "Error: Service account JSON not found at $PLAY_SERVICE_ACCOUNT_JSON"
  exit 1
fi

# ── Version Bump ─────────────────────────────────────────────────────────────
VERSION_PROPS="$PROJECT_ROOT/android/version.properties"
if [[ ! -f "$VERSION_PROPS" ]]; then
  echo "Error: android/version.properties not found"
  exit 1
fi

CURRENT_CODE=$(grep "^versionCode=" "$VERSION_PROPS" | cut -d'=' -f2)
CURRENT_NAME=$(grep "^versionName=" "$VERSION_PROPS" | cut -d'=' -f2)

NEW_CODE=$((CURRENT_CODE + 1))
VN_MAJOR=$(echo "$CURRENT_NAME" | cut -d'.' -f1)
VN_MINOR=$(echo "$CURRENT_NAME" | cut -d'.' -f2)
NEW_NAME="$VN_MAJOR.$((VN_MINOR + 1))"

sed -i '' "s/^versionCode=.*/versionCode=$NEW_CODE/" "$VERSION_PROPS"
sed -i '' "s/^versionName=.*/versionName=$NEW_NAME/" "$VERSION_PROPS"

echo "Version bumped: versionCode $CURRENT_CODE → $NEW_CODE | versionName $CURRENT_NAME → $NEW_NAME"

# ── Build AAB ─────────────────────────────────────────────────────────────────
echo "Building Android App Bundle (prod)..."
"$FLUTTER" build appbundle --release --dart-define=APP_ENV=prod

if [[ $? -ne 0 ]]; then
  echo "Error: Flutter build failed"
  exit 1
fi

# ── Find the generated AAB ────────────────────────────────────────────────────
AAB_PATH=$(find "$PROJECT_ROOT/build/app/outputs/bundle/release" -name "*.aab" | head -1)

if [[ -z "$AAB_PATH" ]]; then
  echo "Error: No .aab file found in build/app/outputs/bundle/release/"
  exit 1
fi

echo "Found AAB: $AAB_PATH"

# ── Upload to Google Play ─────────────────────────────────────────────────────
echo "Uploading to Google Play ($PLAY_TRACK track)..."
python3 "$PROJECT_ROOT/tools/play_upload.py" \
  --service-account "$PLAY_SERVICE_ACCOUNT_JSON" \
  --package-name "$PLAY_PACKAGE_NAME" \
  --aab "$AAB_PATH" \
  --track "$PLAY_TRACK"

if [[ $? -eq 0 ]]; then
  echo "Upload successful!"

  # ── Git commit & push ────────────────────────────────────────────────────────
  git -C "$PROJECT_ROOT" add android/version.properties
  git -C "$PROJECT_ROOT" commit -m "chore: bump android version to $NEW_NAME ($NEW_CODE) [prod deploy]"

  if [[ $? -eq 0 ]]; then
    echo "Version bump committed to git"
    git -C "$PROJECT_ROOT" push
    [[ $? -eq 0 ]] && echo "Pushed to remote" || echo "Warning: git push failed"
  else
    echo "Warning: git commit failed — version.properties was updated but not committed"
  fi
else
  echo "Upload failed."
  exit 1
fi