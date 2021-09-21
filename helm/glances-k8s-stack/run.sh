
helm upgrade -i        \
  glances-k8s-stack .  \
  --namespace gks      \
  --create-namespace
