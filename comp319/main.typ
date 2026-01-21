#import "@preview/ilm:1.4.2": *

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#show: codly-init
#codly(languages: codly-languages)

#set text(lang: "zh")

#set text(font: ("New Computer Modern", "Source Han Serif SC"))

#show: ilm.with(
  title: "软件工程 II 笔记",
  author: "ShenMian",
  abstract: [
    本文为软件工程 II (COMP319, University of Liverpool) 的课程笔记.
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

*讲师*: #link("https://www.liverpool.ac.uk/people/sebastian-coope")[Mr Sebastian Coope] <#link("mailto:Sebastian.Coope@liverpool.ac.uk")>

== 分数构成

#figure(caption: [分数构成])[
  #table(
    columns: 4,
    table.header[*名称*][*分数*][*类型*][*时间*],
    [OOP 作业], [$20%$], [编程作业], [],
    [Final Exam], [$80%$], [线下简答题], [],
  )
]

以下是对 2014, 2015, 2020, 2021/22, 2023/24 年试卷各知识点分数占比的统计结果:

#figure(caption: [Final Exam 知识点分数占比])[
  #image("imgs/exam_percentage.svg", width: 70%)
]

其中*依赖图与程序切片*与*面向切面编程*仅在较早前的考试中出现.

= 成本估算与项目管理

== 软件危机

这部分讲解了由软件危机导致的事故与故障, 此处略过.

== CHAOS 报告

#link("https://www.csus.edu/indiv/v/velianitis/161/chaosreport.pdf")[Chaos (Comprehensive Human Appraisal for Originating Software) 报告], 是由美国 Standish Group 于 1994 年发布的研究报告, 专注于分析和评估全球IT项目的成功率与失败原因.

该报告将项目分为以下三类:

- *成功 (Successful)*: 按时按预算完成, 所有功能均已实现.
- *受挫 (Challenged)*: 超时/超预算且部分功能未完成.
- *未完成 (Incomplete)*: 项目被取消.

=== 主要成果

#figure(caption: [项目超支原因])[
  #image("imgs/project_overrun_reasons.svg", width: 70%)
]

#figure(caption: [项目成功原因])[
  #image("imgs/project_successful_reasons.svg", width: 70%)
]

#figure(caption: [项目取消/失败原因])[
  #image("imgs/project_incompleted_reasons.svg", width: 70%)
]

=== 批评

#link("https://ieeexplore.ieee.org/document/5232804")[The rise and fall of the Chaos report figures] 对 Chaos 报告提出了以下批评

- *定义片面*: 将项目成功仅定义为成本、时间和功能估算的准确性, 忽略了其他关键成功因素 (如用户满意度、业务价值等).
- *衡量标准失衡*: 其 "估算准确性" 指标过于单向, 未考虑项目实际交付的价值或适应变化的能力, 导致成功率被低估.
- *误导管理实践*: 过度强调估算精确性, 可能扭曲团队的估算行为, 鼓励保守或不切实际的预测, 而非聚焦于交付价值.
- *数据方法论缺陷*: 报告中的统计数据混合了来源不同、估算方法各异的项目, 存在未知偏差, 平均值缺乏可比性和实际意义.

此外, Chaos 报告还存在原始数据未公开等问题.

可以看出, Chaos 报告的评估方式存在明显的缺陷, 实质是在衡量对项目的估算是否 "成功", 而非项目本身.

== Boehm 的不确定性锥

#figure(caption: [不确定性锥])[
  #image("imgs/cone_of_uncertainty.webp", width: 70%)
]

该模型说明对项目预估的准确度 (即预估的 "不确定性") 会随着时间, 在项目的推进下逐渐精确. \
在项目早期做出的精确估算往往是不可靠的, 管理者应接受早期估算的宽泛区间, 并随着项目演进不断修正计划. 它也被广泛用于支持敏捷开发中的渐进式规划和基于反馈的调整.

== 估算质量因子

估算质量因子 (Estimation quality factor, EQF) 用于衡量预估工作量与实际工作量的接近程度, 公式如下:

$ "EQF" = a / (1/n sum_(i=1)^n |e_i - a|) $

其中 $e_i$ 为第 $i$ 个预估值, $a$ 为实际值. \
EQF 值即*实际值除以平均绝对偏差*.

偏差越小, *EQF 值越高, 表示预估越好*. 一般认为 EQF 值大于 10 表示预估效果非常好, 即平均偏差小于 10%.

== 估算偏差

由于 EQF 值使用绝对差进行计算, 无法得出预估值整体被高估还是低估. 因此引入偏差 (Bias), 用于判断具体的偏差比例和*方向*. 其公式为:

$ "Bias" = (macron(e) - a) / a $

其中 $e$ 为估计值, $macron(e)$ 为估计值的平均值, $a$ 为实际值.

*偏差值越小, 表示预估越好. 偏差值为负表示低估, 为正表示高估.*

- *高 EQF + 低偏差*: 估算准确, 管理成熟.
- *低 EQF + 正偏差*: 估算不准确但保守, 资源浪费.
- *低 EQF + 负偏差*: 估算不准确且乐观.

== 练习

