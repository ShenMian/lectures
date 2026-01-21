#import "@preview/ilm:1.4.2": *
#import "@preview/mannot:0.3.1": *

#import "@preview/fletcher:0.5.8" as fletcher: node
#let diagram = fletcher.diagram.with(node-stroke: .1em)
#let world = fletcher.node.with(shape: circle)
#let relate = fletcher.edge.with(marks: "->")
#let bi-relate = fletcher.edge.with(marks: "<->")

#let generate-binary-columns(n) = {
  let ith-row = i => ("0" * (n - 1) + str(i, base: 2)).slice(-n)
  let rows = range(calc.pow(2, n)).map(ith-row).map(row => row.clusters())
  array.zip(..rows)
}

#let truth-table(inputs: (), outputs: ()) = {
  table(
    columns: inputs.len() + outputs.len(),
    column-gutter: 3pt,
    stroke: none,
    align: center,
    table.hline(y: 1),
    table.vline(x: inputs.len() - 1, position: right),
    table.vline(x: inputs.len(), position: left),
    ..array
      .zip(
        ..inputs.enumerate().map(((i, x)) => (x, ..generate-binary-columns(inputs.len()).at(i))),
        ..outputs.map(((header, values)) => (header, ..values.map(str))),
      )
      .enumerate()
      .map(((i, row)) => if i == 0 { table.header(..row) } else { row })
      .flatten()
  )
}

#let notmodels = $cancel(models, length: #90%)$

#set text(lang: "zh")

#set text(font: ("New Computer Modern", "Source Han Serif SC"))

#show: ilm.with(
  title: "知识表示与推理笔记",
  author: "ShenMian",
  abstract: [
    本文为知识表示与推理 (#link("https://www.liverpool.ac.uk/info/portal/pls/portal/tulwwwmerge.mergepage?p_template=m_cs&p_tulipproc=moddets&p_params=%3Fp_module_id%3D184351")[COMP304], University of Liverpool) 的课程笔记.
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

= 简介

== 课程简介

*讲师*: #link("https://www.liverpool.ac.uk/people/louwe-kuijer")[Dr Louwe Kuijer] <#link("mailto:Louwe.Kuijer@liverpool.ac.uk")>

本课程可以大致分为下面四个部分:

+ *命题逻辑*: 前置知识, 仅作简单复习.
+ *模态逻辑*: 命题逻辑的拓展, 是学习认知逻辑的基础.
+ *认知逻辑*: 特化的模态逻辑, 尤其适用于多主体 (multi-agent) 及高阶 (higher order) 知识.
+ *描述逻辑*: 特化的模态逻辑, 聚焦于本体论 (Ontologies).

此外研究生课程 COMP521 与本科生课程 COMP304 高度相似, 因此这两个课程被合并. 存在的差别会在讲到的时候提及.

== 分数构成

#figure(caption: [分数构成])[
  #table(
    columns: 4,
    table.header[*名称*][*分数*][*类型*][*时间*],
    [Class Test 1], [$13%$], [线下简答题], [第 6 周, 星期二],
    [Class Test 2], [$12%$], [线下简答题], [第 11 周, 星期二],
    [Final Exam], [$75%$], [线下简答题], [],
  )
]

== 注意事项

- *两种课件*: 带 `handout` 没有动画, 而不带的则会为动画创建不同的页. 建议使用带 `handout` 的, 但可能存在动画重叠的问题.
- *两种练习*
  - *普通练习*: 如果目标是 60 分应该完成, 答案一周后公布.
  - *额外练习*: 如果目标是 90 分应该完成, 答案不公布, 但是容易自行判断是否正确. 考察的是课外的拓展内容, 需要学生自学.
- *两种回放*
  - 2020 年的录播, 是专门录播课, 针对镜头前的学生, 可能有些过时.
  - 2025 年现场的回放.
- *教材*: 提供对课程内容的另一种不同的解释方式.
- *提问方式*: 建议使用 Canvas 的 Message board, 其次才是邮件 (`Louwe.Kuijer@liverpool.ac.uk`) 和 MS Teams.

= 命题逻辑 (Propositional Logic)

命题逻辑是课程的前置知识, 因此仅在开学第一周做简单回顾. 这是四种逻辑中最简单的一种, 同时也是其他三种逻辑的基础. 缺点是由于过于简单, 因此适用性不足.

== 语言 (Language)

命题逻辑的语言可以通过下面公式定义:

$
  phi ::= p | not phi | phi and phi
$

原子集合 $PP = {p, q, p_1, q_1, ...}$ 中的原子就是不再被细分的基本事实, 被称为原子命题 (atomic proposition).

原子命题也被称之为简单命题, 其特点是不包含逻辑联结词. 与之对应的复杂命题则是通过逻辑联结词组合简单命题得来的.

== 合式公式 (Well-formed Formulas)

合式公式 (well-formed formulas, wff) 通常简称公式 (formula), 即符合语法规则的公式:

- 每个 $p in PP$ 是一个公式.
- 如果 $p$ 和  $q$ 都是公式, 则 $p and q$ 和 $p or q$ 等也是公式.
- 除此之外, 都不是公式.

所以上文提到的简单命题和复杂命题都是公式, 其中简单命题是最简单的公式.

== 常用符号

#figure(caption: [常用希腊字母])[
  #table(
    columns: 3,
    [*小写*], [*大写*], [*名称*],
    [$phi$], [$Phi$], [phi],
    [$psi$], [$Psi$], [psi],
    [$chi$], [], [chi],
    [$xi$], [], [xi],
    [$gamma$], [$Gamma$], [gamma],
    [$alpha$], [], [alpha],
    [$beta$], [], [beta],
  )
]

== 语义 (Semantics)

#figure(caption: [逻辑连接词])[
  #table(
    columns: 3,
    [*符号*], [*名称*], [*读作*],
    [$not$], [negation], [not],
    [$and$], [conjunction], [and],
    [$or$], [disjunction], [or],
    [$->$], [implication], [implies (蕴涵) / if ... then ...],
    [$<->$], [bi-implication], [if and only if (双关系)],
  )
]

#figure(caption: [蕴涵真值表])[
  #truth-table(inputs: ($phi$, $psi$), outputs: (($phi -> psi$, (1, 1, 0, 1)),))
]

前提 $phi$ 为真时, 承诺要求结论 $psi$ 必为真. 如果前提为假, 则无所谓结论的真假, 因为都不会违反承诺 (即承诺为真). 即 $not phi or psi$.

