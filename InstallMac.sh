export NAME="YOUR NAME"
export EMAIL="your@email.com"
export PYTHON=3.10.10

defaults write com.apple.desktopservices DSDontWriteNetworkStores true
defaults write com.apple.finder ShowPathBar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo '# Set PATH, MANPATH, etc., for Homebrew.' >> ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
brew tap homebrew/cask-versions
brew tap homebrew/cask-fonts

brew install jq xz make tree wget iterm2 httrack make git git-flow zsh-completions dos2unix

git config --global user.name $NAME
git config --global user.email $EMAIL
git config --global core.editor 'code --wait'
git config --global core.autocrlf input

ssh-keygen -b 4096 -t rsa -C $EMAIL -f ${HOME}/.ssh/id_rsa -q -N ""
eval "$(ssh-agent -s)"
ssh-add ${HOME}/.ssh/id_rsa

brew install --cask docker

curl -fsSL https://get.pnpm.io/install.sh | sh -
source $HOME/.zshrc
pnpm env use --global lts

brew install dotnet-sdk
dotnet tool install --global dotnet-ef

brew install pyenv
pyenv install $PYTHON
pyenv global $PYTHON
echo 'PATH=$(pyenv root)/shims:$PATH' >> ~/.zprofile

brew install visual-studio-code
brew install --cask firefox google-chrome cryptomator keepassxc onedrive the-unarchiver iina whatsapp


sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
sed -i '' "s/robbyrussell/gnzh/g" ~/.zshrc
sed -i '' "s/plugins=(git)/plugins=(git-prompt zsh-syntax-highlighting zsh-autosuggestions aliases)/g" ~/.zshrc

mkdir -p ~/Workspace/templates/temp
echo -e 'alias w="cd ~/Workspace"' >> ~/.zprofile
echo -e 'scrape() { cd ~/Workspace/templates/temp && httrack --disable-security-limits --connection-per-second=50 --sockets=80 --keep-alive --verbose --advanced-progressinfo -F "Mozilla/5.0 (X11;U; Linux i686; en-GB; rv:1.9.1) Gecko/20090624 Ubuntu/9.04 (jaunty) Firefox/3.5" -i --footer " " -s0 -m -r5 -d "$@"; }' >> ~/.zprofile

brew install font-fira-code
wget -O extensions.list https://raw.githubusercontent.com/alvinluc/workspacebootstrap/master/Resources/vscode_extensions.list
dos2unix extensions.list
cat extensions.list | xargs -L1 code --install-extension
rm -rf extensions.list

curl -o  $HOME/Library/Application\ Support/Code/User/settings.json https://raw.githubusercontent.com/alvinluc/workspacebootstrap/master/Resources/visual-studio-code-settings.json