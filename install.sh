#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGES_FILE="$DOTFILES_DIR/packages.txt"

# --- Parse groups from packages.txt ---
get_packages() {
    local groups=("$@")
    local current_group=""

    while IFS= read -r line; do
        # Detect group header
        if [[ "$line" =~ ^#\ Group:\ (.+)$ ]]; then
            current_group="${BASH_REMATCH[1]}"
            continue
        fi
        # Skip comments and empty lines
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        # Check if current group is in requested groups
        for g in "${groups[@]}"; do
            if [[ "$g" == "$current_group" ]]; then
                echo "$line"
                break
            fi
        done
    done < "$PACKAGES_FILE"
}

# --- Usage ---
if [[ $# -eq 0 ]]; then
    echo "=== Arch Linux Workstation Setup ==="
    echo ""
    echo "Usage: ./install.sh <group1> [group2] ..."
    echo ""
    echo "Available groups:"
    grep '^# Group:' "$PACKAGES_FILE" | sed 's/# Group: /  - /'
    echo ""
    echo "Examples:"
    echo "  ./install.sh base dev apps           # full workstation"
    echo "  ./install.sh base dev apps i3        # + i3"
    echo "  ./install.sh base dev apps hyprland  # + hyprland"
    echo "  ./install.sh base dev apps aur       # + AUR packages"
    exit 0
fi

GROUPS=("$@")
echo "=== Arch Linux Workstation Setup ==="
echo "Groups: ${GROUPS[*]}"
echo ""

# [1] Install packages
PACKAGES=$(get_packages "${GROUPS[@]}")
if [[ -z "$PACKAGES" ]]; then
    echo "No packages found for groups: ${GROUPS[*]}"
    exit 1
fi

echo "[1/3] Installing pacman packages..."
echo "$PACKAGES" | sudo pacman -S --needed --noconfirm -

# [2] Install yay if not present
if ! command -v yay &>/dev/null; then
    echo "[2/3] Installing yay..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay-install
    cd /tmp/yay-install && makepkg -si --noconfirm
    rm -rf /tmp/yay-install
else
    echo "[2/3] yay already installed, skipping"
fi

# [2.5] Install AUR packages if aur group was requested
for g in "${GROUPS[@]}"; do
    if [[ "$g" == "aur" ]]; then
        AUR_PACKAGES=$(get_packages aur)
        if [[ -n "$AUR_PACKAGES" ]]; then
            echo "[2.5] Installing AUR packages..."
            echo "$AUR_PACKAGES" | yay -S --needed --noconfirm -
        fi
        break
    fi
done

# [3] Deploy configs
echo "[3/3] Deploying configs..."

mkdir -p ~/.config/nvim
ln -sf "$DOTFILES_DIR/nvim/init.lua" ~/.config/nvim/init.lua
echo "  -> nvim config linked"

echo ""
echo "Done! Open nvim to auto-install plugins via lazy.nvim."
