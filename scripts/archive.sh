#!/usr/bin/env bash
set -euo pipefail

xcodegen generate --spec project.yml

archive_path="${NAGI_ARCHIVE_PATH:-$PWD/Artifacts/StillWant.xcarchive}"
derived_data="${NAGI_DERIVED_DATA:-$PWD/DerivedData}"

xcodebuild \
  -project StillWant.xcodeproj \
  -scheme StillWant \
  -destination "generic/platform=iOS" \
  -archivePath "$archive_path" \
  -derivedDataPath "$derived_data" \
  CODE_SIGNING_ALLOWED=NO \
  archive
