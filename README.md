# Cloudera Manager & CDH Prerequisites Check
launch redhat 8 ec2 instance
image: ami-0619404f9180a28b3

=====update the vms======
sudo yum update -y

======install wget=====

sudo yum install wget -y

=====change the swappiness=====
sudo sysctl -a | grep vm.swappiness 

 sudo su -c 'cat >>/etc/sysctl.conf <<EOL
 'vm.swappiness=1' 
EOL' 

sudo sysctl -p

=====THCP===== (host config portocol)

echo "echo never > /sys/kernel/mm/transparent_hugepage/defrag" | sudo tee -a /etc/rc.d/rc.local
echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" | sudo tee -a /etc/rc.d/rc.local

sudo chmod +x /etc/rc.d/rc.local

cat /sys/kernel/mm/transparent_hugepage/enabled
cat /sys/kernel/mm/transparent_hugepage/defrag

=====diable se-linux=====
sestatus

echo "SELINUX=disabled" | sudo tee /etc/selinux/config

sestatus

====reboot=====

sudo reboot

cat /sys/kernel/mm/transparent_hugepage/enabled
cat /sys/kernel/mm/transparent_hugepage/defrag 

sestatus

=====passwordless login===== (same like hadoop deployment OS)

sudo su -c "touch /home/ec2-user/.ssh/config
 
echo -e 'Host *\n  StrictHostKeyChecking no\n  UserKnownHostsFile=/dev/null' >> /home/ec2-user/.ssh/config"

echo -e  'y\n'| ssh-keygen -t rsa -P "" -f $HOME/.ssh/id_rsa

cat authorized_keys

cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

sudo systemctl restart sshd.service  (exit)

ssh localhost

exit
(image created with kernal tunning and stored at IMA)
make the image and launch 6 more machines

=====mysql=====

wget https://dev.mysql.com/get/mysql80-community-release-el8-8.noarch.rpm

sudo rpm -ivh mysql80-community-release-el8-8.noarch.rpm  (unzip pre-downloaded package)

sudo yum install mysql-devel -y (sql download)

sudo yum install --nogpgcheck mysql-server -y (checked downloaded sql folder)

sudo systemctl start mysqld 

sudo systemctl status mysqld

sudo grep 'temporary password' /var/log/mysqld.log

sudo mysql_secure_installation


provide password like (Cloudage@123)

y, y, n, y, y   (check info from terminal)

mysqladmin -u root -p version   (check detail of isntalled version)

mysql -u root -p (login)

exit;
=========================================================================
send pem key to the main host
using pscp or scp

[On Powershell]

.\pscp.exe -i .\testy.ppk testy.pem clustercmd.sh ec2-user@ip:/home/ec2-user

[On linux]
scp -i cloudera.pem cloudera.pem ec2-user@13.126.28.164:/home/ec2-user

chmod 400 cloudera.pem

sudo vi cluster

put all ip in clutser file (from ec2 istances)

:wq! (press enter)

sudo vi clustercmd.sh (auto for all the machines)

for i in `cat cluster`; do
ssh -t -i ./cloudera.pem ec2-user@$i $* #change the keyname(cloudage.pem)
done

:wq! 
===================================
Install JDBC CONNECTOR On All Host 

sh clustercmd.sh uptime --pretty

sh clustercmd.sh wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.tar.gz

sh clustercmd.sh tar zxvf mysql-connector-java-5.1.46.tar.gz

sh clustercmd.sh sudo mkdir -p /usr/share/java/

sh clustercmd.sh cd mysql-connector-java-5.1.46

sh clustercmd.sh sudo cp /home/ec2-user/mysql-connector-java-5.1.46/mysql-connector-java-5.1.46-bin.jar /usr/share/java/mysql-connector-java.jar
===================================
Create SCM Database

mysql -u root -p

CREATE DATABASE scm DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE USER 'scm'@'%' IDENTIFIED BY 'P@ssw0rd';
GRANT ALL ON scm.* TO 'scm'@'%';
SHOW DATABASES;

