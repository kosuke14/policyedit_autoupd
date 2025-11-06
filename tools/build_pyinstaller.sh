#!/usr/bin/env bash
set -eux

# args:
# $1 = entrypoint (repo-relative path to your script, e.g. main.py)
# $2 = base name for the generated binary (e.g. policyedit_autoupd)
# $3 = arch name (x86_64 or arm64)
ENTRY=${1:-main.py}
BASENAME=${2:-policyedit_autoupd}
ARCH=${3:-x86_64}

DIST_DIR=dist
BUILD_DIR=build
ARTIFACT_DIR=/src/artifacts

# ensure paths
rm -rf "${DIST_DIR}" "${BUILD_DIR}"
mkdir -p "${ARTIFACT_DIR}"

# Compose --add-data arguments to include interfaces, proto, schema dirs if they exist
ADD_DATA_ARGS=()
for d in interfaces proto schema; do
  if [ -e "$d" ]; then
    # format: "source:dest" (on Linux use colon)
    ADD_DATA_ARGS+=(--add-data "${d}:${d}")
  fi
done

# Run PyInstaller: onefile, name per-arch, include data dirs
pyinstaller --onefile --noconfirm --clean --name "${BASENAME}-${ARCH}" "${ENTRY}" "${ADD_DATA_ARGS[@]}"

# copy output artifact(s) back to the repository-mounted artifacts dir
if [ -d "${DIST_DIR}" ]; then
  cp -a "${DIST_DIR}/." "${ARTIFACT_DIR}/"
else
  echo "ERROR: dist directory not found, build probably failed"
  exit 2
fi

# strip binary (attempt) to reduce size if strip exists and binary is ELF
BIN="${ARTIFACT_DIR}/${BASENAME}-${ARCH}"
if [ -f "$BIN" ]; then
  file "$BIN" || true
  if command -v strip >/dev/null 2>&1; then
    strip --strip-all "$BIN" || true
  fi
  ls -lh "$BIN"
else
  echo "No binary produced at expected path: $BIN"
  echo "Dist contents:"
  ls -al "${DIST_DIR}" || true
  exit 3
fi
