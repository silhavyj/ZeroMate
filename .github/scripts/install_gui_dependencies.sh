#!/bin/bash

# Update all package lists
sudo apt-get update -qq

# Install additional dependencies required for a successful build of ImGUI
sudo apt-get install -y libgl-dev \
                        libgl1-mesa-dev \
                        libx11-xcb-dev \
                        libfontenc-dev \
                        libxaw7-dev \
                        libxcomposite-dev \
                        libxcursor-dev \
                        libxdamage-dev \
                        libxfixes-dev \
                        libxi-dev \
                        libxinerama-dev \
                        libxmu-dev \
                        libxmuu-dev \
                        libxpm-dev \
                        libxrandr-dev \
                        libxres-dev \
                        libxss-dev \
                        libxtst-dev \
                        libxv-dev \
                        libxvmc-dev \
                        libxxf86vm-dev \
                        libxcb-render-util0-dev \
                        libxcb-xkb-dev \
                        libxcb-icccm4-dev \
                        libxcb-image0-dev \
                        libxcb-keysyms1-dev \
                        libxcb-randr0-dev \
                        libxcb-shape0-dev \
                        libxcb-sync-dev \
                        libxcb-xfixes0-dev \
                        libxcb-xinerama0-dev \
                        libxcb-dri3-dev \
                        libxcb-util-dev \
                        libxcb-util0-dev \
                        libglu1-mesa-dev

# EOF