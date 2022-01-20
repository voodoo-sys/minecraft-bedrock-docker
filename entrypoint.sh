#!/bin/bash

cd /srv/minecraft-bedrock

## ================================================================================================================================================================
## environmental variables
## ================================================================================================================================================================

if [[ ! -z ${SERVER_PROPERTIES} ]]; then
    echo "[Entrypoint][Info] Processing SERVER_PROPERTIES."
    IFS1=$IFS; IFS="|";
    for sProperty in ${SERVER_PROPERTIES}; do
        spVariable="${sProperty%%=*}"
            echo "[Entrypoint][Info] Processing property \"${spVariable}\"."
            spLine=$(cat ./server.properties 2>/dev/null | grep -e "^${spVariable}=" 2>/dev/null)
            if [[ ! -z ${spLine} ]]; then
                echo "[Entrypoint][Info] Property line found in server.properties - replacing."
                sed -i "s|${spVariable}=.*|${sProperty}|g" ./server.properties
            else
                echo "[Entrypoint][Info] Property line not found in server.properties - appending."
                echo "" >> ./server.properties
                echo "${sProperty}" >> ./server.properties
            fi
    done
    IFS=$IFS1
fi

wlUserTemplate='{"ignoresPlayerLimit":false,"name":"%s"}'
##wlUserTemplate='{"bucketname":"%s","objectname":"%s","targetlocation":"%s"}\n'
printf "$JSON_FMT" "$BUCKET_NAME" "$OBJECT_NAME" "$TARGET_LOCATION"

if [[ ! -z ${WHITELIST} ]]; then
    echo "[Entrypoint][Info] Processing WHITELIST."
    echo -n "[" > ./whitelist.json
    wlUserList=""
    IFS1=$IFS; IFS="|";
    for sUser in ${WHITELIST}; do
        echo "[Entrypoint][Info] Adding ${sUser} to whitelist.json."
        if [[ -z ${wlUserList} ]]; then
           wlUserList=$(printf "${wlUserTemplate}" "${sUser}")
        else
           wlUserList="${wlUserList},$(printf "${wlUserTemplate}" "${sUser}")"
        fi
        ##printf "${wlUserTemplate}" "${sUser}" >> ./whitelist.json
    done
    IFS=$IFS1
    echo -n "${wlUserList}" >> ./whitelist.json
    echo -n "]" >> ./whitelist.json
fi

## ================================================================================================================================================================
## main
## ================================================================================================================================================================

export LD_LIBRARY_PATH=.
./bedrock_server
