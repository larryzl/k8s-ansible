# Kubernetes 二进制安装 ansible playbook 

## 说明

- 支持一键安装 kubernetes 集群组件,
- 本项目默认 kubernetes 1.15.12 版本 ，如果需修改版本 修改 group_vars/all.yaml : k8s.version
-  inventory/hosts 定义 集群主机角色
- group_vars/all.yaml 定义全局变量,  包括 组件版本、VIP 等
- 支持单独部署新节点

## inventory/hosts 说明

根据hostname字段在 初始化主机时会修改hostname

master / node 中的 nodename 会标记为 在kubernetes 中的node name

etcd 中的nodename 会成为 etcd配置中的节点名称

```ini
[master]
192.168.31.101 hostname=hm-31-101 nodename=192.168.31.101
192.168.31.102 hostname=hm-31-102 nodename=192.168.31.102
192.168.31.103 hostname=hm-31-103 nodename=192.168.31.103

[node]
192.168.31.101
192.168.31.102
192.168.31.103
192.168.31.104 hostname=hm-31-104

[etcd]
192.168.31.101 nodename=etcd-101
192.168.31.102 nodename=etcd-102
192.168.31.103 nodename=etcd-103
```



## group_vars/all.yaml 说明

```yaml
VIP: 集群虚拟IP
INTERFACE_NAME: 虚拟IP绑定的网卡名称

localDNS: 本地DNS服务IP
podCidr: 172.31.0.0/16 Pod网络
clusterIPRange: 10.254.0.0/16  Service网络
clusterDNS: 10.254.0.2  集群内部DNS地址。本项目使用 coredns
serviceNodePortRange: 20000-32767  
```





## 使用方法

```shell
$ git clone https://github.com/larryzl/k8s-ansible.git
$ cd ./k8s-ansible
# 此步骤执行完会重启相应主机
$ ansible-playbook -t setup install.yaml

# 初始化各节点后 安装其他服务
$ ansible-playbook --skip-tags setup install.yaml
```



