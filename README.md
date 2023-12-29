# rke2-install

#### First lets make sure rke2 isnt there 
```bash
rke2-uninstall.sh
```

#### Lets get the scripts and everything on the vms. On each node run the following command 
```bash
git clone https://github.com/brooksphilip/cdf2-rke2-install.git
```

#### Next lets get the first master set up. cd into the cloned git dir
```bash
./first_master_script.sh <token_make_this_a_longpassword>
```

#### Next lets set up the other 
```bash 
other_master_script.sh <IP_or_fqdn_of_first_master> <token_from_above>
```

#### after that you should be able to go back to the first node and run the following and see the nodes in the cluster
```bash
kubectl get nodes
```