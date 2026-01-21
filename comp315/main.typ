#import "@preview/ilm:1.4.2": *
#import "@preview/mannot:0.3.1": *

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#show: codly-init
#codly(languages: codly-languages)

#set text(lang: "zh")

#set text(font: ("New Computer Modern", "Source Han Serif SC"))

#show: ilm.with(
  title: "电子商务云计算笔记",
  author: "ShenMian",
  abstract: [
    本文为电子商务云计算 (#link("https://tulip.liv.ac.uk/mods/student/cm_COMP315_202526.htm")[COMP315], University of Liverpool) 的课程笔记.
  ],
  preface: [
    #align(center + horizon)[
      本文采用 #link("https://creativecommons.org/licenses/by-nc-sa/4.0/")[CC BY-NC-SA 4.0] 许可协议进行授权.
      #image("imgs/cc-by-nc-sa.svg", width: 15%)
    ]
  ],
  figure-index: (enabled: true, title: "图片索引"),
  table-index: (enabled: false, title: "表格索引"),
  listing-index: (enabled: true, title: "代码索引"),
  raw-text: (custom-font: ("Cascadia Code", "Source Han Serif SC")),
)

#show figure.where(kind: raw): set block(breakable: true)

= 简介

== 课程简介

*讲师*: Dr Dominic Anthony Richards <#link("mailto:Dominic.Anthony.Richards@liverpool.ac.uk")>

- Infrastructure as a Service (IaaS).
- Platform as a Service (PaaS).
- Software as a Service (SaaS).

== 分数构成

#figure(caption: [分数构成])[
  #table(
    columns: 4,
    table.header[*名称*][*分数*][*类型*][*时间*],
    [CA1], [10%], [作业], [],
    [CA2], [10%], [作业], [],
    [Final Exam], [80%], [], [],
  )
]

== 学习路线图

#figure(caption: [并行化的学习路线图])[
  #image("imgs/roadmap.svg")
]

权限模型:

- *自主访问控制 (Discretionary Access Control, DAC)*: 是 Linux 和 Windows 的基础权限模型.
- *强制访问控制 (Mandatory Access Control, MAC)*: 通过 Linux 安全模块 (Linux Security Modules, LSM) 提供支持, 如 SELinux 和 AppArmor.

= SELinux

SELinux 是一个 Linux 安全模块 (Linux Security Modules, LSM).

SELinux 一共有三种模式:

- *Enforcing*.
- *Permissive*.
- *Disabled*.

= Containerization

TODO: Namespaces, Cgroups

https://www.kernel.org/doc/html/v6.18/admin-guide/cgroup-v2.html

== Docker

Docker 采取开放核心模式.

Docker 有三个核心概念:

- *Dockerfile*: 文本指令脚本, 用于定义镜像.
- *Image (镜像)*: 包含创建镜像所需软件的包.
- *Container (容器)*: 通过镜像创建的运行时实例.

这些概念之间的关系如下图所示:

#figure(caption: [Docker 关键概念关系])[
  #image("imgs/docker.svg", width: 70%)
]

== Podman

Podman 是由 Red Hat 推出的 Docker 开源 (Apache-2.0) 替代品.

相比 Docker, Podman 的主要优点有:

- *100% 开源*: Docker Desktop 是纯粹的商业化产品, 与其对应的 Podman Desktop 则是完全开源免费的.
- *无守护进程 (Daemonless)*: 可避免单点故障, 无容器运行时无额外开销.
- *原生 Rootless 支持*:

  一般, 位于 docker 组的用户才能使用 Docker CLI. 但由于运行容器的 dockerd 拥有 root 权限, 导致 docker 组的普通用户可以提权, 实现对任意宿主机任意路径的访问.

在与 Docker 的兼容性方面:

- CLI 用法与 Docker CLI 基本相同.
- Containerfile 是 Dockerfile 的替代品, 100% 兼容其语法.
- 由于 Docker 镜像都遵循 OCI 标准, 所以 Docker 镜像与 Podman 镜像相互兼容.

官方文档甚至推荐直接使用 `alias docker=podman` 来将其作为 Docker 的 drop-in replacement.

== 容器运行时 (Container Runtime)

