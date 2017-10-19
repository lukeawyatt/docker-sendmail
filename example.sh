# BUILD THE REPO INTO A DOCKER IMAGE
echo "Building sendmail image..."
docker build --pull=true --tag=meatspace/sendmail .
echo;

# STOP AN EXISTING CONTAINER IF IT EXISTS
echo "Stopping existing container if it exists..."
docker stop sendmail
echo;

# REMOVE AN EXISTING CONTAINER IF IT EXISTS
echo "Removing existing container if it exists..."
docker rm sendmail
echo;

# RUN THE SENDMAIL CONTAINER
echo "Running the container interactively..."
docker run --tty \
	--publish=25:25 \
	--publish=587:587 \
	--restart=unless-stopped \
	--detach=true \
	--name=sendmail \
	meatspace/sendmail -n "gibson" -r 10.10
echo;
