FROM openjdk:8-jdk-alpine
WORKDIR /app
EXPOSE 8090
ADD target/springboot2-jpa-crud-example.jar springboot2-jpa-crud-example.jar
RUN wget -O /apm-agent.jar https://search.maven.org/remotecontent?filepath=co/elastic/apm/elastic-apm-agent/1.8.0/elastic-apm-agent-1.8.0.jar
ENTRYPOINT ["java", "-jar", "/app/springboot2-jpa-crud-example.jar"]