ARG JDK_VERSION="11-aarch64"

FROM bellsoft/liberica-openjdk-alpine:${JDK_VERSION}
LABEL maintainer="Edwin Martinez <dev.edwinmartinez@gmail.com>"

ARG CMDLINE_VERSION="9.0"
ARG SDK_TOOLS_VERSION="9477386"
ENV ANDROID_SDK_ROOT "/opt/sdk"
ENV ANDROID_HOME ${ANDROID_SDK_ROOT}
ENV PATH $PATH:${ANDROID_SDK_ROOT}/cmdline-tools/${CMDLINE_VERSION}/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/extras/google/instantapps

RUN apk upgrade && \ 
    apk add --no-cache bash curl git unzip wget coreutils && \ 
    rm -rf /tmp/* && \ 
    rm -rf /var/cache/apk/* && \ 
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-${SDK_TOOLS_VERSION}_latest.zip -O /tmp/tools.zip && \ 
    mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \ 
    unzip -qq /tmp/tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \ 
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/* ${ANDROID_SDK_ROOT}/cmdline-tools/${CMDLINE_VERSION} && \ 
    rm -v /tmp/tools.zip && \ 
    mkdir -p ~/.android/ && touch ~/.android/repositories.cfg && \ 
    yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses && \ 
    sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "platform-tools" "extras;google;instantapps" 

WORKDIR /home/android

ARG BUILD_TOOLS="33.0.2"
ARG TARGET_SDK="33"
ENV PATH $PATH:${ANDROID_SDK_ROOT}/build-tools/${BUILD_TOOLS}

ARG BUILD_TOOLS
ARG TARGET_SDK

ENV PATH $PATH:${ANDROID_SDK_ROOT}/build-tools/${BUILD_TOOLS}

RUN sdkmanager --sdk_root="${ANDROID_SDK_ROOT}" --install "build-tools;${BUILD_TOOLS}" "platforms;android-${TARGET_SDK}" && \
    sdkmanager --sdk_root="${ANDROID_SDK_ROOT}" --uninstall emulator


CMD ["/bin/bash"]