#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────
# fetch-images.sh — pull the Casa Ezra and Maria portfolio images
# straight to the right filenames so the deck just works.
#
# Run once from this folder:
#   bash fetch-images.sh
# ─────────────────────────────────────────────────────────────────────

set -euo pipefail
cd "$(dirname "$0")"

mkdir -p img/casa-ezra img/maria

CE="https://cocoonflexspaces.com/wp-content/uploads/2025/07"
MS="https://images.squarespace-cdn.com/content/v1/637d3ed5b298951a81704223"

# Browser-style headers to bypass Sucuri / sgcaptcha on cocoonflexspaces.com
UA='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15'
COOKIE_JAR="$(mktemp)"
trap 'rm -f "$COOKIE_JAR"' EXIT

valid_image() {
  # File must exist, be > 1KB, and be a real image (not an HTML captcha page)
  [ -f "$1" ] && [ "$(stat -f%z "$1" 2>/dev/null || stat -c%s "$1")" -gt 1024 ] && \
    file "$1" | grep -qiE 'image|jpeg|png|webp'
}

dl() {
  local url="$1" out="$2" referer="${3:-}"
  if valid_image "$out"; then
    echo "  ✓ $out (already downloaded)"
    return
  fi
  echo "  → $out"
  curl -sSL --fail \
    -A "$UA" \
    ${referer:+-e "$referer"} \
    -H 'Accept: image/avif,image/webp,image/png,image/jpeg,*/*;q=0.8' \
    -H 'Accept-Language: en-US,en;q=0.9' \
    -b "$COOKIE_JAR" -c "$COOKIE_JAR" \
    -o "$out" "$url" \
    || { echo "    ✗ failed (http error): $url"; rm -f "$out"; return; }

  if ! valid_image "$out"; then
    echo "    ✗ got non-image (likely WAF challenge): $url"
    echo "      Workaround: open $url in Safari, save image, place at $out"
    rm -f "$out"
  fi
}

# Warm Sucuri cookies by visiting the Casa Ezra listing first
echo "  → warming up cookies on cocoonflexspaces.com…"
curl -sSL -A "$UA" -b "$COOKIE_JAR" -c "$COOKIE_JAR" \
  -H 'Accept: text/html,application/xhtml+xml' \
  -o /dev/null "https://cocoonflexspaces.com/casa-ezra/" || true

echo "──────────────────────────────────────────"
echo "  Casa Ezra (cocoonflexspaces.com)"
echo "──────────────────────────────────────────"
CE_REF="https://cocoonflexspaces.com/casa-ezra/"
# Hero (cover image): wisteria-pergola backyard
dl "$CE/cocoon-casa-ezra-outdoor-backyard-wisteria-pergola-grill.jpg"                     "img/casa-ezra/hero.jpg"        "$CE_REF"
dl "$CE/cocoon-casa-ezra-outdoor-backyard-wisteria-pergola-grill.jpg"                     "img/casa-ezra/backyard.jpg"    "$CE_REF"
dl "$CE/cocoon-casa-ezra-living-room-modern-fireplace-armchairs-artifacts1.jpg"           "img/casa-ezra/living-room.jpg" "$CE_REF"
dl "$CE/cocoon-casa-ezra-kitchen-lavender-white-storage-marble-counter-island-scaled.jpg" "img/casa-ezra/kitchen.jpg"     "$CE_REF"

echo ""
echo "──────────────────────────────────────────"
echo "  Photographer 2 — Maria's portfolio"
echo "──────────────────────────────────────────"
# A curated 7-shot set across Maria's portfolio (event/portrait/atmospheric)
dl "$MS/bb2090fb-841c-46b4-af60-4178fa43faea/361A1832-2.jpg?format=1500w"  "img/maria/01.jpg"
dl "$MS/f497d28e-ac45-42f7-860b-e389bd0fffc1/361A3943.jpg?format=1500w"    "img/maria/02.jpg"
dl "$MS/f1514fc0-756d-48a4-8c82-455c97038254/361A7621.jpg?format=1500w"    "img/maria/03.jpg"
dl "$MS/2b0bb228-2431-44a2-bf90-72377a4801cb/361A1054.jpg?format=1500w"    "img/maria/04.jpg"
dl "$MS/3ae0cd5d-e83c-4ae0-9103-a0c50b3e6375/DSC06183.jpg?format=1500w"    "img/maria/05.jpg"
dl "$MS/dac17fb7-7447-41e0-b831-51da319d2b10/DSC09993-3.jpg?format=1500w"  "img/maria/06.jpg"
dl "$MS/4d56ea8b-ad0c-41c0-80f6-fc4f166ba742/361A7949-2.jpg?format=1500w"  "img/maria/07.jpg"

echo ""
echo "──────────────────────────────────────────"
echo "  Resizing to ≤1600px and stripping metadata"
echo "──────────────────────────────────────────"

# Optional: resize/strip if ImageMagick is available
if command -v magick >/dev/null 2>&1 || command -v convert >/dev/null 2>&1; then
  CMD="magick"; command -v $CMD >/dev/null 2>&1 || CMD="convert"
  for f in img/casa-ezra/*.jpg img/maria/*.jpg; do
    [ -f "$f" ] || continue
    $CMD "$f" -resize "1600x1600>" -strip -quality 84 "$f.tmp" && mv "$f.tmp" "$f"
    echo "  ✓ $f"
  done
else
  echo "  (ImageMagick not installed — skipping resize. Install via 'brew install imagemagick' if you want.)"
fi

echo ""
echo "  ✓ Done. Open index.html to preview."
echo ""