#blockquote([
  我们用一个具体的例子来逐行分析这个 "承诺" :
  承诺: "如果 (If) 今天下雨 (命题 φ) , 那么 (then) 我就会带伞 (命题 ψ)."

  现在我们来看这个承诺在四种情况下是否被遵守了:

  *第 3 行*: φ = 1, ψ = 0 ⇒ φ -> ψ = 0 (最直观的情况)
  情况: 今天下雨了 (φ 是真的), 但是我没有带伞 (ψ 是假的).

  分析: 我违背了我的承诺. 我说过如果下雨我就会带伞, 但我没做到.

  结论: 所以, 这个蕴涵陈述是假 (0) 的. 这是唯一一种违背承诺的情况.

  *第 4 行*: φ = 1, ψ = 1 ⇒ φ -> ψ = 1
  情况: 今天下雨了 (φ 是真的), 而且我也带了伞 (ψ 是真的).

  分析: 我完全遵守了我的承诺.

  结论: 这个蕴涵陈述是真 (1) 的.

  接下来的两行是通常让人困惑的地方, 关键在于理解: 当 "如果" 部分不成立时, 承诺根本没有被触发, 所以也就谈不上被违背.  我们称这种情况为 "空虚的真"  (Vacuously True).

  *第 1 行*: φ = 0, ψ = 0 ⇒ φ -> ψ = 1
  情况: 今天没有下雨 (φ 是假的), 我也没有带伞 (ψ 是假的).

  分析: 我的承诺是关于 "下雨时" 该怎么做的. 既然今天没下雨, 这个承诺的条件就没有被触发. 我带不带伞都和我那个 "关于下雨" 的承诺无关. 我没有违背任何承诺.

  结论: 既然承诺没有被违背, 这个蕴涵陈述就被认为是真 (1) 的.

  *第 2 行*: φ = 0, ψ = 1 ⇒ φ -> ψ = 1
  情况: 今天没有下雨 (φ 是假的), 但我还是带了伞 (ψ 是真的).

  分析: 同样, 我的承诺只规定了下雨时必须做什么. 它并没有限制我 "不下雨时" 不能做什么. 也许我带伞是为了防晒, 或者只是忘了放在家里. 无论如何, 我并没有违背 "如果下雨就带伞" 的承诺.

  结论: 承诺没有被违背, 所以蕴涵陈述仍然是真 (1) 的.

  --- Gemini 2.0 Pro
])

#figure(caption: [双条件真值表])[
  #truth-table(inputs: ($phi$, $psi$), outputs: (($phi <-> psi$, (1, 0, 0, 1)),))
]

这个可以直接当作*等于*号来加速判断.

这部分主要解释逻辑连接词的具体含义. 请参见幻灯片, 此处忽略.

== 习题

习题为两道 Wason Selection Task, 约束是一个简单的蕴涵命题.

+ 应该翻开的卡片为 2 和 C. 此处注意不要倒因为果, A 不需要翻开.
+ 应该检查 "Person" 2 和 3.

详细答案解析请参见幻灯片.

== 有效性 (Validity)

在命题逻辑中, 所有公式可以根据有效性分为以下三类:

- *有效公式 (Valid Formulas)*

  总是为真的公式, 即恒真式 (tautology).

  写作: $models Phi$ \
  比如: $models p or not q$

- *矛盾公式 (Contradictions)*

  总是为假的公式, 即恒假式.

  写作: $models not Phi$ \
  比如: $models p and not q$

- *条件公式 (Contingent Formulas)*

  真值取决于原子命题的公式.

=== 有效推理 (Valid Inference)

当前提 (premise) 集 $Gamma$ 为真时, 结论 (conclusion) $Phi$ 一定为真的推理 (inference):

$ Gamma models Phi $

比如: ${p, p -> q} models q$.

相对的, $Gamma notmodels Phi$ 则表示, 即使 $Gamma$ 为真, 也不一定能推理出 $Phi$ 为真.

前面有效公式的写法 $models Phi$ 实际上就是省略了为空集的 $Gamma$, 完整写法为 $emptyset models Phi$.

== Hilbert 风格证明系统

Hilbert 系统是一种演绎系统, 通过*公理*和*推理规则*生成定理.

例如, 下面是一个适用于命题逻辑的 Hilbert 系统#footnote[逻辑命题的证明系统不在考察范围内.], 证明系统 $frak(P)$, 包含公理和推理规则两部分:

*公理*

#table(
  columns: 3,
  [*公理类别*], [*公理名称*], [*公理内容*],
  [蕴涵公理], [($->$1)], [$phi -> (psi -> phi)$],
  [], [($->$2)], [$(phi -> (chi -> psi)) -> ((phi -> chi) -> (phi -> psi))$],
  [合取公理], [($and 1$)], [$(phi and psi) -> phi$],
  [], [($and 2$)], [$(phi and psi) -> psi$],
  [], [($and 3$)], [$phi -> (psi -> (phi and psi))$],
  [析取公理], [($or 1$)], [$phi -> (phi or psi)$],
  [], [($or 2$)], [$psi -> (phi or psi)$],
  [], [($or 3$)], [$((phi -> chi) and (psi -> chi)) -> ((phi or psi) -> chi)$],
  [否定公理], [($not 1$)], [$((phi -> psi) and (phi -> not psi)) -> not phi$],
  [], [($not 2$)], [$(phi and not phi) -> psi$],
  [], [($not 3$)], [$phi or not phi$],
  [双条件公理], [($<-> 1$)], [$(phi <-> psi) -> (phi -> psi)$],
  [], [($<-> 2$)], [$(phi <-> psi) -> (psi -> phi)$],
  [], [($<-> 3$)], [$((phi -> psi) and (psi -> phi)) -> (phi <-> psi)$],
)

*推理规则*

+ MP: 如果推导出了 $psi$ 和 $phi -> psi$, 则可以推导出 $psi$.

后续将在 @proof-system-k 介绍一种适用于模态逻辑的证明系统 $K$.

