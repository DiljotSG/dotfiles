#!/bin/zsh

# Detect operating system
OS=$(uname -s)

echo "================================"
echo "Dotfiles Setup Script"
echo "================================"
echo ""

# ============================================================================
# INSTALL OH-MY-ZSH
# ============================================================================
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✓ Oh My Zsh installed"
else
    echo "✓ Oh My Zsh already installed"
fi
echo ""

# ============================================================================
# MACOS SPECIFIC SETUP
# ============================================================================
if [[ "$OS" == "Darwin" ]]; then
    echo "Detected macOS - setting up macOS environment"
    echo ""
    
    # Check for Homebrew
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo "✓ Homebrew installed"
    else
        echo "✓ Homebrew already installed"
    fi
    
    # Install Spaceship Prompt
    if ! brew list spaceship &> /dev/null; then
        echo "Installing Spaceship Prompt..."
        brew install spaceship
        echo "✓ Spaceship Prompt installed"
    else
        echo "✓ Spaceship Prompt already installed"
    fi
    
    # Install Autojump
    if ! brew list autojump &> /dev/null; then
        echo "Installing Autojump..."
        brew install autojump
        echo "✓ Autojump installed"
    else
        echo "✓ Autojump already installed"
    fi
    
    # Install zsh-autosuggestions
    if ! brew list zsh-autosuggestions &> /dev/null; then
        echo "Installing zsh-autosuggestions..."
        brew install zsh-autosuggestions
        echo "✓ zsh-autosuggestions installed"
    else
        echo "✓ zsh-autosuggestions already installed"
    fi
    
    # Install FiraCode font
    if ! brew list --cask font-fira-code &> /dev/null; then
        echo "Installing FiraCode font..."
        brew tap homebrew/cask-fonts 2>/dev/null || true
        brew install --cask font-fira-code
        echo "✓ FiraCode font installed"
        echo "  ⚠ Remember to set FiraCode as your terminal font in Terminal.app or iTerm"
    else
        echo "✓ FiraCode font already installed"
    fi
    
    # Copy zshrc
    echo ""
    echo "Copying zshrc_darwin..."
    cp ~/Developer/git/dotfiles/zshrc_darwin ~/.zshrc
    echo "✓ zshrc copied"

# ============================================================================
# LINUX SPECIFIC SETUP
# ============================================================================
elif [[ "$OS" == "Linux" ]]; then
    echo "Detected Linux - setting up Linux environment"
    echo ""
    
    # Detect package manager
    if command -v apt-get &> /dev/null; then
        PKG_MANAGER="apt-get"
        INSTALL_CMD="sudo apt-get install -y"
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
        INSTALL_CMD="sudo dnf install -y"
    elif command -v yum &> /dev/null; then
        PKG_MANAGER="yum"
        INSTALL_CMD="sudo yum install -y"
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
        INSTALL_CMD="sudo pacman -S --noconfirm"
    else
        echo "⚠ Could not detect package manager. Please install autojump manually."
        PKG_MANAGER="unknown"
    fi
    
    # Install Autojump
    if ! command -v autojump &> /dev/null; then
        if [[ "$PKG_MANAGER" != "unknown" ]]; then
            echo "Installing Autojump..."
            $INSTALL_CMD autojump
            echo "✓ Autojump installed"
        fi
    else
        echo "✓ Autojump already installed"
    fi
    
    # Install Spaceship Prompt
    SPACESHIP_DIR="$HOME/.oh-my-zsh/custom/themes/spaceship-prompt"
    if [ ! -d "$SPACESHIP_DIR" ]; then
        echo "Installing Spaceship Prompt..."
        git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$SPACESHIP_DIR" --depth=1
        echo "✓ Spaceship Prompt installed"
    else
        echo "✓ Spaceship Prompt already installed"
    fi
    
    # Install zsh-autosuggestions
    AUTOSUGGESTIONS_DIR="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    if [ ! -d "$AUTOSUGGESTIONS_DIR" ]; then
        echo "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGESTIONS_DIR"
        echo "✓ zsh-autosuggestions installed"
    else
        echo "✓ zsh-autosuggestions already installed"
    fi
    
    # Install FiraCode font (skip if in Docker)
    if [[ ! -f /.dockerenv ]] && [[ ! -f /run/.containerenv ]]; then
        if ! fc-list | grep -qi "fira code"; then
            if [[ "$PKG_MANAGER" != "unknown" ]]; then
                echo "Installing FiraCode font..."
                if [[ "$PKG_MANAGER" == "apt-get" ]]; then
                    $INSTALL_CMD fonts-firacode
                elif [[ "$PKG_MANAGER" == "dnf" ]] || [[ "$PKG_MANAGER" == "yum" ]]; then
                    $INSTALL_CMD fira-code-fonts
                elif [[ "$PKG_MANAGER" == "pacman" ]]; then
                    $INSTALL_CMD ttf-fira-code
                fi
                echo "✓ FiraCode font installed"
                echo "  ⚠ Remember to set FiraCode as your terminal font"
            else
                echo "⚠ Could not install FiraCode font automatically. Install manually."
            fi
        else
            echo "✓ FiraCode font already installed"
        fi
    else
        echo "⊙ Skipping FiraCode font (running in container)"
        echo "  Install FiraCode on your host machine's terminal instead"
    fi
    
    # Copy zshrc
    echo ""
    echo "Copying zshrc_linux..."
    cp ~/dotfiles/zshrc_linux ~/.zshrc
    echo "✓ zshrc copied"

else
    echo "Unknown operating system: $OS"
    exit 1
fi

echo ""
echo "================================"
echo "✓ Setup complete!"
echo "================================"
echo ""
echo "Please restart your terminal or run: source ~/.zshrc"