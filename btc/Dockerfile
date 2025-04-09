FROM ubuntu:22.04
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get update && apt-get install -y libc6
RUN apt-get install -y build-essential
RUN apt-get install -y ufw

# uncomment this if your physical machine is arm processor and comment the other section.
RUN dpkg --add-architecture armhf && \
    apt-get update && \
    apt-get install -y wget libc6:armhf libstdc++6:armhf
RUN wget https://bitcoin.org/bin/bitcoin-core-28.1/bitcoin-28.1-arm-linux-gnueabihf.tar.gz

# Uncomment this if your physical machine is x86_64 processor and comment the other section.

# RUN apt-get update && \
#     apt-get install -y wget libc6 libstdc++6
# RUN wget https://bitcoin.org/bin/bitcoin-core-28.1/bitcoin-28.1-x86_64-linux-gnu.tar.gz


RUN tar xzf bitcoin-28.1-*
RUN su -c 'install -m 0755 -o root -g root -t /usr/local/bin bitcoin-28.1/bin/*'
EXPOSE 38332 38333
COPY ./btc/btc_entrypoint.sh btc_entrypoint.sh
RUN chmod +x btc_entrypoint.sh