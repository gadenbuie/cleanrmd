#' Use a clean CSS theme from cleanrmd
#'
#' Provides a \pkg{cleanrmd} CSS theme using \pkg{htmltools}. You can use this
#' CSS theme anywhere that HTML dependencies are handled via
#' [htmltools::htmlDependency()], for example in R Markdown or Quarto documents
#' or in Shiny apps.
#'
#' @section R Markdown documents:
#'
#'   In [R Markdown](https://rmarkdown.rstudio.com/) (static or Shiny
#'   prerendered), you should use the [html_document_clean()] output format to
#'   use a cleanrmd theme.
#'
#'   ````markdown
#'   ---
#'   output:
#'     cleanrmd::html_document_clean:
#'       theme: NULL # or pick a specific theme
#'       self_contained: false
#'   ---
#'   ````
#'
#' @section Quarto documents:
#'
#'   You can also use \pkg{cleanrmd} in [Quarto](https://quarto.org/) documents
#'   or apps (using `server: shiny`). You'll need to turn off the themes
#'   provided by Quarto with `theme: none` and then call
#'   `cleanrmd::use_cleanrmd()` in a code chunk in your document.
#'
#'   ````markdown
#'   ---
#'   title: "Untitled"
#'   format:
#'     html:
#'       theme: none
#'   #server: shiny
#'   ---
#'
#'   ```{r cleanrmd, echo=FALSE}
#'   cleanrmd::use_cleanrmd("bamboo")
#'   ```
#'   ````
#'
#' @section Shiny apps:
#'
#'   In Shiny apps, you'll need to use [shiny::basicPage()] rather than
#'   [shiny::fluidPage()]. Then call `use_cleanrmd()` in your app to use a
#'   cleanrmd theme.
#'
#'   ````r
#'   library(shiny)
#'
#'   ui <- shiny::basicPage(
#'     cleanrmd::use_cleanrmd(),
#'
#'     h2("Old Faithful Geyser Data"),
#'
#'     sliderInput(
#'       "bins",
#'       "Number of bins:",
#'       min = 1,
#'       max = 50,
#'       value = 30
#'     ),
#'     plotOutput("distPlot")
#'   )
#'   ````
#'
#' @example man/examples/use_cleanrmd.R
#'
#' @param name The name of the theme, see [cleanrmd_themes()] for a list of
#'   available themes. If `NULL`, all themes will be loaded with a simple
#'   drop down theme picker.
#'
#' @return `use_cleanrmd()` returns an [htmltools::tagList()] with an
#'   [htmltools::htmlDependency()]. `cleanrmd_theme_dependency()` returns only
#'   the [htmltools::htmlDependency()].
#'
#' @describeIn use_cleanrmd Use a clean CSS theme in the current document or app
#'   (general usage)
#' @export
use_cleanrmd <- function(name = NULL) {
  htmltools::tagList(cleanrmd_theme_dependency(name))
}

#' @describeIn use_cleanrmd Use a clean CSS theme dependency (advanced usage)
#' @export
cleanrmd_theme_dependency <- function(name = NULL) {
  css_file <- if (!is.null(name)) {
    name <- match.arg(name, cleanrmd_themes())
    if (name == "latex.css") {
      "latex.css"
    } else {
      cleanrmd_theme_list$file[which(name == cleanrmd_theme_list$name)]
    }
  } else {
    "theme-picker.css"
  }

  src <- if (is.null(name) || name != "latex.css") "resources" else "resources/latex"
  all_files <- is.null(name) || name == "latex.css"

  htmltools::htmlDependency(
    name = "cleanrmd",
    package = "cleanrmd",
    version = utils::packageVersion("cleanrmd"),
    src = src,
    script = if (is.null(name)) "theme-picker.js",
    head = if (is.null(name)) paste0(
      '<script id="theme-picker-themes" type="application/json">',
      cleanrmd_theme_json(),
      "</script>"
    ),
    stylesheet = css_file,
    all_files = all_files
  )
}

#' List cleanrmd themes
#'
#' Lists the available themes in \pkg{cleanrmd}
#'
#' @section cleanrmd theme list:
#'
#' \pkg{cleanrmd} includes the following no-class CSS themes:
#' `r cleanrmd_theme_list_roxygen()`
#'
#' @examples
#' cleanrmd_themes()
#'
#' @return A character string of available theme names.
#'
#' @export
cleanrmd_themes <- function() {
  cleanrmd_theme_list$name
}

cleanrmd_theme_json <- function(fields = c("name", src = "file")) {
  if (is.null(names(fields))) {
    names(fields) <- fields
  } else {
    names(fields)[names(fields) == ""] <- fields[names(fields) == ""]
  }
  out <- cleanrmd_theme_list[, unname(fields)]
  names(out) <- names(fields)
  jsonlite::toJSON(out)
}

# nocov start
cleanrmd_theme_file <- function(file) {
  cleanrmd_file("resources", file)
}

cleanrmd_theme_list_roxygen <- function() {
  paste0(
    "- [",
    cleanrmd_theme_list$name,
    "](",
    cleanrmd_theme_list$url,
    ")",
    collapse = "\n"
  )
}
# nocov end
