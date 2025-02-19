#!/bin/bash

if [ -d "$HOME/.oh-my-zsh/" ]; then
    echo "oh-my-zsh is already installed as ~/.oh-my-zsh already exists"
else
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "Hithere"
    rm -f "$HOME/.zshrc"
fi


# Define repositories as tuples (repo_url destination)
repos=(
    "https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    "https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    "https://github.com/zpm-zsh/autoenv $HOME/.oh-my-zsh/custom/plugins/autoenv"
    "https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm"
    "https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
)


# Output directory for fonts
OUTPUT_DIR="$HOME/.local/share/fonts"

# Function to clone repositories gracefully
clone_repo() {
    repo_url=$1
    target_dir=$2

    if [ -d "$target_dir" ]; then
        echo "Skipping: '$target_dir' already exists."
    else
        echo "Cloning: $repo_url -> $target_dir"
        git clone "$repo_url" "$target_dir" 2>&1 | sed 's/^fatal: //'
    fi
}

# Iterate over repositories
for repo in "${repos[@]}"; do
    clone_repo $repo
done


# Output directory for fonts
OUTPUT_DIR="$HOME/.local/share/fonts"
mkdir -p "$OUTPUT_DIR"

# Font URLs and corresponding filenames
fonts=(
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" "MesloLGS NF Regular.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" "MesloLGS NF Bold.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" "MesloLGS NF Italic.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" "MesloLGS NF Bold Italic.ttf"
)

download_font() {
    url="$1"
    filename="$2"
    filepath="$OUTPUT_DIR/$filename"

    if [ -f "$filepath" ]; then
        echo "Skipping: '$filename' already exists."
    else
        echo "Downloading: $filename"
        curl -o "$filepath" "$url" --fail --silent || echo "Failed to download: $filename"
    fi
}

# Iterate over font URLs and filenames (handling spaces correctly)
for ((i=0; i<${#fonts[@]}; i+=2)); do
    download_font "${fonts[i]}" "${fonts[i+1]}"
done



#!/bin/bash
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS, installing fzf using Homebrew..."
    brew install fzf stow
elif [[ -f /etc/os-release ]]; then
    . /etc/os-release
    if [[ "$ID" == "ubuntu" ]]; then
        echo "Detected Ubuntu, installing fzf using apt..."
        sudo apt update && sudo apt install -y fzf stow
    else
        echo "Unsupported Linux distribution: $ID"
        exit 1
    fi
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

stow . 
