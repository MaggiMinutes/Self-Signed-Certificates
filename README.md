# Self-Signed-Certificates + RootCA
Shell script to generate RootCA and self-signed certificates with OpenSSL.

**Create separate folder for all certificates**

      mkdir -p /etc/certs/ && cd /etc/certs/
    
**Provide executable permission to the script**
    
      chmod u+x gen_certificates.sh
    
**Execute the script to generate Self-Signed-Certificates with CA**
    
      ./gen_certificates.sh
