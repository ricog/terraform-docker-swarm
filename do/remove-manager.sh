ssh root@$2 docker node demote $1

sh ./remove-node.sh $1 $2 $3 manager
