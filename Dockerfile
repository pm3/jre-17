FROM openjdk:17-jdk-slim as build

WORKDIR /app

RUN jlink --add-modules java.base,java.sql,java.naming,java.xml,java.management,java.desktop,java.instrument,java.security.jgss,jdk.crypto.ec,jdk.localedata,java.rmi,java.net.http,jdk.zipfs,jdk.unsupported --include-locales en,sk-SK,cs-CZ,hu-HU  --output jre

FROM debian:buster-slim

RUN apt-get update && apt-get install -y curl tzdata curl libfontconfig1 && rm -rf /var/cache /var/lib/apt /var/lib/dpkg /var/log/apt
COPY --from=build /app/jre /usr/jre/

WORKDIR /app
USER 1000:1000
ENV LANG=C.UTF-8 JAVA_HOME=/usr/jre PATH=$PATH:/usr/jre/bin JAVA_OPTS= 
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
