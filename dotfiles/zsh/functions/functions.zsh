
cct() {
	sbt ';clean;compile;test;scalafmtAll'
}

sandbox_deployer() {
   export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.gcp-keys/eli-jordan-sandbox.json"
}

staging_dataloader() {
   export GOOGLE_APPLICATION_CREDENTIALS="$HOME/data-platform-stg-dataloader.json"	
}


k8s_dashboard() {
	kubectl proxy &
	open http://localhost:8001/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy
}