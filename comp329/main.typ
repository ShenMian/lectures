#import "@preview/ilm:1.4.2": *
#import "@preview/mannot:0.3.1": *

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#show: codly-init
#codly(languages: codly-languages)

#import "@preview/fletcher:0.5.8" as fletcher: node
#let diagram = fletcher.diagram.with(node-stroke: .1em)
#let state = fletcher.node.with(shape: circle)
#let trans = fletcher.edge.with(marks: "-|>")

#set text(lang: "zh")

#set text(font: ("New Computer Modern", "Source Han Serif SC"))

#show: ilm.with(
  title: "自主移动机器人笔记",
  author: "ShenMian",
  abstract: [
    本文为自主移动机器人 (COMP329, University of Liverpool) 的课程笔记.
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

#set math.mat(delim: "[")

#show figure.where(kind: raw): set block(breakable: true)

= 简介

== 课程简介

*讲师*: #link("https://www.liverpool.ac.uk/people/terry-payne")[Terry R. Payne] <#link("mailto:T.R.Payne@liverpool.ac.uk")>

本课程的部分教学内容基于 University of Freiburg 的 #link("http://ais.informatik.uni-freiburg.de/teaching/ss19/robotics/")[Introduction to Mobile Robotics], 链接内包含课程的讲义和视频录像.

本课程采用自下而上的方法构建知识体系, 并且频繁地依赖高度抽象的数学公式, 因此学习起来难免枯燥.

== 分数构成

#figure(caption: [分数构成])[
  #table(
    columns: 4,
    table.header[*名称*][*分数*][*类型*][*时间*],
    [Engagement Tasks], [10%], [参与任务], [第 2-8 周],
    [Class Tests], [40%], [Canvas 线上测试], [待定],
    [Programming Assignment], [50%], [编程作业 (含报告)], [],
  )
]

= 介绍 (Introduction)

主题是 "Uncertainty in robotics", 强调了:

- *对世界的建模是近似的*.
  - 模型本身就是简化的, 抽象的.
  - 传感器能测量的数据/精度有限, 甚至有可能损坏.
- *算法近似进一步造成了不确定性*: 机器人是实时系统, 需要及时做出响应, 因此并不能总是有充足的时间计算出问题的最优解.

课程目标包括:

- 理解移动机器人和它们的自主控制.
- 关注由现实世界传感器 (sensor) 和执行器 (actuator) 带来的不确定性挑战.

= 智能体与自主系统 (Agents and Autonomous Systems)

== 智能体与机器人 (Agents and Robots)

"Robot" 一词起源: 源自捷克语 #text(lang: "cs")[robota] (意为无偿劳役), 首次出现在 #text(lang: "cs")[Karel Čapek] 1920 年的戏剧《罗素姆万能机器人》中. Isaac Asimov 于 1942 年提出 "robotics".

定义: 通过操控物理世界执行任务的物理智能体. (Russell & Norvig, 2003)

自主机器人能独立做决策, 而非依赖远程操控.
智能体是能在环境中自主行动以实现目标的计算系统.

移动机器人三大问题:

- Where am I? (定位)
- Where am I going? (目标)
- How do I get there? (路径规划)

== 自主性的属性 (Properties of Autonomy)

- Reactivity (反应性): 能感知并及时响应环境变化.
- Proactiveness (目标驱动性): 主动设定并追求目标, 而非仅被动响应.
- Social Ability (社交能力): 能与其他智能体 (或人) 合作/协调/协商.

== 机器人控制架构 (The Robot Control Architecture)

#figure(caption: [智能体控制循环])[
  #image("imgs/agent_control_loop.svg", width: 80%)
]

可以使用下面三个公式表示:

- $italic("see"): E -> italic("Per")$.
- $italic("action"): I -> italic("Ac")$.
- $italic("next"): I times italic("Per") -> I$.

其中 $E$ 表示环境, $italic("Per")$ 表示感知 (percept), $I$ 表示内部状态, $italic("Ac")$ 表示动作.

典型架构:

- *慎思式 (Classical/Deliberative)*: 完整建模, 水平分层, 强调规划.
- *行为式 (Behaviour-Based)*: 无/稀疏建模, 垂直分层, 反应快.
- *混合式 (Hybrid)*: 底层用*行为式* (如避障) , 高层用*慎思式* (如路径规划).

其中混合式架构是当前机器人控制的主流方法.

=== 效用函数 (Utility functions)

要为智能体规定任务做什么, 而非怎么做则需要指定任务规范 (Task Specification). 其中一个方法就是使用*效用函数*:

$ u: E -> RR $

即将环境状态 $E$ 映射到其对应的效用值 (utility value), 也称之为奖励 (reward).

= 智能体与机器人架构 (Agent and Robot Architectures)

== 慎思型架构 (Deliberative Architectures)

== 反应式架构 (Reactive Architectures)

对慎思型架构的批评: 规划与推理耗时, 世界可能在决策期间变化, 导致“计算理性”失效.

- 具身性 (Embodiment): 智能必须依托于物理身体, 与物理世界耦合.
- 情境性 (Situatedness): 行为的意义依赖于当前环境上下文.

其核心思想是智能是涌现 (emergent) 的, 强调具身性 (embodiment) 与情境性 (situatedness).

=== 包容架构 (Subsumption Architecture)

包容架构是一种特定类型的反应式架构.

== 通用控制架构 (General Control Architecture)

= 信念与贝叶斯滤波 (Beliefs and Bayesian Filters)

机器人技术需要处理多种形式的不确定性, 包括:

