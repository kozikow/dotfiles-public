sudo apt-get update && sudo apt-get dist-upgrade -y
sudo apt-get install -y software-properties-common python-software-properties
sudo apt-get install -y vim

# C++
sudo apt-get install -y g++

# Java 8
sudo apt-get install -y openjdk-8-jdk openjdk-8-source

# Bazel dependencies
sudo apt-get install -y pkg-config zip zlib1g-dev unzip git

# Configure git
git config --global push.default simple

# Build bazel
git clone https://github.com/google/bazel.git ~/bazel && cd ~/bazel
~/bazel/compile.sh
sudo cp ~/bazel/bazel-bin/src/bazel /usr/bin

# Build keyremaplinux
git clone https://github.com/kozikow/keyremaplinux ~/keyremaplinux
cd ~/keyremaplinux
bazel build //keyremaplinux:keyremaplinux

# Download dotfiles
mkdir ~/github
git clone https://github.com/kozikow/github/dotfiles-public.git ~/github/dotfiles-public

# Download IntelliJ
cd ~
wget -O /tmp/intellij.tar.gz http://download.jetbrains.com/idea/ideaIC-15.0.1.tar.gz
tar xfz /tmp/intellij.tar.gz
mv idea-* intellij-idea
wget -O ~/ideavim.zip http://plugins.jetbrains.com/plugin/download?pr=idea&updateId=20052
unzip ~/ideavim.zip
cp -R ~/IdeaVim ~/.IdeaIC1*/config/plugins/
git clone https://github.com/kozikow/programming_contests_live_templates.git ~/live_templates
cd ~/.IdeaIC1*/config && mkdir templates && cd templates
cp ~/live_templates/*.xml .

# Configure emacs
sudo apt-get install -y emacs24
ln -s ~/github/dotfiles-public/.emacs ~/.emacs
ln -s ~/github/dotfiles-public/.emacs.d ~/.emacs.d

# Configure oh-my-zsh
sudo apt-get install -y zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm ~/.zshrc  
ln -s ~/github/dotfiles-public/.zshrc ~/.zshrc
chsh -s $(which zsh)
chsh -s $(which zsh) $(whoami)

# Tmux settings
sudo apt-get install -y xclip
sudo apt-get install -y tmux
ln -s ~/github/dotfiles-public/.tmux.conf ~/.tmux.conf

#####################
## Ubuntu specific ##
#####################

# Annoying ubuntu ads
sudo apt-get remove -y unity-webapps-common

# Ubuntu keybindings
dconf write /org/compiz/profiles/unity/plugins/unityshell/show-launcher '"<Super>space"'
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"

# Side bar auto hide
dconf write /org/compiz/profiles/unity/plugins/unityshell/launcher-hide-mode 1
