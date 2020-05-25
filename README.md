# Clean R Markdown HTML Documents

<!-- badges: start -->
<!-- badges: end -->

**cleanrmd** is a no-frills, lightweight HTML format for R Markdown, using class-less CSS. 

This package was greatly inspired by Yuval Greenfield's blog post: [The Next CSS Frontier - Classless](https://blog.usejournal.com/the-next-css-frontier-classless-5e66f3f25fdd).

## Installation

You can install the released version of **cleanrmd** from GitHub:

``` r
devtools::install_github("gadenbuie/cleanrmd")
```

## Usage

Create a new R Markdown document using the *Clean HTML R Markdown* template in RStudio, or add the following to your `.Rmd` YAML header.

``` yaml
output: 
  cleanrmd::html_document_clean:
    theme: no-class
```

To explore the available themes, set `theme` to `NULL`.

``` yaml
output: 
  cleanrmd::html_document_clean:
    theme: NULL
```

MathJax and FontAwesome are available but disabled by default. To enable either feature, you can set `mathjax` to `local` or `default`, as in `rmarkdown::html_document()`. Set `use_fontawesome` to `TRUE` to enable Font Awesome icons.

``` yaml
output: 
  cleanrmd::html_document_clean:
    mathjax: default
    use_fontawesome: true
```

## Themes

The following CSS themes are included in this package and you can preview [all the themes here](https://gadenbuie.github.io/cleanrmd/index.html).

- [awsm.css](https://igoradamenko.github.io/awsm.css/)
- [bahunya](https://kimeiga.github.io/bahunya/)
- [holiday](https://evgenyorekhov.github.io/holiday.css/)
- [kacit](https://kimeiga.github.io/kacit/)
- [latex.css](https://github.com/vincentdoerig/latex-css)
- [markdown-splendor](http://markdowncss.github.io/splendor/)
- [markdown-retro](http://markdowncss.github.io/retro/)
- [markdown-air](http://markdowncss.github.io/air/)
- [markdown-modest](http://markdowncss.github.io/modest/)
- [marx](https://mblode.github.io/marx/)
- [minicss](https://minicss.org/)
- [new.css](https://newcss.net/)
- [no-class](https://davidpaulsson.github.io/no-class/)
- [sakura](https://oxal.org/projects/sakura/)
- [sakura-vader](https://oxal.org/projects/sakura/)
- [style-sans](https://css-pkg.github.io/style.css/)
- [style-serif](https://css-pkg.github.io/style.css/)
- [stylize](https://gadenbuie.github.io/stylize.css/) (forked from [vasanthv/stylize.css](https://github.com/vasanthv/stylize.css))
- [tacit](https://yegor256.github.io/tacit/)
- [vanilla](https://vanillacss.com/)
- [water](https://kognise.github.io/water.css/)
- [water-dark](https://kognise.github.io/water.css/)
- [writ](https://writ.cmcenroe.me/)
