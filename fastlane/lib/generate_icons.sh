#!/usr/bin/env bash
set -e

RES_DIR="./out"
ICON_SRC="app_icon.png"

for ARG in "$@"; do
  case $ARG in
    --res_dir=*)
      RES_DIR="${ARG#*=}"
      shift
      ;;
    --icon_src=*)
      ICON_SRC="${ARG#*=}"
      shift
      ;;
    *)
      echo "Warning: unknown parameter $ARG"
      ;;
  esac
done

if [ ! -f "$ICON_SRC" ]; then
  echo "Error: icon file '$ICON_SRC' not found!"
  exit 1
fi

densities=(mdpi hdpi xhdpi xxhdpi xxxhdpi)

# Legacy Icon Sizes !fuck you bash 3!
sizes=(48 72 96 144 192)

# Adaptive Icon Sizes !fuck you bash 3!
fg_sizes=(108 162 216 324 432)

legacy_icons=("ic_launcher" "ic_launcher_round")
adaptive_icons=("ic_launcher_foreground")

generate_icon() {
  local src=$1
  local dest=$2
  local size=$3

  magick "$src" -resize "${size}x${size}" "$dest"
  echo "Created $dest"
}

# Legacy Icons
for i in "${!densities[@]}"; do
  density="${densities[$i]}"
  size="${sizes[$i]}"
  folder="$RES_DIR/mipmap-$density"
  mkdir -p "$folder"

  for icon in "${legacy_icons[@]}"; do
    dest="$folder/$icon.webp"
    generate_icon "$ICON_SRC" "$dest" "$size"
  done
done

# Adaptive Icons
for i in "${!densities[@]}"; do
  density="${densities[$i]}"
  size="${fg_sizes[$i]}"
  folder="$RES_DIR/mipmap-$density"
  mkdir -p "$folder"

  for icon in "${adaptive_icons[@]}"; do
    dest="$folder/$icon.webp"
    generate_icon "$ICON_SRC" "$dest" "$size"
  done
done

PLAYSTORE_ICON="$RES_DIR/../ic_launcher-playstore.png"
mkdir -p "$(dirname "$PLAYSTORE_ICON")"
magick "$ICON_SRC" -resize 512x512 "$PLAYSTORE_ICON"
echo "Creato $PLAYSTORE_ICON (Play Store)"