#blockquote[
  Project 1
  - Time to complete 20 weeks
  - Estimates 4,4,4,6,7,22,21
]

$
  "EQF" & = frac(1, frac((frac(|20 - 4|, 20) times 3 + frac(|20 - 6|, 20) + frac(|20 - 7|, 20) + frac(|20 - 22|, 20) + frac(|20 - 21|, 20)), 7)) \
  & = frac(1, frac(2.4 + 0.7 + 0.65 + 0.1 + 0.05, 7)) \
  & = frac(7, 3.9) approx 1.79
$

$
  "Bias" & = frac(frac(4 times 3 + 6 + 7 + 22 + 21, 7) - 20, 20) \
         & = frac(frac(68, 7) - 20, 20) \
         & approx frac(9.71 - 20, 20) \
         & approx frac(-10.28, 20) approx -0.51
$

#blockquote[
  Project 2
  - Time to complete 22 weeks
  - Estimates 18,19,23,24,22
]

$
  "EQF" & = frac(1, frac((frac(|22 - 18|, 22) + frac(|22 - 19|, 22) + frac(|22 - 23|, 22) + frac(|22 - 24|, 22) + frac(|22 - 22|, 22)), 5)) \
  & approx frac(1, frac(0.18 + 0.14 + 0.045 + 0.09, 5)) \
  & = frac(5, 0.455) approx 10.99
$

$
  "Bias" & = frac(frac(18 + 19 + 23 + 24 + 22, 5) - 22, 22) \
         & = frac(21.2 - 22, 22) \
         & = frac(-0.8, 22) approx -0.036
$

#blockquote[
  Project 3
  - Time to complete 50 weeks
  - Estimates 49,50,50,50,50
]

$
  "EQF" & = frac(1, frac((frac(|50 - 49|, 50) + frac(|50 - 50|, 50) times 4), 5)) \
        & = frac(1, frac(0.02, 5)) \
        & = frac(5, 0.02) = 250
$

$
  "Bias" & = frac(frac(49 + 50 times 4, 5) - 50, 50) \
         & = frac(49.8 - 50, 50) \
         & = frac(-0.2, 50) approx -0.004
$

== 影响估算的因素

- *估算时间点*: 越早估算, 越不准确. 即前面提及的 Boehm 的不确定性锥.
- *管理层压力*: 可能导致低估.
- *开发者经验*: 经验不足可能导致过于乐观或悲观.
- *设计详细程度*: 设计越详细, 估算越准确.
- *需求质量*: 需求越清晰, 估算越准确.

= 面向对象设计模式

== 基本原则

=== DRY 原则

即不要重复自己 (Don't Repeat Yourself, DRY). 避免*冗余* (包括代码和文档等知识), 但允许缓存.

不应该在不同的数据表中存储重复的内容, 以及不应该存储可通过已有数据推导得出的结果. \
比如不应该存储银行账户的总余额, 而是仅存储账户交易信息, 在每次查询时通过聚合函数计算得到总余额.

=== SOLID 原则

- *单一职责 (Single Responsibility Principle, SRP)*: 与函数类似, 每个类应该只做一件事.

  - 增加内聚性, 减少耦合性, 使其更容易被复用.
  - 更易于理解和测试.

- *开闭原则 (Open-Closed Principle, OCP)*: 即对拓展开放, 对修改关闭 (open for extension, but closed for modification). 应该通过添加新的代码来扩充原有的功能, 而非修改已有的代码.

  一个简单的例子就是通过提供接口, 方便后期添加拓展. \
  滥用该设计模式会导致代码复杂度非必要的增加.

- *里氏代换原则 (Liskov Substitution Principle, LSP)*: 子类应该能替代父类的使用.

  继承关系在逻辑上是 "is-a" 关系.

  比如 `Duck` 是一个 `Animal`, 因此 `Duck` 可以继承自 `Animal`, 也可以被当作 `Animal` 使用. 反之则会违反 LSP.

- *接口隔离原则 (Interface Segregation Principle, ISP)*: 即接口也需要遵循单一职责, 可以帮助实现依赖最小化.

  例如许多现代打印机同时具有打印和扫描功能, 应该将其拆分为两个接口, 即 `Printer` 和 `Scanner`.

- *依赖倒置原则 (Dependency Inversion Principle, DIP)*: 高层模块不应该依赖于低层模块, 二者都应该依赖于抽象. 即上下层交互应该依赖一个抽象的中间层, 而非直接依赖一个具体的实现.

  其中*依赖注入 (Dependency Injection, DI)* 是实现该原则的主要手段.

== 设计模式

=== 责任链模式 (Chain of Responsibility)

该模式属于*行为设计模式 (Behavioral Design Pattern)*.

一个良好的例子是 UI 控件处理输入事件. UI 组件通常相互嵌套, 因此需要递归的处理输入事件, 直到找到一个处理该事件的组件.

```
+------------------------+
| Window                 |
|   +----------------+   |
|   | Panel          |   |
|   |   +--------+   |   |
|   |   | Button |   |   |
|   |   +--------+   |   |
|   |                |   |
|   +----------------+   |
|                        |
+------------------------+
```

当输入事件作用在 `Button` 组件上, 则按钮会先尝试处理, 比如:

- *鼠标单击事件*: `Button` 组件处理该事件, 响应按钮点击操作.
- *鼠标滚轮滚动事件*:
  + `Button` 组件忽略该事件, 并交给父组件 `Panel` 处理.
  + `Panel` 组件接收事件后处理该事件, 尝试滚动面板.

#blockquote[
  在 Godot 4 中, UI 节点 (`Control`) 包含 #link("https://docs.godotengine.org/en/4.5/classes/class_control.html#enum-control-mousefilter")[`mouse_filter` 属性], 取值范围为 [`Stop`, `Ignore (Propagate Up)`, `Pass`]:

  - `Stop`: 处理该事件, 然后抛弃.
  - `Pass`: 尝试处理该事件, 如果事件未被标记 "已处理", 则继续向上传递.
  - `Ignore`: 鼠标事件不会作用在该组件上.

  前两个选项其本质就是处理鼠标事件的方式, 不同组件该属性的默认值不一样, 例如:

  - `Container`: `mouse_filter` 默认值为 #link("https://github.com/godotengine/godot/blob/16a11ac88b3aedac2825ec570910f34fb40f3f98/scene/gui/container.cpp#L233")[`Pass`].
  - `Button`: `mouse_filter` 默认值为 #link("https://github.com/godotengine/godot/blob/16a11ac88b3aedac2825ec570910f34fb40f3f98/scene/gui/button.cpp#L871")[`Stop`].
  - `Label`: `mouse_filter` 默认值为 #link("https://github.com/godotengine/godot/blob/16a11ac88b3aedac2825ec570910f34fb40f3f98/scene/gui/label.cpp#L1430")[`Ignore`].
]

