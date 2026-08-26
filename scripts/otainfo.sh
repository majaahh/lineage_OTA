#!/bin/bash

if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <ota zip> <repo url> <releasename>"
    exit 1
fi

ZIP="$1"
REPOURL="$2"
RELEASENAME="$3"

if [[ ! -f "$ZIP" ]]; then
    echo "ZIP file was not found: $ZIP"
    exit 1
fi

METADATA=$(unzip -p "$ZIP" "META-INF/com/android/metadata")

DEVICE=$(echo "$METADATA" | grep pre-device | cut -f2 -d '=' | cut -f1 -d ',')
SDK_LEVEL=$(echo "$METADATA" | grep post-sdk-level | cut -f2 -d '=')
TIMESTAMP=$(echo "$METADATA" | grep post-timestamp | cut -f2 -d '=')

FILENAME=$(basename "$ZIP")
ID=$(echo "${TIMESTAMP}${DEVICE}${SDK_LEVEL}" | sha256sum | cut -f 1 -d ' ')
SIZE=$(du -b "$ZIP" | cut -f1 -d '	')
TYPE=$(echo "$FILENAME" | cut -f4 -d '-')
VERSION=$(echo "$FILENAME" | cut -f2 -d '-')

URL="$REPOURL/releases/download/$RELEASENAME/$FILENAME"

echo "{"
echo "  \"response\": ["
echo "    {"
echo "      \"datetime\": \"$TIMESTAMP\","
echo "      \"filename\": \"$FILENAME\","
echo "      \"id\": \"$ID\","
echo "      \"romtype\": \"$TYPE\","
echo "      \"size\": \"$SIZE\","
echo "      \"url\": \"$URL\","
echo "      \"version\": \"$VERSION\""
echo "    }"
echo "  ]"
echo "}"
