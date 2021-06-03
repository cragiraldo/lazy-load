FROM openjdk:8u292-oraclelinux7

USER root

RUN yum update -y && yum install git wget unzip vi -y
RUN wget https://services.gradle.org/distributions/gradle-6.4.1-bin.zip -P /tmp
RUN sudo unzip -d /opt/gradle /tmp/gradle-*.zip
RUN sudo vi /etc/profile.d/gradle.sh
RUN echo "export GRADLE_HOME=/opt/gradle/gradle-6.4.1" >> /etc/profile.d/gradle.sh
RUN echo "export PATH=${GRADLE_HOME}/bin:${PATH}" >> /etc/profile.d/gradle.sh
WORKDIR /backend
ADD ./build/libs/lazy-load-backend-1.0.jar /backend/
ADD ./resources/application.yml /backend/resources/

ENTRYPOINT [ "executable" ]["java", "-jar build/libs/lazy-load-app-1.0.jar --spring.config.location=./resources/application.yml"]

CMD [ "/bin/bash" ]