另一种常见的处理事件的模式为*发布/订阅模式 (Publish/Subscribe Pattern)*, 这种模式通常订阅者收到事件的顺序不确定, 且所有订阅者都会收到事件. \
而责任链模式有着明确的处理顺序, 并且最终只由其中一个处理者处理或最终抛弃.

=== 工厂模式 (Factory)

该模式属于*创建型设计模式 (Creational Design Pattern)*.

本质上就是封装根据条件创新对象实例的代码.

```java
class ShapeFactory {
    public Shape getShape(String shapeType) {
        if (shapeType.equalsIgnoreCase("CIRCLE")) {
            return new Circle();
        } else if (shapeType.equalsIgnoreCase("SQUARE")) {
            return new Square();
        }
        return null;
    }
}
```

=== 单例模式 (Singleton)

单例是指仅支持创建*单个实例*的类.

==== Eager Initialization

也被称之为 "饿汉式".

```java
public class Singleton {
    private static final Singleton INSTANCE = new Singleton();

    // 私有构造函数, 防止外部实例化
    private Singleton() {}

    public static Singleton getInstance() {
        return INSTANCE;
    }
}
```

==== Lazy Initialization

也被称之为 "懒汉式".

可以使用*双检锁 (Double-checked locking)* 来确保高效且并发安全:

```java
public class Singleton {
    // 防止指令重排序
    private static volatile Singleton instance;

    private Singleton() {} // 私有构造函数

    public static Singleton getInstance() {
        // 第一重检查: 避免不必要的同步块开销
        if (instance == null) {
            synchronized (Singleton.class) {
                // 第二重检查: 确保只有一个线程创建实例
                if (instance == null) {
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
}
```

去除第一重 `if` 检查代码依然能保持正确, 担心会有性能损失. 这是因为 `synchronized` 会带来性能开销. 如果已经实例化, 则不必再使用 `synchronized`, 从而避免不必要的开销.

=== MVC

- *#emph[M]odel*: Stores application data and handles the business logic.
- *#emph[V]iew*: Provides the graphical user interface.
- *#emph[C]ontroller*: Handles user input and updates the model.

类似于前后端分离, 其中前端为 VC, 后端为 M.

*优点*:

- *代码安全 (Code security)*: 修改前端不需要触碰后端的业务逻辑.
- *多界面 (Multiple interfaces)*: 更容易支持多个用户界面. 开发者可以分为两组, 同时开发前后端.

=== 备忘录模式 (Memento)

#figure(caption: [备忘录模式类图])[
  #image("imgs/memento.svg", width: 50%)
]

=== 构造器模式 (Builder)

```java
public class Builder {
    private String name;
    private int age;
    private String email;

    public Builder setName(String name) {
        this.name = name;
        return this; // 返回当前对象以支持链式调用 (Method Chaining)
    }

    public Builder setAge(int age) {
        this.age = age;
        return this;
    }

    public Builder setEmail(String email) {
        this.email = email;
        return this;
    }

    // 构建方法 (Build Method)
    public User build() {
        return new User(this.name, this.age, this.email);
    }
}
```

=== 外观模式 (Facade)

该模式属于*结构型设计模式 (Structural Design Pattern)*.

= 敏捷软件开发 (Agile Software Development)

== 4 个价值观

+ *个体和互动*高于流程和工具.
+ *工作的软件*高于详尽的文档.
+ *客户合作*高于合同谈判.
+ *响应变化*高于遵循计划.

