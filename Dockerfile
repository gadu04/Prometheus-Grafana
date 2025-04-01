# Use Gradle image for building
FROM gradle:8.3-jdk17 AS build

# Set the working directory
WORKDIR /app

# Copy only necessary files to improve build caching
COPY gradlew gradlew
COPY gradle gradle
COPY build.gradle build.gradle
# COPY settings.gradle settings.gradle
COPY src src

# Ensure Gradle wrapper has execute permissions
RUN chmod +x gradlew

# Build the application (skip tests for faster builds)
RUN ./gradlew clean build -x test

# Use a lightweight JRE image to run the application
FROM eclipse-temurin:17-jre-alpine

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the previous stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose correct application port
EXPOSE 3000

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
