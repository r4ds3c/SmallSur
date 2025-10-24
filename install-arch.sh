#!/bin/bash
set -e  # Exit on any error

# --- Basic info ---
THEME_NAME="WhiteSur-Dark"
ICON_NAME="WhiteSur-dark"
CURSOR_NAME="WhiteSur-cursors"
WALLPAPER_DIR="$HOME/Pictures"
PLANK_THEME="mcOS-BS-iMacM1-Black"

echo "=== Installing SmallSur (WhiteSur-based) XFCE Setup ==="

# --- 1. Install XFCE extras ---
echo "[1/7] Installing XFCE extras..."
sudo pacman -S --noconfirm --needed xfce4-goodies xfce4-power-manager plank git

# --- 2. Install GTK theme ---
echo "[2/7] Installing WhiteSur GTK theme..."
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1
cd WhiteSur-gtk-theme
./install.sh -l -c dark -c light
cd ..

# --- 3. Install icon theme ---
echo "[3/7] Installing WhiteSur icons..."
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git --depth=1
cd WhiteSur-icon-theme
./install.sh
cd ..

# --- 4. Install cursor theme ---
echo "[4/7] Installing WhiteSur cursors..."
git clone https://github.com/vinceliuice/WhiteSur-cursors.git --depth=1
mkdir -p ~/.local/share/icons/
cp -r WhiteSur-cursors/dist/* ~/.local/share/icons/

# --- 5. Copy wallpapers ---
if [ -d "wallpaper" ]; then
    echo "[5/7] Copying wallpapers..."
    mkdir -p "$WALLPAPER_DIR"
    cp -r wallpaper/* "$WALLPAPER_DIR/"
else
    echo "⚠️  'wallpaper' folder not found — skipping wallpaper copy."
fi

# --- 6. Plank themes ---
echo "[6/7] Installing Plank themes..."
mkdir -p ~/.local/share/plank/themes/
if [ -d "WhiteSur-gtk-theme/src/other/plank" ]; then
    cp -rp WhiteSur-gtk-theme/src/other/plank/* ~/.local/share/plank/themes/
fi
if [ -d "plank/$PLANK_THEME" ]; then
    cp -rp "plank/$PLANK_THEME" ~/.local/share/plank/themes/
fi

# --- 7. Apply theme in XFCE ---
echo "[7/7] Applying theme settings in XFCE..."

# GTK Theme
xfconf-query -c xsettings -p /Net/ThemeName -s "$THEME_NAME"

# Icon Theme
xfconf-query -c xsettings -p /Net/IconThemeName -s "$ICON_NAME"

# Cursor Theme
xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "$CURSOR_NAME"

# Optional: Set wallpaper if one exists
DEFAULT_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | head -n 1)
if [ -n "$DEFAULT_WALLPAPER" ]; then
    echo "Applying wallpaper: $DEFAULT_WALLPAPER"
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s "$DEFAULT_WALLPAPER"
fi

# Optional: Set Plank theme
if command -v plank >/dev/null 2>&1; then
    mkdir -p ~/.config/plank/dock1/
    echo "[PlankPreferences]
#Automatically generated
Theme=$PLANK_THEME" > ~/.config/plank/dock1/settings
fi

echo
echo "🎉 SmallSur installation and configuration complete!"
echo "🔁 Please log out or reboot for all changes to take effect."
