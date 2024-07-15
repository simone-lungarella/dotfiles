# Personal configuration files

- [Personal configuration files](#personal-configuration-files)
  - [Nvim](#nvim)
    - [Installation](#installation)

## Nvim
Install all required packages:

```bash
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip curl
```

### Installation
Install lates version:

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim-linux64
sudo mkdir -p /opt/nvim-linux64
sudo chmod a+rX /opt/nvim-linux64
sudo tar -C /opt -xzf nvim-linux64.tar.gz
```

Make it available with:

```bash
sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/
```

Configure it with files contained in `nvim` folder:
```bash
git init temp-repo && cd temp-repo && git remote add origin https://github.com/simone-lungarella/dotfiles && git config core.sparseCheckout true && echo "nvim" >> .git/info/sparse-checkout && git pull origin master && rsync -av nvim/ ~/.config/nvim/ && cd .. && rm -rf temp-repo

```