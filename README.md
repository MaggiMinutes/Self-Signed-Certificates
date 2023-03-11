# Self-Signed-Certificates
Shell script to generate RootCA and self-signed certificates with OpenSSL.

**Steps involved to generate RootCA and server certificate:**

1. Generate RootCA private key

2. Generate RootCA certificate

3. Generate server private key

4. Generate CSR for server certificate

5. Generate server certificate and sign using RootCA

**Provide executable permission to the script**

    chmod u+x gen_certificates.sh
