# Stage 1 - Build the application
FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src

RUN mvn clean package -DskipTests

# Stage 2 - Tomcat runtime
FROM tomcat:9.0-jdk17-temurin

WORKDIR /usr/local/tomcat/webapps

RUN rm -rf ROOT

COPY --from=build /app/target/*.war ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
