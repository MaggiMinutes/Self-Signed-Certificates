# Self-Signed-Certificates
Shell script to generate RootCA and self-signed certificates with OpenSSL.

Steps involved to generate RootCA and server certificate:

Generate RootCA private key
Generate RootCA certificate
Generate server private key
Generate CSR for server certificate
Generate server certificate and sign using RootCA
