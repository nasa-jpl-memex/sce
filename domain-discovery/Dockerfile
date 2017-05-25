
# Pull base image.

FROM ubuntu
RUN echo "Hello world"
WORKDIR /projects
RUN apt-get update && \
    apt-get install -y software-properties-common wget git
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-add-repository universe && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN apt-get update && apt-get install -y git maven emacs-nox

RUN git clone https://bitbucket.org/sujen1412/domain-discovery.git

RUN apt-get install -y python && \
    apt-get install -y python-setuptools python-dev build-essential && \
    easy_install pip

WORKDIR /projects/domain-discovery/webui
RUN git pull --all && git checkout memex-dd
RUN pip install -r requirements.txt

CMD ["python", "run.py"]

