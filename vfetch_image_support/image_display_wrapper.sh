#!/bin/bash
# image_display_wrapper.sh - Wrapper to display images in terminal

IMAGE_PATH="$1"

if [ ! -f "$IMAGE_PATH" ]; then
    echo "Error: Image file not found: $IMAGE_PATH"
    exit 1
fi

# Check file extension
EXT="${IMAGE_PATH##*.}"
EXT=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')

case "$EXT" in
    png|jpg|jpeg|gif)
        echo "Displaying image: $IMAGE_PATH"
        echo "Format: $EXT"
        
        # Check if we have image utilities
        if command -v img2txt >/dev/null 2>&1; then
            # Use caca-utils to convert image to ASCII
            img2txt -W 60 "$IMAGE_PATH"
        elif command -v convert >/dev/null 2>&1; then
            # Use ImageMagick to resize and potentially convert
            echo "Image: $IMAGE_PATH (using ImageMagick)"
        else
            # Fallback: just show image info
            echo "Image file: $IMAGE_PATH"
            echo "Size: $(du -h "$IMAGE_PATH" | cut -f1)"
            echo "Format: $EXT"
            echo ""
            echo "  ╔══════════════════════════════════════╗"
            echo "  ║                                      ║"
            echo "  ║    IMAGE PLACEHOLDER - $EXT         ║"
            echo "  ║                                      ║"
            echo "  ║  This would display your image in    ║"
            echo "  ║  the terminal using appropriate      ║"
            echo "  ║  image-to-ASCII conversion or        ║"
            echo "  ║  terminal image protocols.           ║"
            echo "  ║                                      ║"
            echo "  ╚══════════════════════════════════════╝"
        fi
        ;;
    *)
        echo "Error: Unsupported image format: $EXT"
        echo "Supported formats: PNG, JPG, JPEG, GIF"
        exit 1
        ;;
esac