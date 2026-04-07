# dotfiles

Arch Linux workstation setup.

## Install

```bash
git clone https://github.com/mnx/dotfiles.git
cd dotfiles

# full workstation
./install.sh base dev apps

# + window manager
./install.sh base dev apps i3
./install.sh base dev apps hyprland

# + AUR packages
./install.sh base dev apps aur
```

## Groups

| Group | Description |
|-------|-------------|
| `base` | base-devel, networking, audio, fonts |
| `dev` | neovim, alacritty, tmux, docker, languages, tools |
| `apps` | firefox, chromium, telegram, obs, gnucash |
| `i3` | i3wm + utilities |
| `hyprland` | hyprland + wayland utilities |
| `security` | ufw, audit, clamav |
| `aur` | AUR-only packages (impala, maldet) |
