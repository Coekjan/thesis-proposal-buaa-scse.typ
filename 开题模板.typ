#import "utils/bilingual-bibliography.typ": *

#import "@preview/cuti:0.2.1": show-cn-fakebold
#import "@preview/indenta:0.0.3": fix-indent
#import "@preview/pointless-size:0.1.0": zh

/// For internal use only.
#let __shared_impl(
  文档类型: "",
  论文信息: (:),
  body,
) = {
  let (
    论文题目,
    专业,
    研究方向,
    研究生,
    学号,
    指导教师,
    参考文献,
  ) = 论文信息

  set document(author: 研究生, title: "毕业论文开题（" + 文档类型 + "）")
  set text(size: zh(-4), lang: "zh", font: ("Times New Roman", "SimSun"))
  set page(number-align: center, margin: (x: 3.17cm, y: 3.4cm))

  // Front matter
  {
    show: show-cn-fakebold

    v(0.5fr)

    align(center, text(size: zh(-2), font: ("Times New Roman", "KaiTi"))[*北京航空航天大学计算机学院*])

    v(1fr)

    align(center, text(size: zh(1), font: ("Times New Roman", "SimHei"))[
      *硕士研究生学位论文*

      *#文档类型*
    ])

    v(1fr)

    align(center, {
      set text(size: zh(-3), font: ("Times New Roman", "KaiTi"))
      let item(body) = strong[
        #body.clusters().map(it => [#it]).join(h(1fr))：
      ]
      let content(body) = table.cell(stroke: (bottom: 1pt), body)

      table(
        stroke: none,
        columns: (6em, 20em),
        item("论文标题"), content(论文题目),
        item("专业"), content(专业),
        item("研究方向"), content(研究方向),
        item("研究生"), content(研究生),
        item("学号"), content(学号),
        item("指导教师"), content(指导教师),
      )
    })

    v(1fr)

    align(center, text(size: zh(3), font: ("Times New Roman", "SimHei"))[*北京航空航天大学计算机学院*])

    v(0.25fr)

    align(center, text(size: zh(-3), font: ("Times New Roman", "SimHei"), datetime.today().display("[year] 年 [month] 月 [day] 日")))
  }

  // Basic settings for the outline & main body
  let header = [
    #set text(size: zh(-5), font: ("Times New Roman", "KaiTi"))
    论文题目：#论文题目
    #line(length: 100%)
  ]
  let footer(numbering: "1") = context [
    #set text(size: zh(-5), font: ("Times New Roman", "KaiTi"))
    #line(length: 100%)
    北京航空航天大学计算机学院硕士学位论文#文档类型#h(1fr)#sym.bullet~~#counter(page).display(numbering)~~#sym.bullet
  ]

  set text(top-edge: 0.7em, bottom-edge: -0.3em)
  set page(header: header, footer: footer(numbering: "i"))
  set par(leading: 0.5em, spacing: 0.5em, first-line-indent: 2em, justify: true)
  set heading(numbering: "1.1.1")

  show heading: set block(above: 1.4em, below: 1em)
  show heading: set text(font: ("Times New Roman", "SimHei"), weight: 100)
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    it
  }
  show heading.where(level: 1): set text(size: zh(-3))
  show heading.where(level: 2): set text(size: zh(4))
  show heading.where(level: 3): set text(size: zh(-4))
  show figure.where(kind: image): set figure.caption(position: bottom)
  show figure.where(kind: table): set figure.caption(position: top)

  counter(page).update(1)

  // Settings for outline
  set outline(depth: 3, indent: true)
  show outline: set align(center)
  show outline.entry: it => if it.level == 1 {
    strong(it)
  } else {
    it
  }

  let outline-title(s) = text(size: zh(-2), s.clusters().intersperse(h(2em)).join())
  outline(title: outline-title("目录"))
  context {
    if query(figure.where(kind: image)).len() > 0 {
      outline(title: outline-title("图目"), target: figure.where(kind: image))
    }
    if query(figure.where(kind: table)).len() > 0 {
      outline(title: outline-title("表目"), target: figure.where(kind: table))
    }
  }

  // Settings for main body
  set page(header: header, footer: footer(numbering: "1"))
  set ref(supplement: it => if it.func() != heading {
    it.supplement
  })

  show: fix-indent() // workaround for https://github.com/typst/typst/issues/311

  counter(page).update(1)

  body

  // Settings for bibliography
  show heading.where(level: 1): set align(center)

  bilingual-bibliography(
    title: "主要参考文献",
    style: "/gb-7714-2015-numeric.csl",
    bibliography: bibliography.with(参考文献),
  )
}

#let 文献综述(
  论文信息: (:),
  body,
) = __shared_impl(
  文档类型: "文献综述",
  论文信息: 论文信息,
  body,
)

#let 开题报告(
  论文信息: (:),
  body,
) = __shared_impl(
  文档类型: "开题报告",
  论文信息: 论文信息,
  body,
)
