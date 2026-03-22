#import "@preview/ilm:1.4.2": *
#import "@preview/mannot:0.3.1": *

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#show: codly-init
#codly(languages: codly-languages)

#set text(lang: "zh", font: ("New Computer Modern", "Source Han Serif SC"))

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
  raw-text: (custom-font: ("Cascadia Code", "Maple Mono")),
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

= SELinux

Linux 主要有两种权限模型:

- *自主访问控制 (Discretionary Access Control, DAC)*: 是 Linux 和 Windows 的基础权限模型. 访问决策由资源所有者制定的访问控制列表 (Access Control List, ACL) 决定.
- *强制访问控制 (Mandatory Access Control, MAC)*: 通过 Linux 安全模块 (Linux Security Modules, LSM) 提供支持, 如 SELinux 和 AppArmor. 访问决策由系统安全策略强制执行, 不受 DAC 影响.

两种访问控制都基于一个 "规则表", 主要区别在于这个表由谁管理.

另外, 这两种访问控制模型并不是排他的, 在启用 SELinux 时, 系统会先检查是否满足 DAC 条件, 然后再检查是否满足 MAC 条件.

SELinux 是一个 *Linux 安全模块*, 一共有三种模式:

- `enforcing`: 拦截并记录非法访问, 适用于生产环境.
- `permissive`: 只记录非法访问, 适用于调试.
- `disabled`: 不执行任何动作.

其中 `enforcing`/`permissive` 与 `disabled` 模式之间的切换需要重启系统才能生效.#footnote[因为 SELinux 是基于 LSM 的, 而非可以动态加载的 LKM (Loadable Kernel Module).]

- `getenforce`/`setenforce`: 查询/切换当前模式.

  ```sh
  getenforce              # 查询当前模式
  setenforce Enforcing    # 临时切换到 Enforcing 模式
  setenforce Permissive   # 临时切换到 Permissive 模式
  ```

