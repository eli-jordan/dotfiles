

COORDINATOR_KUBE_CTX="gke_tapad-coordinator-stg_us-central1_tapad-coordinator-stg-152b"
MAINTAINER_KUBE_CTX="gke_tapad-sandbox-201809_us-central1_sandbox-gp"

HELM="$HOME/.local/bin/helm"
CHARTS_ROOT="$HOME/code/mart-framework/platform/mart-framework/helm"

link_coordinator_service_account() {
   sudo mkdir -p "/var/run/secrets/kubernetes.io"
   sudo ln -s "/Users/elias.jordan/.gcp-keys/coordinator-k8s-service-acct" "/var/run/secrets/kubernetes.io/serviceaccount"
}

publish_docker_image() {
   echo "####"
   echo "#   install-mart-framework.sh: Building docker image"
   echo "####"
   echo ""

   local currentDir="$PWD"
   local dockerBuildOut="/tmp/docker_build_out_$RANDOM.txt"
   cd "$HOME/code/mart-framework"
   sbt mart-framework/dockerBuildAndPush | tee "$dockerBuildOut"
   cd "$currentDir"
   export VERSION="$(cat "$dockerBuildOut" | grep 'digest:' | cut -d':' -f1 | sed s/'\[.*\] '//g | sed 's/[\d128-\d255]//g')"
   echo "VERSION=$VERSION"
}

publish_charts() {
   echo "####"
   echo "#   install-mart-framework.sh: Publishing mart-framework helm charts"
   echo "####"
   echo ""
   local currentDir="$PWD"
   cd "$HOME/code/mart-framework"
   sbt mart-framework/helmPublish
   cd "$currentDir"
}

upgrade_coordinator() {
   echo "####"
   echo "#  install-mart-framework.sh: Upgrading coordinator to version=$VERSION"
   echo "####"
   echo ""
   if [ -z "$VERSION" ]; then
      echo "VERSION env var is required"
      exit 1
   fi
   $HELM upgrade mart-coordinator "$CHARTS_ROOT/mart-coordinator" \
      --set "imageVersion=$VERSION" \
      --kube-context "$COORDINATOR_KUBE_CTX" \
      --namespace default
}

upgrade_maintainer() {
   echo "####"
   echo "#   install-mart-framework.sh: Upgrading maintainer to version=$VERSION"
   echo "####"
   echo ""
   if [ -z "$VERSION" ]; then
      echo "VERSION env var is required"
      exit 1
   fi
   $HELM upgrade mart-maintainer-eli-test "$CHARTS_ROOT/mart-framework-cli" \
      --set "imageVersion=$VERSION" \
      --kube-context "$MAINTAINER_KUBE_CTX" \
      --namespace eli-maintainer-test
}

upgrade_mart_framework() {
   publish_docker_image

   upgrade_maintainer
   upgrade_coordinator
}

port_forward_coordinator() {
   kubectl --context="$COORDINATOR_KUBE_CTX" port-forward deployment/mart-coordinator 8081:8080
}

logs_coordinator() {
   local coordinatorPod="$(kubectl --context=$COORDINATOR_KUBE_CTX get pods | grep mart-coordinator | awk '{ print $1 }')"
   kubectl --context="$COORDINATOR_KUBE_CTX" logs -f "$coordinatorPod"
}

logs_maintainer() {
   local maintainerPod="$(kubectl --context=$MAINTAINER_KUBE_CTX --namespace=eli-maintainer-test get pods | grep mart-maintainer | awk '{ print $1 }')"
   kubectl --context="$MAINTAINER_KUBE_CTX" logs -f "$maintainerPod"
}

proxy_coordintor_db() {
  cloud_sql_proxy -instances=tapad-coordinator-stg:us-central1:tapad-coordinator-db=tcp:5432
}

km() {
   kubectl --context="$MAINTAINER_KUBE_CTX" --namespace="eli-maintainer-test" $@
}

kc() {
   kubectl --context="$COORDINATOR_KUBE_CTX" $@
}

hm() {
   $HELM --kube-context="$MAINTAINER_KUBE_CTX" $@
}

hc() {
   $HELM --kube-context="$COORDINATOR_KUBE_CTX" $@
}

