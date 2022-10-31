# Docker container for SiPM

Singularity and Docker recipes to build a ROOT and Geant4 environment to run SiPM simulation.

For regular usage, simply download the pre-built container with the following instructions the container

As of ***October 30, 2022*** Docker is implementing an inactive image removal policy, meaning in a free account (which is where this container is hosted) if the container is not ***updated or pulled for 6 consecutive months*** it will be ***deleted***. This isn't a huge issue, someone will just have to do the following:
- Build the container manually from the image file in this repository according to the instructions below
- Upload it to another Dockerhub repository
- Update the download links that reference the Dockerhub location with the new location

# FEATURES
- SiPM simulation compatible environment, including ROOT6, GEANT4 and scons
- GUI output support

# [PLEASE READ]

1. Docker provides you with an isolated virtual filesystem (meaning you **can't** access your files from outside
the container). In summary, it is best to **mount** whatever directories you may need when running the container
in Docker (see the section "**To write/execute files from directories outside of simulation
directory**" below).

2. Regardless of whether you download or build the container, you can use and develop simulation as you see fit as it is external
to the container.

3. Instructions to install Docker for each platform can be found [here.](https://docs.docker.com/install/#supported-platforms).
**Version 19.0+ is required**

4. **To be clear, if you wish to use the prebuilt image, then you do NOT need to clone this repo; simply follow the
instructions below.**

# To download the pre-built container
***
The command to obtain the latest version of the container for Docker is:
```
docker pull dmytrocloud/sipm_simulation_env:latest
```
The tag (in the above command, `latest`) can be replaced with the desired tag.

Docker doesn't actually create a file in your working directory; rather, it
downloads the image layers and adds an entry to your local **Docker registry** which can be viewed by going:
```
docker images
```
# Instructions on how to use the container with simulation

**To build RAT for the first time**:
- Clone simulation code form from [GitLab](https://gitlab.triumf.ca/phaar/g4sipm/-/tree/DockerVersion/). ***Use DockerVersion branch!***
- Enter the following command, filling in the path to simulation with your own.
  This will mount your SiPM repo to the directory `/home/software/g4sipm` inside the container:

  For *Docker*:
  ```
  docker run -ti --init --rm -v /absolute/path/to/simulation:/home/software/g4sipm dmytrocloud/sipm_simulation_env
  ```
  *Note* - for the `-v` flag you **must** provide it with an absolute path (one starting at /);
  relative paths (the path from where you are now) will **not** work.
  You can also check *run.sh* file in this repository for an example command of how I run it on my computer.

- Once in the container change the directory to g4sipm and follow the general instructions from the SiPM simulation [repo](https://gitlab.triumf.ca/phaar/g4sipm/-/tree/DockerVersion/)

***
**To exit the container**:
```
exit
```
***
**To use GUI apps like ROOT's TBrowser**:
(This is based on CERN's documentation for [running ROOT with graphics](https://hub.docker.com/r/rootproject/root-ubuntu16/))

- The process is different on each OS but I will outline steps here to make it work on each. Note that these instructions
  assume that since you are on your own machine, you are using **Docker**.

  For **Linux**:
  ```
  docker run -ti --init --rm --user $(id -u) -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /absolute/path/to/simulation:/home/software/g4sipm dmytrocloud/sipm_simulation_env
  ```
  As you can see, the difference is a few extra options. As the command has gotten so large, you can [set an alias in your .bashrc](https://askubuntu.com/a/17538) to something much shorter and more convenient.

  For **macOS**:

  1. Install [XQuartz](https://www.xquartz.org/)
  2. Open XQuartz, and then go XQuartz -> Preferences -> Security, and tick the box "Allow connections from network clients"
  3. Run `xhost + 127.0.0.1` which will whitelist your local IP
  4. Finally, you can run the container with the following:
  ```
  docker run --rm --init -ti -v /tmp/.X11-unix:/tmp/.X11-unix -v /absolute/path/to/simulation:/home/software/g4sipm  -e DISPLAY=host.docker.internal:0 dmytrocloud/sipm_simulation_env
  ```
  (The order `-ti` instead of `-it` seems to only matter for MacOS)

***
**To write/execute files from directories outside of simulation directory**:
- Add additional bind mounts to your Docker command
- Example:

  For *Docker*:
  ```
  docker run --init --rm -ti -v /absolute/path/to/simulation:/rat -v /other/path:/home/software/g4sipm  dmytrocloud/sipm_simulation_env
  ```
- Now in the container, you have access to /other/path at /stuff

# [ADVANCED]
# To build the container
To build, you must have **root permissions** and **Docker installed on your machine**. Docker installation instructions can be found [here](https://docs.docker.com/get-docker/) for each OS.

To rebuild the container:

1. Clone this repository
2. Edit `Dockerfile`, which is the recipe on what you would like to put into your container
3. Once you are happy with your changes run:
   ```
   docker build -t YOUR_CONTAINER_TAG .
   ```
   where `YOUR_CONTAINER_TAG` is the name you would like to give to your container.

5. This will build your container with your tag name, which you can then use in the same way as in the above guide, but instead of
   ```
   docker run ... dmytrocloud/sipm_simulation_env
   ```
   you will now run:
   ```
   docker run ... YOUR_TAG_NAME
   ```

6. [OPTIONAL] If you would like to share or back up your container image, you can push it to Dockerhub. You can follow [the official documentation](https://docs.docker.com/docker-hub/repos/#pushing-a-docker-container-image-to-docker-hub) to learn how


***

The template of this README.me is taken from RAT container [repository](https://github.com/snoplus/rat-container/blob/master/README.md)
