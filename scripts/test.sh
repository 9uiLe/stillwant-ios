#!/usr/bin/env bash
set -euo pipefail

xcodegen generate --spec project.yml

device="$(xcrun simctl list devices available --json | jq -r '
  [.devices[][] |
    select(.isAvailable == true) |
    select(.deviceTypeIdentifier | contains("iPhone"))
  ][0] |
  if . then [.udid, .state] | @tsv else "" end
')"

if [[ -z "$device" ]]; then
  echo "No available iPhone Simulator was found." >&2
  exit 1
fi

IFS=$'\t' read -r device_udid device_state <<< "$device"

if [[ "$device_state" != "Booted" ]]; then
  xcrun simctl boot "$device_udid"
fi
xcrun simctl bootstatus "$device_udid" -b

derived_data="${NAGI_DERIVED_DATA:-$PWD/DerivedData}"

xcodebuild \
  -project StillWant.xcodeproj \
  -scheme StillWant \
  -destination "platform=iOS Simulator,id=$device_udid" \
  -derivedDataPath "$derived_data" \
  test