#blockquote[
  *Why* \
  在数学和逻辑学中, 证明是非常重要的. 我们需要一种系统化的方法来验证一个命题是否正确. *Hilbert 风格证明系统*就是一种这样的工具, 它帮助我们用一种清晰、规范的方式进行逻辑推理. 就像搭积木一样, 我们用一些基本的规则和步骤, 逐步构建出复杂的证明.

  *What* \
  *Hilbert 风格证明系统*是一种形式化的逻辑证明系统. 它由两部分组成: *公理* (axioms) 和*推理规则* (rules of inference).

  - *公理*: 这些是不需要证明的基本命题, 就像数学中的 "1+1=2" 一样, 是大家都认可的基础.
  - *推理规则*: 这些规则告诉我们如何从已知的命题推出新的命题. 比如, 如果已知 "如果A成立, 那么B成立", 并且已知 "A成立", 那么我们可以推出 "B成立".

  这个系统的主要作用是帮助我们从已知的命题出发, 通过一系列逻辑步骤, 证明新的命题是否成立. 它广泛应用于数学、计算机科学和逻辑学中, 帮助我们构建严谨的证明.

  *How* \
  使用 *Hilbert 风格证明系统* 的过程可以分为以下几步:

  + *列出公理*: 首先, 我们需要明确系统中的公理. 这些公理是证明的基础, 就像地基一样.
  + *应用推理规则*: 根据已知的命题和公理, 使用推理规则逐步推导出新的命题. 推理规则就像是工具, 帮助我们从一个命题到达另一个命题.
  + *构建证明序列*: 将这些步骤按照逻辑顺序排列, 形成一个完整的证明序列. 每一步都要符合规则, 不能跳过任何逻辑环节.

  -- Kimi K2
]

== 可靠性与完备性 (Soundness and Completeness)

可靠性定理的逆命题是语义完备性定理.

存在一个证明系统 $op(tack.r)_frak(P)$:

- 如果 $Gamma op(tack.r)_frak(P) Phi$, 则 $Gamma models Phi$. 即*可以被推导*出来的结论都是*有效的*. 因此, 我们只能*推导*出*有效推理*. 这称为可靠性 (Soundness).
- 如果 $Gamma models Phi$, 则 $Gamma op(tack.r)_frak(P) Phi$. 即逻辑上*有效的*结论都*可以被推导*出来. 因此, 每一个*有效推理*都可以被*推导*出来. 这称为完备性 (Completeness).

其中:

- *有效推理*关乎*真理 (Truth)*.
- *推导*关乎*规则 (Rules)*, 即符号操作, 指通过证明系统中提供的公理和规则进行推导.

仅当一个证明系统同时具备可靠性和完备性时, 语法上的推导和语义上的有效推理才产生相同的结果. \
一个即可靠又完备的证明系统才被认为是有用的.

== 缩写 (Abbreviations)

- $tack.b phi$: 表示 $phi$ 是*永真*的.
- $tack.t phi$: 表示 $phi$ 是*永假*的.
- $phi and psi$: 可缩写 $not (not phi or not psi)$.
- $phi -> psi$: 可缩写 $not phi or psi$.
- $phi <-> psi$: 可缩写 $(phi -> psi) and (psi -> phi)$.

= 模态逻辑 (Modal Logic)

== 介绍

下面将介绍模态逻辑引入的两个新算子:

- $square phi$: 表示在特定上下文下, $phi$ 一定成立. 表达*必然性*或*确定性*.
- $diamond phi$: 表示在特定上下文下, $phi$ 可能成立. 表达*可能性*.

== 语言 (Language)

模态逻辑的语言可以通过下面公式定义:

$
  phi ::= p | not phi | phi and phi | square phi
$

在命题逻辑语言的基础上添加了 $square phi$. $diamond$ 可以使用 $square phi$ 表示, 即 $not square not Phi$. \
例如: 可能下雨 ($diamond "下雨"$), 也可以写成 $not square not "下雨"$, 即不一定不下雨.

因此此处只需要添加一个新算子.

#table(
  columns: 3,
  table.header[*上下文 (Context)*][*$square phi$ 的含义*][*$diamond phi$ 的含义*],
  [Alethic (真理)], [$phi$ is necessarily true], [$phi$ is possibly true],
  [Epistemic (知识)], [I know that $phi$ is true], [as far as I know, $phi$ might be true],
  [Deontic (道义)], [$phi$ should be true], [$phi$ is allowed to be true],

  [Temporal (时间)],
  [At every time in the future, $phi$ will be true],
  [At some time in the future, $phi$ will be true],

  [Doxastic (信念)], [I believe that $phi$ is true], [I believe that $phi$ might be true],
  [Legal (法律)], [$phi$ is legally required to be true], [it is legal for $phi$ to be true],
)

== 翻译

这部分将说明如何实现自然语言与模态逻辑的相互转换.

=== 模态逻辑转自然语言

若 $square (square p or diamond square q)$ 的上下文为*真理*, 则可以翻译为自然语言:
+ it is necessarily true that $(square p or diamond square q)$.
+ it is necessarily true that (it is necessarily true that $p$ or $diamond square q$).
+ it is necessarily true that (it is necessarily true that $p$ or it is possibly true that $square q$).
+ it is necessarily true that (it is necessarily true that $p$ or it is possibly true that it is necessarily true that $q$).
+ It is necessary that either p is necessary or q is possibly necessary.

==== 有趣的公式

- *时间*: $square diamond p$ \
  At every point in the future, $p$ will be true some later time.
- *信念*: $square p -> diamond p$ \
  If $p$ is mandatory then it is also permitted.
- *法律*: $not diamond square not p$ \
  It is not permitted to forbid $p$.
- *知识*: $square p -> square square p$ \
  If I know $p$, then I know that I know $p$.

=== 自然语言转模态逻辑

由于自然语言的不如模态逻辑严谨, 因此这种转换可能产生*歧义*. 即单个自然语言句子可能对应多个模态逻辑公式. \
考试时只需要写出任意其中一个合理 (plausible) 的公式即可得分.

比如句子 "I know that it is Monday or it is Tuesday.", 首先从 "I know that" 可以判断出上下文是*知识*, 原子命题为:

$
  p = "it is Monday" \
  q = "it is Tuesday"
$

可以翻译为:

+ $square p or q$: (I know that it is Monday) or it is Tuesday.
+ $square (p or q)$: I know that (it is Monday or it is Tuesday).
+ $square p or square q$: I know that it is Monday or I know that it is Tuesday.

虽然一般理解下, 这个句子的含义很可能是 2, 不太可能是 1 或 3. 但是严格上有三种对应的模态逻辑公式.

通过上面例子可以看出, 自然语言的不严谨主要是由于*算子作用域不明确*导致的.

== 语义

上面从自然语言的层面描述了模态逻辑的大致语义, 下面将对其本质进行更准确的描述, 并给出正式定义.

=== 正式定义

Kripke 模型 $M$ 是一个三元组 $(W, R, V)$:

