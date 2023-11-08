#!/usr/local/bin/zsh

function confirm_command {
  COMMAND=$1
  INSTALL_COMMAND=$2
  if ! command -v $COMMAND > /dev/null; then
    echo "$SHELL: $COMMAND command not found. Please install it using following command:\n\t$INSTALL_COMMAND";
    exit 1;
  fi
}

confirm_command magick "brew install imagemagick"
confirm_command fastfetch "brew install fastfetch"

IMAGE_CATEGORY=${1:-default}

IMAGE_SCALE_HEIGHT=20
IMAGE_DIRECTORY="$HOME/.powerwelcome/images/$IMAGE_CATEGORY"
IMAGE_FILES=$(\ls $IMAGE_DIRECTORY)
IMAGE_COUNT=$(echo $IMAGE_FILES | wc -l)

if [ $IMAGE_COUNT = 0 ]; then
  echo "$SHELL: no images in path $IMAGE_DIRETORY."
  exit 1;
fi

IMAGE_NAME=$(echo $IMAGE_FILES | tr '\n' ' ' | cut -d' ' -f$(($$%$IMAGE_COUNT+1)))
IMAGE_PATH="$IMAGE_DIRECTORY/$IMAGE_NAME"

# brew install imagemagick
SIZE=$(magick identify -format '%w %h' $IMAGE_PATH)

WIDTH=$(echo $SIZE | cut -d' ' -f1)
HEIGHT=$(echo $SIZE | cut -d' ' -f2)

DISPLAY_HEIGHT=$(printf "%.0f" "$IMAGE_SCALE_HEIGHT")
MOD=$(($HEIGHT/$IMAGE_SCALE_HEIGHT))
DISPLAY_WIDTH=$(printf "%.0f" "$(($WIDTH/$MOD*2))")

fastfetch --logo $IMAGE_PATH --logo-width $DISPLAY_WIDTH --logo-height $DISPLAY_HEIGHT --logo-type iterm

