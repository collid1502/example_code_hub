# Start from Amazon Linux 2
FROM amazonlinux:2

# Install Java, Python, and utilities
RUN yum update -y && \
    yum install -y java-1.8.0-openjdk-devel python3 python3-pip wget curl tar bzip2 gcc && \
    yum clean all

## ----- Activate shell
# the SHELL instruction sets the default shell that will be used for subsequent RUN instructions
# the provided "/bin/bash" specifies the executable to use for the shell
# the "-c" option tells the shell to execute the given command in non-interactive mode 
SHELL ["/bin/bash", "-c"]

## ----- Install Apache Spark
# Set the Spark version and the Hadoop version compatible with the Spark version
# PyDeequ only supports up to spark v3.3
ARG SPARK_VERSION=3.3.4
ARG HADOOP_VERSION=3

# download and install spark (via archive site) https://archive.apache.org/dist/spark/... 
RUN wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar xvf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /opt && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

# Set environment variables for Spark
ENV SPARK_HOME=/opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}
ENV PATH=$PATH:$SPARK_HOME/bin

# Install Apache Iceberg runtime
RUN mkdir -p $SPARK_HOME/jars && \
    wget -O $SPARK_HOME/jars/iceberg-spark-runtime-3.3_2.12-1.2.0.jar \
    https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.3_2.12/1.2.0/iceberg-spark-runtime-3.3_2.12-1.2.0.jar

# Install Python libraries
RUN pip3 install boto3 jupyterlab faker pandas pydeequ==1.3.0 pyspark==3.3.4

# Set working directory
WORKDIR /development

# Expose port for Jupyter (optional if you want to run Jupyter)
EXPOSE 8888

# Set the entrypoint to bash
ENTRYPOINT ["/bin/bash"]