- *感知不确定性*: 机器人通过传感器感知世界, 但传感器会受到*噪声*和*误差*的影响.
- *执行不确定性*: 机器人通过物理作用力来操控世界, 而这些作用力本质上是非确定性的. 即机器人执行的动作所产生的结果不是完全*可预测的*也不是完全*可重复的*.
- *模型不确定性*: 机器人通过估计环境状态来为世界建模. 由于世界无法被直接观测, 其状态只能通过传感器数据来推断.

为了应对这些挑战, 概率状态估计算法被用来计算关于世界可能状态的*信念分布 (belief distributions)*.

== 概率论 (Probability theory)

这部分内容是推导贝叶斯定理部分相关公式的基础.

=== 概率机器人学

这是一种明确使用概率论来表示不确定性的方法, 其核心思想是:

- *感知 = 状态估计 (Perception = state estimation)*

  将机器人感知到的信息, 转化为关于环境或其自身状态的概率性信念. \
  即把传感器读数 $z$ 变成对状态 $x$ 的信念 $P(x|z)$.

- *行动 = 效用优化 (Action = utility optimisation)*

  基于当前的信念, 寻找能够执行的最佳行动. \
  即在给定信念下选最优的动作, 使期望代价最小/回报最大.

=== 概率三公理

#blockquote[
  略微简化的 Kolmogorov 公理:
  + *非负性*: $P(E) >= 0$.
  + *归一化*: $P(Omega) = 1$, 其中 $Omega$ 表示所有可能事件.
  + *可加性*: $P(E_1 union E_2 union ...) = sum P(E_i)$.
]

下面为课件给出的三条公理:

+ $0 <= P(A) <= 1$
+ $P("True") = 1, P("False") = 0$
+ $P(A or B) = P(A) + P(B) - P(A and B)$

#blockquote[
  下面为 $P("False") = 0$ 的推导过程:

  $
    P("True" union "False") & = P("True") + P("False") \
                  P("True") & = P("True") + P("False") \
                          1 & = 1 + P("False") \
                 P("False") & = 1 - 1 = 0
  $
]

通过上面公理可以推导出补事件公式:

$
  because P(A or B) = P(A) + P(B) - P(A and B) \
  therefore P(A or not A) = P(A) + P(not A) - P(A and not A) \
  because P(A or not A) = P("True") = 1, P(A and not A) = P("False") = 0 \
  therefore 1 = P(A) + P(not A) - 0 \
  therefore P(not A) = 1 - P(A)
$

=== 随机变量 (Random Variables)

==== 离散随机变量 (Discrete Random Variables)

$X$ 代表一个*随机变量*, 属于可数的/有限的集合 ${x_1, x_2, ..., x_n}$. \
传感器测量值/控制输入以及机器人及其环境的状态等量都被建模为随机变量.

函数 $P(X = x_i)$ (简写为 $P(x_i)$) 表示随机变量 $X$ 取值为 $x_i$ 的概率.#footnote[此处函数 $P$ 在 Probabilistic Robotics 一书中的写法为 $p$]
该函数被称之为*概率质量函数 (Probability Mass Function)*.

离散随机变量具有归一性, 即所有可能取值的概率之和恒等于 1: $sum_(x in X) p(x)$.

==== 连续随机变量 (Continuous Random Variables)

$
  P(x in (a, b)) = integral_a^b markhl(p(x), tag: #<H>) markhl(dif x, tag: #<W>, color: #blue)
  #annot(<H>, pos: top, dy: -1em)[高度 (概率密度)]
  #annot(<W>, pos: bottom, dy: 1em)[无穷小的宽度]
$

函数 $p$ 被称之为*概率密度函数 (Probability Density Function)*.

=== 联合概率 (Joint Probability)

函数 $P(X = x "and" Y = y)$ (简写为 $P(x, y)$) 表示 $X = x$ 且 $Y = y$ 同时发生的概率.

假设 $X$ 与 $Y$ 相互*独立 (independent)*, 则:

$ P(x, y) = P(x) P(y) $

=== 条件概率 (Conditional Probability)

在已知 $y$ 发生的前提下, $x$ 发生的概率写作:

$ P(x | y) = frac(P(x, y), P(y)) $ <conditional-to-joint>

$ P(x, y) = P(x | y) P(y) $ <joint-to-conditional>

假设 $x$ 与 $y$ 相互独立, 则:

$ P(x | y) = P(x) $

即 $y$ 是否发生, 不会影响 $x$ 发生的概率.

#blockquote[
  下面为 $x$ 与 $y$ 相互独立的情况下, $P(x | y) = P(x)$ 推导过程:

  $
    P(x | y) & = frac(P(x, y), P(y)) \
    P(x | y) & = frac(P(x) P(y), P(y)) \
    P(x | y) & = P(x)
  $
]

=== 边缘化 (Marginalisation)

从联合概率分布 (Joint Probability Distribution) 中消除 (Summing out) 一个或多个变量, 得到剩余变量的边缘概率分布 (Marginal Probability Distribution).

离散情形:

$ P(x) = sum_(y in Y) P(x, y) $ <marginalization>

连续情形:

$ P(x) = integral_(y in Y) p(x, y) dif y $

=== 全概率定理 (Theorem of Total Probability)

利用条件概率和先验分布表达边缘概率分布.

将 @joint-to-conditional 带入 @marginalization 即可得到全概率定律公式:

离散情形:

$ P(x) = sum_(y in Y) P(x | y) P(y) $ <total-probability>

连续情形:

$ P(x) = integral_(y in Y) p(x | y) p(y) dif y $

== 贝叶斯理论 (Bayes Theorem)

=== 贝叶斯公式 (Bayes Formula)

联合概率满足交换律, 即:

$ P(x, y) = P(y, x) $

结合 @conditional-to-joint 可得:

$ P(x, y) = P(x | y) P(y) = P(y | x) P (x) $

从该公式可以推导出*贝叶斯公式*:

