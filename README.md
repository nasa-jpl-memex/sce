# Sparkler Crawl Environment

The Sparkler Crawl Environment aims at providing an efficient, scalable, consistent and reliable software architecture consisting of domain discovery tools able to enrich a given domain by expanding the collection of artifacts that define the domain.

This repository, named __sce__, provides a command-line utility for building Sparkler Crawl Environment as a multi-container [Docker](https://www.docker.com/) application running through the [Docker Compose](https://docs.docker.com/compose/) tool on a single node. As a PoC, you can easily install the Sparkler Crawl Environment on a single node using the `kickstart.sh` bash script that automatically builds and starts up all the software components:

> ./kickstart.sh [-l /path/to/log]

The Sparkler Crawl Environment is built on top of [Sparkler](https://github.com/USCDataScience/sparkler), a new web crawler that makes use of recent advancements in distributed computing and information retrieval domains by conglomerating various Apache projects like Spark, Kafka, Lucene/Solr, Tika, and Felix. Sparkler is an extensible, highly scalable, and high-performance web crawler that is an evolution of Apache Nutch and runs on Apache Spark Cluster.
