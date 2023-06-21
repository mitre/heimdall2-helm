
#!/bin/bash

# Copyright (C) 2020 Michael Joseph Walsh - All Rights Reserved
# You may use, distribute and modify this code under the
# terms of the the license.
#
# You should have received a copy of the license with
# this file. If not, please email <mjwalsh@nemonik.com>

source .env

if [ -f ./nginx/certs/ssl_certificate.crt ]; then
	echo "SSL Certificate already exists. if you would like to regenerate your certificates, please delete the files in ./nginx/certs/ and re-run this script."
else
	echo "SSL Certificate does not exist, creating self-signed certificate..."
	echo "Do not use a self-signed certificate in a production environment."
	echo
	echo "Generating certificate (Expires in 7 days)..."
	openssl req -newkey rsa:4096 \
							-x509 \
							-sha256 \
							-days 7 \
							-nodes \
							-out nginx/certs/ssl_certificate.crt \
							-keyout nginx/certs/ssl_certificate_key.key \
							-subj "/C=US/ST=SelfSigned/L=SelfSigned/O=SelfSigned/OU=SelfSigned"
fi

echo "Done generating keys"


# secrets
DATABASE_USERNAME="postgres"
DATABASE_PASSWORD="$(openssl rand -hex 33)"
JWT_SECRET="$(openssl rand -hex 64)"
JWT_TIMEOUT="1d"
API_KEY_SECRET="$(openssl rand -hex 33)"
NAMESPACE="heimdall"

# Install heimdall
helm install heimdall heimdall2 \
    -n $NAMESPACE --create-namespace \
    -f heimdall2/local-values.yaml \
    --set   databaseUsername=$DATABASE_USERNAME \
    --set   databasePassword=$DATABASE_PASSWORD \
    --set   jwtSecret=$JWT_SECRET \
    --set   jwtTimeout=$JWT_TIMEOUT \
    --set   apiKeySecret=$API_KEY_SECRET \
    --set   oidcName=$OIDC_NAME \
    --set   oidcExternalUrl=$EXTERNAL_URL \
    --set   oidcIssuer=$OIDC_ISSUER \
    --set   oidcAuthorizationUrl=$OIDC_AUTHORIZATION_URL \
    --set   oidcTokenUrl=$OIDC_TOKEN_URL \
    --set   oidcUserInfoUrl=$OIDC_USER_INFO_URL \
    --set   oidcClientId=$OIDC_CLIENTID \
    --set   oidcClientSecret=$OIDC_CLIENT_SECRET \
    --set   externalUrl=$EXTERNAL_URL \
    --set   nginx-ingress.controller.defaultTLS.cert=$NGINX_CRT \
    --set   nginx-ingress.controller.defaultTLS.key=$NGINX_KEY

