#!/bin/bash

# Check if required parameters are provided
if [ -z "$1" ]; then
  echo "Usage: $0 <kaggle-dataset-name>"
  echo "Example: $0 berkeleyearth/climate-change-earth-surface-temperature-data"
  exit 1
fi

# Get dataset name from argument
DATASET="$1"

# Extract the dataset name (remove slashes)
DATASET_NAME=$(echo "$DATASET" | awk -F '/' '{print $2}')

# Define dynamic target directory inside ~/dataset/
TARGET_DIR="$HOME/dataset/$DATASET_NAME"

# Ensure Kaggle API is installed
pip3 install kaggle --quiet

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# Download the dataset
echo "Downloading dataset: $DATASET"
kaggle datasets download -d "$DATASET"

# Find the downloaded zip file
ZIP_FILE=$(ls *.zip | head -n 1)

# Unzip the dataset if found
if [ -f "$ZIP_FILE" ]; then
  echo "Unzipping dataset..."
  unzip -o "$ZIP_FILE"
  rm "$ZIP_FILE"  # Remove the zip file after extraction
else
  echo "No zip file found!"
  exit 1
fi

echo "Download and extraction complete!"

# List extracted files
echo "Listing extracted files in $TARGET_DIR:"
ls -lh "$TARGET_DIR"

# Inspect each file in the target directory
for file in "$TARGET_DIR"/*; do
    if [ -f "$file" ]; then
        echo "Inspecting file: $file"

        # Show the first 5 lines
        echo "First 5 lines of $file:"
        head -n 5 "$file"
        echo "-------------------------------"

        # Show the last 5 lines
        echo "Last 5 lines of $file:"
        tail -n 5 "$file"
        echo "-------------------------------"

        # Count the number of lines
        echo "Line count of $file:"
        wc -l "$file"
        echo "==============================="
    fi
done
