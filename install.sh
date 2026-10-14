#!/bin/sh
# Aun Kitchen 投稿づくりを入れる（Mac用）。2回目以降に実行すると最新版に入れ替わる（作った投稿は残る）。
# 使い方: ターミナルに次の1行を貼る
#   curl -fsSL https://raw.githubusercontent.com/fuganakai/aun-studio/main/install.sh | sh
main() {
  set -e
  URL="${AUN_URL:-https://github.com/fuganakai/aun-studio/releases/latest/download/aun-studio.zip}"
  DEST="$HOME/AunKitchen"
  TMP=$(mktemp -d)
  echo "ダウンロードしています…"
  curl -fsSL "$URL" -o "$TMP/a.zip"
  ditto -x -k "$TMP/a.zip" "$TMP/x"
  mkdir -p "$DEST"
  cp -R "$TMP/x/Aun投稿づくり/." "$DEST/"
  rm -rf "$TMP"
  chmod +x "$DEST/はじめる.command"
  # アイコン付きのアプリを作る。開くとターミナルで はじめる.command が動く
  APP="$HOME/Applications/Aun投稿づくり.app"
  rm -rf "$APP"; mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
  cp "$DEST/studio/assets/icon.icns" "$APP/Contents/Resources/icon.icns"
  printf '#!/bin/sh\nopen -a Terminal "$HOME/AunKitchen/はじめる.command"\n' > "$APP/Contents/MacOS/run"
  chmod +x "$APP/Contents/MacOS/run"
  cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleName</key><string>Aun投稿づくり</string>
<key>CFBundleDisplayName</key><string>Aun投稿づくり</string>
<key>CFBundleIdentifier</key><string>jp.aunkitchen.studio</string>
<key>CFBundleExecutable</key><string>run</string>
<key>CFBundleIconFile</key><string>icon</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleShortVersionString</key><string>1.0</string>
</dict></plist>
PLIST
  touch "$APP"
  rm -f "$HOME/Desktop/Aun投稿づくり.command"  # 以前の版がデスクトップに置いたもの
  if ln -sfn "$APP" "$HOME/Desktop/Aun投稿づくり" 2>/dev/null; then
    echo "入れました。次からはデスクトップ（またはアプリケーション）の「Aun投稿づくり」をダブルクリックすると開けます。"
  else
    echo "入れました。次からはアプリケーションの「Aun投稿づくり」をダブルクリックすると開けます。"
  fi
  exec "$DEST/はじめる.command" </dev/null
}
main