== 12 条原则

下面是#link("https://agilemanifesto.org/iso/zhchs/manifesto.html")[敏捷软件开发宣言 (Manifesto for Agile Software Development)] 中提出的 12 条原则:

+ *客户满意*: 通过尽早并持续交付有价值的软件来满足客户.
+ *拥抱变更*: 即使在开发后期也欢迎需求变更, 利用变更为客户创造竞争优势.
+ *频繁交付*: 经常交付可工作的软件, 周期从几周到几个月不等, 倾向于较短的周期.
+ *业务协作*: 业务人员与开发者必须在项目全过程中每天紧密合作.
+ *激励个体*: 围绕被激励的个体构建项目, 提供所需环境、支持和信任.
+ *高效沟通*: 在团队内部, 面对面交谈是传递信息最高效的方式.
+ *进度度量*: 可工作的软件是衡量进度的首要标准.
+ *可持续节奏*: 敏捷过程倡导可持续开发, 保持稳定的步调.
+ *技术卓越*: 持续追求技术卓越和良好设计以增强敏捷性.
+ *简洁为本*: 最大化不做的工作量的艺术至关重要.
+ *自组织团队*: 最好的架构、需求和设计出自自组织团队.
+ *持续改进*: 团队定期反思如何更高效, 并相应调整自身行为.

其中得到广泛应用的有两个框架:

- *极限编程*: 侧重工程.
- *Scrum*: 侧重管理.

这两个框架通常会结合使用, 有各自的侧重点.

== 极限编程 (Extreme Programming)

- *重构 (Refactoring)*.
- *测试驱动开发 (Test-Driven Development, TDD)*.
- *持续集成 (Continuous Integration, CI)*.
- *结对编程 (Pair Programming)*: Two developers collaborating on one task, one coding (the driver), one reviewing (the reviewer).
  - 开发时间增加 15%, 但缺陷减少 15%.
  - 适合复杂任务.
  - 新手收益大于专家.

== Scrum

Scrum 依次来源于英式橄榄球运动. 侧重于项目管理, 角色分工和工作流.

=== 项目管理 (Artifacts)

- *产品待积压表 (Product Backlog)*: 一个按优先级排序的清单, 类似于 GitHub Projects.
- *迭代积压列表 (Sprint Backlog)*: 从产品积压列表中挑选, 准备在当前 Sprint 中完成的集合.

=== 主要角色 (Roles)

- *Scrum 主管 (Scrum Master)*: 促进 Scrum 过程.
- *产品负责人 (Product Owner)*: 确定产品的方向和愿景, 编写用户故事 (User Stories), 排出优先级, 然后放入产品待积压表.
- *开发团队 (Development Team)*: 一个跨职能的小团队, 5-9 人.

=== 工作流 (Events)

- *迭代 (The Sprint)*: 周期通常为两周 (1-4 周), 具有不可变性.
- *每日站会 (Daily Scrum)*: 15 分钟短会, 讨论内容为:
  - 昨天做了什么?
  - 今天打算做什么?
  - 是否遇到了任何困难?
- *规划扑克 (Planning Poker)*: 主要目的是避免*锚定效应 (anchoring)*, 比如: 考虑当一个人先说出 "我觉得要 5 天" 时, 其他人可能会倾向于报出相近数字的心理倾向.

  流程大致为每个成员独立做出估测, 然后同时亮出, 最后估算最低和最高的成员和团队进行讨论. 重复上述流程, 直到团队达成一致.

= 并发与 Actor 模型

== 死锁类型与线程饥饿

#blockquote[
  *死锁 (Deadlock)*
  - 顾客 A 拿着餐刀, 等顾客 B 的餐叉.
  - 顾客 B 拿着餐叉, 等顾客 A 的餐刀.
  - *结果*: 两人僵持不动, 都不吃饭.

  *活锁 (Livelock)*
  - 顾客 A 端着餐盘走向座位, 看到顾客 B 走来, 礼貌让路.
  - 顾客 B 也同时让路, 结果两人又面对面.
  - 不断重复这个"让路舞蹈".
  - *结果*: 两人都很忙 (在移动), 但都没坐到座位上.

  *线程饥饿 (Thread starvation)*
  - VIP 顾客 (高优先级)不断被服务员优先服务.
  - 普通顾客 (低优先级)举手呼叫服务员, 但服务员总是先服务 VIP.
  - *结果*: 普通顾客一直举手等待, 但得不到服务.

  --- DeepSeek V3.2
]

如果账户 1 给账户 2 转账的同时, 账户 2 也给账户 1 转账, 就可能发生*死锁*:
+ `transferMoney(account1, account2)`: 先锁定账户 1, 再锁定账户 2.
+ `transferMoney(account2, account1)`: 先锁定账户 2, 再锁定账户 1.

一个简单的解决方法是确保加锁的*顺序相同*. 比如从小到大, 二者都先锁定账户 1, 再锁定账户 2.

== Actor 模型

#figure(caption: [Actor 并发模型优点])[
  #image("imgs/actor.svg", width: 90%)
]

=== 特点

