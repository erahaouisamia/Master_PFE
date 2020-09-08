FROM openjdk:8-jdk-alpine
WORKDIR /app
EXPOSE 8090
ADD target/crud-api.jar /app/crud-api.jar
ENTRYPOINT ["java", "-jar", "/app/crud-api.jar"]
