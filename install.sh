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
  L="$HOME/Desktop/Aun投稿づくり.command"
  if printf '#!/bin/sh\nexec "$HOME/AunKitchen/はじめる.command"\n' > "$L" 2>/dev/null && chmod +x "$L"; then
    echo "入れました。次からはデスクトップの「Aun投稿づくり」をダブルクリックすると開けます。"
  else
    echo "入れました。次からは ホーム → AunKitchen →「はじめる.command」をダブルクリックすると開けます。"
  fi
  exec "$DEST/はじめる.command" </dev/null
}
main