$
  P(markhl(x, tag: #<hypothesis>) | markhl(y, tag: #<evidence>, color: #blue)) = frac(P(y | x) P(x), P(y))
  #annot(<hypothesis>, pos: top, dy: -1em)[假设 (hypothesis)]
  #annot(<evidence>, pos: bottom, dy: 1em)[证据 (evidence)]
$ <bayes-formula>

#blockquote[
  _Introduction to Mobile Robotics_ 给出了 @bayes-formula 的另一种理解方式.

  根据 @total-probability, 可得:

  $ P(y) = sum_x P(y | x) P(x) $

  将其带入 @bayes-formula, 可得:

  $ P(x | y) = frac(P(y | x) P(x), sum_x P(y | x) P(x)) $

  值得注意的一点是, 分母是所有可能的分子值之和. @normalisation 将说明如何利用这一点减少计算量.
]

已知 $P(y | x)$ 和 $P(x)$, 可以通过 @total-probability 得到 $P(y)$:

$ P(y) = sum_x P(y | x) P(x) $ <bayes-formula-denominator>

#blockquote[
  下面为推导过程:

  $
    P(x | y) P(y) & = P(y | x) P(x) \
         P(x | y) & = (P(y | x) P(x)) / P(y)
  $
]

#blockquote[
  课件第 16 页举了一个将 @bayes-formula-denominator 展开的例子. 可以简单的进行展开是因为 $X = {"True", "False"}$ (即服从伯努利分布), 只有两种取值, 因此很容易进行枚举.
]

下面是简化版的公式:

$ "后验概率 (posterior)" = ("似然 (likelihood)" times "先验概率 (prior)") / "证据 (evidence)" $

有以下两种类型的知识:

- *诊断性知识 (Diagnostic)*: 从结果 (症状) 反推原因 (疾病), 即后验概率. 如 $P("open" | z)$.
- *因果性知识 (Causal)*: 从原因推导到结果的知识, 即似然. 如 $P(z | "open")$.

机器人需要诊断性知识来评估自身状态, 但是因果知识更容易获取. 比如多次测量门打开情况下 $z$ 的平均值. \
然后通过贝叶斯公式把因果知识转成诊断知识:

$ P("open" | z) = frac(P(z | "open") P("open"), P(z)) $

这样就可以通过 $z$ 的值推测当前门的开启状态.

=== 归一化 (Normalisation) <normalisation>

该小节将介绍一种*工程上的优化手段*. 因为在实际的机器人代码中, @bayes-formula 将被多次使用, 其中的部分计算结果可以被复用, 以减少计算量.

@bayes-formula 中负责归一化的 $P(y)$ 计算量较大, 可以将其提取出来, 避免反复计算.

由于 @bayes-formula 中的 $P(y)$ 较难计算, 而归一化可以将其替换为一个常数归一化因子 (normaliser) $eta$, 从而简化计算.

设 $eta = P(y)^(-1) = 1 / P(y)$, 则 @bayes-formula 可以写成:

$ P(x | y) = eta P(y | x) P(x) $

#blockquote[
  推导过程如下:

  $
    P(x | y) & = (P(y | x) P(x)) / P(y) \
    P(x | y) & = P(y | x) P(x) P(y)^(-1) \
    P(x | y) & = P(y)^(-1) P(y | x) P(x)
  $

  设 $eta = P(y)^(-1)$
]

将 @bayes-formula-denominator 带入 $eta$ 得到:

$ eta = 1 / (sum_x P(y | x) P(x)) $

机器人需要更新所有状态 $x_i$ 的后验概率, 因此需要循环计算 @bayes-formula. \
可分为下面三个步骤:

+ 先单独计算分子部分:

  $ "numerator"_i = P(y | x_i) P(x_i) $

+ 根据 @total-probability, 将分子部分的值求和得到分母 $P(y)$:

  $ P(y) = sum_i "numerator"_i $

  进而得到 $eta = 1 / P(y)$.

+ 最终将分子部分乘以 $eta$ 得到最终的后验概率:

  $ P(x_i | y) = eta "numerator"_i $

上面方法相比直接多次计算 @bayes-formula 公式有以下优点:

+ 计算 $P(y)$ 复用了计算分子的结果.
+ 避免重复计算 $P(y)$.

虽然优点 1 是该算法的巧妙之处, 但实际的重头戏是优点 2, 因为该方法将算法的复杂度由 $O(n^2)$ 降至 $O(n)$ ($n$ 为 $X$ 的状态空间大小). 实践中 $n$ 的值通常较大, 因此该优化非常有必要.

=== 带有背景知识的贝叶斯规则 (Bayes Rule with Background Knowledge)

$ P(x | y, z) = frac(P(y | x, z) P(x | z), P(y | z)) $

=== 条件独立 (Conditional Independence)

假设给定*条件* $z$ 的情况下, $x$ 与 $y$ 相互*独立*, 则:

- $P(x, y | z) = P(x | z) P(y | z)$
- $P(x | z) = P(x | z, y)$: 在已知背景信息 $z$ 的前提下, 额外知道 $y$ 并不会改变我们对 $x$ 发生概率的判断, 因此可以直接忽略.
- $P(y | z) = P(y | z, x)$: 与上一个公式完全一致.

