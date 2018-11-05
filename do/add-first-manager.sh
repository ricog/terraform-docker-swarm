sh ./register-node.sh $1 $2 $3 manager
echo "$3" > first-manager-ip.txt

ssh -A root@$2 docker swarm join-token -q worker > token-worker.txt
ssh -A root@$2 docker swarm join-token -q manager > token-manager.txt
