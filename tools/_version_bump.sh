#!/bin/zsh
# Shared version bump prompts — sourced by deploy scripts.
#
# prompt_android_version_bump <version.properties path>
#   Exports: NEW_CODE, NEW_NAME, VERSION_BUMPED
#
# prompt_ios_version_bump <Info.plist path>
#   Exports: NEW_SHORT_VERSION, NEW_BUNDLE_VERSION, VERSION_BUMPED

# ── Android ───────────────────────────────────────────────────────────────────
prompt_android_version_bump() {
  local props="$1"

  CURRENT_CODE=$(grep "^versionCode=" "$props" | cut -d'=' -f2)
  CURRENT_NAME=$(grep "^versionName=" "$props" | cut -d'=' -f2)

  local MAJOR MINOR PATCH
  MAJOR=$(echo "$CURRENT_NAME" | cut -d'.' -f1)
  MINOR=$(echo "$CURRENT_NAME" | cut -d'.' -f2)
  PATCH=$(echo "$CURRENT_NAME" | cut -d'.' -f3)
  PATCH=${PATCH:-0}

  echo ""
  echo "  ${BOLD}Current:${NC} versionName=${YELLOW}$CURRENT_NAME${NC}  versionCode=${YELLOW}$CURRENT_CODE${NC}"
  echo ""
  echo "  What would you like to bump?"
  echo "  1) versionName only  ($CURRENT_NAME → $MAJOR.$MINOR.$((PATCH + 1)))"
  echo "  2) versionCode only  ($CURRENT_CODE → $((CURRENT_CODE + 1)))"
  echo "  3) Both (auto)"
  echo "  4) Enter custom"
  echo "  5) Skip"
  echo ""
  printf "  Choose [1-5]: "
  read -r _choice

  VERSION_BUMPED=true

  case "$_choice" in
    1)
      NEW_NAME="$MAJOR.$MINOR.$((PATCH + 1))"
      NEW_CODE=$CURRENT_CODE
      ;;
    2)
      NEW_NAME=$CURRENT_NAME
      NEW_CODE=$((CURRENT_CODE + 1))
      ;;
    3)
      NEW_NAME="$MAJOR.$MINOR.$((PATCH + 1))"
      NEW_CODE=$((CURRENT_CODE + 1))
      ;;
    4)
      printf "  versionName (e.g. 5.2.1): "
      read -r NEW_NAME
      printf "  versionCode (integer):    "
      read -r NEW_CODE
      [[ -z "$NEW_NAME" ]] && NEW_NAME=$CURRENT_NAME
      [[ -z "$NEW_CODE" ]] && NEW_CODE=$CURRENT_CODE
      ;;
    5)
      NEW_NAME=$CURRENT_NAME
      NEW_CODE=$CURRENT_CODE
      VERSION_BUMPED=false
      echo "  ${DIM}Version bump skipped${NC}"
      return 0
      ;;
    *)
      echo "  ${YELLOW}Invalid choice — skipping version bump${NC}"
      NEW_NAME=$CURRENT_NAME
      NEW_CODE=$CURRENT_CODE
      VERSION_BUMPED=false
      return 0
      ;;
  esac

  sed -i '' "s/^versionCode=.*/versionCode=$NEW_CODE/" "$props"
  sed -i '' "s/^versionName=.*/versionName=$NEW_NAME/" "$props"

  info "versionCode : $CURRENT_CODE → $NEW_CODE"
  info "versionName : $CURRENT_NAME → $NEW_NAME"
  success "Version updated"
}

# ── iOS ───────────────────────────────────────────────────────────────────────
prompt_ios_version_bump() {
  local plist="$1"
  local pb="/usr/libexec/PlistBuddy"

  SHORT_VERSION=$("$pb" -c "Print :CFBundleShortVersionString" "$plist")
  BUNDLE_VERSION=$("$pb" -c "Print :CFBundleVersion" "$plist")

  local MAJOR MINOR PATCH
  MAJOR=$(echo "$SHORT_VERSION" | cut -d'.' -f1)
  MINOR=$(echo "$SHORT_VERSION" | cut -d'.' -f2)
  PATCH=$(echo "$SHORT_VERSION" | cut -d'.' -f3)
  PATCH=${PATCH:-0}

  echo ""
  echo "  ${BOLD}Current:${NC} shortVersion=${YELLOW}$SHORT_VERSION${NC}  bundleVersion=${YELLOW}$BUNDLE_VERSION${NC}"
  echo ""
  echo "  What would you like to bump?"
  echo "  1) Short version only  ($SHORT_VERSION → $MAJOR.$MINOR.$((PATCH + 1)))"
  echo "  2) Bundle version only ($BUNDLE_VERSION → $((BUNDLE_VERSION + 1)))"
  echo "  3) Both (auto)"
  echo "  4) Enter custom"
  echo "  5) Skip"
  echo ""
  printf "  Choose [1-5]: "
  read -r _choice

  VERSION_BUMPED=true

  case "$_choice" in
    1)
      NEW_SHORT_VERSION="$MAJOR.$MINOR.$((PATCH + 1))"
      NEW_BUNDLE_VERSION=$BUNDLE_VERSION
      ;;
    2)
      NEW_SHORT_VERSION=$SHORT_VERSION
      NEW_BUNDLE_VERSION=$((BUNDLE_VERSION + 1))
      ;;
    3)
      NEW_SHORT_VERSION="$MAJOR.$MINOR.$((PATCH + 1))"
      NEW_BUNDLE_VERSION=$((BUNDLE_VERSION + 1))
      ;;
    4)
      printf "  Short version (e.g. 5.2.1): "
      read -r NEW_SHORT_VERSION
      printf "  Bundle version (integer):   "
      read -r NEW_BUNDLE_VERSION
      [[ -z "$NEW_SHORT_VERSION" ]] && NEW_SHORT_VERSION=$SHORT_VERSION
      [[ -z "$NEW_BUNDLE_VERSION" ]] && NEW_BUNDLE_VERSION=$BUNDLE_VERSION
      ;;
    5)
      NEW_SHORT_VERSION=$SHORT_VERSION
      NEW_BUNDLE_VERSION=$BUNDLE_VERSION
      VERSION_BUMPED=false
      echo "  ${DIM}Version bump skipped${NC}"
      return 0
      ;;
    *)
      echo "  ${YELLOW}Invalid choice — skipping version bump${NC}"
      NEW_SHORT_VERSION=$SHORT_VERSION
      NEW_BUNDLE_VERSION=$BUNDLE_VERSION
      VERSION_BUMPED=false
      return 0
      ;;
  esac

  "$pb" -c "Set :CFBundleShortVersionString $NEW_SHORT_VERSION" "$plist"
  "$pb" -c "Set :CFBundleVersion $NEW_BUNDLE_VERSION" "$plist"

  info "CFBundleShortVersionString : $SHORT_VERSION → $NEW_SHORT_VERSION"
  info "CFBundleVersion            : $BUNDLE_VERSION → $NEW_BUNDLE_VERSION"
  success "Version updated"
}