openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -keyout config/local.key \
  -out config/local.crt \
  -subj "/CN=*.local" \
  -addext "subjectAltName=DNS:.local,IP:127.0.0.1"
