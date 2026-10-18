#!/usr/bin/env bash
# ============================================================
#  Apex Minimap Studio - import a minimap you already have
#  (Linux / macOS - works headless over SSH)
#
#  TWO WAYS TO USE THIS:
#    A) bash import_map.sh /path/to/your/minimap        (folder, .zip or .png)
#    B) copy the files into tools/map_in/ then:  bash import_map.sh
#
#  Optional:
#    bash import_map.sh /path/to/map --label "Roxwood"
#    bash import_map.sh --list
#    bash import_map.sh --remove roxwood
#
#  Make it executable once if you prefer ./import_map.sh :
#    chmod +x import_map.sh
# ============================================================
cd "$(dirname "$0")" || exit 1

if ! command -v node >/dev/null 2>&1; then
    echo
    echo "[ERROR] Node.js is not installed or not on PATH."
    echo "Install it:  https://nodejs.org  (or 'apt install nodejs' / 'nvm install --lts')"
    echo
    exit 1
fi

node import_map.js "$@"
