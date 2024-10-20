if ! command -v docker > /dev/null; then
  echo "Docker is not installed. Please install docker."
  exit 1
fi

if ! command -v unzip > /dev/null; then
  echo "unzip is not installed. Please install it"
  exit 1
fi

if ! docker compose > /dev/null; then
  echo "docker compose not installed. Please install the docker compose plugin"
  exit 1
fi