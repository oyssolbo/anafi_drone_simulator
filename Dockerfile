# Modified from Vortex-Simulator: https://github.com/vortexntnu/Vortex-Simulator

ARG ROS_DOCKERFILE_DISTRO=ros:melodic-ros-base-bionic
FROM ${ROS_DOCKERFILE_DISTRO}

SHELL [ "/bin/bash", "-c" ]

ARG USERNAME=oyssolbo

RUN adduser --quiet --disabled-password --shell /bin/bash \
    --home /home/${USERNAME} --gecos "User for anafi-simulator" ${USERNAME}
RUN usermod -aG sudo ${USERNAME}

#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 314DF160 
RUN apt-get update
# Accept software from packages.osrfoundation.org.
RUN apt-get install wget
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -

RUN apt-get update

# Utility
RUN apt-get install -y --allow-unauthenticated \
    openssh-server \
    nano \
    net-tools \
    curl \
    python-catkin-tools \
    python-openpyxl \
    python-dev \
    python-pip

# Required packages
RUN apt-get install -y \
    protobuf-compiler \
    gazebo9 \
    libgazebo9-dev \
    ros-melodic-gazebo-plugins \
    ros-melodic-gazebo-msgs \
    ros-melodic-xacro \
    ros-melodic-tf \
    ros-melodic-robot-state-publisher \
    ros-melodic-message-to-tf \
    ros-melodic-image-view \
    ros-melodic-uuv-simulator \
    libeigen3-dev 

# Pip packages
RUN pip install pymap3d==1.5.2


# Set up gazebo
RUN echo "export ROS_PACKAGE_PATH=/home/${USERNAME}/sim_ws:$ROS_PACKAGE_PATH" >> ~/.bashrc
RUN echo "export GAZEBO_MODEL_PATH=/home/${USERNAME}/sim_ws/src/gazebo:$GAZEBO_MODEL_PATH" >> ~/.bashrc 

# Source workspaces
RUN echo 'source /opt/ros/melodic/setup.bash' >> /home/${USERNAME}/.bashrc
RUN echo 'source ~/sim_ws/devel/setup.bash' >> /home/${USERNAME}/.bashrc

COPY ./pkg /home/${USERNAME}/sim_ws/src/pkg
COPY ./graphical_pkg /home/${USERNAME}/sim_ws/src/graphical_pkg

RUN cd /home/${USERNAME}/sim_ws && source /opt/ros/melodic/setup.bash && catkin build

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
