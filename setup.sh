#!/usr/bin/env bash

# Arch Linux Shell Customizer (Archify)
# Created by Raj Aryan (H4CK3R)

# Color variables
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;93m'
B='\033[1;34m'
C='\033[1;36m'
W='\033[1;97m'
RS='\033[0m'

clear
SUDO_CMD=$(command -v sudo)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure we're in the script directory
cd "$SCRIPT_DIR" 2>/dev/null

# Display banner
banner() {
    clear
    if command -v figlet &> /dev/null && command -v lolcat &> /dev/null; then
        figlet -f standard "Archify" | lolcat
    else
        echo -e "${C}    /\    ${B}  __    __  _                  ${RS}"
        echo -e "${C}   /  \   ${B} / / /\ \ \(_) _ __   __ _     ${RS}"
        echo -e "${C}  / /\ \  ${B} \ \/  \/ /| || '_ \ / _\` |    ${RS}"
        echo -e "${C} / ____ \ ${B}  \  /\  / | || | | | (_| |    ${RS}"
        echo -e "${C}/_/    \_\${B}   \/  \/  |_||_| |_|\__, |    ${RS}"
        echo -e "${B}                                 |___/     ${RS}"
        echo -e "${C}             Arch Linux Customizer         ${RS}"
    fi
    echo -e "${B} ┌──────────────────────────────────────────────────┐"
    echo -e "${B} │ ${W}Coder  : ${C}Raj Aryan ${B}│ ${W}YouTube : ${G}H4Ck3R ${B}        │"
    echo -e "${B} │ ${W}Version: ${Y}2.0       ${B}│ ${W}Target  : ${R}Arch Linux ${B}    │"
    echo -e "${B} └──────────────────────────────────────────────────┘${RS}"
}

# Error prompt
wr() {
    echo -e "${R}\n [!] Invalid Option Selected!${RS}"
    sleep 1
    menu
}

# Verify Arch Linux Compatibility
check_arch() {
    if [ ! -f /etc/arch-release ] && ! command -v pacman &> /dev/null; then
        echo -e "${R}[!] Warning: This script is designed for Arch Linux.${RS}"
        read -p "Do you want to proceed anyway? [y/N]: " proceed
        if [[ ! "$proceed" =~ ^[Yy]$ ]]; then
            echo -e "${R}Exiting script.${RS}"
            exit 1
        fi
    fi
}

# Setup AUR Helper
setup_aur_helper() {
    if ! command -v yay &> /dev/null && ! command -v paru &> /dev/null; then
        echo -e "${Y}\n [!] No AUR helper (yay/paru) detected.${RS}"
        read -p " Would you like to install yay AUR helper? [y/N]: " inst_aur
        if [[ "$inst_aur" =~ ^[Yy]$ ]]; then
            echo -e "${G} [*] Installing base-devel and git...${RS}"
            $SUDO_CMD pacman -S --needed --noconfirm git base-devel
            echo -e "${G} [*] Building yay...${RS}"
            git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
            cd /tmp/yay-bin && makepkg -si --noconfirm
            cd "$SCRIPT_DIR"
            echo -e "${G} [✓] yay successfully installed!${RS}"
        fi
    fi
}

# Install core packages
install_packages() {
    echo -e "${G}\n [*] Updating system databases...${RS}"
    $SUDO_CMD pacman -Sy
    
    echo -e "${G} [*] Installing core tools (zsh, fish, fastfetch, figlet, toilet, git, wget, curl, unzip)...${RS}"
    $SUDO_CMD pacman -S --needed --noconfirm zsh fish fastfetch figlet toilet git wget curl unzip
    
    # Try installing lolcat
    if ! command -v lolcat &> /dev/null; then
        echo -e "${G} [*] Installing lolcat...${RS}"
        $SUDO_CMD pacman -S --noconfirm lolcat || yay -S --noconfirm lolcat || gem install lolcat
    fi
    
    echo -e "${G} [✓] Core packages installed successfully!${RS}"
    sleep 2
    menu
}

