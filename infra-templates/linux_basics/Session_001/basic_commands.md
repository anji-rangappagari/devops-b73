ls 
ls -l
ls -A
ls -lA
ls -ltra

cat (cat -n /etc/passwd)
cd
cp -r
mv
rm
rm -r
mv 

head -n 7 
tail -n 9
grep   (grep login /etc/passwd)
awk   awk F : '{print $1,$2}'

sed -i 's|nologin|yeslogin|' /etc/passwd

-- -
vi
find 
curl
tar/unzip
pipes

--
ps -ef
kill
sudo 
yum
systemctl start,stop,enable,restart.deamon-reload
useradd  <user name>

File Ownership

chown
chmod

Owner(u)
group(g)
other(o)

Read (r) , write(w) execute(x)
rw-rw-r 
rw(owner)  rw(group) r--(others)

sudo chmod ugo-rwx sample.txt

ip a ( finding the ipaddress)

sudo yum install net-tools
sudo netstat -lntp