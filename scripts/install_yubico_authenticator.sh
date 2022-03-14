#!/bin/bash

echo '=> Installing Yubico Authenticator'
rm -f "${HOME}/bin/yubioath-desktop-"*"-linux.AppImage"
rm -f "${HOME}/Applications/yubioath-desktop-"*"-linux.AppImage"
if command -v -- "appimagelauncherd" &>/dev/null; then
  mkdir -p "${HOME}/Applications"
  wget \
    --directory-prefix="${HOME}/Applications" \
    --progress=bar:force:noscroll \
    --quiet \
    --show-progress \
    --timeout="5" \
    --tries="1" \
    -- \
    "https://developers.yubico.com/yubioath-desktop/Releases/yubioath-desktop-latest-linux.AppImage"
  chmod +x "${HOME}/Applications/yubioath-desktop-"*"-linux.AppImage"
else
  mkdir -p "${HOME}/bin"
  wget \
    --directory-prefix="${HOME}/bin" \
    --progress=bar:force:noscroll \
    --quiet \
    --show-progress \
    --timeout="5" \
    --tries="1" \
    -- \
    "https://developers.yubico.com/yubioath-desktop/Releases/yubioath-desktop-latest-linux.AppImage"
  chmod +x "${HOME}/bin/yubioath-desktop-"*"-linux.AppImage"
fi
