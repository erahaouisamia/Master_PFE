FROM openjdk:8-jdk-alpine
WORKDIR /app
EXPOSE 8090
ADD target/crud-api-0.0.1-SNAPSHOT.jar /app/crud-api.jar
ENTRYPOINT ["java", "-jar", "/app/crud-api.jar"]
