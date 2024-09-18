# Development on a Local Spark Cluster

We have used Docker to create a network, and establish a mimic production cluster (albeit very small) so that we can develop Spark applications locally, without needing to run against a full cluster.

The idea here is to mimic an AWS EMR style setup.
We will have a Spark Master, 2 worker nodes, and then an "edge-node" which can connect to the cluster and submit jobs to it.

The "object storage" will be MinIO, to replicate the AWS S3 functionality, due to it's compaitble APIs.

-------------

... more details to come ... 