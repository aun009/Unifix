#!/bin/bash
# Resize Image using Python (Pillow)

echo "Enter the image file path:"
read image_path

echo "Enter the new width:"
read width

echo "Enter the new height:"
read height

python3 -c "
from PIL import Image
img = Image.open('$image_path')
img = img.resize(($width, $height))
img.save('resized_$image_path')
"

echo "Image resized successfully!"
