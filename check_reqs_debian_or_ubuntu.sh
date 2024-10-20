if ! [[ $(which docker) && $(docker --version) ]]; then
  echo "Docker is not installed. Please install docker."
  exit 1
fi

if ! [[ $(which unzip) ]]; then
  echo "unzip is not installed. Please install it"
  exit 1
fi

docker compose version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "docker compose not installed. Please install the docker compose plugin"
  exit 1
fi