SOURCE=$1
TARGET=$2
INTERIM=`basename $SOURCE`

for i in `cat cluster`; do
scp -i ./security.pem $SOURCE centos@$i:~/
ssh -t -i ./security.pem centos@$i "sudo cp $INTERIM $TARGET"
done