# Apply custom Zsh theme
apply_zsh_theme() {
    # Verify Zsh installation
    if ! command -v zsh &> /dev/null; then
        echo -e "${Y}\n [!] Zsh is not installed. Installing it...${RS}"
        $SUDO_CMD pacman -S --noconfirm zsh
    fi

    echo -e "${C}"
    read -p " Enter Custom Shell Prompt Name [Default: H4CK3R] ❯ " custom_name
    custom_name=${custom_name:-H4CK3R}

    # Oh-My-Zsh Installation Check
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        read -p " Oh My Zsh is not installed. Install it now? [y/N]: " inst_omz
        if [[ "$inst_omz" =~ ^[Yy]$ ]]; then
            echo -e "${G} [*] Downloading & installing Oh My Zsh (unattended)...${RS}"
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        fi
    fi

    # Deploy Theme File
    echo -e "${G} [*] Copying theme file to Zsh directory...${RS}"
    OMZ_THEMES="$HOME/.oh-my-zsh/themes"
    STANDALONE_THEMES="$HOME/.zsh/themes"
    
    if [ -d "$HOME/.oh-my-zsh" ]; then
        mkdir -p "$OMZ_THEMES"
        cp "$SCRIPT_DIR/.object/.h4Ck3r_arch.zsh-theme" "$OMZ_THEMES/h4Ck3r_arch.zsh-theme"
    fi
    mkdir -p "$STANDALONE_THEMES"
    cp "$SCRIPT_DIR/.object/.h4Ck3r_arch.zsh-theme" "$STANDALONE_THEMES/h4Ck3r_arch.zsh-theme"

    # Set up Config
    echo -e "${G} [*] Deploying custom .zshrc...${RS}"
    [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
    sed -e "s/PROC/$custom_name/g" "$SCRIPT_DIR/.object/.zshrc_template" > "$HOME/.zshrc"

    # Deploy Fastfetch Config
    echo -e "${G} [*] Copying Fastfetch configuration...${RS}"
    mkdir -p "$HOME/.config/fastfetch"
    cp "$SCRIPT_DIR/.object/fastfetch_config.jsonc" "$HOME/.config/fastfetch/config.jsonc"

    # Change Default Shell
    if [[ "$SHELL" != */zsh ]]; then
        read -p " Change default shell to Zsh? [y/N]: " change_shell
        if [[ "$change_shell" =~ ^[Yy]$ ]]; then
            $SUDO_CMD chsh -s "$(command -v zsh)" "$USER"
            echo -e "${G} [✓] Shell changed to Zsh. Please log out and back in for changes to take effect.${RS}"
        fi
    fi

    echo -e "${G} [✓] Zsh theme applied successfully!${RS}"
    sleep 2
    menu
}

# Apply custom Bash theme
apply_bash_theme() {
    echo -e "${C}"
    read -p " Enter Custom Shell Prompt Name [Default: H4CK3R] ❯ " custom_name
    custom_name=${custom_name:-H4CK3R}

    echo -e "${G} [*] Deploying custom .bashrc...${RS}"
    [ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$HOME/.bashrc.bak"
    sed -e "s/PROC/$custom_name/g" "$SCRIPT_DIR/.object/.bashrc_template" > "$HOME/.bashrc"

    # Deploy Fastfetch Config
    echo -e "${G} [*] Copying Fastfetch configuration...${RS}"
    mkdir -p "$HOME/.config/fastfetch"
    cp "$SCRIPT_DIR/.object/fastfetch_config.jsonc" "$HOME/.config/fastfetch/config.jsonc"

    echo -e "${G} [✓] Bash theme applied successfully! Run 'source ~/.bashrc' to apply.${RS}"
    sleep 2
    menu
}

# Apply custom Fish theme
apply_fish_theme() {
    # Verify Fish installation
    if ! command -v fish &> /dev/null; then
        echo -e "${Y}\n [!] Fish is not installed. Installing it...${RS}"
        $SUDO_CMD pacman -S --noconfirm fish
    fi

    echo -e "${C}"
    read -p " Enter Custom Shell Prompt Name [Default: H4CK3R] ❯ " custom_name
    custom_name=${custom_name:-H4CK3R}

    echo -e "${G} [*] Deploying custom config.fish...${RS}"
    mkdir -p "$HOME/.config/fish"
    [ -f "$HOME/.config/fish/config.fish" ] && cp "$HOME/.config/fish/config.fish" "$HOME/.config/fish/config.fish.bak"
    sed -e "s/PROC/$custom_name/g" "$SCRIPT_DIR/.object/config.fish_template" > "$HOME/.config/fish/config.fish"

    # Deploy Fastfetch Config
    echo -e "${G} [*] Copying Fastfetch configuration...${RS}"
    mkdir -p "$HOME/.config/fastfetch"
    cp "$SCRIPT_DIR/.object/fastfetch_config.jsonc" "$HOME/.config/fastfetch/config.jsonc"

    # Change Default Shell
    if [[ "$SHELL" != */fish ]]; then
        read -p " Change default shell to Fish? [y/N]: " change_shell
        if [[ "$change_shell" =~ ^[Yy]$ ]]; then
            $SUDO_CMD chsh -s "$(command -v fish)" "$USER"
            echo -e "${G} [✓] Shell changed to Fish. Please log out and back in for changes to take effect.${RS}"
        fi
    fi

    echo -e "${G} [✓] Fish theme applied successfully!${RS}"
    sleep 2
    menu
}

# Download & Setup Plugins
apply_plugins() {
    echo -e "${G}\n [*] Setting up autosuggestions and syntax highlighting...${RS}"
    
    # Try system packages first
    echo -e "${G} [*] Installing plugin system packages if available...${RS}"
    $SUDO_CMD pacman -S --needed --noconfirm zsh-syntax-highlighting zsh-autosuggestions 2>/dev/null
    
    # Backup setup: Clone to user directories
    ZSH_PLUGINS_DIR="$HOME/.zsh"
    mkdir -p "$ZSH_PLUGINS_DIR"

    # Syntax Highlighting
    if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
        echo -e "${G} [*] Cloning zsh-syntax-highlighting...${RS}"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
    else
        echo -e "${G} [*] Updating zsh-syntax-highlighting...${RS}"
        cd "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" && git pull && cd "$SCRIPT_DIR"
    fi

    # Autosuggestions
    if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
        echo -e "${G} [*] Cloning zsh-autosuggestions...${RS}"
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
    else
        echo -e "${G} [*] Updating zsh-autosuggestions...${RS}"
        cd "$ZSH_PLUGINS_DIR/zsh-autosuggestions" && git pull && cd "$SCRIPT_DIR"
    fi

    echo -e "${G} [✓] Plugins ready! Reload Zsh to verify.${RS}"
    sleep 2
    menu
}

# Install Nerd Fonts
install_nerd_fonts() {
    echo -e "${G}\n [*] Preparing to install Nerd Fonts...${RS}"
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
    
    echo -e "${C} Choose font to install:${RS}"
    echo -e " ${B}[1]${G} JetBrains Mono Nerd Font (Recommended)"
    echo -e " ${B}[2]${G} Hack Nerd Font"
    echo -e " ${B}[3]${G} Fira Code Nerd Font"
    read -p " Select option [1-3]: " font_opt

    case $font_opt in
        2) 
            FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
            FONT_ZIP="Hack.zip"
            ;;
        3)
            FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
            FONT_ZIP="FiraCode.zip"
            ;;
        *)
            FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
            FONT_ZIP="JetBrainsMono.zip"
            ;;
    esac

    echo -e "${G} [*] Downloading font archive...${RS}"
    wget -O "/tmp/$FONT_ZIP" "$FONT_URL"
    
    echo -e "${G} [*] Extracting to $FONT_DIR...${RS}"
    unzip -o "/tmp/$FONT_ZIP" -d "$FONT_DIR"
    rm "/tmp/$FONT_ZIP"
    
    echo -e "${G} [*] Rebuilding font cache...${RS}"
    fc-cache -fv &>/dev/null || $SUDO_CMD fc-cache -fv &>/dev/null

    echo -e "${G} [✓] Nerd Font files installed!${RS}"
    
    # Detect terminal emulator and give instructions
    TERM_EMULATOR="generic"
    if [ -n "$QTERMINAL_IPC" ]; then
        TERM_EMULATOR="qterminal"
    elif [ -n "$GNOME_TERMINAL_SCREEN" ]; then
        TERM_EMULATOR="gnome-terminal"
    elif [ "$TERM" = "xterm-kitty" ]; then
        TERM_EMULATOR="kitty"
    elif [ "$TERM" = "alacritty" ]; then
        TERM_EMULATOR="alacritty"
    fi

    echo -e "\n${Y} [!] HOW TO SET THE FONT IN YOUR TERMINAL:${RS}"
    case "$TERM_EMULATOR" in
        "qterminal")
            echo -e "   1. Click ${C}File${RS} in the menu bar."
            echo -e "   2. Go to ${C}Preferences${RS} -> ${C}Appearance${RS}."
            echo -e "   3. Click ${C}Change${RS} next to 'Font'."
            echo -e "   4. Choose ${G}JetBrainsMono Nerd Font${RS} (or Hack Nerd Font) and Save."
            ;;
        "gnome-terminal")
            echo -e "   1. Click the ${C}Menu (3 bars)${RS} in the top-right."
            echo -e "   2. Go to ${C}Preferences${RS}."
            echo -e "   3. Under Profiles, click your profile (e.g. Unnamed)."
            echo -e "   4. Check ${C}Custom font${RS}."
            echo -e "   5. Choose ${G}JetBrainsMono Nerd Font${RS} and click Select."
            ;;
        "kitty")
            echo -e "   Add this to your ${C}~/.config/kitty/kitty.conf${RS}:"
            echo -e "   ${G}font_family JetBrainsMono Nerd Font${RS}"
            ;;
        "alacritty")
            echo -e "   Update your ${C}~/.config/alacritty/alacritty.toml${RS}:"
            echo -e "   ${G}[font.normal]"
            echo -e "   family = \"JetBrainsMono Nerd Font\"${RS}"
            ;;
        *)
            echo -e "   1. Open your terminal emulator's ${C}Settings/Preferences${RS}."
            echo -e "   2. Navigate to ${C}Appearance / Font${RS} settings."
            echo -e "   3. Change the font to ${G}JetBrainsMono Nerd Font${RS}."
            ;;
    esac
    echo -e ""
    read -n 1 -s -r -p " Press any key to return to menu... "
    menu
}