- $W$ 为可能世界的集合.
- $R subset.eq W times W$ 为联系的连接矩阵.
- $V: P -> cal(P)(W)$#footnote[此处表示 $W$ 的幂集 (所有子集构成的集合), 课件上写作 $2^W$.] 为赋值函数 (valuation function).

其中 $R$ 表示 $w_i in W$ 之间的联系 (有向), 是对当前可能世界 (possible world) 的观察与可能的实际世界之间联系.

课件中给出了一个无窗房间的例子 (第 9 页), 其模型为 $M_1 = (W, R, V)$:

- $W = {w_1, w_2}$.
- $R = {(w_1, w_1), (w_2, w_2), (w_1, w_2), (w_2, w_1)} = W times W$.
- $V(p) = {w_1}$.

#figure(
  caption: [$M_1$ 的模型图.],
  diagram(
    spacing: 2em,

    world((0, 0), name: <w1>, [$w_1 : p$]),
    world((1, 0), name: <w2>, [$w_2$]),

    relate(<w1>, <w1>, bend: 130deg),
    relate(<w2>, <w2>, bend: 130deg),

    bi-relate(<w1>, <w2>),
  ),
)

其中命题 $p$ 表示正在下雨, 因此 $w_1$ 正在下雨, $w_2$ 没有在下雨.

#blockquote[
  区分这两个世界的唯一方法是观察是否正在下雨. 但是在无窗房间中无法进行这个观察, 因此可访问关系 $R$ 构成了一个全域关系 (universal relation), 即 $R = W times W$.
]

== 证明系统 K (The Proof System K) <proof-system-k>

=== 定义

证明系统 K 包含下面两个公理:

+ *T*: 所有有效的命题逻辑, 即重言式.
+ *K*: $square (psi -> phi) -> (square psi -> square phi)$

和下面两个规则:

+ *MP*: 分离规则 (Modus Ponens), 如果推导出了 $psi$ 和 $phi -> psi$, 则可以推导出 $psi$.
+ *Necc*: 必然化规则 (Necessitation), 如果推导出了 $phi$, 则可以推导出 $square phi$.

如果 $phi$ 在 K 中可导, 可以写作 $tack.r_K phi$.

#blockquote[
  值得注意的是, T 系统也存在一个 T 公理 ($square phi -> phi$), 与上面系统 K 不同.
]

=== 证明

对于简单的公式, 可以直接通过应用两条公理来进行证明. 否则需要使用规则 MP, 即通过证明 $psi$ 和 $psi -> phi$ 来证明 $phi$.

一个合适的 $psi$ 应该具备下面条件:

+ $psi$ 和 $psi -> phi$ 必须是有效的.
+ $psi$ 和 $psi -> phi$ 必须比直接推导 $phi$ 更简单.

证明是一个搜索的过程, 有经验的人可以更快的发现有效的证明方式. 因此需要练习.#footnote[考试时分数占比约 10-15%, 可能分为一道简单题 (5%) 和一道普通题 (10%). 也可能遵循往年试卷, 仅保留一道普通题 (10%).]

= 认知逻辑 (Epistemic Logic)

#blockquote[
  缺失的第 15 号课件是线下课程的现场演示, 课程录像请参见 Canvas.
]

== 共同知识 (Common Knowledge)

正式定义

一个公式 $phi$ 是共同知识, 写作 $C phi$, 当且仅当:

- $E phi$, 即每个人都知道 (Everybody Knows) $phi$, 并且
- $E C phi$, 即每个人都知道 $phi$ 是共同知识.

可以看出这是一个递归定义, 其中 $E phi$ 的语义如下:

$M, w |= E phi$ 当且仅当 $w$ 的所有后继都满足 $phi$.

#blockquote[
  课件中还给出了另一个定义:

  一个公式 $phi$ 是共同知识, 写作 $C phi$, 当且仅当:
  - 每个人都知道 $phi$ (即 $E phi$),
  - 每个人都知道每个人都知道 $phi$ (即 $E E phi$),
  - 每个人都知道每个人都知道每个人都知道 $phi$ (即 $E E E phi$),
  - 依此类推, 无限次.

  课件强调这两个定义可以互换, 虽然存在差别, 但暂时可以忽略.
]

#blockquote[
  课件中给出的拜占庭将军例子容易使人困惑, 因为直觉上, 从 A 将军首次致信到 B 将军收到确认回信构成了一个完整的闭环. 但根据上面给出的定义可以看出, 达成共同知识需要满足无数个层次的 "知道", 因此无论写多少封信, 两位将军也无法达成这个共同知识.
]

== 公开宣告 (Public Announcements)

=== 陷阱 (Pitfalls)

+ 宣布真实的事可能使其变为假.
+ 重复宣布同一内容可能产生不同效果.
+ 并非所有命题都能成为共同知识.

== 证明系统 S5 (The Proof System S5)

#table(
  columns: 3,
  table.header[*知识性质名称*][*公理 (S5 中)*][*对应的可达关系 $R_a$ 性质*],
  [真实性 (Truthfulness) ], [$K_a phi -> phi$], [自反性 (Reflexive)],
  [正向内省 (Positive Introspection) ], [$K_a phi -> K_a K_a phi$], [传递性 (Transitive)],
  [负向内省 (Negative Introspection) ], [$not K_a phi -> K_a not K_a phi$], [欧几里得性 (Euclidean)],
)

= 描述逻辑 (Description Logic)

== $cal("ALC")$

$cal("ALC")$ (Attribute Logic with Complement), 有时写作 $cal("ALC")$.

正式定义:

一个 $cal("ALC")$ 签名是一个三元组 $Sigma = (O, C, R)$, 其中:

- $O$ 是*对象名称*集合.
- $C$ 是*原子概念*集合.
- $R$ 是*关系符号*集合.

$cal("ALC")$ 公式称为概念 (Concept):

$ C ::= top | bot | A | not C | C union.sq C | C inter.sq C | forall r.C | exists r.C $

其中 $A in C$ 且 $r in R$.

符号含义可以参考下表:

#table(
  columns: 3,
  table.header[*描述逻辑*][*模态逻辑*][*集合论*],
  [$top$], [$p or not p$], [$U$],
  [$bot$], [$p and not p$], [$emptyset$],
  [$not X$], [$not phi$], [$U backslash X$],
  [$X_1 union.sq X_2$], [$phi_1 or phi_2$], [$X_1 union X_2$],
  [$X_1 inter.sq X_2$], [$phi_1 and phi_2$], [$X_1 inter X_2$],
  [$forall r.X$], [$square_r phi$], [${y | forall z: (y, z) in r arrow.r.double z in X}$],
  [$exists r.X$], [$diamond_r phi$], [${y | exists z: (y, z) in r text(" and ") z in X}$],
)

