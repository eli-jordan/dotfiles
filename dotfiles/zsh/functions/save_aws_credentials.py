import os
import configparser

access_key_id = os.environ["AWS_ACCESS_KEY_ID"]
secret_access_id = os.environ["AWS_SECRET_ACCESS_KEY"]
session_token = os.environ["AWS_SESSION_TOKEN"]

credentials_file = os.path.join(os.path.expanduser("~"), '.aws', 'credentials')

credentials_config = configparser.ConfigParser()
credentials_config.read(credentials_file)
credentials_config['mfa'] = {
	"aws_access_key_id": access_key_id,
	"aws_secret_access_key": secret_access_id,
	"aws_session_token": session_token
}

with open(credentials_file, 'w') as configfile:
    credentials_config.write(configfile)