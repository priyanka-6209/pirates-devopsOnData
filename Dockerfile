FROM openjdk:8
WORKDIR /ms-pdf2img/v1
COPY . .
EXPOSE 8030
CMD java -jar target/pirates-0.0.1-SNAPSHOT-jar-with-dependencies.jar