exit;

======cm========= 

sudo vi /etc/yum.repos.d/cloudera-manager.repo

[cloudera-manager]
# Packages for Cloudera Manager, Version 5, on RedHat or CentOS 7 x86_64
name=Cloudera Manager
baseurl=https://archive.cloudera.com/cm7/7.4.4/redhat8/yum/
gpgkey =https://archive.cloudera.com/cm7/7.4.4/redhat8/yum/RPM-GPG-KEY-cloudera
gpgcheck = 0

sudo yum clean all

sudo yum makecache

sudo yum install openjdk8 -y

sudo yum install cloudera-manager-server cloudera-manager-daemons -y  (install one bye one)

echo "ssl = 0" | sudo tee -a /etc/my.cnf.d/mysql-server.cnf 

sudo systemctl start mysqld 

sudo systemctl status mysqld 

(change ip address-//machine having database)

sudo /opt/cloudera/cm/schema/scm_prepare_database.sh mysql -h 172.31.38.38 scm scm P@ssw0rd

sudo service cloudera-scm-server start

sudo service cloudera-scm-server status

======web ui====

http://13.233.87.61:7180 (ip of machine (scm server's public ip))

=====login=====

admin
admin

try 60 days

clustername= staging

provide hostnames (by providing the hostname name sure updated the sg all traffic to to same security goup eg all traffic=lauch wizard1)

Repository Location : Cloudera Repository (Requires direct Internet access on all hosts.)

leave as it as everything as we are taking repo from cloudera

Install a Cloudera-provided version of OpenJDK

another user : ec2-user
key :

continue it install automatically agent and then cdh

run network performance and host 

continue

choose service and assign nodes

************Now create the databases*************************88

mysql -u root -p

CREATE DATABASE hive DEFAULT CHARACTER SET utf8;
CREATE USER 'hive'@'%' IDENTIFIED BY 'P@ssw0rd';
GRANT ALL ON hive.* TO 'hive'@'%';

CREATE DATABASE hue DEFAULT CHARACTER SET utf8;
CREATE USER 'hue'@'%' IDENTIFIED BY 'P@ssw0rd';
GRANT ALL ON hue.* TO 'hue'@'%';

CREATE DATABASE rman DEFAULT CHARACTER SET utf8;
CREATE USER 'rman'@'%' IDENTIFIED BY 'P@ssw0rd';
GRANT ALL ON rman.* TO 'rman'@'%';

CREATE DATABASE oozie DEFAULT CHARACTER SET utf8;
CREATE USER 'oozie'@'%' IDENTIFIED BY 'P@ssw0rd';
GRANT ALL ON oozie.* TO 'oozie'@'%';

CREATE DATABASE navs DEFAULT CHARACTER SET utf8;
CREATE USER 'navs'@'%' IDENTIFIED BY 'P@ssw0rd';
GRANT ALL ON navs.* TO 'navs'@'%';

CREATE DATABASE navms DEFAULT CHARACTER SET utf8;
CREATE USER 'navms'@'%' IDENTIFIED BY 'P@ssw0rd';
GRANT ALL ON navms.* TO 'navms'@'%';

CREATE DATABASE actmo DEFAULT CHARACTER SET utf8;
CREATE USER 'actmo'@'%' IDENTIFIED BY 'P@ssw0rd';
GRANT ALL ON actmo.* TO 'actmo'@'%';

CREATE DATABASE ranger DEFAULT CHARACTER SET utf8;
CREATE USER 'ranger'@'%' IDENTIFIED BY 'P@ssw0rd';
GRANT ALL ON ranger.* TO 'ranger'@'%';

CREATE USER 'temp'@'%' IDENTIFIED BY 'P@ssw0rd';

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, PROCESS, REFERENCES, INDEX, ALTER, SHOW DATABASES, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER ON *.* TO 'temp'@'%' WITH GRANT OPTION;

exit

//provide the database and password (On GUI)

test connection

continue.............






