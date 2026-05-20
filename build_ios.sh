#!/usr/bin/env bash

cd "$(dirname "$0")"

rm -rf build/ios/iphoneos

flutter build ios --flavor production --no-codesign

codesign -s - -f build/ios/iphoneos/Runner.app
codesign -s - -f build/ios/iphoneos/Runner.app/Frameworks/*

cd build/ios/iphoneos
mkdir Payload
mv Runner.app Payload/
zip -qr Fladder.ipa Payload

echo "IPA built at $(realpath Fladder.ipa)"
