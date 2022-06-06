#' Use a clean CSS theme from cleanrmd
#'
#' Provides a \pkg{cleanrmd} CSS theme using \pkg{htmltools}. You can use this
#' CSS theme anywhere that HTML dependencies are handled via
#' [htmltools::htmlDependency()], for example in R Markdown or Quarto documents
#' or in Shiny apps.
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
#' @return A character string of available theme names.
#'
#' @export
cleanrmd_themes <- function() {
  cleanrmd_theme_list$name
}

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