# Setup Starship prompt
install_starship() {
    echo -e "${G}\n [*] Checking Starship Prompt...${RS}"
    if ! command -v starship &> /dev/null; then
        echo -e "${G} [*] Installing Starship prompt using pacman...${RS}"
        $SUDO_CMD pacman -S --needed --noconfirm starship
    fi

    echo -e "${G} [*] Deploying Starship configuration...${RS}"
    mkdir -p "$HOME/.config"
    cat << 'EOF' > "$HOME/.config/starship.toml"
# Custom Starship Config by H4CK3R - Matches Custom Theme Design
format = '''
[┌─\[](bold cyan)[󰣇 ](bold blue)$username[@](bold cyan)$hostname[\]-\[](bold cyan)$directory[\]](bold cyan)$git_branch$git_status
$character'''

[username]
show_always = true
style_user = "bold white"
format = "$user"

[hostname]
ssh_only = false
style = "bold blue"
format = "$hostname"

[directory]
style = "bold green"
format = "$path"
truncation_length = 3
truncation_symbol = "…/"

[git_branch]
symbol = " "
style = "bold red"
format = '-\[[git:\(](bold cyan)$symbol$branch[\)](bold cyan)\]'

[git_status]
style = "bold red"
format = "[$all_status$ahead_behind]($style)"

[character]
success_symbol = "[└─╼ ](bold cyan)[❯❯❯](bold blue) "
error_symbol = "[└─╼ ](bold cyan)[✗❯❯](bold red) "
EOF

    echo -e "${G} [✓] Starship prompt configured!${RS}"
    
    # Auto-activate Starship in .zshrc
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q "starship init zsh" "$HOME/.zshrc"; then
            echo -e "${G} [*] Activating Starship in your .zshrc...${RS}"
            echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
        fi
    fi

    # Auto-activate Starship in .bashrc
    if [ -f "$HOME/.bashrc" ]; then
        if ! grep -q "starship init bash" "$HOME/.bashrc"; then
            echo -e "${G} [*] Activating Starship in your .bashrc...${RS}"
            echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
        fi
    fi

    # Auto-activate Starship in config.fish
    if [ -f "$HOME/.config/fish/config.fish" ]; then
        if ! grep -q "starship init fish" "$HOME/.config/fish/config.fish"; then
            echo -e "${G} [*] Activating Starship in your config.fish...${RS}"
            echo 'starship init fish | source' >> "$HOME/.config/fish/config.fish"
        fi
    fi

    echo -e "${G} [✓] Starship successfully enabled and configured! Reload your shell (e.g. run 'zsh') to see it.${RS}"
    sleep 4
    menu
}

