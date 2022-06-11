
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cleanrmd

<!-- badges: start -->

[![cleanrmd status
badge](https://gadenbuie.r-universe.dev/badges/cleanrmd)](https://gadenbuie.r-universe.dev)
[![CRAN
status](https://www.r-pkg.org/badges/version/cleanrmd)](https://CRAN.R-project.org/package=cleanrmd)
[![R-CMD-check](https://github.com/gadenbuie/cleanrmd/actions/workflows/check-standard.yaml/badge.svg)](https://github.com/gadenbuie/cleanrmd/actions/workflows/check-standard.yaml)
<!-- badges: end -->

**cleanrmd** is a no-frills, lightweight HTML format for R Markdown,
using class-less CSS.

This package was greatly inspired by Yuval Greenfield’s blog post: [The
Next CSS Frontier -
Classless](https://blog.usejournal.com/the-next-css-frontier-classless-5e66f3f25fdd).

## Installation

You can install the released version of cleanrmd from CRAN:

``` r
install.packages("cleanrmd")
```

You can install the latest development version from
[GitHub](https://github.com/gadenbuie/cleanrmd/):

``` r
# install.packages("remotes")
remotes::install_github("gadenbuie/cleanrmd")
```

or from [gadenbuie.r-universe.dev](https://gadenbuie.r-universe.dev/):

``` r
options(repos = c(
  gadenbuie = 'https://gadenbuie.r-universe.dev',
  CRAN = 'https://cloud.r-project.org'
))

install.packages('cleanrmd')
```

## Usage

### cleanrmd::html_document_clean

Create a new R Markdown document using the *Clean HTML R Markdown*
template in RStudio, or add the following to your `.Rmd` YAML header.

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

**Syntax highlighting** is provided by default by pandoc, where syntax
highlighting is performed during during the render, minimizing
dependencies. pandoc’s highlighting themes include `pygments`, `tango`,
`espresso`, `zenburn`, `kate`, `monochrome`, `breezedark`, and
`haddock`. The `default` highlighting theme is `arrow`, provided by the
[rmarkdown](https://rmarkdown.rstudio.com/docs/) package in addition to
the `rstudio` theme.

`html_document_clean()` can also use [Prism](https://prismjs.com/) for
highlighting. In this case, highlighting is performed in the browser and
the dependencies are downloaded as needed. To use Prism, set
`theme: prism` or use one of the following value to choose a specific
Prism theme: `prism-coy`, `prism-dark`, `prism-funky`, `prism-okaidia`,
`prism-solarizedlight`, `prism-tomorrow`, and `prism-twilight`.

**MathJax and FontAwesome** are also available but disabled by default.
To enable either feature, you can set `mathjax` to `local` or `default`,
as in `rmarkdown::html_document()`. Set `use_fontawesome` to `TRUE` to
enable Font Awesome icons.

``` yaml
output: 
  cleanrmd::html_document_clean:
    mathjax: default
    use_fontawesome: true
```

### Just the theme

You can also load the CSS theme dependencies in other places where
[htmltools](https://rstudio.github.io/htmltools/) can be used to provide
HTML dependencies, such as Shiny apps.

To include a theme in your app or page, use

``` r
cleanrmd::use_cleanrmd(theme = "new.css")
```

To view the list of theme options view the help pages of
`?cleanrmd_themes()` or use its output:

``` r
cleanrmd::cleanrmd_themes()
#>  [1] "almond"            "awsm.css"          "axist"            
#>  [4] "bamboo"            "bullframe"         "holiday"          
#>  [7] "kacit"             "latex.css"         "markdown-splendor"
#> [10] "markdown-retro"    "markdown-air"      "markdown-modest"  
#> [13] "marx"              "minicss"           "new.css"          
#> [16] "no-class"          "picocss"           "sakura"           
#> [19] "sakura-vader"      "semantic"          "simplecss"        
#> [22] "style-sans"        "style-serif"       "stylize"          
#> [25] "superstylin"       "tacit"             "vanilla"          
#> [28] "water"             "water-dark"        "writ"
```

## Themes

The following CSS themes are included in this package and you can
preview [all 30 themes in one place
here](https://gadenbuie.github.io/cleanrmd/index.html).

-   [almond](https://github.com/alvaromontoro/almond.css)
-   [awsm.css](https://igoradamenko.github.io/awsm.css/)
-   [axist](https://ruanmartinelli.github.io/axist/)
-   [bamboo](https://rilwis.github.io/bamboo/)
-   [bullframe](https://marcopontili.com/projects/bullframe-css)
-   [holiday](https://evgenyorekhov.github.io/holiday.css/)
-   [kacit](https://kimeiga.github.io/kacit/)
-   [latex.css](https://github.com/vincentdoerig/latex-css)
-   [markdown-splendor](http://markdowncss.github.io/splendor/)
-   [markdown-retro](http://markdowncss.github.io/retro/)
-   [markdown-air](http://markdowncss.github.io/air/)
-   [markdown-modest](http://markdowncss.github.io/modest/)
-   [marx](https://mblode.github.io/marx/)
-   [minicss](https://minicss.org/)
-   [new.css](https://newcss.net/)
-   [no-class](https://davidpaulsson.github.io/no-class/)
-   [picocss](https://picocss.com/)
-   [sakura](https://oxal.org/projects/sakura/)
-   [sakura-vader](https://oxal.org/projects/sakura/)
-   [semantic](https://dimitrinicolas.github.io/semantic.css/)
-   [simplecss](https://simplecss.org/)
-   [style-sans](https://ungoldman.com/style.css/)
-   [style-serif](https://ungoldman.com/style.css/)
-   [stylize](https://gadenbuie.github.io/stylize.css/)
-   [superstylin](https://caiogondim.github.io/superstylin/)
-   [tacit](https://yegor256.github.io/tacit/)
-   [vanilla](https://vanillacss.com/)
-   [water](https://kognise.github.io/water.css/)
-   [water-dark](https://kognise.github.io/water.css/)
-   [writ](https://writ.cmcenroe.me/)
