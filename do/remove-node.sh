ssh root@$2 docker swarm leave
ssh-keygen -q -R $2

sed -i '' "/$1/d" ./$4s.txt
sed -i '' "/$1/d" ./$4s-private.txt
