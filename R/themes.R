#' List cleanrmd themes
#'
#' Lists the available themes in \pkg{cleanrmd}
#'
#' @section cleanrmd theme list:
#'
#' \pkg{cleanrmd} includes the following no-class CSS themes:
#' - [awsm.css](https://igoradamenko.github.io/awsm.css/)
#' - [bahunya](https://kimeiga.github.io/bahunya/)
#' - [kacit](https://kimeiga.github.io/kacit/)
#' - [marx](https://mblode.github.io/marx/)
#' - [minicss](https://minicss.org/)
#' - [no-class](https://davidpaulsson.github.io/no-class/)
#' - [sakura](https://oxal.org/projects/sakura/)
#' - [sakura-vader](https://oxal.org/projects/sakura/)
#' - [stylize](https://gadenbuie.github.io/stylize.css/) (forked from [vasanthv/stylize.css](https://github.com/vasanthv/stylize.css)
#' - [tacit](https://yegor256.github.io/tacit/)
#' - [vanilla](https://vanillacss.com/)
#' - [water](https://kognise.github.io/water.css/)
#' - [water-dark](https://kognise.github.io/water.css/)
#' - [writ](https://writ.cmcenroe.me/)
#'
#' @return A character string of available theme names.
#'
#' @export
cleanrmd_themes <- function() {
  cleanrmd_theme_list$name
}

cleanrmd_theme_dep <- function(name) {
  name <- match.arg(name, cleanrmd_themes())

  css_file <- cleanrmd_theme_list$file[which(name == cleanrmd_theme_list$name)]

  htmltools::htmlDependency(
    name = "cleanrmd",
    package = "cleanrmd",
    version = utils::packageVersion("cleanrmd"),
    src = "resources",
    stylesheet = css_file
  )
}

cleanrmd_theme_file <- function(file) {
  cleanrmd_file("resources", file)
}

cleanrmd_theme_list_roxygen <- function() {
  cat(
    paste0(
      "#' - [",
      cleanrmd_theme_list$name,
      "](",
      cleanrmd_theme_list$url,
      ")"
    ),
    sep = "\n"
  )
}
