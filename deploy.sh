if grep -q "Ubuntu\|Debian" /etc/os-release; then
  echo "Running on Ubuntu or Debian"
  source deploy_debian_or_ubuntu.sh
elif grep -q "Alpine Linux" /etc/os-release; then
  echo "Running on Alpine Linux"
  source deploy_alpine.sh
else
  echo "Not running on Ubuntu or Debian. Not sure how to install"
  exit 1;
fi