#blockquote[
  一个生动的例子: 冰淇淋销量与溺水人数

  让我们想象一下有三个变量:

  - $x$ = 城市里每天的溺水人数量
  - $y$ = 城市里每天的冰淇淋销量
  - $z$ = 当天的天气温度

  *第一阶段: 不知道"根本原因" (天气温度 $z$)*

  如果你只看数据, 你会发现一个惊人的关联: 冰淇淋销量高 ($y$ 增加) 的日子, 溺水人数 ($x$) 似乎也多. 反之亦然.

  在这种情况下, 信息 $y$ (冰淇淋销量) 能不能为我们提供关于 $x$ (溺水人数) 的新信息呢？
  能!  如果我告诉你: "今天冰淇淋卖得特别好!" 你会立刻推断: "那今天去游泳的人可能很多, 溺水的风险也更高." 在这里, $y$ 给了你关于 $x$ 的有效信息. 它们是相关的.

  *第二阶段: 知道了"根本原因" (天气温度 $z$)*

  现在, 我告诉你一个确切的背景信息 $z$: "今天的气温是 35 摄氏度."

  在这个已知的前提下, 我再告诉你信息 $y$: "今天冰淇淋卖得特别好." 这句话还能为你提供关于溺水人数 $x$ 的新信息吗？

  不能了!

  为什么呢？因为你已经从 "天气很热" 这个根本原因 $z$ 中, 推断出了所有你需要的信息. 你的思考逻辑会是:

  - "天气 35 度 (z)" -> 这意味着很多人会去游泳 (导致 $x$ 可能增加).
  - "天气 35 度 (z)" -> 这也意味着很多人会买冰淇淋 (导致 $y$ 可能增加).

  当你知道了天气很热 z 之后, "冰淇淋销量高 $y$" 这个消息就变成了一句 "废话". 它只是天气热的另一个必然结果而已, 并没有为 "溺水人数" 这件事增加任何新的、独立的预测价值.

  换句话说, 在已知天气炎热的前提下, 溺水人数的多少, 只跟天气本身有关, 而跟另一群人在商店里买冰淇淋的行为没有直接关系了.  这就是条件独立.

  *回到数学公式*

  现在我们再看这个表述:

  $P(x | z) = P(x | z,y)$

  - $P(x | z)$: 在已知天气温度 $z$ 的情况下, 发生溺水 $x$ 的概率.
  - $P(x | z, y)$: 在已知天气温度 $z$ 并且 已知冰淇淋销量 $y$ 的情况下, 发生溺水 $x$ 的概率.

  这个等式告诉我们, 一旦 $z$ 已知, 额外增加 $y$ 这个信息并不会改变我们对 $x$ 发生概率的判断. 信息 $y$ 变得冗余了.

  --- Gemini 2.5 Pro
]

=== 递归贝叶斯更新 (Recursive Bayesian Updating)

上面仅讨论了只有一个观测值的情况. 但实际上随着时间的推进, 单个传感器也会不断采集数据, 得到多个观测值 ($z_1, ..., z_n$). 下面将说明如何通过递归更新来处理多个观测值.

$ P(x | z_1, ..., z_n) = (P(z_n | x, z_1, ..., z_(n-1)) P(x | z_1, ..., z_(n-1))) / P(z_n | z_1, ..., z_(n-1)) $

设 $eta = 1 / P(z_n | z_1, ..., z_(n-1))$, 则:

$ P(x | z_1, ..., z_n) = eta P(z_n | x, z_1, ..., z_(n-1)) P(x | z_1, ..., z_(n-1)) $

马尔可夫假设 (Markov assumption): 系统的未来状态只依赖于当前状态, 而与过去的状态无关. 其思想是如果已经知道了当前世界的真实状态 $x$, 那么过去的观测历史 ($z_1, ..., z_(n-1)$) 对于预测当前的观测值就没有任何帮助了.

#blockquote[
  想象一下, 你要通过一个光线传感器读数 $z_n$ 来判断门是开是关 (状态 $x$). 如果你能 "开天眼", 直接看到了门确实是开着的 (即已知 $x = "open"$), 那么无论你过去的光线传感器读数是什么, 都不会改变你对当前读数的预期. 当前的光线只和当前门的状态有关.
  --- Gemini 2.5 Pro
]

基于这一假设, 结合前面给出的条件独立公式可以对似然项 ($P(z_n | x, z_1, ..., z_(n-1))$) 进行简化:

$ P(z_n | x, z_1, ..., z_(n-1)) = P(z_n | x) $

重新带入公式得到:

$ P(x | z_1, ..., z_n) = eta P(z_n | x) P(x | z_1, ..., z_(n-1)) $

贝叶斯公式 @bayes-formula 的结果是根据证据 $y$ 推测的 $x$ 的概率, 即后验概率, 可作为下一次计算中的先验概率 $P(x)$.

*信念 (Belief)* 就是某个状态的后验概率 (posterior probability). 因此可以得到进一步简化的公式:

$ "Bel"(x) = eta P(z_n | x) overline("Bel")(x) $

即:

$ "Bel"_(n)(x) = eta P(z_n | x) "Bel"_(n-1)(x) $

可以看出, 这个公式的计算十分简单. 只需要计算 $z_n$ 在当前状态 $x$ 下的概率, 并复用上一次计算得到的信念即可.

将上面公式展开可得:

$
  P(x | z_1, ..., z_n) = eta_(1...n) [product_(i=1)^n P(z_i | x)] P(x)
$

其中 $"Bel"_0 = P(x)$, 此处 $P(x)$ 为初始信念.

#blockquote[
  课件 35 页声称 $P(x | z_1, ..., z_n)$ 是最大后验估计 (Maximum a posteriori estimation, MAP), *暂不清楚原因*.
  // TODO: 待查
]

== 动作建模 (Modelling actions)

观测可以减少不确定性, 而*动作则通常会增加不确定性*. 并且由于世界本身是运动的, 所以随着时间的流逝, 不确定性也会增加.

#figure(caption: [里程计的误差传播])[2
  #image("imgs/odometry_error.png", width: 70%)
]

通过上图可以直观的看出, 随着移动距离的增加, 里程计的误差也逐步扩大.

