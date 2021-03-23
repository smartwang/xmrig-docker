FROM ubuntu:20.04 as builder
COPY sources.list /etc/apt/sources.list
RUN DEBIAN_FRONTEND=noninteractive apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y wget git build-essential cmake automake libtool autoconf 
RUN git clone https://github.com/smartwang/xmrig.git --depth 1
RUN  mkdir xmrig/build && cd xmrig/scripts && \
    ./build_deps.sh && cd ../build && \
    cmake .. -DXMRIG_DEPS=scripts/deps -DBUILD_STATIC=ON -DWITH_CUDA=OFF -DWITH_OPENCL=OFF && \
    make -j$(nproc)

FROM ubuntu:20.04
COPY --from=builder /xmrig/build/xmrig /xmrig
ENTRYPOINT ["/xmrig"]
    
