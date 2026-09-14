# Stage 1: Build stage (Jar already built via Maven in Jenkins, or fallback copy)
FROM eclipse-temurin:21-jre-alpine

# Set working directory
WORKDIR /app

# Create a non-root user for security best practices
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy built JAR from target directory into container
COPY target/*.jar app.jar

# Ownership shift to non-root user
RUN chown -R appuser:appgroup /app

USER appuser

# Expose Spring Boot default port
EXPOSE 8085

# Healthcheck for container stability
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:8085/actuator/health || exit 1

# Run Application
ENTRYPOINT ["java", "-jar", "app.jar"]