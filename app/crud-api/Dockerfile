FROM openjdk:8-jdk-alpine
WORKDIR /app
EXPOSE 8090
ADD target/springboot2-jpa-crud-example.jar springboot2-jpa-crud-example.jar
ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=k8s", "/app/springboot2-jpa-crud-example.jar"]