前面说明了如何对通过观测估计当前状态, 这部分将引入动作对估计的影响. 二者相结合即可得到完整的贝叶斯滤波器.

可以通过下面*条件概率密度函数 (conditional pdf)* 对行为进行建模:

$ P(x_t | u, x_(t-1)) $

即上一个状态 $x_(t-1)$ 通过执行动作 $u$ 后得到 $x_t$ 的概率.

下面给出一个更直观的例子:

#figure(
  caption: [关门动作状态图.],
  diagram(
    spacing: 2em,

    state((0, 0), name: <open>, [open]),
    state((1, 0), name: <close>, [close]),

    trans(<open>, <open>, [$0.1$], bend: 130deg),
    trans(<close>, <close>, [$1.0$], bend: 130deg),

    trans(<open>, <close>, [$0.9$], bend: 30deg),
    trans(<close>, <open>, [$0$], bend: 30deg),
  ),
)

其中, 开门状态下执行关门动作的成功率为 90%, 有 10% 的概率会失败并依然处于开门状态.

离散情形:

$ P(x_t, u) = sum_(x_(t-1)) P(x_t | u, x_(t-1)) P(x_(t-1) | u) $

连续情形:

$ P(x_t, u) = integral_(x_(t-1)) P(x_t | u, x_(t-1)) P(x_(t-1) | u) dif x_(t-1) $

== 贝叶斯滤波器 (Bayesian Filters)

其核心思想是通过概率统计数据滤除不确定性.

#blockquote[
  - *贝叶斯滤波器*是一个通用的理论框架, 提供了一种系统化的方法来结合预测和观测数据, 更新对系统状态的估计.
  - *卡尔曼滤波器*是贝叶斯滤波器在线性高斯系统下的最优实现, 具有高效和简单的特点.
  - *粒子滤波器*是贝叶斯滤波器在非线性或非高斯系统下的实现, 通过粒子逼近来处理复杂的概率分布, 适用于更广泛的实际问题.
  --- Gemini 2.5 Pro
]

$
  "Bel"(x_t) = eta markhl(P(z_t | x_t), tag: #<sensor>, color: #green) sum_(x_(t-1)) markhl(P(x_t | u_t, x_(t-1)), tag: #<action>, color: #red) "Bel"(x_(t-1))
  #annot(<sensor>, pos: bottom, dy: 1em)[传感器模型]
  #annot(<action>, pos: bottom, dy: 1em)[动作模型]
$

= 运动与运动学 (Locomotion and Kinematics)

== 轮式运动 (Wheeled Motion)

ICR 坐标:

$ "ICR" = [x - R sin theta, y + R cos theta] $

ICR 到机器人中心的距离 $R$:

$ R = v / omega = (l (v_r + v_l)) / (2 (v_r - v_l)) $

如果机器人以角速度 $omega$ 绕 ICR 旋转时间 $t$，旋转角度 $Delta theta = omega t$. 则最终位姿 $(x_f, y_f, theta_f)$ 为:

新朝向角:

$theta_f = theta + Delta theta$

新坐标:

$
  mat(x_f; y_f) = mat(cos Delta theta, -sin Delta theta; sin Delta theta, cos Delta theta) mat(x - x_c; y - y_c) + mat(x_c; y_c)
$

== 运动学 (Kinematics)

- *自由度 (Degree of Freedom)*: 描述机器人运动能力的独立坐标参数数量, 即确定机器人位形所需的最少独立变量数.
- *机动度 (Degree of Mobility)*: 轮式机器人中, 机动度特指通过主动改变轮子朝向所能实现的独立运动方向数.

欠驱动 = 控制输入 < 自由度

以四轴无人机为例, 其分别有 3 个平动自由度和 3 个旋转自由度, 共 6 个自由度,  只有 4 个独立控制输入, 分别对应 4 个电机.

== 差速器 (Differential Drives)

$ omega = (v_r - v_l) / l $

= 里程计与运动模型 (Odometry and the Motion Model)

== 里程计与轮式编码器 (Odometry and Wheel Encoders)

=== 传感器分类 (Classification of Sensors)

#table(
  columns: 3,
  [*传感器分类*], [*描述*], [*示例*],
  [本体感受传感器 (Proprioceptive)], [测量系统内部数值], [电机速度、车轮负载、机器人航向、电池状态],
  [被动传感器 (Passive)], [能量来自环境, 无外部效应], [IMU],
  [外部感受传感器 (Exteroceptive)], [从机器人外部环境获取信息], [到物体的距离、环境光强度、独特特征],
  [主动传感器 (Active)], [发射自身能量并测量反应], [红外测距],
)

=== 轮式编码器 (Wheel Encoders)

#table(
  columns: 3,
  [*编码器类型*], [*特点*], [*适用场景*],
  [无编码 (Unencoded)], [无方向信息, 仅计数], [基础计数应用],
  [带索引轨的无编码 (Unencoded with Index Track)], [增加索引标记, 用于归零或定位], [需要参考点的简单定位],
  [双轨正交编码 (Two Track Quadrature)], [两路相位差 90° 的信号, 可判断方向], [方向+速度测量, 常见于机器人],
  [带索引轨的双轨正交编码 (Two Track Quad with Index Track)], [正交编码 + 索引标记], [高精度定位+方向判断],
  [绝对位置格雷码 (Absolute Position Gray Code)], [每个位置有唯一编码, 无累积误差], [需要上电即知位置的系统],
  [绝对位置二进制码 (Absolute Position Binary)], [类似格雷码但为二进制格式], [绝对位置测量, 易处理],
  [自定义编码 (Custom)], [根据需求定制编码方式], [特殊应用或协议需求],
)

=== 误差

通过里程计进行位置估算与航位推算 (Dead Reckoning) 相似, 其基本原理为通过时间和速度推测距离. \
随着时间的推移, 误差会不断累积.

误差来源包括:

- 凹凸不平的地面会增加实际的距离.
- 轮子直径存在差异.
- 在地毯上移动可能导致侧向滑动.

误差类型:

- *距离误差 (Range error)*: 是集成路径长度 (距离) 的误差, 它是轮子总运动量的累加. 这通常发生在直线移动时, 但实际上任何移动都会产生距离误差.
- *漂移误差 (Drift error)*: 是由于左右轮的误差不同步, 导致机器人角度方向上产生的误差. 这确实主要发生在直线移动时, 是机器人无法走直线的原因.
- *转向误差 (Turn error)*: 是由于车轮运动的差异, 导致机器人在转弯时产生的角度方向上的误差. 这只在机器人执行转弯动作时发生.

距离误差和漂移误差是在直线移动时产生, 而转向误差则是在转向时产生.

在长时间的移动中, 转向误差和漂移误差的累积远远大于距离误差.#footnote[个人理解是指漂移和转向误差会改变方向, 进而导致后续的任何移动都会产生新的误差.]

应对方式为 *建立随机误差的概率模型*, 即获得一个*可能的位姿分布*, 而非一个精确的位姿.

"香蕉形 (banana-shaped)" 分布是二维投影的 3D 后验分布的典型结果.#footnote[个人理解此处 3D 后验分布是指表示 2D 移动机器人位姿的三元组 $(x, y, theta)$, 投影就是直接抛弃 $theta$ 项.]

== 基于里程计的运动模型 (The Odometry-based Motion Model)

=== 相对里程计 (Relative Odometry)

相对里程计可以通过一个三元组表示 $(delta_"rot1", delta_"trans", delta_"rot2")$, 其中:

- $delta_"rot1" = "atan2"(y' - overline(y), x' - overline(x)) - overline(theta)$
- $delta_"trans" = sqrt((overline(x) - x')^2 + (overline(y) - y')^2)$
- $delta_"rot2" = overline(theta)' - overline(theta) - delta_"rot1"$

// FIXME

里程计模型 (Odometry-based model) 通常比速度模型 (Velocity-based model) 更精确.

此处机器人只能向前移动, 因此必须使用三元组表示其相对里程.
完成这样的运动, 至少包含这三个动作.

== 查询分布并计算后验概率 (Querying Distributions and calculating the Posterior)

TODO

== 采样里程计运动模型 (Sample Odometry Motion Model)

TODO

== 比例积分微分反馈控制 (Proportional Integral Derivative Feedback Control)

TODO

= 占用网格与建图 (Occupancy Grids and Mapping)

本章主要讲解*已知位姿下的占用网格与建图 (Occupancy Grids and Mapping with Known Poses)*.

== 构建网格地图 (Building Grid Maps)

=== 计数模型 (Counting Model)

首先创建两个零矩阵 $C$ 和 $M$.

每对位置 $(x, y)$ 进行一次观测:

- $C_(x,y) = C_(x,y) + 1$.
- 如果观测到障碍物, $M_(x,y) = M_(x,y) + 1$, 否则 $M_(x,y) = M_(x,y) - 1$.

位置 $(x, y)$ 存在障碍物的概率为:

$ P((x, y)) = C_(x,y) + M_(x,y) / 2 C_(x,y) $

个人认为下面公式更直观和简单:

$ P((x, y)) = O_(x,y) / C_(x,y) $

其中 $O$ 表示观测到有障碍物的次数.

== 使用对数几率构建地图 (Building Maps with Log Odds)

TODO

== 简单的逆向传感器模型 (Simple Inverse Sensor Models)

TODO

== 参数化逆传感器模型 (Parametric Inverse Sensor Models)

TODO

= 地图与导航 (Maps and Navigation)

== 连接特征 (Connecting Features)

特征 (feature) 就是环境中机器人关注的部分, 比如:

- *障碍物*: 需要规避.
- *信标 (beacon)*: 用于辅助定位和导航.

地标 (landmark) 一般具备以下特征:

- *易于识别*.
- *支持任务*: 需要支持机器人要完成的任务.
- *多视角可感知性*.

== 导航简介 (Intro to Navigation)

TODO

== 拓扑地图与路径规划 (Topological Maps and Path Planning)

=== 搜索算法

- Dijkstra 寻路算法. *(正向)* *(最优)* *(距离场)*

  适合单起点, 多终点的情况.

- 贪心最佳优先搜索 (Greedy Best-First Search, GBFS). *(正向)* *(非最优)* *(启发式)*

  虽然贪心搜索的速度比 A\* 快, 但是无法保证获得最优解.

- A\* 搜索. *(正向)* *(最优)* *(启发式)*
- D\* 搜索. *(反向)* *(最优)* *(启发式)*
- D\* Lite 搜索. *(反向)* *(最优)* *(启发式)*

  是 D\* 搜索算法的上位替代, 是目前的主流实现. D\* 主要是有历史意义. \
  D\* Lite 本身并不基于 D\*, 而是基于 Lifelong Planning A\*.

  该算法的特点是可以通过局部更新保持全局最优.

- 波前规划 (Wavefront Planning). *(反向)* *(最优)* *(距离场)*

  在均匀代价场中 (例如栅格地图), 波前规划是 Dijkstra 算法在栅格空间中的反向传播形式. \
  适合单终点, 多起点 (起点可变) 的情况, 比如对于机器人来说, 目标点往往是固定的 (如充电桩), 因此可以重复利用计算得到的*距离场 (distance map)*.

#blockquote[
  课件第 58 页将贪心最佳优先搜索的效率与 Dijkstra 算法进行了对比, 感觉并不合适. 因为会计算出完整的距离场, 结果可复用. 和 A\* 搜索比较会更加合适.
]

