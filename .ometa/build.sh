#!/usr/bin/env bash
# Upstream only builds jailbreak .debs; this also injects the rootless build into a
# decrypted SoundCloud IPA with cyan (which bundles ElleKit for the hooks).
source "$PIPELINE/lib/helpers.sh"
setup_theos 16.5
install_cyan

VERSION=$(awk '/^Version:/ {print $2}' control)
FLAGS=(FINALPACKAGE=1 ARCHS="arm64 arm64e" TARGET="iphone:clang:16.5:14.0")

log "Rootless .deb"; make clean package "${FLAGS[@]}" THEOS_PACKAGE_SCHEME=rootless
ROOTLESS=$(ls packages/*_iphoneos-arm64.deb)
cp "$ROOTLESS" "$OUT/"
log "Rootful .deb";  make clean package "${FLAGS[@]}"
cp packages/*_iphoneos-arm.deb "$OUT/"

log "IPA (SoundCloud $BASE_VERSION)"
cyan -i "$BASE_IPA" -o "$OUT/SCMusicPlus_${BASE_VERSION}_v$VERSION.ipa" -uwf "$OUT/$(basename "$ROOTLESS")"
