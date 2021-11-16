# CKA - Cluster enviroment

I'm studying for the CKA exam and need a k8s cluster to practice, so why not take advantage of this need and improve my skills with other tools like Terraform and git?

The goal is to provide a simple setup of four Ubuntu VMs ready to be used as K8S clusters. You can use this to create these VMs on AWS or in a local KVM host.

<br />

# Usage


**AWS**

Use the ssh-keygen command to create you own key pair, use the name "k8s-cka.key" for the private key:
```bash
$ cd aws
$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ubuntu/.ssh/id_rsa): ./k8s-cka.key
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in ./k8s-cka.key
Your public key has been saved in ./k8s-cka.key.pub
```

Run the following commands to initialize terraform and create everything:
```bash
$ terraform init
$ terraform plan
$ terraform apply
```

<br />

**KVM**

Use the ssh-keygen command to create you own key pair, use the name "k8s-cka.key.pub" for the private key:
```bash
$ cd kvm
$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ubuntu/.ssh/id_rsa): ./k8s-cka.key
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in ./k8s-cka.key
Your public key has been saved in ./k8s-cka.key.pub
```

<br />

Copy the content of the "k8s-cka.key" file to "ssh_authorized_keys" (line 62) inside the file "kvm/k8s-cka.yaml" 

<br />

Download the latest Ubuntu Image:
```bash
./download-image.py
```

Run the following commands to initialize terraform and create everything:
```bash
terraform init
terraform plan
terraform apply
```

You might face a "Permission Denied" issue. The workaround is setting `security_driver = "none"` in `/etc/libvirt/qemu.conf` but followed by `sudo systemctl restart libvirtd`. More details [here](https://github.com/dmacvicar/terraform-provider-libvirt/issues/546#issuecomment-840127487).

<br />
<br />

# Setting up Kubernetes cluster

Initialize the K8s cluster by running `kubeadm` on the first node and set up kubectl access:
```bash
sudo kubeadm init --pod-network-cidr 192.168.0.0/16

mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Verify if the cluster is working:
```bash
kubectl version
```

Install the Calico network add-on:
```bash
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

Check the calico-related kube-system Pods to verify that everything is running:
```bash
kubectl get pods -n kube-system
```
    
Get the join command:
```bash
kubeadm token create --print-join-command
```

Copy the join command from the control plane node and run it on each worker node as root: 
```bash
sudo kubeadm join ...
```

On the control plane node, verify all nodes in your cluster are running and Ready:
```bash
kubectl get nodes
```


# References

 * [kubic-terraform-kvm] (https://github.com/kubic-project/kubic-terraform-kvm)
