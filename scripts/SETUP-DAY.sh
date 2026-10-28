#!/bin/bash
# SETUP DAY - Ubuntu 22.04 on new SSD.
# Offline part runs with NO internet. The internet part is the ONE BIG SESSION
# that installs everything for the first 18 months of the journey.
# FIRST: copy 08-linux-stack from external USB to ~/offline (Ubuntu reads NTFS fine):
#   mkdir -p ~/offline
#   cp -r /media/$USER/<EXT_NAME>/robotics-offline/08-linux-stack/* ~/offline/
set -e
OFF=~/offline

echo "== 1. VS Code =="
sudo dpkg -i $OFF/debs/vscode*.deb || true

echo "== 2. Arduino CLI (tar.gz - works offline) =="
mkdir -p ~/.local/bin ~/arduino-cli
tar -xzf $OFF/appimages/arduino-cli*Linux_64bit.tar.gz -C ~/arduino-cli
ln -sf ~/arduino-cli/arduino-cli ~/.local/bin/arduino-cli
echo "NOTE: the Arduino IDE AppImage needs libfuse2 - installed in the internet step below."

echo "== 3. ESP32 Arduino core (offline staging for Board Manager) =="
mkdir -p ~/.arduino15/staging/packages
cp $OFF/esp32-arduino/*.zip $OFF/esp32-arduino/*.tar.gz ~/.arduino15/staging/packages/ 2>/dev/null || true
echo "Archives keep exact original filenames - Board Manager verifies checksums and reuses them without downloading."
echo "OFFLINE TRICK for the board index (when there is no internet):"
echo "  cd $OFF/esp32-arduino && python3 -m http.server 8000"
echo "  Then in Arduino IDE > Preferences > Additional Boards Manager URLs put:"
echo "  http://localhost:8000/package_esp32_index.json"

echo "== 4. pip bootstrap (offline) + Python wheels (no index) =="
python3 $OFF/wheels/get-pip.py --no-index --find-links $OFF/wheels || true
pip3 install --no-index --find-links $OFF/wheels numpy opencv-python-headless pyserial || true
echo "(esptool ships as source-only - installed in the internet step with setuptools.)"

echo "== 5. Foxglove =="
sudo dpkg -i $OFF/debs/foxglove*.deb || true

echo "== OFFLINE PART DONE =="
echo "Run the ONE BIG INTERNET SESSION below (tether / uni wifi)."

echo ""
echo "== ONE BIG INTERNET SESSION - run in order =="
echo "# A. system + build tools"
echo "sudo apt update && sudo apt --fix-broken install -y"
echo "sudo apt install -y locales software-properties-common curl ca-certificates libfuse2 git build-essential cmake python3-pip python3-setuptools python3-dev python3-venv python3-colcon-common-extensions python3-rosdep"
echo "sudo locale-gen en_US en_US.UTF-8 && sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8"
echo ""
echo "# B. ROS 2 Humble core + Gazebo sim (~2GB)"
echo "sudo add-apt-repository -y universe"
echo "sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg"
echo 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list'
echo "sudo apt update"
echo "sudo apt install -y ros-humble-desktop ros-humble-gazebo-ros-pkgs ros-humble-gazebo-ros2-control ros-humble-slam-toolbox ros-humble-navigation2 ros-humble-nav2-bringup"
echo "sudo rosdep init && rosdep update   # if rosdep init says 'file exists', that is fine"
echo 'echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc'
echo ""
echo "# C. Docker (cloud/DevOps sweet spot)"
echo "sudo install -m 0755 -d /etc/apt/keyrings"
echo "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc"
echo "sudo chmod a+r /etc/apt/keyrings/docker.asc"
echo 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list'
echo "sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
echo "sudo usermod -aG docker $USER   # log out and back in afterwards"
echo ""
echo "# D. KiCad 8 (PCB / chip sweet spot)"
echo "sudo add-apt-repository -y ppa:kicad/kicad-8.0-releases"
echo "sudo apt update && sudo apt install -y kicad"
echo ""
echo "# E. Python libs from cached wheels (no download)"
echo "pip3 install --no-index --find-links ~/offline/wheels numpy opencv-python-headless pyserial"
echo "pip3 install --no-index --find-links ~/offline/wheels esptool --no-build-isolation"
echo ""
echo "# F. OPTIONAL NOW (~400MB): torch CPU + YOLO for Week 11-12 vision. Skip if data is tight - Colab covers training."
echo "pip3 install torch --index-url https://download.pytorch.org/whl/cpu"
echo "pip3 install ultralytics"
echo ""
echo "OPTIONAL (free, personal use): sudo pro attach <token from ubuntu.com/pro/dashboard> - Ubuntu Pro, ESM security to 2032"
