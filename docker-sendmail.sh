#!/bin/bash

echo "Initializing default variables..."
HOST="SET"
RELAYCONTENT=""
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
	-r|--relay)
    RELAY="$2"
	echo "Whitelisting relay: $RELAY"
	RELAYCONTENT="${RELAYCONTENT}\nConnect:$RELAY\t\tRELAY"
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

echo "Default configuration prep..."
if [ -e /etc/mail/access.original ]
then
    cp /etc/mail/access.original /etc/mail/access
else
    cp /etc/mail/access /etc/mail/access.original
fi

if [ -e /etc/mail/sendmail.mc.original ]
then
    cp /etc/mail/sendmail.mc.original /etc/mail/sendmail.mc
else
    cp /etc/mail/sendmail.mc /etc/mail/sendmail.mc.original
fi
echo;

echo "Adding hostname to hosts file..."
HOSTCONTENT=$(sed -e "s/^127.0.0.1.*$/127.0.0.1\tlocalhost\t$HOST/g" /etc/hosts)
echo "$HOSTCONTENT" > /etc/hosts
echo;

echo "Pre-configuring SENDMAIL..."
sendmailconfig <<< $'y\ny\ny\n'
echo;

echo "Adding relay configuration..."
echo -e $RELAYCONTENT >> /etc/mail/access
echo;

echo "Opening the listening IPs..."
NEWCONFIG=$(sed -e "s/Addr=127.0.0.1/Addr=0.0.0.0/g" /etc/mail/sendmail.mc)
echo "$NEWCONFIG" > /etc/mail/sendmail.mc
m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf
service sendmail stop
service sendmail start

echo "Persisting container..."
tail -f /dev/null
echo;
