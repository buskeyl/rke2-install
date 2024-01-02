# rke2-install

#### First lets make sure rke2 isnt there 
```bash
rke2-uninstall.sh
```

#### Make sure required repos are available 

````bash
subscription-manager repos  --enable=rhel-7-server-extras-rpms
````


#### Lets get the scripts and everything on the vms. On each node run the following command 
```bash
git clone https://github.com/brooksphilip/cdf2-rke2-install.git
```

#### lets make it executable 
```bash 
chmod +x first_master_script.sh
chmod +x other_master_script.sh
chmod +x install_rancher.sh
```

#### Lets generate a token 
```bash 
rke2_token=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 32; echo)
```

#### Next lets get the first master set up. cd into the cloned git dir
```bash
./first_master_script.sh $rke2_token
```

#### before we go to the other nodes we need to get the token
```bash 
echo $rke2_token
```

#### Next lets set up the other nodes. Go to the other nodes. 
```bash 
other_master_script.sh <IP_or_fqdn_of_first_master> <token_from_above>
```

#### after that you should be able to go back to the first node and run the following and see the nodes in the cluster
```bash
kubectl get nodes
```

#Rancher install 

lets first make the script executable. 
```bash 
chmox +x install_rancher.sh
```

take note of all the cert paths. you will need a concatonated ca chain pem file if you are using a private CA. All these files need to be present on the machine you are running the script. 

Install Rancher 

```bash
./install_rancher.sh
```
