path=$(CURDIR)
build:
	docker build -t docker_ros2_humble_on_windows .
run:
	docker run -it -e DISPLAY=host.docker.internal:0 -v ${path}/src:/root/src --gpus all --name docker_ros2_humble_on_windows docker_ros2_humble_on_windows:latest /bin/bash
start:
	docker start docker_ros2_humble_on_windows
shell:
	docker exec -it docker_ros2_humble_on_windows /bin/bash
stop:
	docker stop docker_ros2_humble_on_windows
rm:
	docker rm docker_ros2_humble_on_windows

clone:
	git clone -b humble git@github.com:wyd0817/sim_physx_control.git share/ros2_ws/src/sim_physx_control
	git clone -b humble git@github.com:wyd0817/sim_physx_pursuit.git share/ros2_ws/src/sim_physx_pursuit
	git clone -b main-ros2 https://github.com/Unity-Technologies/ROS-TCP-Endpoint.git share/ros2_ws/src/ROS-TCP-Endpoint