# Reset Configurations
reset_config() {
    echo -e "${Y}\n [!] Warning: This will back up and reset your current shell configuration files!${RS}"
    read -p " Proceed? [y/N]: " confirm_reset
    if [[ "$confirm_reset" =~ ^[Yy]$ ]]; then
        echo -e "${G} [*] Backing up and resetting .zshrc, .bashrc, and config.fish...${RS}"
        [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc.bak" && rm "$HOME/.zshrc"
        [ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$HOME/.bashrc.bak" && rm "$HOME/.bashrc"
        [ -f "$HOME/.config/fish/config.fish" ] && cp "$HOME/.config/fish/config.fish" "$HOME/.config/fish/config.fish.bak" && rm "$HOME/.config/fish/config.fish"
        
        # Simple default configs
        echo -e "PROMPT='%F{cyan}%n@%m %F{blue}%~ %F{yellow}❯ %f'" > "$HOME/.zshrc"
        echo -e "PS1='[\u@\h \W]\$ '" > "$HOME/.bashrc"
        mkdir -p "$HOME/.config/fish"
        echo -e "set fish_greeting\nfunction fish_prompt\n    set_color cyan\n    printf '%s ' (prompt_pwd)\n    set_color normal\nend" > "$HOME/.config/fish/config.fish"
        
        echo -e "${G} [✓] Configs reset. Backups saved as .zshrc.bak / .bashrc.bak / config.fish.bak${RS}"
    fi
    sleep 2
    menu
}

# Customize Welcome Banner
customize_banner() {
    echo -e "${C}\n [*] Custom Welcome Banner Setup${RS}"
    echo -e " Choose banner style:"
    echo -e "  ${B}[1]${G} Fastfetch Banner (Default)"
    echo -e "  ${B}[2]${G} Custom Text figlet Banner"
    echo -e "  ${B}[3]${G} Simple Arch ASCII Art"
    echo -e "  ${B}[4]${R} Disable Welcome Banner"
    read -p " Select option [1-4]: " banner_opt
    
    local banner_script="$HOME/.archify-banner.sh"
    
    case $banner_opt in
        1)
            echo -e "${G} [*] Setting up Fastfetch Welcome Banner...${RS}"
            if ! command -v fastfetch &>/dev/null; then
                echo -e "${Y} [!] Fastfetch is not installed. Installing...${RS}"
                $SUDO_CMD pacman -S --needed --noconfirm fastfetch
            fi
            
            mkdir -p "$HOME/.config/fastfetch"
            if [ ! -f "$HOME/.config/fastfetch/config.jsonc" ]; then
                cp "$SCRIPT_DIR/.object/fastfetch_config.jsonc" "$HOME/.config/fastfetch/config.jsonc" 2>/dev/null || true
            fi
            
            cat << 'EOF' > "$banner_script"
#!/usr/bin/env bash
clear
if command -v fastfetch &>/dev/null; then
    if [ -f "$HOME/.config/fastfetch/config.jsonc" ]; then
        fastfetch --config "$HOME/.config/fastfetch/config.jsonc"
    else
        fastfetch
    fi
else
    echo -e "\e[1;36m  /\  \e[0m"
    echo -e "\e[1;36m /  \ \e[1;37m  Arch Linux\e[0m"
    echo -e "\e[1;36m/ _ _ \ \e[0m"
fi
EOF
            chmod +x "$banner_script"
            echo -e "${G} [✓] Fastfetch Welcome Banner configured!${RS}"
            ;;
        2)
            echo -ne "${C} Enter Custom Banner Text [Default: Archify] ❯ ${RS}"
            read banner_text
            banner_text=${banner_text:-Archify}
            
            echo -e "\n Choose Figlet Font:"
            echo -e "  ${B}[1]${G} Standard"
            echo -e "  ${B}[2]${G} Slant"
            echo -e "  ${B}[3]${G} Shadow"
            echo -e "  ${B}[4]${G} Doom"
            echo -e "  ${B}[5]${G} Block"
            read -p " Select option [1-5]: " font_choice
            
            local font_name="standard"
            case $font_choice in
                2) font_name="slant" ;;
                3) font_name="shadow" ;;
                4) font_name="doom" ;;
                5) font_name="block" ;;
                *) font_name="standard" ;;
            esac
            
            echo -e "\n Choose Color Style:"
            echo -e "  ${B}[1]${G} Rainbow (lolcat)"
            echo -e "  ${B}[2]${G} Cyberpunk (Cyan)"
            echo -e "  ${B}[3]${G} Matrix (Green)"
            echo -e "  ${B}[4]${G} Plain (White)"
            read -p " Select option [1-4]: " color_choice
            
            local color_code=""
            if [ "$color_choice" = "2" ]; then
                color_code="\\\\e[1;36m"
            elif [ "$color_choice" = "3" ]; then
                color_code="\\\\e[1;32m"
            elif [ "$color_choice" = "4" ]; then
                color_code="\\\\e[1;37m"
            fi
            
            read -p " Include System Info Box? [y/N]: " include_info
            
            local figlet_dir="$HOME/.local/share/figlet"
            mkdir -p "$figlet_dir"
            
            if ! command -v figlet &>/dev/null; then
                echo -e "${Y} [!] Figlet is not installed. Installing...${RS}"
                $SUDO_CMD pacman -S --needed --noconfirm figlet
            fi
            
            if [ "$color_choice" = "1" ] && ! command -v lolcat &>/dev/null; then
                echo -e "${Y} [!] Lolcat is not installed. Installing...${RS}"
                $SUDO_CMD pacman -S --needed --noconfirm lolcat || gem install lolcat
            fi
            
            local font_file="$figlet_dir/$font_name.flf"
            if [ ! -f "$font_file" ]; then
                echo -e "${Y} [*] Downloading $font_name font...${RS}"
                curl -s -L "https://raw.githubusercontent.com/patorjk/figlet.js/master/fonts/$font_name.flf" -o "$font_file"
                if [ ! -f "$font_file" ] || [ ! -s "$font_file" ]; then
                    echo -e "${R} [!] Failed to download $font_name font. Using default standard font.${RS}"
                    font_file=""
                fi
            fi
            
            cat << EOF > "$banner_script"
