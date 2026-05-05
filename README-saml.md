# OpenConnect SAML Ubuntu GUI Docker

This Dockerfile sets up `openconnect-saml` on Ubuntu 24.04 with full GUI support for SSO/SAML authentication.

## Build

```bash
docker build -t openconnect-saml-ubuntu -f Dockerfile-saml-ubuntu .
```

## Run

To run with GUI support, you must share your X11 socket and set the `DISPLAY` variable.

### Linux (Native X11)

```bash
xhost +local:docker
docker run -it --rm \
  --cap-add=NET_ADMIN \
  --device=/dev/net/tun \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  openconnect-saml-ubuntu \
  --server vpn.example.com
```

### macOS (XQuartz)

1. Open XQuartz Preferences -> Security -> Check "Allow connections from network clients".
2. Run `xhost +localhost`.
3. Run:

```bash
docker run -it --rm \
  --cap-add=NET_ADMIN \
  --device=/dev/net/tun \
  -e DISPLAY=host.docker.internal:0 \
  openconnect-saml-ubuntu \
  --server vpn.example.com
```

### FIDO2 / Hardware Key Support (Yubikey)

To use a hardware key for MFA, you need to map the USB devices and hidraw devices to the container:

```bash
docker run -it --rm \
  --cap-add=NET_ADMIN \
  --device=/dev/net/tun \
  --device=/dev/bus/usb \
  --device=/dev/hidraw0 \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  openconnect-saml-ubuntu \
  --server vpn.example.com
```

*Note: You may need to map multiple `/dev/hidraw*` devices depending on your hardware.*

## Notes

- The container uses the `ubuntu` user (UID 1000).
- `sudo` is configured without a password for the `ubuntu` user to allow `openconnect` to manage network interfaces.
- The `vpnc-script` is copied to `/usr/share/vpnc-scripts/vpnc-script`.