- *数据隔离 (Data Ownership)*.
- *异步消息传递 (Message Passing)*.
- *消息不可变性 (Immutability)*.

=== 优点

- *消除死锁 (Eliminates Deadlock)*: 由于 Actor 之间不共享数据, 而是通过消息通信 (即数据都是独占的), 不需要使用锁, 因此不可能发生死锁或活锁.
- *防止线程饥饿 (Avoids Starvation)*.
- *高扩展性 (Scalability)*.
- *位置透明性 (Location Transparency)*: 由于 Actor 之间通过消息通信, 因此无需关心目标 Actor 是在本地还是远程机器上.
- *支持迁移 (Mobility)*: Actor 可以在不同系统间移动, 以实现负载均衡.

= 面向切面编程

面向切面编程 (Aspect-oriented programming, AOP) 本质上是代码注入, 目标是将横切关注点 (cross-cutting concerns) 与主业务逻辑解耦, 类似于 Vulkan 的 Layers.
- 与传统的装饰器模式相比, AOP 支持更高级的功能.
- 与传统框架相比, 以 AspectJ 框架为例, 声明 Aspect 有专用语法, 并写在专门的文件. 需要通过 `ajc` 编译器将其编译为可用的 class 文件.

#figure(caption: [AOP 术语表])[
  #table(
    columns: 3,
    table.header[*中文*][*英文*][*描述*],
    [切面], [Aspect], [模块化的横切关注点 (cross-cutting concern), 例如日志. 通常包含通知 (Advice) 和切点 (Pointcut).],
    [连接点], [Join Point], [程序执行过程中可被拦截的特定点, 如方法调用、异常抛出等.],
    [切点], [Pointcut], [用于匹配连接点的表达式, 决定通知在哪些连接点生效.],
    [通知], [Advice], [在特定连接点执行的动作, 分为前置 (before), 后置 (after), 环绕 (around) 等类型.],
    [织入], [Weaving], [将切面与目标类结合生成代理或修改字节码的过程, 可在编译时、类加载时或运行时进行.],
    [目标对象], [Target Object], [被一个或多个切面通知的对象, 也称被代理对象.],
  )
]

面向切面编程可以解决以下问题:
- *代码冗余 (Code cloning/duplication)*: 相同代码多次出现.
- *散射 (Scattering)*: 由于关注点散布在整个软件中, 很难确定它具体在哪里被执行.
- *纠缠 (Tangling)*: 代码与它所属的主要业务逻辑代码以及其他横切关注点交织在一起. 有时一个横切关注点甚至会调用另一个 (如安全性功能调用日志记录).

= 依赖图与程序切片

== 依赖图

*依赖图 (Dependency graph)* 是代码中依赖关系的一种表现形式.

```java
var a = 1; // A
var b = 2; // B
var c = a + b; // C
```

上面代码的数据依赖图如下:

#figure(caption: [数据依赖图])[
  #image("imgs/dependency_graph.svg", width: 20%)
]

*程序依赖图 (Program Dependence Graph, PDG)* 是生成切片的中间步骤, 包含:
- *数据依赖图 (Data dependence graph, DDG)*.
- *控制依赖图 (Control dependence graph, CDG)*.

== 程序切片

程序切片 (Program slicing) 主要有两种类型:

- *后向切片 (Backward slicing)*: 看变量*之前*在哪里*被写入*.
- *前向切片 (Forward slicing)*: 看变量*后续*在哪里*被读取*.

= 考试

== 高频 (出现 4 次)

#table(
  columns: 4,
  table.header[*考点*][*考查形式*][*核心要求*][*考察年份*],

  [*开闭原则*],
  [理论定义 + Java实现],
  [类应对修改关闭而对扩展开放. 通过 Java 接口定义、`final` 关键字锁定方法以及创建 `protected` 方法作为扩展点来实现.],
  [2014-2015, 2020-2021, 2021-2022, 2023-2024],

  [*估算质量因子*],
  [公式计算 + 结果分析],
  [熟练计算 EQF (实际值除以预测偏差). 高 EQF (如 >10) 表示估算准确.],
  [2014-2015, 2015-2016, 2020-2021, 2023-2024],

  [*估算偏差*],
  [计算 + 原因分析],
  [计算偏差, 0 偏差表示高估与低估抵消. 管理压力可能导致低估 (负偏差), 而管理层为规避进度超支风险可能导致高估 (正偏差).],
  [2014-2015, 2015-2016, 2020-2021, 2023-2024],
)

== 中高频 (出现 3 次)

#table(
  columns: 4,
  table.header[*考点*][*考查形式*][*核心要求*][*考察年份*],
  [*Actor 并发模型*],
  [理论定义 + 实战建模],
  [掌握 Actor、消息、邮箱等核心要素. 理解该模型如何通过避免共享内存来解决并发问题. 能将账户建模为 Actor, 通过发送消息执行扣款或加款操作.],
  [2014-2015, 2015-2016, 2020-2021],

  [*敏捷软件开发*],
  [流程描述 + 问题解决],
  [熟悉 Scrum (Sprint、积压工作、每日会议)  和 XP (用户故事、测试驱动开发 TDD、迭代发布). 2022 年卷要求利用敏捷实践 (如结对编程解决代码质量问题、用户故事解决需求优先级问题) 处理 5 个真实的工程挑战.],
  [2014-2015, 2021-2022, 2023-2024],

  [*工厂模式*], [代码设计题], [工厂类根据运行时参数决定创建哪个具体对象实例.], [2020-2021, 2021-2022, 2023-2024],

  [*结对编程*],
  [文献引用分析],
  [引用 Williams 等 (2000) 的数据：开发时间增加 15%, 但缺陷减少 15%. 引用 Lui (2006) 结论：对复杂任务有效, 新手比专家获益更多.],
  [2014-2015, 2021-2022, 2023-2024],
)

