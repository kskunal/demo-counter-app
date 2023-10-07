FROM maven as base
WORKDIR /app
COPY . .
RUN mvn install

FROM openjdk:11.0
WORKDIR /app
COPY --from=base /app/target/*.jar /app
CMD ["java","-jar","*.jar"]
