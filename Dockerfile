ARG osversion=8
FROM openjdk:${osversion}

ARG VERSION=master
ARG VCS_REF
ARG BUILD_DATE

RUN echo "VCS_REF: "${VCS_REF}", BUILD_DATE: "${BUILD_DATE}", VERSION: "${VERSION}

LABEL maintainer="rsettlag@vt.edu" \
      description="Dockerfile providing the canu assembler for long reads - currently testing this" \
      version=${VERSION} \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.build-date=${BUILD_DATE} \

RUN apt-get update && \
    apt-get --yes install \
       build-essential \
       wget \
       gnuplot && \
    apt autoclean && \
    rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

WORKDIR /opt
RUN wget -O canu-2.1.1.tar.xz https://github.com/marbl/canu/releases/download/v2.1.1/canu-2.1.1.tar.xz && \
    tar -xf canu-2.1.1.tar.xz && \
    cd canu-2.1.1/src && \ 
    make -j 8

ENV PATH=/opt/canu-2.1.1/build/bin:${PATH}

VOLUME /data
WORKDIR /data

ENTRYPOINT ["canu"]
CMD ["--help"]