== 稳定考点 (出现 2 次)

#table(
  columns: 4,
  table.header[*考点*][*考查形式*][*核心要求*][*考察年份*],

  [*双检锁*],
  [代码实现 + 性能解释],
  [能写出线程安全的 `Singleton` 实现. 理解 `synchronized` 虽安全但运行缓慢, 通过先检查后加锁 (lock hint) 可减少同步开销, 提高性能. 需理解 `volatile` 关键字的作用.],
  [2015-2016, 2023-2024],

  [*MVC 架构模式*],
  [组件职责 + 交互示例],
  [将代码分为模型 (数据与业务逻辑) 、视图 (渲染数据) 和控制器 (解释输入). 核心优势包括支持多界面切换且不影响业务逻辑, 以及允许团队并行开发.],
  [2014-2015, 2023-2024],

  [*责任链模式*],
  [理论 + 代码],
  [多类协作处理请求, 若当前类不处理则传给下一级. 常用于实现日志过滤器或具有不同用户偏好的消息发送链 (Email/SMS/Twitter).],
  [2015-2016, 2020-2021],

  [*外观模式*],
  [架构结构],
  [提供统一接口隐藏子系统的复杂性. 例如通过单例 `SpellChecker` 服务访问复杂的拼写检查逻辑.],
  [2020-2021, 2021-2022],

  [*单例模式实现*],
  [代码实现],
  [支持单实例, 控制自身创建. 核心是 `private` 构造函数 + 静态 `getInstance()` 方法.],
  [2015-2016, 2021-2022],

  [*程序切片技术*],
  [前向/后向计算],
  [利用依赖图构造切片. 后向切片用于调试, 显示所有影响某点的代码；前向切片用于维护, 显示修改某处代码可能产生的影响.],
  [2014-2015, 2015-2016],

  [*不确定性锥*],
  [理论解释],
  [说明估算准确度随生命周期推进而提高. 早期阶段 (如初始定义) 的不确定性最高, 误差范围可达 0.6x 到 1.6x.],
  [2014-2015, 2015-2016],

  [*并发死锁*],
  [场景分析 + 解决],
  [分析多线程以相反顺序锁定资源 (如账户 A 锁 B, 账户 B 锁 A) 导致的死锁. 解决方案是按固定顺序加锁, 例如按账户 ID 升序加锁.],
  [2014-2015, 2015-2016],
)

== 低频考点 (出现 1 次)

#table(
  columns: 4,
  table.header[*考点*][*考查形式*][*核心要求*][*考察年份*],

  [*抽象工厂模式*],
  [理论定义],
  [提供一种创建相关对象家族的方法, 而无需指定具体类. 客户端通过通用接口与工厂交互.],
  [2023-2024],
)

== 术语

#table(
  columns: 2,
  table.header[*中文*][*英文*],
  [内聚], [Cohesion (co-hes-ion)],
  [耦合], [Coupling],
  [封装], [Encapsulating],
  [业务逻辑], [Business logic],
  [具体类], [Concrete class],
  [超支], [Overrun],
  [验收测试], [Acceptance tests],
  [架构], [Architecture],
  [散射 (AOP)], [Scattering],
  [纠缠 (AOP)], [Tangling],
  [可协商 (INVEST)], [Negotiable],
)

= 作业

- 要求使用*工厂模式*, 同时还需遵循 SOLID 原则, 因此应该使用*抽象工厂*, 而非工厂方法或简单工厂模式.
- 尽量将类标记为 `final`.
- 只重载 `protected` 方法.
- 有效性验证, 比如验证 `User` 类 email 属性的有效性.
- 在合适的地方使用 `enum`, 可以避免不必要的有效性检查.
- 使用 `interface` 访问具体类.

= 辅导

== Tutorial 1

阅读 #link("https://www.cs.unc.edu/techreports/86-020.pdf")[No Silver Bullet: Essence and Accidents of Software Engineering], 并回答下面问题:

