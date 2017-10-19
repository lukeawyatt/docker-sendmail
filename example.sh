# BUILD THE REPO INTO A DOCKER IMAGE
docker build --pull=true --tag=meatspace/sendmail .
echo;

# STOP AN EXISTING CONTAINER IF IT EXISTS
docker stop sendmail
echo;

# REMOVE AN EXISTING CONTAINER IF IT EXISTS
docker rm sendmail
echo;

# RUN THE SENDMAIL CONTAINER
docker run -it --rm --name=sendmail meatspace/sendmail -h "gibson"
echo;