#!/usr/bin/env bash
clear
BOX_WIDTH=56
cyan='\\e[1;36m'
reset='\\e[0m'

print_center() {
    local text="\$1"
    local len=\${#text}
    local space_len=\$(( (BOX_WIDTH - 2 - len) / 2 ))
    printf "\${cyan}║%*s\${reset}%s\${cyan}%*s║\${reset}\\n" \$space_len "" "\$text" \$(( BOX_WIDTH - 2 - len - space_len )) ""
}

draw_line() {
    local char=\$1
    local end=\$2
    printf "\${cyan}%s" "\$char"
    for ((i=0; i<BOX_WIDTH-2; i++)); do
        printf "═"
    done
    printf "%s\${reset}\\n" "\$end"
}
EOF
            
            local fig_cmd="figlet"
            if [ -n "$font_file" ]; then
                fig_cmd="figlet -d \"$figlet_dir\" -f \"$font_name\""
            fi
            
            if [ "$color_choice" = "1" ]; then
                echo "$fig_cmd -c -w 56 \"$banner_text\" 2>/dev/null | lolcat 2>/dev/null || echo -e \"   $banner_text\"" >> "$banner_script"
            elif [ -n "$color_code" ]; then
                echo "echo -e \"$color_code\"" >> "$banner_script"
                echo "$fig_cmd -c -w 56 \"$banner_text\" 2>/dev/null || echo -e \"   $banner_text\"" >> "$banner_script"
                echo "echo -e \"\\\\e[0m\"" >> "$banner_script"
            else
                echo "$fig_cmd -c -w 56 \"$banner_text\" 2>/dev/null || echo -e \"   $banner_text\"" >> "$banner_script"
            fi
            
            if [[ "$include_info" =~ ^[Yy]$ ]]; then
                cat << 'EOF' >> "$banner_script"
echo ""
draw_line '╔' '╗'
print_center ""
print_center "SYSTEM: ONLINE  |  USER: $(whoami)"
if command -v free &>/dev/null; then
    mem_info=$(free -m | awk '/Mem:/ {print "RAM: " $3 "MB / " $2 "MB"}')
    [ -n "$mem_info" ] && print_center "$mem_info"
fi
print_center "KERNEL: $(uname -r)"
print_center ""
draw_line '╚' '╝'
EOF
            fi
            
            chmod +x "$banner_script"
            echo -e "${G} [✓] Custom Text figlet Banner configured!${RS}"
            ;;
        3)
            echo -e "${G} [*] Setting up Simple Arch ASCII Art...${RS}"
            cat << 'EOF' > "$banner_script"
