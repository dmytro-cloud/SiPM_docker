docker run --rm --init -it -v /tmp/.X11-unix:/tmp/.X11-unix -v /Users/minchenk/Documents/Docker_SiPM_sim/g4sipm:/home/software/g4sipm -v /Users/minchenk/Documents:/Documents -v /Users:/Users -e DISPLAY=host.docker.internal:0 dmytrocloud/sipm_simulation_env
