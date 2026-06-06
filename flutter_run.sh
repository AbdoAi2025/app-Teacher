#!/bin/zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOCAL_PROPS="$SCRIPT_DIR/android/local.properties"

if [[ ! -f "$LOCAL_PROPS" ]]; then
  echo "Error: android/local.properties not found at $LOCAL_PROPS"
  exit 1
fi

FLUTTER_SDK=$(grep "^flutter.sdk=" "$LOCAL_PROPS" | cut -d'=' -f2)

if [[ -z "$FLUTTER_SDK" ]]; then
  echo "Error: flutter.sdk not found in local.properties"
  exit 1
fi

FLUTTER="$FLUTTER_SDK/bin/flutter"

if [[ ! -x "$FLUTTER" ]]; then
  echo "Error: flutter binary not found at $FLUTTER"
  exit 1
fi

echo "Using Flutter SDK: $FLUTTER_SDK"
exec "$FLUTTER" "$@"