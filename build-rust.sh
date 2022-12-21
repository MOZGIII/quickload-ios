#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

PROJECT_DIR="${PROJECT_DIR:-"$SCRIPT_DIR"}"

cd "$PROJECT_DIR"

export PATH="$HOME/.cargo/bin:$PATH"

export SWIFT_BRIDGE_OUT_DIR="${PROJECT_DIR}/Generated"

# Without this we can't compile on MacOS Big Sur
# https://github.com/TimNN/cargo-lipo/issues/41#issuecomment-774793892
if [[ -n "${DEVELOPER_SDK_DIR:-}" ]]; then
  export LIBRARY_PATH="${DEVELOPER_SDK_DIR}/MacOSX.sdk/usr/lib:${LIBRARY_PATH:-}"
fi

TARGETS=(aarch64-apple-ios x86_64-apple-ios)
if [[ "${LLVM_TARGET_TRIPLE_SUFFIX:-}" == "-simulator" ]]; then
  TARGETS=(aarch64-apple-ios-sim)
fi

TARGETS_STR="$(
  IFS=,
  printf "%s" "${TARGETS[*]}"
)"

CMD=(
  cargo lipo -v
  --targets "$TARGETS_STR"
)

if [[ "${CONFIGURATION:-}" == "Release" ]]; then
  echo "BUIlDING FOR RELEASE"
  CMD+=(--release)
else
  echo "BUIlDING FOR DEBUG"
fi

"${CMD[@]}"
