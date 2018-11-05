sed -i '' "/$1/d" ./managers.txt
sed -i '' "/$1/d" ./managers-private.txt
rm token-worker.txt
rm token-manager.txt
rm first-manager-ip.txt

ssh-keygen -q -R $2
