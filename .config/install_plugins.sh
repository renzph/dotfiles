git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
bash ~/.tmux/plugins/tpm/scripts/install_plugins.sh
#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS, installing fzf using Homebrew..."
    brew install fzf
elif [[ -f /etc/os-release ]]; then
    . /etc/os-release
    if [[ "$ID" == "ubuntu" ]]; then
        echo "Detected Ubuntu, installing fzf using apt..."
        sudo apt update && sudo apt install -y fzf
    else
        echo "Unsupported Linux distribution: $ID"
        exit 1
    fi
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi
