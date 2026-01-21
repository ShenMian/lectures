#import "@preview/ilm:1.4.2": *
#import "@preview/mannot:0.3.1": *

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#show: codly-init
#codly(languages: codly-languages)

#set text(lang: "zh")

#set text(font: ("New Computer Modern", "Source Han Serif SC"))

#show: ilm.with(
  title: "计算机游戏开发高级专题笔记",
  author: "ShenMian",
  abstract: [
    本文为计算机游戏开发高级专题 (#link("https://tulip.liv.ac.uk/mods/student/cm_COMP342_202526.htm")[COMP342], University of Liverpool) 的课程笔记.
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

*讲师*: Dr K Tsakalidis <#link("mailto: K.Tsakalidis@liverpool.ac.uk")>

== 分数构成

#figure(caption: [分数构成])[
  #table(
    columns: 4,
    table.header[*名称*][*分数*][*类型*][*时间*],
    [CA1], [%], [作业], [2026 年 3 月 19 日 (周四) 17:00],
    [CA2], [%], [作业], [2026 年 4 月 23 日 (周四) 17:00],
    [Final Exam], [%], [], [],
  )
]
