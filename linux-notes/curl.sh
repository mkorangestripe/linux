# HTTP requests

curl -I www.redhat.com  # Fetch the headers only

# GET request - status codes and locations:
curl -svL redhat.com 2>&1 | egrep '^< HTTP|^< Location'

# GET request - status codes and locations:
printf "GET / HTTP/1.1\r\nHOST: localhost\r\nConnection: Close\r\nUser-Agent: netcat\r\n\r\n" | \
nc redhat.com 80 | egrep 'HTTP|Location'

# HEAD request - status codes and locations:
curl -sIL redhat.com | egrep 'HTTP|Location'

# Check HTTP status codes on multiple URLs:
echo; for URL in $URLS; do echo $URL; curl -vLks $URL 2>&1 | grep HTTP; echo; done
echo; for URL in $URLS; do echo $URL; curl -ILks $URL | grep HTTP; echo; done

# HEAD request - status codes and locations:
printf "HEAD / HTTP/1.1\r\nHOST: localhost\r\nConnection: Close\r\nUser-Agent: netcat\r\n\r\n" | \
nc redhat.com 80 | egrep 'HTTP|Location'

# Get a URL that requires a username and password:
curl -u 'admin:p@55W0rd' server1:8080/solr/admin/health
curl -H ‘Authorization: Basic YWRtaW46cEA1NVcwcmQ=’ server1:8080/solr/admin/health

# Get a URL that requires a username and password:
printf "GET /solr/admin/health HTTP/1.1\r\nAuthorization: Basic YWRtaW46cEA1NVcwcmQ=\r\nHOST: \
localhost\r\nConnection: Close\r\nUser-Agent: netcat\r\n\r\n" | nc server1 8080

# Connect to a specific node:
curl -H 'HOST: ordersummary-dev.esri.com' server1.domain.com:7775


# Certificates, Encryption

# Allow insecure server connections when using SSL:
curl -k https://fake.fakeapp-0be7676-6.zpc-sandbox.zebra.com/fake/

# Find the expiration date, etc of a cert:
openssl x509 -text -noout -in wildcard.domain.net.crt

# Get the intermediate cert, example:
openssl x509 -text -noout -in wildcard.domain.net.crt | grep "CA Issuers"
wget http://SVRSecure-G3-aia.verisign.com/SVRSecureG3.cer
openssl x509 -inform DER -outform PEM -in SVRSecureG3.cer -out verisign_g3.crt

# Encrypt/decrypt a password with a key:
echo "p@sswd123" > passwd.txt
echo "redgreenblue" | base64 > key.txt
openssl enc -base64 -bf -in passwd.txt -out passwd_encrypted.txt -kfile key.txt
openssl enc -base64 -bf -d -in passwd_encrypted.txt -kfile key.txt  # p@sswd123


# Misc
# List memcached stats on memcached server:
echo stats | nc server1 11211