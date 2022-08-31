#!/bin/bash

# Modified from Vortex-Simulator: https://github.com/vortexntnu/Vortex-Simulator

USERNAME=oyssolbo

source /opt/ros/melodic/setup.bash
cd /home/${USERNAME}/sim_ws && source devel/setup.bash && roslaunch simulator_launch robosub2022_sim.launch