+ Describe the 4 aspects of software development that make it inherently hard to do.

  #blockquote[
    - *复杂性 (Complexity)*: 软件实体通常比同等规模的其他任何人类构造都要复杂, 因为没有任何两个部分是相同的 (至少在语句级别以上). 如果不相同, 我们会将其抽象为子程序. 软件系统的状态数量比计算机硬件多出几个数量级. 这种复杂性是非线性的, 随着规模扩大, 元素之间的交互以非线性方式增加.
    - *一致性 (Conformity)*: 软件工程师必须面对大量任意的复杂性, 这些复杂性并非由自然法则决定, 而是由必须遵循的人类制度和系统接口强加的. 这些接口随时间、随人而异, 导致软件必须不断调整以保持一致, 这种复杂性无法通过重新设计软件本身来简化.
    - *可变性 (Changeability)*: 软件实体面临着不断的变更压力. 成功的软件之所以会改变, 一是因为用户发现它有用并试图将其应用到原始领域之外的新场景；二是因为软件必须适应新的硬件载体 (如新磁盘、新显示器). 软件被认为是 "纯粹的思维产物" (pure thought-stuff), 因此人们觉得它比物理建筑或汽车更容易修改.
    - *不可见性 (Invisibility)*: 软件是不可见的, 且无法可视化 (unvisualizable). 与建筑平面图或机械图纸不同, 软件没有一种现成的几何表示法能捕捉其全貌. 当我们试图绘制软件结构图时, 通常会得到多个相互重叠的有向图 (如控制流、数据流、依赖关系等), 且这些图往往不是平面的. 这种不可见性严重阻碍了设计过程中的思维和团队间的沟通.

    --- Gemini 3 Pro
  ]

+ What is difference between accidental and inherent complexity in software development?

  #blockquote[
    - *本质复杂性 (Essence/Inherent Complexity)*: 指软件本身固有的困难, 即构建由抽象概念 (数据集合、关系、算法、函数调用) 组成的复杂概念结构. *无论使用何种表示方法, 这些概念设计的困难都是无法消除的*. Brooks 认为构建软件最难的部分正是这一概念结构的规范、设计和测试.
    - *附带复杂性 (Accidental Complexity)*: 指那些目前伴随着软件生产过程但并非其本质所固有的困难. 这主要包括将抽象概念表示为编程语言, 以及在空间和速度限制下将其映射到机器语言上的工作.

    *核心区别*: 过去软件生产力的巨大提升主要来自于消除了 "附带复杂性" (例如硬件限制、笨拙的语言等). 然而, Brooks 认为除非附带任务占据了超过 9/10 的工作量, 否则即使把所有附带复杂性降为零, 也无法获得数量级的生产力提升, 因为 "本质复杂性" 依然存在.

    --- Gemini 3 Pro
  ]

+ Brooks put forward and analysed proposals for a number of so called "silver bullets" to cure the software development crisis, namely: \
  Better HLL, Object Oriented programming, Artificial intelligence,
  Expert systems, "Automatic" programming, Graphical programming,
  Program verification, Environment and tools \
  Describe in your own works, Brooks's critique of these approaches.

  #blockquote[
    - *更强的高级语言 (Better High-Level Languages)*: 高级语言通过通过消除机器层面的复杂性 (如寄存器/位操作), 将程序从大部分附带复杂性中解放出来. 但这方面的红利已经基本耗尽, 因为剩下的复杂性主要在概念层面, 语言本身无法进一步简化这些本质思考.
    - *面向对象编程 (Object-Oriented Programming)*: 抽象数据类型和分层类型确实消除了更高层次的附带困难, 允许设计者表达本质设计而无需过多的语法细节. 但它们只能简化设计的*表达*, 无法消除设计本身的本质复杂性.
    - *人工智能 (Artificial Intelligence)*: 对于 AI-1 (解决以前需要人类智能的问题), 一旦人们理解了其工作原理, 就不再将其视为 AI. 对于图像或语音识别等技术, Brooks 认为这对编程实践帮助不大, 因为软件开发的难点在于决定 "想说什么", 而不是 "怎么说" .
    - *专家系统 (Expert Systems)*: 专家系统可以将应用规则与程序逻辑分离. 它们可以作为经验不足的程序员的辅助工具 (如调试建议) . 但其核心难点在于知识获取——找到能清晰表达知识的专家并提炼规则.
    - *"自动" 编程 ("Automatic" Programming)*: 这通常只是更高层级语言的委婉说法. 虽然在排序或微分方程等参数少/解法已知的特定领域有效, 但这很难推广到普通软件系统, 因为大部分系统并不具备这种规整的属性.
    - *图形化编程 (Graphical Programming)*: Brooks 对此持怀疑态度. 他认为流程图是对软件结构的糟糕抽象. 此外, 屏幕像素有限, 无法展示复杂软件的详细图景. 更根本的是, 软件本质上很难可视化, 任何单一维度的图表都无法概括其整体.
    - *程序验证 (Program Verification)*: 验证工作量巨大, 且并未承诺节省劳动. 验证只能证明程序符合规范 (Specification), 但最困难的部分恰恰是制定出完整且一致的规范本身.
    - *环境与工具 (Environment and Tools)*: 虽然集成的数据库系统能帮助管理细节, 但像分层文件系统这样的主要突破已经实现, 未来的收益将是边际递减的.

    --- Gemini 3 Pro
  ]