#!/usr/bin/env bash
clear
C='\e[1;36m'
W='\e[1;37m'
G='\e[1;32m'
B='\e[1;34m'
RS='\e[0m'

echo -e "${C}    /\\     ${RS}"
echo -e "${C}   /  \\    ${W}  Arch Linux${RS}"
echo -e "${C}  / /\\ \\   ${G}  Kernel: $(uname -r)${RS}"
echo -e "${C} / ____ \\  ${B}  Uptime: $(uptime -p)${RS}"
echo -e "${C}/_/    \\_\\ ${RS}"
echo ""
EOF
            chmod +x "$banner_script"
            echo -e "${G} [✓] Simple Arch ASCII Art configured!${RS}"
            ;;
        4)
            echo -e "${Y} [*] Disabling Welcome Banner...${RS}"
            echo -e "#!/usr/bin/env bash\n# Welcome Banner Disabled" > "$banner_script"
            chmod +x "$banner_script"
            echo -e "${G} [✓] Welcome Banner disabled!${RS}"
            ;;
        *)
            echo -e "${R} [!] Invalid Option Selected!${RS}"
            sleep 1
            customize_banner
            return
            ;;
    esac
    
    # Ensure all configurations source/run the banner
    if [ -f "$HOME/.bashrc" ] && ! grep -q ".archify-banner.sh" "$HOME/.bashrc"; then
        echo -e "\n# Archify Welcome Banner\nif [ -f \"\$HOME/.archify-banner.sh\" ]; then\n    bash \"\$HOME/.archify-banner.sh\"\nfi" >> "$HOME/.bashrc"
    fi
    if [ -f "$HOME/.zshrc" ] && ! grep -q ".archify-banner.sh" "$HOME/.zshrc"; then
        echo -e "\n# Archify Welcome Banner\nif [ -f \"\$HOME/.archify-banner.sh\" ]; then\n    bash \"\$HOME/.archify-banner.sh\"\nfi" >> "$HOME/.zshrc"
    fi
    if [ -f "$HOME/.config/fish/config.fish" ] && ! grep -q ".archify-banner.sh" "$HOME/.config/fish/config.fish"; then
        echo -e "\n# Archify Welcome Banner\nif test -f \"\$HOME/.archify-banner.sh\"\n    bash \"\$HOME/.archify-banner.sh\"\nend" >> "$HOME/.config/fish/config.fish"
    fi
    
    sleep 2
    menu
}

