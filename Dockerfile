FROM openjdk:24

WORKDIR /app

COPY target/tp4-0.0.1-SNAPSHOT.jar tp4-0.0.1-SNAPSHOT.jar
COPY ./wait-for-it.sh .

RUN chmod +x ./wait-for-it.sh

ENTRYPOINT ["./wait-for-it.sh", "tp4-k8s:5432", "--", "java", "-jar", "tp4-0.0.1-SNAPSHOT.jar"]