== 避障 (Avoiding Obstacles)

下面将介绍 Bug 算法, 这是一种早期的/简单的避障算法, 能确保最终一定能到达目标 (如果目标是可达的). 其优点是不需要依赖地图建模和概率, 机器人只需要拥有触碰传感器并具备沿墙体移动的能力即可实现避障.

- *Bug 0*: 往终点移动, 遇到障碍物就朝一侧绕行, 直到无障碍物遮挡. 缺点是需要记忆遇到过的 Hit point, 如果再次遇到, 则往另一侧绕行, 防止死循环.

  综上所述, Bug 0 若需要确保一定能达到目标则需要具备寻左侧和右侧墙的能力.

- *Bug 1*: 往终点移动, 遇到障碍物就绕其一圈, 确认障碍物的外形, 然后计算该外形距离目标最近的点, 以该点为新的 Leave point.

  下界为:

  $ L_"Bug1" >= D $

  上界为:

  $ L_"Bug1" <= D + 1.5 sum_i P_i $

  其中 $D$ 是起点到终点的直线距离, $P_i$ 是第 i 个障碍物的周长.

  #blockquote[
    没有遇到任何障碍物时 $L_"Bug1" = D$, $1.5$ 分别为绕障碍物一圈的周长 $1.0$ 和 最长到达新 Leave point 的距离 $0.5$ (如果机器人既可以寻左侧和右侧的墙).

    课上有学生询问是否必须绕障碍物一周才能找到最近点, 这个是必须的, 读者可以自己思考一下.
  ]

- *Bug 2*: 往终点移动, 遇到障碍物就朝一侧绕行, 直到再次遇到起点到终点的线段 (m-line), 则以此为 Leave point, 继续向目标方向前进 (沿 m-line). 但遇到 m-line 需确保比上次更接近目标点, 否则会回到上一个 Hit point, 产生死循环.

  下界为:

  $ L_"Bug2" >= D $

  上界为:

  $ L_"Bug2" <= D + 1/2 sum_i^n n_i P_i $

  其中 $n_i$ 是与第 i 个障碍物边界的交点数, 由于障碍物有体积 (或者 2D 情况下的面积), 因此与每个障碍物边界必然有至少 2 个交点.

  #blockquote[
    课上与学生询问为什么 $n_i$ 要与 $P_i$ 相乘.

    如果 m-line 只碰到障碍物的一角, 即两个交点之间沿障碍物边缘的距离很近, 近似为 $0$, 则如果机器人绕行另一侧的距离为 $P_i - 0 = P_i$. 上界考虑最坏情况, 所以公式里需要直接乘以 $P_i$.
  ]

  与 Bug 0 和 Bug 1 相比, Bug 2 只需要具备寻其中一侧墙移动的能力即可.

假设 m-line 与大于或等于一个障碍物边界相交, 且与每个障碍物边界只存在两个交点, 则可以得到下界:

$
  L_"Bug1" & = D + sum_i 1.5 P_i \
  L_"Bug2" & = D + sum_i P_i
$

可以看出, $L_"Bug2"$ 的下界在这种情况下更优. 如果交点数继续增加, 则 $L_"Bug2"$ 最终将大于 $L_"Bug1"$. 比如课件 P111 给出的例子, 只有单个障碍物, 但是存在 4 个交点, 因此 $P_1$ 的系数为 $2$, 大于 $L_"Bug1"$ 的 $1.5$.

= 感知与传感器模型 (Perception and Sensor Models)

== 传感器的特性 (Characteristics of Sensors)

TODO

== 测距传感器 (Proximity / Range Sensors)

TODO

== 传感器波束模型 (Sensor Beam model)

TODO

== 扫描模型与似然场 (Scan model and Likelihood Fields)

TODO

= 确定机器人位置 (Determining the Robot location)

== 马尔可夫定位 (Markov Localisation)

TODO

== 网格定位 (Grid Localisation)

=== 对数几率 (Log Odds)

Logit 函数, 也称为对数几率函数:

$ l(x) = ln p(x) / (1 - p(x)) $

其反函数名为逻辑函数 (Logistic function), 是一种典型的 Sigmoid 函数:

$ sigma(x) = 1 / (1 + e^(-x)) = e^(x) / (1 + e^(x)) = 1 - sigma(-x) $

$ p(x) = 1 - 1 / (1 + e^l(x)) = 1 - sigma(-l(x)) = sigma(l(x)) $

不需要预先知道数据的最大值或最小值

== 粒子滤波 (Particle Filters)

TODO

== 贝叶斯滤波器 (Bayes Filter)

TODO

= 辅导

Canvas 建议使用 #link("https://github.com/cyberbotics/webots/releases/tag/R2023b")[`R2023b`] 版本的 Webots.

== Tutorial 1

以下内容以 C++ 语言为例, 但课程要求使用 Java 或 Python.

Webots 内置编辑器功能有限, 推荐使用 VSCode.

添加 clangd 插件, 并通过包含下面内容的 `.clangd` 文件指定 Webots 头文件路径:

```yaml
CompileFlags:
  Add:
    - "-ID:/apps/Webots/include/controller/cpp/"
```

对教程中给出的 C++ 代码 (课程要求使用 Java 或 Python) 进行重构后的代码:

```cpp
#include <cassert>
#include <cstdlib>
#include <memory>
#include <numbers>
#include <webots/Motor.hpp>
#include <webots/Robot.hpp>

constexpr int TIME_STEP = 64;
constexpr float MAX_SPEED = std::numbers::pi * 2;

int main(int argc, char *argv[]) {
  std::unique_ptr<webots::Robot> robot = std::make_unique<webots::Robot>();

  webots::Motor *left_motor = robot->getMotor("left wheel motor");
  webots::Motor *right_motor = robot->getMotor("right wheel motor");
  assert(left_motor && right_motor);

  left_motor->setPosition(INFINITY);
  right_motor->setPosition(INFINITY);

  left_motor->setVelocity(0.1 * MAX_SPEED);
  right_motor->setVelocity(0.1 * MAX_SPEED);

  while (robot->step(TIME_STEP) != -1) {
  }

  return EXIT_SUCCESS;
}
```