# Update Tool
update_tool() {
    echo -e "${Y}\n [!] Updating customizer tool...${RS}"
    if [ -d "$SCRIPT_DIR/.git" ]; then
        cd "$SCRIPT_DIR"
        git fetch --all
        git reset --hard origin/main || git reset --hard origin/master || true
        
        if git pull; then
            echo -e "${G} [✓] Update complete! Reloading script...${RS}"
            sleep 2
            # Use absolute path to the script to prevent failure after CWD changes
            exec bash "$SCRIPT_DIR/${0##*/}"
        else
            echo -e "${R} [!] Update failed. Please check network/git.${RS}"
            sleep 2
        fi
    else
        echo -e "${R} [!] Git repository not found. Please manually git pull to update.${RS}"
        sleep 2
    fi
}


# Interactive Menu
menu() {
    banner
    echo -e "\n ${B}Select an option:${RS}\n"
    printf " ${B}[${W}01${B}]${G} Install Core Dependencies\n"
    printf " ${B}[${W}02${B}]${G} Apply Custom Zsh Theme & Fastfetch\n"
    printf " ${B}[${W}03${B}]${G} Apply Custom Bash Theme & Fastfetch\n"
    printf " ${B}[${W}04${B}]${G} Apply Custom Fish Theme & Fastfetch\n"
    printf " ${B}[${W}05${B}]${G} Enable Plugins (Auto-Suggestions/Syntax)\n"
    printf " ${B}[${W}06${B}]${C} Install Custom Nerd Fonts\n"
    printf " ${B}[${W}07${B}]${C} Install Starship Prompt Preset\n"
    printf " ${B}[${W}08${B}]${Y} Reset Shell Configuration\n"
    printf " ${B}[${W}09${B}]${C} Customize Welcome Banner\n"
    printf " ${B}[${W}00${B}]${R} Exit Script\n"
    echo -e ""
    echo -ne "${B} arch-th${W}@${R}root${W}:${C}~${RS}# "
    read opt
    case $opt in
        1|01) install_packages ;;
        2|02) apply_zsh_theme ;;
        3|03) apply_bash_theme ;;
        4|04) apply_fish_theme ;;
        5|05) apply_plugins ;;
        6|06) install_nerd_fonts ;;
        7|07) install_starship ;;
        8|08) reset_config ;;
        9|09) customize_banner ;;
        0|00) exit ;;
        *) wr ;;
    esac
}

# Check for updates on startup
check_for_updates() {
    if [ -d "$SCRIPT_DIR/.git" ] && command -v git &>/dev/null; then
        echo -e "${G} [*] Checking for updates...${RS}"
        # Timeout after 3 seconds to avoid hanging if user is offline
        timeout 3 git fetch --quiet &>/dev/null
        
        LOCAL=$(git rev-parse HEAD 2>/dev/null)
        UPSTREAM=$(git rev-parse @{u} 2>/dev/null)
        
        if [ "$LOCAL" != "$UPSTREAM" ] && [ -n "$UPSTREAM" ]; then
            echo -e "${Y}\n [!] A new update is available for this tool!${RS}"
            read -p " Do you want to update now? [y/N]: " confirm_update
            if [[ "$confirm_update" =~ ^[Yy]$ ]]; then
                update_tool
            fi
        fi
    fi
}

# Entry Point
check_arch
setup_aur_helper
check_for_updates
menu
