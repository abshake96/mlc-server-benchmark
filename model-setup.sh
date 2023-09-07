#!/bin/bash

# Check if the user provided at least one argument
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <hf-path> [--use-safetensors]"
    exit 1
fi

# Set the hf-path
HF_PATH=$1

# Extract the model name from the HF_PATH
MODEL_NAME=$(basename $HF_PATH)

# Append -q4f16_1 to the model name
PRINT_MODEL_NAME="${MODEL_NAME}-q4f16_1"
echo "Using model: $PRINT_MODEL_NAME"

# Check if --use-safetensors flag is set
USE_SAFETENSORS=""
if [[ $2 == "--use-safetensors" ]]; then
    USE_SAFETENSORS="--use-safetensors"
fi

# Execute the command
python3 -m mlc_llm.build --hf-path $HF_PATH --target cuda --quantization q4f16_1 $USE_SAFETENSORS
python3 benchmark.py $PRINT_MODEL_NAME