== 解释 (Interpretation)

=== 正式定义

令 $Sigma = (O, cal(C), cal(R))$ 为一个签名 (Signature).
$Sigma$ 上的一个解释 $cal(I)$ 是一个二元组 $(Delta, dot^cal(I))$, 其中:

- $Delta$ 是一个论域 (Domain), 即一个非空集合
- $dot^cal(I)$ 将 $O$ 映射到 $Delta$, 即对于任意 $o in O$, 有 $o^cal(I) in Delta$
- $dot^cal(I)$ 将 $cal(C)$ 映射到 $2^Delta$, 即对于任意 $C in cal(C)$, 有 $C^cal(I) subset.eq Delta$
- $dot^cal(I)$ 将 $cal(R)$ 映射到 $2^(Delta times Delta)$, 即对于任意 $r in cal(R)$, 有 $r^cal(I) subset.eq Delta times Delta$

此外, 除非 $o_1 = o_2$, 否则 $o_1^cal(I) eq.not o_2^cal(I)$.

论域 $Delta$ 是一个对象空间. $O$ 包含对象 (Objects) 的名称, 可以通过 $dot^cal(I)$ 函数映射到实际对应的对象. 比如 $"Ann"^cal(I)$ 就表示名为 "Ann" 的对象, 其中 $"Ann" in O$.

== TBox 和 ABox

一个 DL 知识库 (Knowledge Base, KB) 是一个二元组 $K = (T, A)$, 其中:

- $T$: TBox (Terminological Box), 概念之间的关系 (Subsumptions). 比如:

  - $italic("parent") subset.eq.sq italic("person")$ (包含关系)
  - $italic("father") equiv italic("parent") inter.sq italic("male")$ (等价关系)

- $A$: ABox (Assertional Box), 包含概念断言 (Concept Assertion) 和角色断言 (Role Assertion). 比如:

  - $italic("Ann"): italic("parent")$ (概念断言)
  - $(italic("Ann"), italic("Charlie")): "hasChild"$ (角色断言)

== Tableaux 方法

Tableaux 方法可用于检查 ALC 无环知识库的一致性 (Consistency).

知识库有环, 当且仅当 TBox 中存在某个原子概念, 其定义直接或间接引用了该概念自身.

该方法有以下 6 个步骤:

+ *消除包含关系*

  通过引入新的原子概念, 将原本的包含关系变为等价关系. 比如:

  $"WhiteHorse" subset.eq.sq "Horse" => "WhiteHorse" equiv "Horse" inter.sq "WhiteHorse"^*$

  其中 $"WhiteHorse"^*$ 可能表示白色的东西.

+ *展开 TBox*
+ *消除 ABox 中的定义概念*

  简单说就是将 TBox 里概念的定义带入 ABox, 得到 $A^"e"$.

+ *ABox 转为否定范式 (Negation Normal Form, NNF)*

  将上一步得到的 $A^"e"$ 根据下面规则进行替换:

  - $not top$ 替换为 $bot$
  - $not bot$ 替换为 $top$
  - $not not X$ 替换为 $X$
  - $not (X inter.sq Y)$ 替换为 $not X union.sq not Y$
  - $not (X union.sq Y)$ 替换为 $not X inter.sq not Y$
  - $not forall r.X$ 替换为 $exists r. not X$
  - $not exists r.X$ 替换为 $forall r. not X$

  直到无法再进行替换, 得到 $A^"en"$.

+ *应用完备规则*

  对 ABox 不断*按顺序*应用完备化规则 (Completion Rules) 来构建树:

  + *冲突规则*: 如果 $o: X$ 且 $o: not X$, *则*添加 $o: bot$
  + *$inter.sq$ 规则*: 如果 $o: X inter.sq Y$, *则*添加 $o: X$  和 $o: Y$
  + *$exists$ 规则*: 如果 $o_1: exists r.X$, *则*创建新对象 $o_2$, 添加 $(o_1, o_2): r$ 和 $o_2: X$
  + *$forall$ 规则*: 如果 $o_1: forall r.X$ 且 $(o_1, o_2): r$, *则*添加 $o_2: X$
  + *$union.sq$ 规则*: 如果 $o: X union.sq Y$, *则*创建分支, 分别添加 $o: X$ 和 $o: Y$ // FIXME

  除此之外, 全部规则还存在一个限制, 即如果要添加的内容已经存在, 则不能继续应用该规则, 否则可能导致无意义的无限循环. // FIXME

  *按顺序应用是为了减少不必要的计算*, 并不影响结果的正确性. 比如:

  - 冲突规则应该被首先考虑: 因为如果产生矛盾, 则其派生节点也必然产生矛盾. 因此可以提前剪枝, 减少不必要的计算.
  - $union.sq$ 规则应该被最后考虑: 因为其需要创建分支, 而过早的创建分支会增加不必要的运算.

  该步骤本质上是拆解复杂的公式, 使其变为多个简单的公式, 从而使其中的矛盾变得显而易见. 比如 $o: A inter.sq not A$ 可以拆分为 $o: A$ 和 $o: not A$.

  由于节点内容会存在大量重复, 因此考试期间允许为已有的节点添加名称 (如 $(1)$), 并在子节点中使用 $(1) union ...$ 复用父节点的内容.

+ *检查叶节点*

  检查叶节点是否存在矛盾, 即是否存在形如 $o: bot$ 的矛盾断言. 只要有单个叶节点不矛盾, 该知识库就是一致的.

== 复杂度 (Complexity)

$ "PTIME (P)" subset.eq "NPTIME (NP)" subset.eq "PSPACE" subset.eq "EXPTIME" subset.eq "EXPSPACE" $

值得注意的是, SPACE 总是包含同级别的 TIME, 这是因为一个单位时间最多只能读或写单个单位空间. 虽然分配空间的速率可以超过时间复杂度, 但是只分配不读写的空间是无意义的.

其中, $cal("ALC")$ 一致性检查的时间复杂度为 PSPACE-complete. $cal("ALC")$ 具备完全布尔封闭性, 其存在两类变体:

- 对 $cal("ALC")$ 进行裁剪, 降低复杂度, 提高实用性. 比如复杂度属于 $P$ 的 EL 语言.
- 对 $cal("ALC")$ 进行扩展, 提升其复杂度, 增加表达能力.

