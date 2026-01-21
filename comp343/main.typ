#import "@preview/ilm:1.4.2": *
#import "@preview/mannot:0.3.1": *

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#show: codly-init
#codly(languages: codly-languages)

#set text(lang: "zh")

#set text(font: ("New Computer Modern", "Source Han Serif SC"))

#show: ilm.with(
  title: "计算机取证笔记",
  author: "ShenMian",
  abstract: [
    本文为计算机取证 (#link("https://tulip.liv.ac.uk/mods/student/cm_COMP343_202526.htm")[COMP343], University of Liverpool) 的课程笔记.
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

*讲师*: #link("https://www.liverpool.ac.uk/people/mohamed-ghanem")[Dr Mohamed Chahine Ghanem] <#link("mailto: Mohamed.Chahine.Ghanem@liverpool.ac.uk")>

== 阅读清单

- #link(
    "https://liverpool.primo.exlibrisgroup.com/permalink/44LIV_INST/1dg072n/alma991018279209707351",
  )[Fundamentals of digital forensics theory, methods, and real-life applications - Joakim Kävrestad]

  附带 #link("https://www.youtube.com/playlist?list=PLEjQDf4Fr75pBnu8WArpeZTKC9-LrYDTl")[YouTube 视频].

- #link(
    "https://liverpool.primo.exlibrisgroup.com/permalink/44LIV_INST/1dg072n/alma991023660677307351",
  )[Digital Forensics Explained - Greg Gogolin]

这两本书目前均*无中译本*.

== 分数构成

#figure(caption: [分数构成])[
  #table(
    columns: 4,
    table.header[*名称*][*分数*][*类型*][*时间*],
    [CA1 (Technical Report)], [25%], [作业], [2026 年 3 月 20 日 (周五) 17:00],
    [CA2 (Research Essay)], [15%], [作业], [2026 年 5 月 7 日 (周四) 17:00],
    [Final Exam], [60%], [MCQ], [],
  )
]

== 辅导

=== Tutorial 1

默认用户名和密码为: `csi`.

#figure(caption: [运行在 VMware 中的 CSI Linux])[
  #image("imgs/tutorial_1.png", width: 70%)
]
