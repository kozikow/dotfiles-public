sudo apt-get update && sudo apt-get dist-upgrade -y
sudo apt-get install -y software-properties-common python-software-properties
sudo apt-get install -y vim

# C++
sudo apt-get install -y g++

# Java 8
sudo apt-get install -y openjdk-8-jdk openjdk-8-source

# Bazel dependencies
sudo apt-get install -y pkg-config zip zlib1g-dev unzip git

# Build bazel
git clone https://github.com/google/bazel.git ~/bazel && cd ~/bazel
~/bazel/compile.sh
sudo cp ~/bazel/bazel-bin/src/bazel /usr/bin

# Build keyremaplinux
git clone https://github.com/kozikow/keyremaplinux ~/keyremaplinux
cd ~/keyremaplinux
bazel build //keyremaplinux:keyremaplinux
