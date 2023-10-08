#
# The MIT License
# Copyright © 2023 Loïc DUBOIS-TERMOZ (alias Djaytan)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

# Inspiration taken from https://github.com/mtoensing/Docker-Minecraft-PaperMC-Server
FROM eclipse-temurin:20-jre AS build

ARG version=1.20.1

WORKDIR /opt/minecraft

COPY ./getpaperserver.sh .
RUN apt update -y && \
    apt install -y curl jq && \
    chmod +x ./getpaperserver.sh && \
    ./getpaperserver.sh ${version}

FROM eclipse-temurin:20-jre

USER paper:paper

# Contains server's data (worlds, configs, plugins, logs, ...)
# The separation between the server himself (located under /opt/minecraft) and its data
# ease server updates
VOLUME /papermc-server-data

# Minecraft ports
EXPOSE 25565/tcp
EXPOSE 25565/udp

# PaperMC server will manage data from the working directory
# In order to decouple the server executable from the data then we specify a different directory
# than the one where the executable belongs to (i.e. /opt/minecraft)
WORKDIR /papermc-server-data

# Define the allocated memory size for the server's heap
# Value format must follow the one from the Java "-Xmx" and "-Xms" options:
# https://docs.oracle.com/en/java/javase/20/docs/specs/man/java.html#extra-options-for-java
ENV HEAP_SIZE=4G
# JVM arguments
ENV JVM_ARGUMENTS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -Dcom.mojang.eula.agree=true"
ENV PAPERMC_ARGUMENTS="--nojline"

COPY --from=build /opt/minecraft/papermc-server.jar /opt/minecraft/
COPY ./docker-entrypoint.sh /opt/minecraft/
RUN chmod +x /opt/minecraft/docker-entrypoint.sh

ENTRYPOINT ["/opt/minecraft/docker-entrypoint.sh"]
