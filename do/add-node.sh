while [ ! -f token-$4.txt ]; do
  echo -e "\033[1;36mWaiting for first-manager to finish..."
  sleep 1
done
token=$(cat token-$4.txt)
manager_ip=$(cat first-manager-ip.txt)
ssh root@$2 docker swarm join --token $token $manager_ip:2377