课件中提供了一个网站 #link("https://www.cs.man.ac.uk/~ezolin/dl/")[Complexity of reasoning in Description Logics] 可以查询许多 ALC 方言的复杂度.

== 翻译

=== 基础逻辑连接词

#table(
  columns: 4,
  table.header[*关键词*][*符号*][*例句*][*翻译*],
  [And, who is, that is], [$inter.sq$], [A person *who* works at a university...], [$"Person" inter.sq dots$],
  [Or, either... or], [$union.sq$], [Either a director *or* is directed by...], [$"Director" union.sq dots$],
  [Not, non-], [$not$], [An owner who is *not* a person.], [$dots exists "hasOwner".(not "Person")$],
  [Neither... nor...], [$not (... union.sq ...)$], [Neither a dog *nor* a cat.], [$not ("Dog" union.sq "Cat")$],

  [...and... (集合并列)],
  [$union.sq$ 或 $inter.sq$],
  [Dogs *and* cats that are pets.],
  [$("Dog" union.sq "Cat") inter.sq "Pet"$],
)

=== 存在量词

#table(
  columns: 4,
  table.header[*句式模式*][*ALC 结构*][*例句*][*翻译*],

  [*A ... who verbs a ...*],
  [$A inter.sq exists "verb".B$],
  [A *dog that teaches*...],
  [$"Dog" inter.sq exists "teaches".dots$],

  [*...directed by a...*],
  [$exists "directedBy".dots$],
  [A movie *directed by* a person...],
  [$"Movie" inter.sq exists "directedBy"."Person"$],

  [*...at least one...*], [$exists r.dots$], [Teaches *at least one* module.], [$exists "teaches"."Module"$],
  [*...has a...*], [$exists "has" dots$], [A person who *has a* pet...], [$"Person" inter.sq exists "hasPet".dots$],
)

=== 全称量词

#table(
  columns: 4,
  table.header[*句式模式*][*ALC 结构*][*例句*][*翻译*],

  [*...only...*], [$forall r.C$], [An object that *only* has genres that are horror.], [$forall "hasGenre"."Horror"$],

  [*teaches only (N) that are (Adj)*],
  [$forall r.(N inter.sq A)$],
  [Teaches *only* modules that are easy.],
  [$forall "teaches".("Module" inter.sq "Easy")$],
)

=== 特殊概念

#table(
  columns: 4,
  table.header[*关键词*][*符号*][*ALC 结构*][*例句与翻译*],

  [Anything, Object], [$top$], [$exists r.top$], [*Owns at least one object.* \ $arrow exists "owns".top$],
  [Not ... anything],
  [$not exists dots$],
  [$not exists r.top$],
  [*Has not appeared in anything.* \ $arrow not exists "appearedIn".top$],

  [No ... (如 prerequisites)],
  [$bot$],
  [$forall r.bot$],
  [*Has no prerequisites.* \ $arrow forall "hasPrerequisite".bot$],
)

=== 包含关系

#table(
  columns: 3,
  table.header[*模式*][*含义*][*例句翻译*],

  [$A subset.eq.sq B$],
  [所有的 A 也是 B],
  [*Every person has a parent.* \ $arrow "Person" subset.eq.sq exists "hasParent".top$],

  [$A equiv B$],
  [A 的定义等同于 B],
  [*A parent is a person that has a child.* \ $arrow "Parent" equiv "Person" inter.sq exists "hasChild".top$],
)

=== 嵌套结构拆解示例

*例句:* "A module taught by a lecturer who teaches only modules that are easy."

#table(
  columns: 3,
  table.header[*层级*][*英文片段*][*对应 ALC*],
  [*第一层 (外)*], [A module taught by...], [$"Module" inter.sq exists "taughtBy".(dots)$],
  [*第二层 (中)*], [...a lecturer who teaches only...], [$"Lecturer" inter.sq forall "teaches".(dots)$],
  [*第三层 (内)*], [...modules that are easy.], [$"Module" inter.sq "Easy"$],
  [*组合结果*],
  [*整句*],
  [$"Module" inter.sq exists "taughtBy".("Lecturer" inter.sq forall "teaches".("Module" inter.sq "Easy"))$],
)

= 考试

下面是对 2020, 2021, 2022 年试卷各知识点分数占比的统计结果:

#figure(caption: [考试知识点分数占比])[
  #image("imgs/exam_percentage.svg", width: 70%)
]

