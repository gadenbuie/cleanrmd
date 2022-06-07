# Clean R Markdown HTML Documents

<!-- badges: start -->
[![cleanrmd status badge](https://gadenbuie.r-universe.dev/badges/cleanrmd)](https://gadenbuie.r-universe.dev)
[![CRAN status](https://www.r-pkg.org/badges/version/cleanrmd)](https://CRAN.R-project.org/package=cleanrmd)
[![R-CMD-check](https://github.com/gadenbuie/cleanrmd/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/gadenbuie/cleanrmd/actions/workflows/R-CMD-check.yaml)
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

- [almond](https://github.com/alvaromontoro/almond.css)
- [awsm.css](https://igoradamenko.github.io/awsm.css/)
- [axist](https://ruanmartinelli.github.io/axist/)
- [bamboo](https://rilwis.github.io/bamboo/)
- [bullframe](https://marcopontili.com/projects/bullframe-css)
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
- [picocss](https://picocss.com/)
- [sakura](https://oxal.org/projects/sakura/)
- [sakura-vader](https://oxal.org/projects/sakura/)
- [semantic](https://dimitrinicolas.github.io/semantic.css/)
- [simplecss](https://simplecss.org/)
- [style-sans](https://ungoldman.com/style.css/)
- [style-serif](https://ungoldman.com/style.css/)
- [stylize](https://gadenbuie.github.io/stylize.css/)
- [superstylin](https://caiogondim.github.io/superstylin/)
- [tacit](https://yegor256.github.io/tacit/)
- [vanilla](https://vanillacss.com/)
- [water](https://kognise.github.io/water.css/)
- [water-dark](https://kognise.github.io/water.css/)
- [writ](https://writ.cmcenroe.me/)
