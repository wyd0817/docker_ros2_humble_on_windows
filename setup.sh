#!/bin/bash
set -e

# ------------ Add apt-get repository
apt-get update
apt-get install -y curl gnupg lsb-release
curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

# ------------ Add repository to source list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# ------------ Install ROS2
apt-get update
apt-get install -y ros-humble-desktop

# ------------ Environment setup
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

# ------------ Install rosdep
apt-get install -y python3-rosdep
if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then
    rosdep init
fi
rosdep update

# ------------ Create workspace
apt-get install -y python3-colcon-common-extensions
mkdir -p ~/share/ros2_ws/src
cd ~/share/ros2_ws/ && colcon build --symlink-install || true

# ------------ Install Gazebo
apt-get install -y gazebo
apt-get install -y ros-humble-gazebo-*

# ------------ Apply environment setup
echo "source ~/share/ros2_ws/install/setup.bash" >> ~/.bashrc
echo "ROS2 Humble setup complete"