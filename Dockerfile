FROM openjdk:11.0.11-jre-slim-buster

EXPOSE 8080

COPY build/libs/sample-ecs-application-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]