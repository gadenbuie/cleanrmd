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

cleanrmd_theme_dep <- function(name, all_files = FALSE) {
  name <- match.arg(name, cleanrmd_themes())

  css_file <- cleanrmd_theme_list$file[which(name == cleanrmd_theme_list$name)]

  htmltools::htmlDependency(
    name = "cleanrmd",
    package = "cleanrmd",
    version = utils::packageVersion("cleanrmd"),
    src = "resources",
    stylesheet = css_file,
    all_files = all_files
  )
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
