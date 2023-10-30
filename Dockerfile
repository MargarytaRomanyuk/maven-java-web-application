# Use the official Maven image for the build
FROM maven:3.8.2-jdk-11 AS build

# Set the work directory
WORKDIR /app

# Copy pom.xml and source code to the work directory
COPY pom.xml .
COPY src ./src/

# Build the project
RUN mvn clean package

# Use the official Java image to run
FROM openjdk:11-jre-slim

# Set the work directory
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Set the port your application is listening on
EXPOSE 808000

# Run the application
CMD ["java", "-jar", "app.jar"]
