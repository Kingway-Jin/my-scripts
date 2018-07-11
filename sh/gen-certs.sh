#!/bin/sh
PASS="123456"

mkdir -p certs
cd certs

openssl genrsa -aes256 -passout pass:$PASS -out ca-key.pem 2048
cat ca-key.pem

# 利用密钥签名并生成 CSR：
openssl req -new -key ca-key.pem -out ca.csr -subj "/C=cn/ST=gd/L=gz/O=iam/OU=jetty/CN=ca" -passin pass:$PASS 
cat ca.csr

# 利用密钥签名并生成证书：
openssl x509 -req -days 365 -sha256 -extensions v3_ca -signkey ca-key.pem -in ca.csr -out ca.crt -passin pass:$PASS 
cat ca.crt

# 生成服务器/客户端密钥和证书：
openssl genrsa -aes256 -passout pass:$PASS -out server-key.pem 2048
openssl req -new -key server-key.pem -out server.csr -subj "/C=cn/ST=gd/L=gz/O=iam/OU=jetty/CN=localhost" -passin pass:$PASS 
openssl x509 -req -days 365 -sha256 -extensions v3_req -CA ca.crt -CAkey ca-key.pem -CAcreateserial -CAserial ca.srl -in server.csr -out server.crt -passin pass:$PASS 

openssl genrsa -aes256 -passout pass:$PASS -out client-key.pem 2048
openssl req -new -key client-key.pem -out client.csr -subj "/C=cn/ST=gd/L=gz/O=iam/OU=jetty/CN=client" -passin pass:$PASS 
openssl x509 -req -days 365 -sha256 -extensions v3_req -CA ca.crt -CAkey ca-key.pem -CAcreateserial -CAserial ca.srl -in client.csr -out client.crt -passin pass:$PASS 

# 将密钥和证书转换成 p12 格式：
openssl pkcs12 -export -clcerts -name server -inkey server-key.pem -in server.crt -out server.p12 -passout pass:$PASS -passin pass:$PASS 
openssl pkcs12 -export -clcerts -name client -inkey client-key.pem -in client.crt -out client.p12 -passout pass:$PASS -passin pass:$PASS 

# 导入证书到 jks (trust store)中：
echo -e $PASS\\n$PASS\\nyes | keytool -importcert -trustcacerts -alias ca -file ca.crt -keystore trust.jks

# 导入服务器证书到 jks (key store)中：
echo -e $PASS\\n$PASS\\n$PASS | keytool -importkeystore -srckeystore server.p12 -srcstoretype PKCS12 -destkeystore server.jks

# 导入客户端证书到 jks (key store)中：
echo -e $PASS\\n$PASS\\n$PASS | keytool -importkeystore -srckeystore client.p12 -srcstoretype PKCS12 -destkeystore client.jks
