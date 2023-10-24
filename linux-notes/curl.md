# Curl

#### Headers, Response Status Codes

```shell script
# Fetch the headers only:
curl -I www.redhat.com

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
```

#### Credentials

```shell script
curl -u 'admin:p@55W0rd' server1:8080/solr/admin/health

curl -H ‘Authorization: Basic YWRtaW46cEA1NVcwcmQ=’ server1:8080/solr/admin/health

printf "GET /solr/admin/health HTTP/1.1\r\nAuthorization: Basic YWRtaW46cEA1NVcwcmQ=\r\nHOST: \
localhost\r\nConnection: Close\r\nUser-Agent: netcat\r\n\r\n" | nc server1 8080
```

#### SSL

```shell script
# Allow insecure server connections when using SSL:
curl -k https://fake.fakeapp-0be7676-6.fakedomain.com/fake/
```

#### Misc

```shell script
# Connect to a specific node:
curl -H 'HOST: ordersummary-dev.esri.com' server1.domain.com:7775
```
