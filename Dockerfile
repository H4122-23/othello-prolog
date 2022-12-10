FROM --platform=linux/amd64 swipl:7.6.4
RUN apt-get update && apt-get install -y python3
CMD ["bash"]