for i in `cat cluster`; do
ssh -t -i ./security.pem centos@$i $* 
done