其中:
- 2024 年第 3 题 (c) (e) 小题的答案均存在错误, 分别将 $T''$ 和 $T'''$ 写成了 $T'$ 和 $T'$.
- 2022 年第 2 题 (b) 小题的题目存在错误, 缺少了一个量词.
- 2019 年第 2 题的题目存在错误, $cal(A)$ 和 $cal(T)$ 写反了. 答案里没有写反, 所以说明题目确实是写错了

怎么会这个样子呢? 😅

考试是 5 题选答 4 题, 如果回答了 5 题, 最低分的题的分数则会被抛弃. 因此建议先审阅试卷题目, 挑选自己最拿手的 4 道题先回答. 如果剩余时间充足, 可以再考虑完成剩余的 1 题.

+ *Q1: 命题逻辑与翻译*
  - 真值表 (Truth Tables)
  - 英译模态逻辑 (English to Modal)
  - 模态/描述逻辑互译与回译
  - 概念包含关系 (Subsumptions)

+ *Q2: 单主体模态逻辑*
  - 有效性检测与反例构造 (Validity & Counter-models)
  - K 系统推理证明 (Proofs in System K)
  - 代换实例 (Substitution Instances)

+ *Q3: 多主体模态逻辑*
  - 模型形式化定义 (Formal Description)
  - 多主体模型检测 (Model Checking)
  - 区分公式 (Distinguishing Formulas)

+ *Q4: 描述逻辑 (Tableaux 算法)*
  - *Tableaux 6步法* (核心拿分点)
  - 扩展规则 ($exists$, $forall$)
  - 一致性/矛盾检测 (Consistency Check)

+ *Q5: 认知逻辑 (S5与公共宣告)*
  - 帽子谜题建模 (Hat Puzzles)
  - 公共宣告逻辑 (PAL)
  - 模型更新与图形重绘 (Model Updates)

= 术语表

#figure(caption: [Class Test 1 术语表])[
  #table(
    columns: 2,
    table.header[*中文术语*][*英文术语*],
    [formula], [公式],
    [inference], [推理],
    [premise], [前提],
    [conclusion], [结论],
  )
]

#figure(caption: [Part 1 术语表])[
  #table(
    columns: 2,
    table.header[*中文术语*][*英文术语*],
    [命题逻辑 (PL)], [Propositional Logic (PL)],
    [模态逻辑 (ML)], [Modal Logic (ML)],
    [认知逻辑 (EL)], [Epistemic Logic (EL)],
    [描述逻辑 (DL)], [Description Logic (DL)],
  )
]

#figure(caption: [Part 2 术语表])[
  #table(
    columns: 2,
    table.header[*中文*][*英文*],
    [逻辑], [logic],
    [演绎系统], [deduction system],
    [语言], [language],
    [语义], [semantics],
    [良构公式], [well-formed formula (wff)],
    [命题逻辑], [propositional logic],
    [联结词], [connective],
    [原子命题], [atom],
    [公式生成], [formation rules],
    [括号与约定], [notation conventions],
    [否定], [negation],
    [合取], [conjunction],
    [析取], [disjunction],
    [蕴涵], [implication],
    [双条件], [bi-implication],
    [真值表], [truth table],
  )
]

= 辅导

== Propositional Logic

=== Exercise 1.1

a, b, d, e, g.

=== Exercise 1.2

#truth-table(inputs: ($phi_1$, $phi_2$), outputs: (($phi_1 "XOR" phi_2$, (0, 1, 1, 0)),))

=== Exercise 1.3

+ #truth-table(inputs: ($p$, $q$), outputs: (($(p -> q) <-> p$, (0, 0, 0, 1)),))

+ #truth-table(inputs: ($p$,), outputs: (($(p and not p) -> p$, (0, 1)),))

+ #truth-table(
    inputs: ($p$, $q$, $r$),
    outputs: (($((p and q) or (p and r)) <-> (p and (q or r))$, (1, 1, 1, 1, 1, 1, 1, 1)),),
  )

+ #truth-table(
    inputs: ($p$, $q$, $r$),
    outputs: (($((p or q) and (p or r) <-> (p or (q and r)))$, (1, 1, 1, 1, 1, 1, 1, 1)),),
  )

=== Exercise 1.4

即 $not (phi_1 or phi_2)$.

#truth-table(
  inputs: ($phi_1$, $phi_2$),
  outputs: (($not (phi_1 or phi_2)$, (1, 0, 0, 0)),),
)

=== Exercise 2.1

+ #truth-table(
    inputs: ($p$, $q$),
    outputs: (($p -> (q -> p)$, (1, 1, 1, 1)),),
  )

  该公式是有效的.

+ #truth-table(
    inputs: ($p$, $q$),
    outputs: (($p -> (p -> q)$, (1, 1, 0, 1)),),
  )

  该公式是无效的.

+ #truth-table(
    inputs: ($p$, $q$),
    outputs: (($p or not q$, (1, 0, 1, 1)),),
  )

  该公式是无效的.

+ #truth-table(
    inputs: ($p$, $q$),
    outputs: (($(p -> q) or (q -> p)$, (1, 1, 1, 1)),),
  )

  该公式是有效的.

=== Exercise 2.2

+ ${not q, p -> q} models not p$

  #truth-table(
    inputs: ($p$, $q$),
    outputs: (($not q$, (1, 0, 1, 0)), ($p -> q$, (1, 1, 0, 1)), ($not p$, (1, 1, 0, 0))),
  )

  仅当 $p$ 和 $q$ 均为 $0$ 时, 所以前提为真, 且结论也为真, 因此公式为*真*.

+ ${not p, p -> q} models not q$

  #truth-table(
    inputs: ($p$, $q$),
    outputs: (($not p$, (1, 1, 0, 0)), ($p -> q$, (1, 1, 0, 1)), ($not q$, (1, 0, 1, 0))),
  )

  因为 $p$ 为 $0$, $q$ 为 $1$ 时存在反例, 所以公式为*假*.

+ ${p, p -> q, not r -> not q} models r$

  #truth-table(
    inputs: ($p$, $q$, $r$),
    outputs: (
      ($p$, (0, 0, 0, 0, 1, 1, 1, 1)),
      ($p -> q$, (1, 1, 1, 1, 0, 0, 1, 1)),
      ($not r -> not q$, (1, 1, 0, 1, 1, 1, 0, 1)),
      ($r$, (0, 1, 0, 1, 0, 1, 0, 1)),
    ),
  )

  仅当 $p$, $q$ 和 $r$ 均为 $1$ 时, 所以前提为真, 且结论也为真, 因此公式为*真*.

+ ${p or q, p -> r, q -> r} models r$

  #truth-table(
    inputs: ($p$, $q$, $r$),
    outputs: (
      ($p or q$, (0, 0, 1, 1, 1, 1, 1, 1)),
      ($p -> r$, (1, 1, 1, 1, 0, 1, 0, 1)),
      ($q -> r$, (1, 1, 0, 1, 1, 1, 0, 1)),
      ($r$, (0, 1, 0, 1, 0, 1, 0, 1)),
    ),
  )

  所有前提为真的情况下, 结论也为真, 因此公式为*真*.

=== Exercise 2.3

+ 每个公式都是一个公理.
+ 没有任何公理和推导规则.

=== Exercise 2.4

#image("imgs/exercise_2.4.png")

=== Exercise 2.5

#image("imgs/exercise_2.5.png")

=== Exercise 3.1

根据真值表可以得到下面析取范式 (Disjunctive Normal Form, DNF):

$
  (not phi_1 and not phi_2 and not phi_3) or
  (not phi_1 and phi_2 and not phi_3) or
  (not phi_1 and phi_2 and phi_3) or
  (phi_1 and phi_2 and not phi_3)
$

$
  (not phi_1 and not phi_3) or
  (not phi_1 and phi_2 and phi_3) or
  (phi_1 and phi_2 and not phi_3)
$

#blockquote[
  德摩根定律 (De Morgan's Laws) 的定律二为 $not (p or q) <-> (not p and not q)$, 两侧取反即可得到题目中给出的 $p or q <-> not (not p and not q)$.
]

在通过题目中给出的德摩根定律 ($p or q$ can be defined as $not (not p and not q)$) 进行展开, 可以得到最终结果:

$
  not (not (not (not (not phi_1 and not phi_2 and not phi_3) and not (not phi_1 and phi_2 and not phi_3))) and \
    not (not (not (not phi_1 and phi_2 and phi_3) and not (phi_1 and phi_2 and not phi_3))))
$

=== Exercise 3.2

Exercise 3.1 已经提及 ${not, and}$ 是真值函数完备的.

可以很容易的从真值表中看出:

- $not p$ 即 $p arrow.t p$.
- $p and q$ 即 $not (p arrow.t q) <-> (p arrow.t q) arrow.t (p arrow.t q)$.

然后补全下面算子:

- $p or q$ 即

  $
    & not (not p and not q) \
    & <-> not (
        (not p arrow.t not q) arrow.t (not p arrow.t not q)
      ) \
    & <-> not (
        ((p arrow.t p) arrow.t (q arrow.t q)) arrow.t ((p arrow.t p) arrow.t (q arrow.t q))
      ) \
    & <-> ((p arrow.t p) arrow.t (q arrow.t q)) arrow.t ((p arrow.t p) arrow.t (q arrow.t q))
      arrow.t
      ((p arrow.t p) arrow.t (q arrow.t q)) arrow.t ((p arrow.t p) arrow.t (q arrow.t q)) \
  $

- $p -> q$ 即

  $
    & p or (p and q) \
    & <-> p or ((p arrow.t q) arrow.t (p arrow.t q)) \
    & <-> ((p arrow.t p) arrow.t (q arrow.t q)) arrow.t ((p arrow.t p) arrow.t (q arrow.t q)) arrow.t ((p arrow.t p) arrow.t (q arrow.t q)) arrow.t ((p arrow.t p) arrow.t (q arrow.t q))
  $

  $
    & not (p and not q) \
    & <-> not (p and (q arrow.t q)) \
    & <-> not ((p arrow.t (q arrow.t q)) arrow.t (p arrow.t (q arrow.t q))) \
    & <-> ((p arrow.t (q arrow.t q)) arrow.t (p arrow.t (q arrow.t q)))
      arrow.t
      ((p arrow.t (q arrow.t q)) arrow.t (p arrow.t (q arrow.t q))) \
  $

  FIXME

- $p <-> q$ 即

  $
    & p -> q and q -> p \
    & <->
  $

  FIXME

== Description Logic

#set enum(numbering: "a.")

=== Exercise 1.1

+ $italic("mother") inter.sq exists "hasChild".italic("parent")$
+ $italic("person") inter.sq exists "hasChild".italic("female") inter.sq exists "hasChild".italic("male")$
+ $italic("dog") inter.sq exists "hasOwner".italic("parent")$
+ $italic("person") inter.sq forall "hasPet".(italic("dog") union.sq italic("canis_lupus"))$#footnote[Canvas 给出的答案使用了 $or$, 但此处要求使用 $cal("ALC")$ 所以并不严谨.]
+ $italic("mother") inter.sq forall "hasChild".bot$
+ $italic("dog") inter.sq exists "hasChild".top$

=== Exercise 1.2

+ Every _dog_ is a _canis_.
+ A _dog_ is the same as _canis_familiaris_.
+ Every _wolf_ is not a _person_.
+ A _grandparent_ is the same as a _person_ who has a _child_ that is a _parent_.

=== Exercise 1.3

+ $"Rover" : italic("dog")$
+ $italic("dog") subset.eq.sq italic("mammal")$
+ $italic("dog") inter.sq exists "hasOwner".italic("mammal")$
+ $italic("dog") inter.sq forall "hasOwner".italic("mammal")$
+ $"Alice" : exists "owns".(italic("pet") inter.sq italic("dog"))$
+ $("Alice", "Rover"): "owns"$
+ $italic("pet") subset.eq.sq italic("animal") inter.sq exists "hasOwner".top$
+ $italic("pet") equiv italic("animal") inter.sq exists "hasOwner".top$
+ $italic("pet") equiv italic("animal") inter.sq exists "hasOwner".top$
+ $italic("pet") subset.eq.sq italic("animal") inter.sq exists "hasOwner".top$
+ $italic("pet") equiv italic("animal") inter.sq exists "hasOwner".top$
+ $(italic("dog") union.sq italic("human")) inter.sq exists "hasOwner".italic("dog")$ // FIXME
+ $italic("dog") inter.sq forall "hasOwner".bot$
+ $"Rover": italic("dog") inter.sq forall "hasOwner".bot$
+ $italic("dog") subset.eq.sq exists "hasOwner".top$
+ $("Rover", "Alice"): "hasOwner"$
+ $"Rover": exists "hasOwner".top$

=== Exercise 1.4

+ SKIP
+ ${z}$
+ ${y, z}$#footnote[Canvas 给出的答案认为是 $emptyset$, 解答中将 $union.sq$ 转换为了集合操作的 $inter$, 显然是错了.]

  $
    (exists "hasOwner".top)^I = {z} \
    ("parent" union.sq exists "hasOwner".top)^I = {y} union {z} = {y, z}
  $

+ ${x, y}$#footnote[Canvas 给出的答案认为是 ${x, y, z}$, 不知所云.]

  $
    (not "parent")^I = Delta backslash "parent"^I = {x, z} \
    (forall "hasOwner".not "parent")^I = {x, y, z} \
    (exists "hasPet" . forall "hasOwner".not "parent")^I = {x, y}
  $

+ $I notmodels ...$
+ $I models ...$
+ $I models ...$
+ $I notmodels ...$
+ $I notmodels ...$

=== Exercise 1.5

+ - $Delta = {x, y, z, u}$
  - $italic("Ann")^I = {u}$
  - $italic("Fido")^I = {x}$
  - $italic("dog")^I = {x}$
  - $italic("canis")^I = {y, u}$
  - $italic("canis_lupus")^I = {y}$
  - $italic("loyal_pet")^I = {x}$
  - $italic("canis_familiaris")^I = {x}$
  - $"hasOwner"^I = {(x, z)}$
+ - $italic("dog")^I = italic("canis_familiaris")^I = {x} => I models italic("dog") equiv italic("canis_familiaris")$
  - $italic("canis_familiaris") subset.eq.not italic("canis") => I notmodels italic("canis_familiaris") subset.eq.sq italic("canis")$
  - $I notmodels italic("wolf") equiv italic("canis_lupus")$
  - $italic("canis_lupus")^I subset.eq italic("canis")^I => I models italic("canis_lupus") subset.eq.sq italic("canis")$
  - $italic("loyal_pet")^I subset.eq (italic("dog")^I inter (exists "hasOwner".top)^I) => I models italic("loyal_pet") subset.eq.sq italic("dog") inter.sq exists "hasOwner".top$
