#!/bin/bash
# macintosh.sh - Macintosh Classic disk builder
# Puny BuildTools, (c) 2024 Stefan Vogt

#read config file 
source config.sh

echo -e "\nmacintosh.sh 2.0 - Macintosh Classic disk builder"
echo -e "Puny BuildTools, (c) 2024 Stefan Vogt\n"

#story check / arrangement
if ! [ -f ${STORY}.z${ZVERSION} ] ; then
    echo -e "Story file '${STORY}.z${ZVERSION}' not found. Operation aborted.\n"
    exit 1;
fi 

#cleanup 
if [ -f ${STORY}_mac.dsk ] ; then
    rm ${STORY}_mac.dsk
fi

#copy resources
cp ~./ClassicMac_MaxZip.dsk ../${ARTIFACT_DIR}/
mv ${ARTIFACT_DIR}/ClassicMac_MaxZip.dsk ${ARTIFACT_DIR}/${STORY}_mac.dsk

#prepare story 
cp ${ARTIFACT_DIR}/${STORY}.z${ZVERSION} ${ARTIFACT_DIR}/game.story

#place story on Macintosh 800k disk image
hmount ${ARTIFACT_DIR}/{STORY}_mac.dsk
hcopy ${ARTIFACT_DIR}/game.story :
hls
humount

#post cleanup
rm ${ARTIFACT_DIR}/game.story

echo -e "\nMacintosh disk image (System 7 or higher) successfully built.\n"