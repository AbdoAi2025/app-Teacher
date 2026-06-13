#!/bin/zsh

# ─────────────────────────────────────────────────────────────────────────────
#  Android Deploy — DEV  (Google Play · Internal Testing track)
# ─────────────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOCAL_PROPS="$PROJECT_ROOT/android/local.properties"
CREDENTIALS="$PROJECT_ROOT/tools/.playstore.env"

# ── Colors & helpers ──────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

section()  { echo "\n${BOLD}${CYAN}▶ $1${NC}" }
success()  { echo "${GREEN}✔ $1${NC}" }
info()     { echo "${DIM}  $1${NC}" }
warn()     { echo "${YELLOW}⚠ $1${NC}" }
error()    { echo "${RED}✖ $1${NC}"; exit 1 }

# ── Flutter SDK ───────────────────────────────────────────────────────────────
section "Loading Flutter SDK"

[[ ! -f "$LOCAL_PROPS" ]] && error "android/local.properties not found"

FLUTTER_SDK=$(grep "^flutter.sdk=" "$LOCAL_PROPS" | cut -d'=' -f2)
FLUTTER="$FLUTTER_SDK/bin/flutter"

[[ ! -x "$FLUTTER" ]] && error "Flutter binary not found at $FLUTTER"
info "Flutter: $FLUTTER"
success "Flutter SDK loaded"

# ── Credentials ───────────────────────────────────────────────────────────────
section "Loading Play Store Credentials"

[[ ! -f "$CREDENTIALS" ]] && error ".playstore.env not found — copy .playstore.env.example and fill in your credentials"

source "$CREDENTIALS"

[[ -z "$PLAY_SERVICE_ACCOUNT_JSON" || -z "$PLAY_PACKAGE_NAME" ]] && \
  error "PLAY_SERVICE_ACCOUNT_JSON and PLAY_PACKAGE_NAME must be set in .playstore.env"

[[ ! -f "$PLAY_SERVICE_ACCOUNT_JSON" ]] && \
  error "Service account JSON not found at $PLAY_SERVICE_ACCOUNT_JSON"

info "Package: $PLAY_PACKAGE_NAME"
info "Track:   internal"
success "Credentials loaded"

# ── Version Bump ─────────────────────────────────────────────────────────────
section "Bumping version"

VERSION_PROPS="$PROJECT_ROOT/android/version.properties"
[[ ! -f "$VERSION_PROPS" ]] && error "android/version.properties not found"

CURRENT_CODE=$(grep "^versionCode=" "$VERSION_PROPS" | cut -d'=' -f2)
CURRENT_NAME=$(grep "^versionName=" "$VERSION_PROPS" | cut -d'=' -f2)

NEW_CODE=$((CURRENT_CODE + 1))
VN_MAJOR=$(echo "$CURRENT_NAME" | cut -d'.' -f1)
VN_MINOR=$(echo "$CURRENT_NAME" | cut -d'.' -f2)
NEW_NAME="$VN_MAJOR.$((VN_MINOR + 1))"

sed -i '' "s/^versionCode=.*/versionCode=$NEW_CODE/" "$VERSION_PROPS"
sed -i '' "s/^versionName=.*/versionName=$NEW_NAME/" "$VERSION_PROPS"

info "versionCode: $CURRENT_CODE → $NEW_CODE"
info "versionName: $CURRENT_NAME → $NEW_NAME"
success "Version bumped"

# ── Build AAB ─────────────────────────────────────────────────────────────────
section "Building Android App Bundle (dev)"

"$FLUTTER" build appbundle --release --dart-define=APP_ENV=dev

[[ $? -ne 0 ]] && error "Flutter build failed"
success "Build complete"

# ── Locate AAB ────────────────────────────────────────────────────────────────
section "Locating Artifact"

AAB_PATH=$(find "$PROJECT_ROOT/build/app/outputs/bundle/release" -name "*.aab" | head -1)
[[ -z "$AAB_PATH" ]] && error "No .aab file found in build/app/outputs/bundle/release/"
info "AAB: $AAB_PATH"
success "Artifact located"

# ── Upload to Google Play (internal) ─────────────────────────────────────────
section "Uploading to Google Play (internal testing)"

python3 "$PROJECT_ROOT/tools/play_upload.py" \
  --service-account "$PLAY_SERVICE_ACCOUNT_JSON" \
  --package-name "$PLAY_PACKAGE_NAME" \
  --aab "$AAB_PATH" \
  --track "internal"

if [[ $? -eq 0 ]]; then
  success "Upload successful — build available to internal testers"

  # ── Git commit ───────────────────────────────────────────────────────────────
  section "Committing version bump"

  git -C "$PROJECT_ROOT" add android/version.properties
  git -C "$PROJECT_ROOT" commit -m "chore: bump android version to $NEW_NAME ($NEW_CODE) [dev deploy]"

  if [[ $? -eq 0 ]]; then
    success "Version bump committed"
    git -C "$PROJECT_ROOT" push
    [[ $? -eq 0 ]] && success "Pushed to remote" || warn "Git push failed"
  else
    warn "Git commit failed — version.properties was updated but not committed"
  fi
else
  error "Google Play upload failed"
fi

# ─────────────────────────────────────────────────────────────────────────────
echo "\n${BOLD}${GREEN}🚀 Dev deploy complete!${NC}\n"