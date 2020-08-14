FROM ubuntu:18.04

LABEL maintainer "Rozhentsov Egor <roov.egor@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /root

# Package list:
# 1.  openjdk-8-jdk
# 2.  ca-certificates
# 3.  tzdata
# 4.  zip
# 5.  unzip
# 6.  curl
# 7.  wget
# 8.  libqt5webkit5
# 9.  libgconf-2-4
# 10. xvfb
# 11. gnupg
# 12. salt-minion
RUN apt-get -qqy update && \
    apt-get -qqy --no-install-recommends install \
    openjdk-8-jdk \
    ca-certificates \
    tzdata \
    zip \
    unzip \
    curl \
    wget \
    libqt5webkit5 \
    libgconf-2-4 \
    xvfb \
    gnupg \
    salt-minion \
  && rm -rf /var/lib/apt/lists/*


ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre" \
    PATH=$PATH:$JAVA_HOME/bin

ARG SDK_VERSION=sdk-tools-linux-3859397
ARG ANDROID_BUILD_TOOLS_VERSION=26.0.0
ARG ANDROID_PLATFORM_VERSION="android-25"

ENV SDK_VERSION=$SDK_VERSION \
    ANDROID_BUILD_TOOLS_VERSION=$ANDROID_BUILD_TOOLS_VERSION \
    ANDROID_HOME=/root

RUN wget -O tools.zip https://dl.google.com/android/repository/${SDK_VERSION}.zip && \
    unzip tools.zip && rm tools.zip && \
    chmod a+x -R $ANDROID_HOME && \
    chown -R root:root $ANDROID_HOME

ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin

RUN mkdir -p ~/.android && \
    touch ~/.android/repositories.cfg && \
    echo y | sdkmanager "platform-tools" && \
    echo y | sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" && \
    echo y | sdkmanager "platforms;$ANDROID_PLATFORM_VERSION"

ENV PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools

ARG APPIUM_VERSION=1.18.0
ENV APPIUM_VERSION=$APPIUM_VERSION

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash && \
    apt-get -qqy install nodejs && \
    npm install -g appium@${APPIUM_VERSION} --unsafe-perm=true --allow-root && \
    exit 0 && \
    npm cache clean && \
    apt-get remove --purge -y npm && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get clean


ARG ATD_VERSION=1.2
ENV ATD_VERSION=$ATD_VERSION
RUN wget -nv -O RemoteAppiumManager.jar "https://github.com/AppiumTestDistribution/ATD-Remote/releases/download/${ATD_VERSION}/RemoteAppiumManager-${ATD_VERSION}.jar"

ENV TZ="US/Pacific"
RUN echo "${TZ}" > /etc/timezone

# 4723 - Appium Server Port
# 4567 - Appium Test Distribution Port
EXPOSE 4723
EXPOSE 4567

COPY script/entry_point.sh \
     script/generate_config.sh \
     script/wireless_connect.sh \
     script/wireless_autoconnect.sh \
     /root/

RUN chmod +x /root/entry_point.sh && \
    chmod +x /root/generate_config.sh && \
    chmod +x /root/wireless_connect.sh && \
    chmod +x /root/wireless_autoconnect.sh

CMD /root/wireless_autoconnect.sh && /root/entry_point.sh
