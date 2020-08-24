FROM openjdk:8-jdk-alpine
WORKDIR /app
EXPOSE 8090
ADD target/crud-api.jar crud-api.jar
ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=k8s", "/app/crud-api.jar"]