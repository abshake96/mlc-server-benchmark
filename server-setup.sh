#!/bin/bash

# Function to check and install pip3
install_pip3() {
    which pip3 > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "pip3 not found. Installing..."
        apt update && apt install -y python3-pip

        # Check if pip3 is installed successfully
        which pip3 > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "Something went wrong with the pip3 installation."
            exit 1
        else
            echo "pip3 installed successfully!"
        fi
    else
        echo "pip3 is already installed!"
    fi
}

# Function to check and install git-lfs
install_git-lfs() {
    which git-lfs > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "git-lfs not found. Installing..."
        apt update && apt install -y git-lfs

        # Check if git-lfs is installed successfully
        which git-lfs > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "Something went wrong with the git-lfs installation."
            exit 1
        else
            echo "git-lfs installed successfully!"
        fi
    else
        echo "git-lfs is already installed!"
    fi
}

# Start installations
install_pip3
install_git-lfs
git-lfs install

pip install --pre --force-reinstall mlc-ai-nightly-cu118 mlc-chat-nightly-cu118 -f https://mlc.ai/wheels

wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run
sh cuda_11.8.0_520.61.05_linux.run --toolkit --silent

CUDA_BIN_PATH="/usr/local/cuda-11.8/bin"
CUDA_LIB_PATH="/usr/local/cuda-11.8/lib64"

# Check if the paths are already in the respective variables
if ! grep -q "${CUDA_BIN_PATH}" ~/.bashrc; then
    echo "export PATH=\${PATH}:${CUDA_BIN_PATH}" >> ~/.bashrc
    echo "Added ${CUDA_BIN_PATH} to PATH in ~/.bashrc"
fi

if ! grep -q "${CUDA_LIB_PATH}" ~/.bashrc; then
    echo "export LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:${CUDA_LIB_PATH}" >> ~/.bashrc
    echo "Added ${CUDA_LIB_PATH} to LD_LIBRARY_PATH in ~/.bashrc"
fi

echo "Done. You might want to run 'source ~/.bashrc' to update the current shell session."
source ~/.bashrc

git clone "https://github.com/mlc-ai/mlc-llm.git" --recursive
cd mlc-llm
pip install .

# Attempt to execute the command and capture its output
output=$(python3 -m mlc_llm.build --help 2>&1)
exit_status=$?

# Check if command executed successfully
if [ $exit_status -eq 0 ]; then
    echo "Command executed successfully!"
else
    echo "Command failed with the following output:"
    echo "-----------------------------------------"
    echo "$output"
    echo "-----------------------------------------"
    exit 1
fi
