FROM osrf/ros:noetic-desktop-full-focal

LABEL maintainer="Yue Erro <yue.erro@pal-robotics.com>"

ARG REPO_WS=/pmb3_public_ws
RUN mkdir -p $REPO_WS/src
WORKDIR $REPO_WS

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    libv4l-dev \
    libv4l2rds0 \
    git \
    wget \
    vim \
    locales \
    dpkg \
    ssh \
    curl \
    aptitude \
    g++ \
    gcc \
    openvpn \
    gnupg \
    bash-completion \
    vim-gtk3 \
    nano \
    psmisc \
    ccache \
    gdb \
    qtcreator \
    htop \
    man \
    meld \
    silversearcher-ag \
    terminator \
    tig \
    valgrind \
    iputils-ping \
    ipython3 \
    python3-scipy \
    python3-wstool \
    python3-networkx \
    python3-pip  \
    python3-vcstool \
    python3-rosinstall \
    python3-catkin-tools \
 && rm -rf /var/lib/apt/lists/* \
 && wget https://raw.githubusercontent.com/pal-robotics/pmb3_tutorials/master/pmb3_public-noetic.rosinstall \
 && vcs import src < pmb3_public-noetic.rosinstall


ARG ROSDEP_IGNORE="pal_gazebo_plugins speed_limit_node sensor_to_cloud pmb3_rgbd_sensors pal_vo_server pal_karto pal_usb_utils pal_local_planner pal_filters hokuyo_node rrbot_launch robot_pose pal_pcl rviz_plugin_covariance pal-orbbec-openni2 slam_toolbox omni_drive_controller"

RUN apt-get update && rosdep install --from-paths src --ignore-src -y --rosdistro noeticc --skip-keys="${ROSDEP_IGNORE}"

RUN bash -c "source /opt/ros/noetic/setup.bash \
    && catkin build -DCATKIN_ENABLE_TESTING=0 -j $(expr `nproc` / 2) \
    && echo 'source $REPO_WS/devel/setup.bash' >> ~/.bashrc"

ENTRYPOINT ["bash"]
