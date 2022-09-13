group=azure-load-balancer-introduction
az group create -g $group -l japaneast
username=adminuser
password='SecretPassword123!@#'

az network vnet create \
  -n vm-vnet \
  -g $group \
  -l japaneast \
  --address-prefixes '192.168.0.0/16' \
  --subnet-name subnet \
  --subnet-prefixes '192.168.1.0/24'
  
az vm availability-set create \
  -n vm-as \
  -l japaneast \
  -g $group

for NUM in 1
do
  az vm create \
    -n bastion-0$NUM \
    -g $group \
    -l japaneast \
    --size Standard_B1s \
    --image UbuntuLTS \
    --admin-username $username \
    --generate-ssh-keys \
    --vnet-name vm-vnet \
    --subnet subnet \
    --public-ip-address-allocation dynamic \
    --availability-set vm-as \
    --nsg vm-nsg
done

for NUM in 1
do
  az vm open-port -g $group --name bastion-0$NUM --port 22
done




