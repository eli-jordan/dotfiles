
cct() {
	sbt ';clean;compile;test;scalafmt'
}

sandbox_deployer() {
   export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.gcp-keys/sandbox-deployer-key.json"
}

staging_dataloader() {
   export GOOGLE_APPLICATION_CREDENTIALS="$HOME/data-platform-stg-dataloader.json"	
}