== Tutorial 2

添加包含下面内容的 `.classpath` 文件到项目根目录, 确保 LSP 能正常运行.

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<classpath>
    <classpathentry kind="src" path="controllers/lab2" />
    <classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER" />
    <classpathentry
        kind="lib"
        path="D:/apps/Webots/lib/controller/java/Controller.jar"
    />
    <classpathentry kind="output" path="controllers/lab2" />
</classpath>
```

```java
import com.cyberbotics.webots.controller.Motor;
import com.cyberbotics.webots.controller.Robot;

public class Lab2 {

    public enum MoveState {
        FORWARD,
        ROTATE,
    }

    public static final double WHEEL_RADIUS = 0.0975; // in meters
    public final static double AXEL_LENGTH = 0.31;    // in meters

    static MoveState state;

    static Motor leftMotor;
    static Motor rightMotor;

    public static void main(String[] args) {
        Robot robot = new Robot();

        double linearVelocity = 1.0; // Linear velocity in m/s

        leftMotor = robot.getMotor("left wheel");
        rightMotor = robot.getMotor("right wheel");

        leftMotor.setPosition(Double.POSITIVE_INFINITY);
        rightMotor.setPosition(Double.POSITIVE_INFINITY);

        double targetTime = 1000.0 * forward(1.0, linearVelocity);

        int timeElapsed = 0; // Monitor the time (in millisecs)
        final int timeStep = (int) Math.round(robot.getBasicTimeStep());
        while (robot.step(timeStep) != -1) {
            timeElapsed += timeStep;
            if (timeElapsed > targetTime) {
                stop();
                timeElapsed = 0;
                switch (state) {
                    case FORWARD:
                        // After moving forward, rotate 90 degrees
                        targetTime = 1000.0 * rotate(Math.PI / 2.0, linearVelocity);
                        break;
                    case ROTATE:
                        // After rotating, move forward again
                        targetTime = 1000.0 * forward(1.0, linearVelocity);
                        break;
                }
            }
        }
    }

    public static double forward(double distance, double linearVelocity) {
        // v = w * r
        // w = v / r
        double angularVelocity = (linearVelocity / WHEEL_RADIUS);

        leftMotor.setVelocity(angularVelocity);
        rightMotor.setVelocity(angularVelocity);
        state = MoveState.FORWARD;

        // s = v * t
        // t = s / v
        return distance / linearVelocity;
    }


    public static double rotate(double radians, double linearVelocity) {
        double circleFraction = radians / (2.0 * Math.PI);
        // 2 pi r = 2 r pi = d pi
        double circumference = AXEL_LENGTH * Math.PI;
        double distance = circumference * circleFraction;
        double angularVelocity = (linearVelocity / WHEEL_RADIUS);

        leftMotor.setVelocity(angularVelocity);
        rightMotor.setVelocity(-angularVelocity);
        state = MoveState.ROTATE;

        return distance / linearVelocity;
    }

    public static void stop() {
        leftMotor.setVelocity(0.0);
        rightMotor.setVelocity(0.0);
    }
}
```

== Tutorial 3

如果没有出现显示器窗口, 则反选 `Overlays | Hide All Display Overlays`.

经测试, 原本的误差主要是默认参数不精确导致的, 更精确的 `AXEL_LENGTH` 值为 0.325.#footnote[Canvas 页面的截图里泄露了具体的测试数据.]

其中下面代码会导致严重的内存泄露, 暂不清楚原因:

```java
odometry_display.setFont("Arial", 12, true);
```

为了后续 Engagement Task 3 统计方便, 建议将 `PioneerNav1.robot_pose` 设为公开字段, 并在 `main` 函数的 `MoveState.STOP` 动作部分追加下面代码:

```java
var estimated_pose = nav.robot_pose;
System.out.print("Estimated Pose: " + estimated_pose);
System.out
    .println(
        "\t, Distance:"
            + Math.sqrt(Math.pow(estimated_pose.getX(), 2) + Math.pow(estimated_pose.getY(), 2)));

var actual_pose = nav.get_real_pose();
System.out.print("Actual Pose   :" + actual_pose);
System.out
    .println("\t, Distance:" + Math.sqrt(Math.pow(actual_pose.getX(), 2) + Math.pow(actual_pose.getY(), 2)));
```

其中的两个 `Distance` 值可以直接填入表格.

= 参与任务

== Engagement Task 4

#figure(caption: "Measurement Likelihood over Map Locations")[
  #image("imgs/task4_likelihood.png")
]

#figure(caption: "Posterior (Uniform Prior) and Posterior (Non-uniform Prior)")[
  #image("imgs/task4_posterior.png")
]

University of Freiburg 课程中对应的#link("http://ais.informatik.uni-freiburg.de/teaching/ss19/robotics/exercises/solutions/05/sheet05sol.pdf")[题目答案].

== Engagement Task 5

University of Freiburg 课程中对应的#link("http://ais.informatik.uni-freiburg.de/teaching/ss19/robotics/exercises/solutions/06/sheet06sol.pdf")[题目答案].

== 编程作业

Canvas 建议使用 "最新" 版本的 Webots, 截至 2025-11-22 日, 最新的版本为 #link("https://github.com/cyberbotics/webots/releases/tag/R2025a")[`R2025a`].

---

Class Test 2
