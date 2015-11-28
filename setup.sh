apt-get update && apt-get dist-upgrade -y
apt-get install -y software-properties-common python-software-properties

# C++
apt-get install -y g++

# Java 8
sudo apt-get install openjdk-8-jdk openjdk-8-source

# Bazel dependencies
apt-get install -y pkg-config zip zlib1g-dev unzip git

# Build bazel
git clone https://github.com/google/bazel.git /bazel && cd /bazel
/bazel/compile.sh
cp /bazel/bazel-bin/src/bazel /usr/local/bin

# Build keyremaplinux
git clone https://github.com/kozikow/keyremaplinux ~/keyremaplinux
cd ~/keyremaplinux

# Uncomment soon:
# RUN bazel build //keyremaplinux:keyremaplinux
