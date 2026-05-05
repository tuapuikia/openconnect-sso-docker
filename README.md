# OpenConnect SSO & SAML Docker

This repository provides Docker environments for connecting to Cisco AnyConnect VPNs using SAML/SSO authentication.

## 1. OpenConnect SAML (Modern - Ubuntu 24.04)
Uses `mschabhuettl/openconnect-saml`. Supports GUI, Chrome (Playwright), FIDO2 (Yubikey), and TUI.

### Build
```bash
docker build -t openconnect:saml -f Dockerfile-saml-ubuntu .
```

### Run (GUI Mode)
Requires an X11 server running on the host.
```bash
xhost +local:docker
docker run -it --rm \
  --cap-add=NET_ADMIN \
  --device=/dev/net/tun \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  openconnect:saml \
  --server vpn.example.com
```

### Run (with FIDO2/Yubikey)
```bash
xhost +local:docker
docker run -it --rm \
  --cap-add=NET_ADMIN \
  --device=/dev/net/tun \
  --device=/dev/bus/usb \
  --device=/dev/hidraw0 \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  openconnect:saml \
  --server vpn.example.com
```

---

## 2. OpenConnect SSO (Legacy - Debian Bullseye)
Uses `vlaci/openconnect-sso`.

### Build
```bash
docker build -t openconnect:sso -f Dockerfile-sso .
```

### Run
```bash
xhost +local:docker
docker run -it --rm \
  --network host \
  --privileged \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /etc/resolv.conf:/etc/resolv.conf:rw \
  openconnect:sso \
  -s vpn.example.com -u user@example.com
```

---

## Requirements & Troubleshooting

### X11 GUI Support
For the SAML login window to appear, you must have an X server running:
- **Linux:** Native X11. Run `xhost +local:docker` before starting the container.
- **macOS:** Install [XQuartz](https://www.xquartz.org/). In Preferences -> Security, check "Allow connections from network clients" and run `xhost +localhost`.

### TUN Device
The container needs access to `/dev/net/tun` to create the VPN interface.
- Use `--cap-add=NET_ADMIN --device=/dev/net/tun` (Recommended)
- Or `--privileged` (Less secure)

### DNS Issues
If the VPN connects but you can't resolve internal hostnames, you may need to mount your host's `resolv.conf`:
`-v /etc/resolv.conf:/etc/resolv.conf:rw`