- `chcon` (#strong[Ch]ange #strong[Con]text): 修改文件安全上下文.

  使用 `chcon` 修改文件上下文一般是临时的, 通常应该使用 `semanage` 来永久修改 SELinux 策略.

- `semanage`/`restorecon` (#strong[SE]Linux *Manage*): 管理 SELinux 策略.

  `semanage` 用于编辑 SELinux 的策略, 而 `restorecon` 则根据该策略修改文件的安全上下文.

- `getsebool`/`setsebool` (*Get*\/*Set* #strong[SE]Linux #strong[Bool]ean): 查询/切换 SELinux 策略开关.

  `setsebool` 默认为临时修改, 重启后失效. 使用 `-P` 选项可以永久生效.

- `audit2allow` (*Audit* to *Allow*): 根据审计日志生成允许策略.

= 容器化 (Containerization)

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

#figure(caption: [低级容器运行时性能对比.])[
  #table(
    columns: 4,
    table.header[*名称*][*语言*][*相对性能*#footnote[越高越好, 基准测试数据来源于 youki.]][*备注*],
    [crun], [C], [200%], [Podman 的默认选项],
    [youki], [Rust], [100%], [],
    [runc], [Go], [42%], [Docker 的默认选项],
  )
]

TODO: 需区分低级和高级容器运行时, 因为 K8s 中会涉及高级容器运行时.

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

Kubernetes (K8s) 是一个开源 (Apache-2.0) 的容器编排系统, 即管理容器集群. K8s 将容器当成积木, 用于构建高可扩展和高可靠性的服务.

== 核心概念

- *Node*: 一个虚拟机或者物理机器, 包含一个或多个 Pod.
- #k8s_link("workloads/pods/")[*Pod*]: 最小管理单位, 包含一个或多个容器. 通常, 一个 Pod 只包含一个容器.

  三者间的包含关系如下图所示:
  #figure(
    image("imgs/k8s_hierarchy.svg", width: 80%),
    caption: [K8s 层级示意图.],
  )

- #link("services-networking/gateway/")[*Gateway API*]: 应用层反向代理 API.

  #blockquote[
    #k8s_link("services-networking/ingress/")[Ingress API] 已经被 Gateway API 所取代. Ingress Controller 是具体的 Ingress API 实现, 比如 #link("https://github.com/kubernetes/ingress-nginx")[Ingress NGINX Controller] (已停止维护).
  ]

- #k8s_link("services-networking/service/")[*Service*]: 为 Pod 提供固定的 IP 地址或域名 #footnote[因此, K8s 内部需要维护一个 DNS 服务器.], 以及负载均衡功能. 正常情况下, Pod 销毁并重新创建时 IP 地址会发生变化. Service 可以为集群内部的网络服务提供稳定的访问口.
- #k8s_link("configuration/configmap/")[*ConfigMap*]: 存储配置数据, 如环境变量和配置文件.
- #k8s_link("configuration/secret/")[*Secret*]: 类似于 ConfigMap, 但专门用于存储机密数据, 如令牌和密钥. 默认不加密.
- #k8s_link("storage/volumes/")[*Volume*]: 持久化容器的数据, 默认生命周期与 Pod 相同, Pod 销毁时卷也会被销毁, 除非使用持久卷.
- #k8s_link("workloads/controllers/deployment/")[*Deployment*].
- #k8s_link("workloads/controllers/statefulset/")[*StatefulSet*].

#figure(caption: [K8s 网络流量示意图])[
  #image("imgs/k8s_traffic.svg")
]

== 架构

K8s 的整体架构如下图所示:

#figure(
  image("imgs/k8s_architecture.svg", width: 80%),
  caption: [K8s 架构示意图.],
)

其中 etcd 是一个供 K8s 内部使用的键值对数据库, 与 Redis 相比, 其完全支持 ACID.

#blockquote[
  *CAP 定理 (CAP theorem)* 指分布式系统不可能同时满足:
  - 一致性 (Consistency)
  - 可用性 (Availability)
  - 分区容错性 (Partition Tolerance)

  etcd 满足 CP, 而 Redis 满足 AP.
]

各组件的具体描述请参见#k8s_link("architecture/")[官方文档].

== 实践

借助 minikube 可以快速搭建一个本地的单节点 K8s 集群:

```ps1
scoop install minikube
minikube start
```

然后再安装 kubectl:

```ps1
scoop install kubectl
```

现在即可使用该 CLI 与 K8s 集群进行交互:

```sh
kubectl create deployment nginx-deployment --image=nginx --replicas=3
# 稍等几秒钟, 待 Pod 启动
kubectl get all
kubectl delete deployment nginx-deployment
```

```sh
kubectl create -f <path/to/config.yml>
kubectl apply -f <path/to/config.yml>
```

此外 Podman 还支持使用下面命令直接应用 K8s 的配置文件:

```sh
podman play kube <path/to/config.yml>
```

这样会启动单个 Pod, 便于本地调试.

下面是一个搭建 K8s 管理界面 #link("https://github.com/portainer/portainer")[Portainer] (CE 版本) 的例子:

```sh
kubectl apply -n portainer -f https://downloads.portainer.io/ce-lts/portainer.yaml
minikube service portainer -n portainer
```

然后点击 `http://127.0.0.1` 开头的链接即可访问 Portainer 的 Web 界面.

如果长时间未访问 Web 界面, 则需要通过下面命令重启 Portainer:

```sh
kubectl rollout restart deployment portainer -n portainer
```

= Ansible

Ansible 是一个开源 (GPL-3.0) 的配置和部署自动化工具. 该工具主要有一下特点:

- *无代理 (Agentless)*: 通过 SSH 协议与远程主机通信, 无需在远程主机上预先安装专用软件.
- *幂等 (Idempotent)*: 多次执行同一 Ansible Playbook 会得到相同的结果, 不会产生副作用.

= 网络 (Networking)

#figure(caption: [OSI 七层模型])[
  #table(
    columns: 3,
    table.header[*层级*][*名称*][*数据单元*],
    [7], [应用层 (Application)], [Data],
    [6], [表示层 (Presentation)], [Data],
    [5], [会话层 (Session)], [Data],
    [4], [传输层 (Transport)], [Segment, Datagram],
    [3], [网络层 (Network)], [Packet],
    [2], [数据链路层 (Data Link)], [Frame],
    [1], [物理层 (Physical)], [Bit, Symbol],
  )
]

实践中 5, 6, 7 层通常被合并为应用层, 并无单独位于 5, 6 层的通用协议.

- SSL 在被 IETF 规范化后称之为 TLS.
- TLS 协商时由客户端提供支持的加密套件列表, 服务器从中选择一个进行通信. 这能确保 Crypto agility.
- Let's Encrypt 使用 ACME 协议自动化 TLS 证书的申请和续期.

= OpenShift

TODO

= TypeScript

#figure(caption: [JavaScript 及其拓展语言关系图])[
  #image("imgs/js_extensions.svg", width: 40%)
]

= React

可以通过下面命令快速创建并运行 React 项目基础模板:

```sh
pnpm create vite <PROJECT_NAME> --template react-compiler-ts --immediate
```

通过下面命令安装 Tailwind CSS:

```sh
pnpm install tailwindcss @tailwindcss/vite
```

修改 `vite.config.ts`:

```diff
--- a/vite.config.ts
+++ b/vite.config.ts
@@ -1,11 +1,13 @@
 import { defineConfig } from 'vite'
 import react, { reactCompilerPreset } from '@vitejs/plugin-react'
 import babel from '@rolldown/plugin-babel'
+import tailwindcss from '@tailwindcss/vite'

 // https://vite.dev/config/
 export default defineConfig({
   plugins: [
     react(),
-    babel({ presets: [reactCompilerPreset()] })
+    babel({ presets: [reactCompilerPreset()] }),
+    tailwindcss()
   ],
 })
```

在 `src/index.css` 的头部添加下面内容:

```css
@import "tailwindcss";
```

最后在 HTML 中添加下面代码即可使用 Tailwind CSS:

```html
<link href="/src/style.css" rel="stylesheet">
```

= 实验

== Lab 1

略.

== Lab 2

```yaml
---
- name: Create directories and scripts
  hosts: all
  tasks:
  - name: Create directories
    file:
      path: "dir_{{ item }}"
      state: directory
    loop: "{{ range(1, 11) | list }}"

  - name: Create scripts
    copy:
      dest: "dir_{{ item }}/hello_{{ item }}.sh"
      content: |
        #!/bin/bash
        echo "Hello from directory {{ item }}"
    loop: "{{ range(1, 11) | list }}"

  - name: Execute scripts
    command: "bash dir_{{ item }}/hello_{{ item }}.sh"
    register: script_output
    loop: "{{ range(1, 11) | list }}"

  - name: Debug output
    debug:
      msg: "{{ item.stdout }}"
    loop: "{{ script_output.results }}"
```

== Lab 3

略.
