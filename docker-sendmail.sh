#!/bin/bash

echo "Initializing default variables..."
HOST="SET"
echo;

echo "Parsing arguments..."
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
	-h|--help)
    echo "Azure File Storage Mounting"
	echo "---------------------------"
	echo "Syntax docker-sendmail.sh -h <hostname>"
	echo;
	exit 0
    ;;
    -n|--host_name)
    HOST="$2"
    shift # past argument
    shift # past value
    ;;
esac
done

echo HOST is set to "${HOST}"
echo;

echo "Bail out if any of the required arguments were skipped..."
if [ "$HOST" == "SET" ]; then
	echo "One or more parameters were not set properly..."
	echo "Exiting script..."
	exit 1
fi
echo;

echo "Adding hostname to hosts file..."
HOSTCONTENT=$(sed -e "s/^127.0.0.1.*$/127.0.0.1\tlocalhost\t$HOST/g" /etc/hosts)
echo "$HOSTCONTENT" > /etc/hosts
echo;

echo "Pre-configuring SENDMAIL..."
sendmailconfig <<< $'y\ny\ny\n'
echo;
