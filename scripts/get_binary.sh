#!/bin/bash

# 打印info信息
print_i(){
	echo -e "\033[32m** $(date +"%Y-%m-%d %H:%M:%S") $@ **\033[0m"
}

# 打印error信息
print_e(){
	echo -e "\033[31m** $(date +"%Y-%m-%d %H:%M:%S") $@ **\033[0m"	
}


etcd_download(){
	
	[[ -d /opt/soft/etcd-${ETCD_VERSION} ]] || mkdir -p /opt/soft/etcd-${ETCD_VERSION}
	if [[ -f /opt/soft/etcd-${ETCD_VERSION}/etcd && -f /opt/soft/etcd-${ETCD_VERSION}/etcdctl ]];then
		print_i "etcd 文件存在"
		exit 0
	fi
	print_i "开始下载 etcd"
	docker pull tcd-amd64:$ETCD_VERSION
	docker run --rm -d --name etcd registry.cn-hangzhou.aliyuncs.com/google_containers/etcd-amd64:$ETCD_VERSION sleep 10
	docker cp etcd:/usr/local/bin/etcd /opt/soft/etcd-${ETCD_VERSION}/
	docker cp etcd:/usr/local/bin/etcdctl /opt/soft/etcd-${ETCD_VERSION}/
	print_i "etcd 下载完成"
}

kubenetes_download(){
	[[ -d /opt/soft/kubernetes-${K8S_VERSION} ]] || mkdir -p /opt/soft/kubernetes-${K8S_VERSION}
	if [[ -f /opt/soft/kubernetes-${K8S_VERSION}/kubernetes-${K8S_VERSION}.tgz ]];then
		print_i "kubernetes 文件存在"
		exit 0
	fi
	print_i "开始下载 kubernetes ${K8S_VERSION}"
	docker pull registry.cn-hangzhou.aliyuncs.com/ops-infra/kubernetes-binary:${K8S_VERSION}
	docker run --rm -d --name k8s-binary registry.cn-hangzhou.aliyuncs.com/ops-infra/kubernetes-binary:${K8S_VERSION} sleep 15
	docker cp k8s-binary:/opt/kubernetes-${K8S_VERSION}.tgz /opt/soft/kubernetes-${K8S_VERSION}/
	print_i "kubernetes ${K8S_VERSION} 下载完成"
}

all_download(){
	etcd_download
	kubenetes_download
}

if [ "${#@}" -eq 1 ];then
    if [ "$1" != 'all' ];then
        $1_download
    else
        all_download
    fi
else
    echo you must choose a type to download
    exit 0
fi

