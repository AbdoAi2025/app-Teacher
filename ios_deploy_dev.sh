#!/bin/zsh

# ─────────────────────────────────────────────────────────────────────────────
#  iOS Deploy — DEV  (TestFlight · Internal testers only)
# ─────────────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOCAL_PROPS="$SCRIPT_DIR/android/local.properties"
CREDENTIALS="$SCRIPT_DIR/.appstore.env"

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
fail()     { echo "${RED}✖ $1${NC}" }

# ── Flutter SDK ───────────────────────────────────────────────────────────────
section "Loading Flutter SDK"

[[ ! -f "$LOCAL_PROPS" ]] && error "android/local.properties not found"

FLUTTER_SDK=$(grep "^flutter.sdk=" "$LOCAL_PROPS" | cut -d'=' -f2)
FLUTTER="$FLUTTER_SDK/bin/flutter"

[[ ! -x "$FLUTTER" ]] && error "Flutter binary not found at $FLUTTER"
info "Flutter: $FLUTTER"

# ── Credentials ───────────────────────────────────────────────────────────────
section "Loading Credentials"

[[ ! -f "$CREDENTIALS" ]] && error ".appstore.env not found — copy .appstore.env.example and fill in your credentials"

source "$CREDENTIALS"

[[ -z "$APPLE_ID" || -z "$APPLE_APP_PASSWORD" ]] && \
  error "APPLE_ID and APPLE_APP_PASSWORD must be set in .appstore.env"

info "Apple ID: $APPLE_ID"
success "Credentials loaded"

# ── Build ─────────────────────────────────────────────────────────────────────
section "Building iOS Archive (dev)"

"$FLUTTER" build ipa --release --dart-define=APP_ENV=dev

[[ $? -ne 0 ]] && error "Flutter build failed"
success "Build complete"

# ── Locate Artifacts ──────────────────────────────────────────────────────────
section "Locating Artifacts"

IPA_PATH=$(find "$SCRIPT_DIR/build/ios/ipa" -name "*.ipa" | head -1)
[[ -z "$IPA_PATH" ]] && error "No .ipa file found in build/ios/ipa/"
info "IPA:   $IPA_PATH"

DSYM_DIR=$(find "$SCRIPT_DIR/build/ios/archive" -type d -name "dSYMs" | head -1)
if [[ -z "$DSYM_DIR" ]]; then
  warn "dSYMs directory not found — Firebase upload will be skipped"
else
  info "dSYMs: $DSYM_DIR"
fi

success "Artifacts located"

# ── Upload to TestFlight ───────────────────────────────────────────────────────
section "Uploading to TestFlight (Internal)"

xcrun altool --upload-app \
  --type ios \
  --file "$IPA_PATH" \
  --username "$APPLE_ID" \
  --password "$APPLE_APP_PASSWORD"

if [[ $? -eq 0 ]]; then
  success "Upload successful — build available to internal testers only"
else
  error "TestFlight upload failed"
fi

# ── Upload dSYMs to Firebase Crashlytics ──────────────────────────────────────
section "Uploading dSYMs to Firebase Crashlytics"

UPLOAD_SYMBOLS="$SCRIPT_DIR/ios/Pods/FirebaseCrashlytics/upload-symbols"
GOOGLE_SERVICE_INFO="$SCRIPT_DIR/ios/GoogleService-Info.plist"

if [[ -n "$DSYM_DIR" && -x "$UPLOAD_SYMBOLS" && -f "$GOOGLE_SERVICE_INFO" ]]; then
  "$UPLOAD_SYMBOLS" -gsp "$GOOGLE_SERVICE_INFO" -p ios "$DSYM_DIR"
  if [[ $? -eq 0 ]]; then
    success "dSYMs uploaded to Firebase Crashlytics"
  else
    fail "dSYM upload to Firebase failed"
  fi
else
  warn "Skipping — upload-symbols binary or GoogleService-Info.plist not found"
fi

# ─────────────────────────────────────────────────────────────────────────────
echo "\n${BOLD}${GREEN}🚀 Dev deploy complete!${NC}\n"
