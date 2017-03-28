FROM harbor-bj.devopshub.cn/library/java:openjdk-8-jdk-alpine
WORKDIR /code
ADD target /code/target
CMD ["java", "-jar", "target/worker-jar-with-dependencies.jar"]
