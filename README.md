# Lectures

University lecture notes written in Typst.

## 课程

| 代码      | 英文名                                       | 中文名                 |
|-----------|----------------------------------------------|------------------------|
| `18.404J` | Theory of Computation                        | 计算理论               |
| `COMP304` | Knowledge Representation & Reasoning         | 知识表示与推理         |
| `COMP329` | Autonomous Mobile Robotics                   | 自主移动机器人         |
| `COMP319` | Software Engineering II                      | 软件工程 II            |
| `COMP315` | Cloud Computing For E-Commerce               | 电子商务云计算         |
| `COMP342` | Advanced Topics In Computer Game Development | 计算机游戏开发高级专题 |
| `COMP343` | Computer Forensics                           | 计算机取证             |

## 构建

首先, 需要安装下面依赖项:

- [typst](https://typst.app/open-source/#download).
- [mermaid-cli](https://github.com/mermaid-js/mermaid-cli#installation).
- [inkscape](https://inkscape.org/release/).

其中 mermaid-cli 和 inkscape 用于生成 Mermaid 图.

然后执行脚本[^cargo-script], 生成 Mermaid 图:

```sh
cargo +nightly -Zscript mmd_to_svg.rs
```

[^cargo-script]: 目前 [cargo-script](https://doc.rust-lang.org/nightly/cargo/reference/unstable.html#script) 仍属于实验特性, 因此需要依赖 nightly 版本的 Rust 工具链.

最终, 通过下面命令编译 Typst 文档:

```sh
typst compile --font-path fonts 18.404j/main.typ
```

## 许可协议

该系列文章均采用 [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) 许可协议进行授权.

部分图片来源于教材, 版权归原作者所有. 为尊重知识产权并恪守学术诚信, 课程作业相关内容不予公开.
