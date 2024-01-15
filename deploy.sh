set -e

if ! [[ $(which docker) && $(docker --version) ]]; then
  echo "Docker is not installed. Please install docker."
fi

if ! [[ $(which unzip) ]]; then
  echo "unzip is not installed. Please install unzip."
fi

# build custom librenms docker image
image_repo='scn-librenms-image'
wget https://github.com/abacef/$image_repo/archive/main.zip
unzip main.zip
rm main.zip
cd $image_repo-main
sudo docker build . -t  scn-librenms
cd ..
rm -r $image_repo-main

# start all docker images
compose_repo='scn-librenms-compose'
wget https://github.com/abacef/$compose_repo/archive/main.zip
unzip main.zip
rm main.zip
sudo docker compose -f $compose_repo-main/compose.yml up -d


