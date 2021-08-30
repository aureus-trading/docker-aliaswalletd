aliaswalletd config tuning
======================

You can use environment variables to customize config ([see docker run environment options](https://docs.docker.com/engine/reference/run/#/env-environment-variables)):

        docker run -v alias-data:/alias --name=aliaswalletd-node -d \
            -p 37347:37347 \
            -p 127.0.0.1:36657:36657 \
            -e DISABLEWALLET=1 \
            -e PRINTTOCONSOLE=1 \
            -e RPCUSER=mysecretrpcuser \
            -e RPCPASSWORD=mysecretrpcpassword \
            aliascash/docker-aliaswalletd

Or you can use your very own config file like that:

        docker run -v alias-data:/alias --name=aliaswalletd-node -d \
            -p 37347:37347 \
            -p 127.0.0.1:36657:36657 \
            -v /etc/myalias.conf:/alias/.aliaswallet/alias.conf \
            aliascash/docker-aliaswalletd

## MAINNET vs. TESTNET
If you want to use the image with TESTNET, just add this option to the cmdline:

```
-e TESTNET=true
```
