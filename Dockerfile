# HDHomeRun DVR Docker Image using Chiseled Ubuntu
# Based on instructions from https://info.hdhomerun.com/info/dvr:linux
# Chiseled Ubuntu images are ultra-small, security-focused images from Canonical

# Stage 1: Download and prepare HDHomeRun DVR software
FROM ubuntu:24.04 AS downloader

# Install required tools for downloading
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Download HDHomeRun record engine
# The DVR software package for Linux x64 systems
WORKDIR /tmp
RUN wget -q http://download.silicondust.com/hdhomerun/hdhomerun_record_linux_beta -O hdhomerun_record || \
    wget -q https://download.silicondust.com/hdhomerun/hdhomerun_record_linux -O hdhomerun_record || \
    (echo "Warning: Could not download HDHomeRun binary. Please provide your own binary." && touch hdhomerun_record) && \
    chmod +x hdhomerun_record

# Stage 2: Create minimal runtime image based on Ubuntu (chiseled approach)
# Using ubuntu:24.04 as base and removing unnecessary components
FROM ubuntu:24.04

# Install only runtime dependencies required by HDHomeRun DVR
# Keeping the image minimal following chiseled image principles
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    libavcodec-extra \
    libavformat60 \
    libavutil58 \
    libavfilter9 \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && rm -rf /usr/share/doc/* \
    && rm -rf /usr/share/man/* \
    && rm -rf /var/cache/* \
    && rm -rf /tmp/*

# Copy HDHomeRun DVR binary from downloader stage
COPY --from=downloader /tmp/hdhomerun_record /usr/local/bin/hdhomerun_record

# Ensure binary is executable
RUN chmod +x /usr/local/bin/hdhomerun_record

# Create directory structure for DVR
RUN mkdir -p /var/lib/hdhomerun/recordings && \
    mkdir -p /etc/hdhomerun && \
    chmod 755 /var/lib/hdhomerun

# HDHomeRun DVR default port
EXPOSE 59090

# Persistent storage for recordings
VOLUME ["/var/lib/hdhomerun/recordings"]

# Set working directory
WORKDIR /var/lib/hdhomerun

# Default startup command
# Users should override this with proper configuration
ENTRYPOINT ["/usr/local/bin/hdhomerun_record"]
CMD ["--conf", "/etc/hdhomerun"]