#figure(caption: [容器运行时性能对比.])[
  #table(
    columns: 4,
    table.header[*名称*][*语言*][*相对性能*#footnote[越高越好, 基准测试数据来源于 youki.]][*备注*],
    [crun], [C], [200%], [Podman 的默认选项],
    [youki], [Rust], [100%], [],
    [runc], [Go], [42%], [Docker 的默认选项],
  )
]

TODO: 需区分低级和高级容器运行时, 因为 K8S 中会涉及高级容器运行时.

== 实践

在 Windows 下, 可以使用下面命令安装并使用 Podman:

```ps1
scoop install podman # 安装 Podman

podman machine init  # 创建 Linux 虚拟机
podman machine start # 启动虚拟机

podman run quay.io/podman/hello

podman rm -a  # 删除所有容器
podman rmi -a # 删除所有镜像
```

= Kubernetes

#let k8s_link(dest, body) = link("https://kubernetes.io/zh-cn/docs/concepts/" + dest, body)

Kubernetes (K8S) 是一个开源 (Apache-2.0) 的容器编排系统, 即管理容器集群. K8S 将容器当成积木, 用于构建高可扩展和高可靠性的服务.

== 核心概念

- *Node*: 一个虚拟机或者物理机器, 包含一个或多个 Pod.
- #k8s_link("workloads/pods/")[*Pod*]: 最小管理单位, 包含一个或多个容器. 通常, 一个 Pod 只包含一个容器.

三者间的包含关系如下图所示:

#figure(
  image("imgs/k8s_hierarchy.svg", width: 80%),
  caption: [K8S 层级示意图.],
)

- #link("services-networking/gateway/")[*Gateway API*]

#blockquote[
  #k8s_link("services-networking/ingress/")[Ingress API] 已经被 Gateway API 所取代. Ingress Controller 是具体的 Ingress API 实现, 比如 #link("https://github.com/kubernetes/ingress-nginx")[Ingress NGINX Controller] (已停止维护).
]
- *Service*.

- *ConfigMap*.
- *Secret*.

- *Volume*.

- #k8s_link("workloads/controllers/deployment/")[*Deployment*].
- #k8s_link("workloads/controllers/statefulset/")[*StatefulSet*].

---

- *Service*: 稳定的网络入口 (内网域名 + 负载均衡).
- *Ingress*: 七层反向代理协议.
  - *七层*: 指位于 ISO 网络模型的第七层 (即应用层), 所以路由规则可以包含应用层协议的内容.
  - *反向代理*: 即网站使用的代理, 为网站后端的服务提供一个统一的接口.
- *ConfigMap* / *Secret*: 配置和密钥管理.
- *Volume*: 持久化存储.

== 架构

K8S 的整体架构如下图所示:

#figure(
  image("imgs/k8s_architecture.svg", width: 80%),
  caption: [K8S 架构示意图.],
)

其中 etcd 是一个供 K8S 内部使用的键值对数据库, 与 Redis 相比, 其完全支持 ACID.

TODO: CAP 定理
- etcd: CP
- redis: AP

各组件的具体描述请参见#k8s_link("architecture/")[官方文档].

== 实践

借助 minikube 可以快速搭建一个本地的单节点 K8S 集群:

```ps1
scoop install minikube
minikube start
```

然后再安装 kubectl:

```ps1
scoop install kubectl
```

现在即可使用该 CLI 与 K8S 集群进行交互:

```ps1
kubectl create deployment nginx-deployment --image=nginx --replicas=3
# 稍等几秒钟, 待 Pod 启动
kubectl get all
kubectl delete deployment nginx-deployment
```

```ps1
kubectl create -f <path/to/config.yml>
kubectl apply -f <path/to/config.yml>
```

此外 Podman 还支持使用下面命令直接应用 K8S 的配置文件:

```
podman play kube <path/to/config.yml>
```

这样会启动单个 Pod, 便于本地调试.

下面是一个搭建 K8S 管理界面 #link("https://github.com/portainer/portainer")[Portainer] (CE 版本) 的例子:

```ps1
kubectl apply -n portainer -f https://downloads.portainer.io/ce-lts/portainer.yaml
minikube service portainer -n portainer
```

然后点击 `http://127.0.0.1` 开头的链接即可访问 Portainer 的 Web 界面.

如果长时间未访问 Web 界面, 则需要通过下面命令重启 Portainer:

```ps1
kubectl rollout restart deployment portainer -n portainer
```

= OpenShift

TODO
