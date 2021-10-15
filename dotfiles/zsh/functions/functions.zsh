
cct() {
	sbt ';clean;compile;test;scalafmtAll'
}


k8s_dashboard() {
	kubectl proxy &
	open http://localhost:8001/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy
}

# Setup auth for the AWS CLI when MFA is required
# See https://aws.amazon.com/premiumsupport/knowledge-center/authenticate-mfa-cli/
aws_auth() {
	local mfaToken
	echo "Enter MFA Token:"
	read mfaToken
	
	local credentialJson="$(aws sts get-session-token \
		--serial-number arn:aws:iam::633015631738:mfa/elias.jordan@tapad.com  \
		--token-code "$mfaToken")"

	export AWS_ACCESS_KEY_ID="$(echo $credentialJson | jq -cMr .Credentials.AccessKeyId)"
	export AWS_SECRET_ACCESS_KEY="$(echo $credentialJson | jq -cMr .Credentials.SecretAccessKey)"
	export AWS_SESSION_TOKEN="$(echo $credentialJson | jq -cMr .Credentials.SessionToken)"

	python3 $HOME/dotfiles/zsh/functions/save_aws_credentials.py

	echo "Autentication details haved been saved in a profile named 'mfa'."
	echo "You can now use 'aws --profile=mfa ...'"
}

ssl_dates() {
	local host="$1"
	openssl s_client -connect "$1":443 -servername "$1" 2> /dev/null | openssl x509 -noout -dates
}

codecov_report() {
	if [[ -z "$CODECOV_TOKEN" ]]; then
		echo "error: CODECOV_TOKEN environment variable must be set"
	fi

	local repos=(dgx dga compass dcs batch-data-ingress warehouse devicegraph-5 standalone-activation pixel-server composer-dsl cloudcre10)

	echo "repo,coverage"
	for r in $repos; do
  		coverage="$(curl -s -X GET https://codecov.io/api/gh/Tapad/$r -H "Authorization: ${CODECOV_TOKEN}" | jq -r '.commit.totals.c')"
  		echo "Tapad/$r,$coverage"
	done
}