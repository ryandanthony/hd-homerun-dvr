# hd-homerun-dvr

Docker image for HDHomeRun DVR based on Ubuntu chiseled image principles.

## About

This Docker image provides a containerized environment for running HDHomeRun DVR on Linux. It's built on Ubuntu 24.04 with a minimal, security-focused approach inspired by chiseled Ubuntu images.

## Using the Pre-built Image

Pre-built images are automatically published to GitHub Container Registry (GHCR) and can be pulled directly:

```bash
docker pull ghcr.io/ryandanthony/hd-homerun-dvr:latest
```

## Building the Docker Image

If you prefer to build the image yourself:

```bash
docker build -t hdhomerun-dvr .
```

## Running with Docker

Using the pre-built image from GHCR:

```bash
docker run -d \
  --name hdhomerun-dvr \
  --network host \
  -v /path/to/recordings:/var/lib/hdhomerun/recordings \
  -v /path/to/config:/etc/hdhomerun \
  ghcr.io/ryandanthony/hd-homerun-dvr:latest
```

Or using a locally built image:

```bash
docker run -d \
  --name hdhomerun-dvr \
  --network host \
  -v /path/to/recordings:/var/lib/hdhomerun/recordings \
  -v /path/to/config:/etc/hdhomerun \
  hdhomerun-dvr
```

## Running with Docker Compose

The repository includes a `docker-compose.yml` file for easier deployment:

```bash
# Start the service
docker compose up -d

# View logs
docker compose logs -f

# Stop the service
docker compose down
```

### Configuration

- **Network Mode**: Use `--network host` to allow the DVR to discover HDHomeRun devices on your local network
- **Recordings Volume**: Mount a local directory to `/var/lib/hdhomerun/recordings` to persist your recordings
- **Config Volume**: Mount a local directory to `/etc/hdhomerun` for configuration files
- **Port**: The DVR service runs on port 59090

## Accessing the DVR

Once running, you can access the DVR web interface at:
```
http://<your-host-ip>:59090
```

## Image Details

- **Base Image**: Ubuntu 24.04
- **Architecture**: x86_64
- **Size**: ~326MB (optimized with minimal dependencies)
- **Security**: Built following chiseled image principles with only essential runtime dependencies

## Additional Resources

For more information about HDHomeRun DVR on Linux, visit:
https://info.hdhomerun.com/info/dvr:linux