FROM ubuntu:14.04
MAINTAINER Rob Cherry

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Update the repositories
RUN apt-get -yqq update

# Upgrade packages
RUN apt-get -yqq upgrade

# Set locale and reconfigure
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure --frontend noninteractive locales
RUN apt-get -yqq install language-pack-en

# Set timezone
ENV TZ "US/Eastern"
RUN echo "US/Eastern" | sudo tee /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Install utilities
RUN apt-get -yqq install ca-certificates curl dnsutils man openssl unzip wget

# Install supervisor
RUN apt-get -yqq install supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install xvfb and fonts
RUN apt-get -yqq install xvfb fonts-ipafont-gothic xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic

# Install VNC
RUN apt-get -yqq install x11vnc
RUN mkdir -p ~/.vnc
RUN x11vnc -storepasswd selenium ~/.vnc/passwd

# Install window manager
RUN apt-get -yqq install fluxbox
 
# Install Java
RUN apt-get -yqq install openjdk-7-jre-headless

# Install Selenium
RUN mkdir -p /opt/selenium
RUN wget --no-verbose -O /opt/selenium/selenium-server-standalone.jar http://selenium-release.storage.googleapis.com/2.42/selenium-server-standalone-2.42.2.jar

# Install Chrome WebDriver
RUN wget --no-verbose -O /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/2.10/chromedriver_linux64.zip
RUN rm -rf /opt/selenium/chromedriver
RUN unzip /tmp/chromedriver_linux64.zip -d /opt/selenium/
RUN rm /tmp/chromedriver_linux64.zip
RUN mv /opt/selenium/chromedriver /opt/selenium/chromedriver-2.10
RUN chmod 755 /opt/selenium/chromedriver-2.10
RUN ln -fs /opt/selenium/chromedriver-2.10 /usr/bin/chromedriver

# Install Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get -yqq update
RUN apt-get -yqq install google-chrome-stable

# Install Firefox
RUN apt-get -yqq install firefox

# Create a default user with sudo access
RUN useradd selenium --shell /bin/bash --create-home
RUN usermod -a -G sudo selenium
RUN echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

# Default configuration
ENV SCREEN_GEOMETRY "1440x900x24"
ENV SELENIUM_PORT 4444
ENV DISPLAY :20.0

# Directories
VOLUME /var/log

# Ports
EXPOSE 4444 5900

CMD ["/usr/bin/supervisord"]
