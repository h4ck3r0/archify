<p align="center">
<a href="https://github.com/h4ck3r0"><img title="Language" src="https://img.shields.io/badge/Made%20with-Bash-1f425f.svg?v=103&style=flat-square"></a>
<a href="https://github.com/h4ck3r0"><img title="Platform" src="https://img.shields.io/badge/Platform-Arch%20Linux-blue?style=flat-square"></a>
</p>

# Arch Linux Shell Customizer (Archify)

Welcome to **Archify**! This tool provides an interactive menu-driven script to customize your Arch terminal using Zsh, Bash, Fish, Fastfetch, Starship, custom Nerd Fonts, shell plugins, multiplexer styling, and modern CLI tools.

---

## Features

- **Package Installer**: Installs standard tools (`zsh`, `fish`, `git`, `lolcat`, `figlet`, `toilet`, `unzip`, `fastfetch`) using `pacman`.
- **AUR Helper Integration**: Detects and offers to automatically install `yay` if no AUR helper is present.
- **Custom Zsh, Bash, & Fish Themes**: Deploys professional twin-line prompt designs featuring Arch branding and styled color themes.
- **Fastfetch Presets**: Modern JSONC configuration that prints a beautiful Arch logo with customized information panels and borders.
- **Multi-Shell Plugins Submenu**: 
  - **Zsh**: Automatically downloads and installs `zsh-syntax-highlighting` and `zsh-autosuggestions`.
  - **Bash**: Automatically installs and configures `ble.sh` (Bash Line Editor) for syntax highlighting and autosuggestions.
  - **Fish**: Automatically installs `fisher` and integrates plugins (`fzf.fish`, `sponge`, and `fish-colored-man`).
- **Accent Color Palette Presets**: Interactive menu to dynamically choose shell accent styles:
  - Cyberpunk Neon (Magenta & Cyan)
  - Dracula (Purple & Green)
  - Nord (Cyan & Blue)
  - Gruvbox (Yellow & Red)
  - H4CK3R Default (Cyan & Blue)
- **Modern CLI Replacements**: Installs and configures modern Rust/C++ utility alternatives and sets up relevant aliases:
  - `eza` (instead of `ls`) with custom directory sorting and icons.
  - `bat` (instead of `cat`) with syntax highlighting.
  - `zoxide` (instead of `cd`) for fuzzy-jumping to directories.
  - `ripgrep` (`rg`), `fzf` (fuzzy finder), and `fd`.
- **Tmux Customization**: Installs and configures `tmux` with a beautiful status bar and colors matching the chosen system theme.
- **Atuin Shell History**: Installs and configures Atuin for a unified, database-driven interactive command history search.
- **Developer Tools Configuration**:
  - **Neovim**: Installs Neovim with the option to deploy the popular `LazyVim` starter framework.
  - **Git**: Configures Git colors and sets up the beautiful visual git diff pager `diff-so-fancy`.
- **Nerd Fonts Installer**: Interactive option to download and install popular developer Nerd Fonts (JetBrains Mono, Hack, Fira Code) to render symbols and icons properly.
- **Starship Prompt Integration**: Installs and applies a customized Starship prompt config that matches the twin-line custom theme.
- **Safe Reset**: Provides a function to reset shell configuration and restore settings with backups.
- **Self-Update**: Built-in option to pull remote script modifications and reload instantly.

---

## Installation & Usage

To execute the Arch customization tool:

1. Open your terminal in Arch Linux.
2. Clone the repository and navigate to the directory:
   ```bash
   git clone https://github.com/h4ck3r0/archify.git
   cd archify
   ```
3. Give execution permissions to the script:
   ```bash
   chmod +x setup.sh
   ```
4. Run the installer:
   ```bash
   ./setup.sh
   ```

---

## Visual Setup Requirements

Most of the prompts and custom displays use special Unicode icons (like `󰣇`). You **MUST** select option `06` in the script to install Nerd Fonts, and then configure your terminal emulator to use the installed font (e.g. `JetBrainsMono Nerd Font` or `Hack Nerd Font`) for the icons to display correctly.
