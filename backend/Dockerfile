# Backend Dockerfile for Smart Wardrobe
# Simple single-stage build using pre-built jar
FROM eclipse-temurin:11-jre-alpine

# Set working directory
WORKDIR /app

# Copy the pre-built jar file (build locally before docker build)
COPY target/*.jar app.jar

# Create uploads directory
RUN mkdir -p /app/uploads

# Expose port
EXPOSE 8080

# Set environment variables
ENV JAVA_OPTS="-Xms256m -Xmx512m"
ENV SPRING_PROFILES_ACTIVE=prod

# Run the application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
