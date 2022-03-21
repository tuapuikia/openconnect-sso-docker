### How to build an openconnect-sso image

`docker buildx build -t myopenconnect:sso --push -f Dockerfile-sso .`

### How to run it from the container.

SAML authentication require **X GUI support**

`xhost +local:docker`

`docker run --pull always --rm -ti --network host --privileged -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /etc/resolv.conf:/etc/resolv.conf:rw myopenconnect:sso -s myvpn.domain.com -u myuser@domain.com`

#### Using prebuild docker image

`docker run --pull always --rm -ti --network host --privileged -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /etc/resolv.conf:/etc/resolv.conf:rw tuapuikia/openconnect:sso "-s myvpn.domain.com -u myuser@domain.com"`
