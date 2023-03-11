#!/bin/bash

PATH="/etc/certs"
SERVER_KEY="$PATH/server.key"
SERVER_CSR="$PATH/server.csr"
SERVER_CRT="$PATH/server.crt"
CA_KEY="$PATH/ca.key"
CA_CRT="$PATH/cacert.pem"
CA_EXTFILE="$PATH/ca_cert.cnf"
SERVER_EXT="$PATH/server_ext.cnf"
SERVER_CONF="$PATH/server_cert.cnf"
OPENSSL_CMD="/usr/bin/openssl"
COMMON_NAME="$1"

function generate_root_ca {

    ## generate rootCA private key
    echo "Generating RootCA private key"
    if [[ ! -f $CA_KEY ]];then
       $OPENSSL_CMD genrsa -out $CA_KEY 4096 2>/dev/null
       [[ $? -ne 0 ]] && echo "ERROR: Failed to generate $CA_KEY" && exit 1
    else
       echo "$CA_KEY seems to be already generated, skipping the generation of RootCA certificate"
       return 0
    fi

    ## generate rootCA certificate
    echo "Generating RootCA certificate"
    $OPENSSL_CMD req -new -x509 -days 3650 -config $CA_EXTFILE -key $CA_KEY -out $CA_CRT 2>/dev/null
    [[ $? -ne 0 ]] && echo "ERROR: Failed to generate $CA_CRT" && exit 1

    ## read the certificate
    echo "Verify RootCA certificate"
    $OPENSSL_CMD  x509 -noout -text -in $CA_CRT >/dev/null 2>&1
    [[ $? -ne 0 ]] && echo "ERROR: Failed to read $CA_CRT" && exit 1
}

function generate_server_certificate {

    echo "Generating server private key"
    $OPENSSL_CMD genrsa -out $SERVER_KEY 4096 2>/dev/null
    [[ $? -ne 0 ]] && echo "ERROR: Failed to generate $SERVER_KEY" && exit 1

    echo "Generating certificate signing request for server"
    $OPENSSL_CMD req -new -key $SERVER_KEY -out $SERVER_CSR -config $SERVER_CONF 2>/dev/null
    [[ $? -ne 0 ]] && echo "ERROR: Failed to generate $SERVER_CSR" && exit 1

    echo "Generating RootCA signed server certificate"
    $OPENSSL_CMD x509 -req -in $SERVER_CSR -CA $CA_CRT -CAkey $CA_KEY -out $SERVER_CRT -CAcreateserial -days 3650 -sha512 -extfile $SERVER_EXT 2>/dev/null
    [[ $? -ne 0 ]] && echo "ERROR: Failed to generate $SERVER_CRT" && exit 1

    echo "Verifying the server certificate against RootCA"
    $OPENSSL_CMD verify -CAfile $CA_CRT $SERVER_CRT >/dev/null 2>&1
     [[ $? -ne 0 ]] && echo "ERROR: Failed to verify $SERVER_CRT against $CA_CRT" && exit 1

}

# MAIN
generate_root_ca
generate_server_certificate
