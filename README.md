# mlchain-helm
[![Github All Releases](https://img.shields.io/github/downloads/mlchain/mlchain-helm/total.svg)]()

Deploy [mlchain/mlchain](https://github.com/mlchain/mlchain), an LLM based chat bot app on kubernetes with helm chart.

## Installation
```
helm repo add mlchain https://mlchain.github.io/mlchain-helm
helm repo update
helm install my-release mlchain/mlchain
```

## Supported Component 
### Components that could be deployed on kubernetes in current version
- [x] core (`api`, `worker`, `sandbox`)
- [x] ssrf_proxy
- [x] proxy (via built-in `nginx` or `ingress`)
- [x] redis
- [x] postgresql
- [x] persistent storage
- [ ] object storage
- [x] weaviate
- [ ] qdrant
- [ ] milvus
### External components that can be used by this app with proper configuration
- [x] redis
- [x] postgresql
- [x] object storage
- [x] weaviate
- [x] qdrant
- [x] milvus
- [x] pgvector

## Contributors
<a href="https://github.com/mlchain/mlchain-helm/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=mlchain/mlchain-helm" />
</a>