+ In your own opinion what modern advances in software development have helped to increase software productivity rates since 1986. \
  Hint: Think of the following problem areas: debugging, GUI development,
  software porting, code re-factoring.

  #blockquote[
    - *调试 (Debugging)*:
      - *集成开发环境 (IDE) 的智能化*: 1986 年的调试往往依赖打印语句或内存转储. 现代 IDE 集成了实时语法检查/静态分析和交互式调试器, 能在代码运行前就捕捉到大量逻辑和类型错误, 极大减少了排错时间.
      - *自动化测试框架*: 单元测试的普及使得回归测试自动化, 让开发者敢于修改代码.
    - *GUI 开发 (GUI Development)*:
      - *声明式 UI 框架*: 从早期的像素绘制或手动管理句柄, 发展到现代的声明式框架 (如 Web 领域的 React/Vue, 或移动端的 SwiftUI/Flutter). 开发者只需描述 "界面应该是通过什么数据呈现的", 而将状态同步的繁琐工作 (附带复杂性) 交给框架处理.
      - *标准组件库*: 丰富的开源组件库让开发者不再需要从零构建按钮或滚动条, 实现了 Brooks 提倡的 "购买 (复用) 而非构建" 的理念.
    - *软件移植 (Software Porting)*:
      - *虚拟机与容器化*: Java JVM 的普及实现了 "一次编写, 到处运行" 的承诺. 随后 Docker 和 Kubernetes 的出现, 进一步将操作系统环境标准化. 这解决了 Brooks 提到的 "一致性" 难题中的环境适配问题, 使得软件可以轻易跨平台部署.
      - *Web 标准*: 浏览器成为了最通用的跨平台运行环境, 极大降低了为不同操作系统开发客户端的成本.
    - *代码重构 (Code Refactoring)*:
      - *自动化重构工具*: 在 1986 年, 修改一个变量名可能需要全项目搜索替换, 风险极高. 现代工具利用抽象语法树 (AST) 技术, 可以安全地自动执行重命名/提取方法/移动类等操作. 这改变了开发模式, 使得 "先写出代码再持续优化" 成为标准流程, 降低了维护遗留系统的难度.

    --- Gemini 3 Pro
  ]

阅读 #link("https://ieeexplore.ieee.org/document/5232804")[The rise and fall of the Chaos report figures], 并回答下面问题:

+ What were the main criticisms of the original Chaos report?

  #blockquote[
    针对 Chaos 报告及其定义的主要批评包括以下四个方面:
    - *误导性的定义 (Misleading Definitions)*: Standish Group 对 "成功" 项目的定义完全基于成本、时间和功能的预估准确性 (estimation accuracy). 它忽略了项目的背景, 例如实用性 (usefulness)、利润 (profit) 和用户满意度 (user satisfaction).
    - *片面性 (One-sided)*: 定义是片面的, 因为它们忽略了成本和时间的 "未超支" (underruns) 以及功能的 "超额交付" (overruns), 只关注单方向的偏差.
    - *扭曲预估实践 (Pervert the estimation practice)*: 这种定义会导致反而降低预估准确性. 为了达到 Standish 的成功标准, 项目经理可能会过度预估预算和时间 (即增加安全边际), 这被称为 "扭曲 (perverting)" 了预估质量.
    - *数据无意义 (Meaningless figures)*: 由于不同组织存在不同的预估偏差 (biases), 且 Standish 的统计方法未考虑这些偏差, 因此聚合后的数据是不可靠且无意义的.

    --- Gemini 3 Pro
  ]

+ What is the meaning of the term f/a and how does it relate to project failure or success when looking at project time taken and also functionality delivered.

  #blockquote[
    TODO

    --- Gemini 3 Pro
  ]

+ The paper uses a plot of forecast against actual ratios, plotted for many projects

  #blockquote[
    TODO

    --- Gemini 3 Pro
  ]

+ For a particular organisation. Why was this done, what could it indicate about the organisations ability when performing project forecasting.

  #blockquote[
    TODO

    --- Gemini 3 Pro
  ]

+ Find out what is EQF, how it is measured and what does it indicate?

  #blockquote[
    EQF 代表*预估质量因子 (Estimation quality factor)*, 是由 Tom DeMarco 在 1982 年提出的指标. \
    *测量方式*: 略. \
    *表明内容*: 它表明预估的质量. EQF 值越高, 预估的质量越高. 它反映了预估值与实际值之间的平均偏差程度.

    --- Gemini 3 Pro
  ]

+ What would an EQF of 2, 5 or 10 indicate? Try and find supporting evidence.

  #blockquote[
    *EQF 为 2/5/10*: 表明时间加权的预估值与实际值平均偏差分别为 *50%/20%/10%*.

    --- Gemini 3 Pro
  ]

+ Why did the report refer to the Chaos report as  "one sided"  in its reporting?

  #blockquote[
    Chaos 报告被称为 "片面" , 是因为其衡量标准*忽略了成本和时间的 "未超支" (underruns) 以及功能的 "超额交付" (overruns)*. \
    它只惩罚单一方向的偏差 (如成本超支), 而不惩罚另一方向的偏差 (如成本高估导致的预算剩余). 这种定义导致即使是预估非常准确、仅有微小偏差的项目也可能被归类为 "受挑战", 或者导致为了满足 "成功" 定义而故意过度预估 (Padding) 的行为被视为正面结果.

    --- Gemini 3 Pro
  ]

