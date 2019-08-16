#' Clean Rmarkdown HTML Document
#'
#' Clean HTML documents with R Markdown.
#'
#' @section MathJax: Note that MathJax is disabled by default to reduce the
#'   overall size of the final document. You can enable MathJax by setting
#'   `mathjax = "default"`, see [rmarkdown::html_document()] for more options.
#'
#' @param theme The class-less CSS theme to use, one of [cleanrmd_themes()].
#' @param use_fontawesome Should links to FontAwesome be included in the HTML
#'   document's `<head>`? Only enable if you are including FontAwesome icons
#'   in your HTML document.
#' @inheritParams rmarkdown::html_document
#' @inheritParams rmarkdown::html_document_base
#' @inheritDotParams rmarkdown::html_document_base
#' @export
html_document_clean <- function(
  ...,
  theme = "no-class",
  css = NULL,
  toc = FALSE,
  toc_depth = 3,
  mathjax = NULL,
  use_fontawesome = FALSE,
  fig_width = 10,
  fig_height = 7,
  fig_retina = 2,
  keep_md = FALSE,
  dev = "png",
  pandoc_args = NULL,
  extra_dependencies = NULL
) {

  deps <- c(
    if (!is.null(theme)) list(cleanrmd_theme_dep(theme)),
    extra_dependencies
  )

  # disable fontawesome if !use_fontawesome
  # add to pandoc_args rmarkdown::pandoc_toc_args(toc, toc_depth)
  pandoc_args <- c(
    pandoc_args,
    if (!use_fontawesome) c("--variable", "disable-fontawesome"),
    if (is.null(theme)) c("--variable", paste0(
      "theme-picker=",
      jsonlite::toJSON(cleanrmd_theme_list[, c("name", "src")])
    )),
    rmarkdown::pandoc_toc_args(toc, toc_depth)
  )

  mathjax_url <- if (!is.null(mathjax) && mathjax %in% c("default", "local")) {
    mathjax_local <- Sys.getenv("RMARKDOWN_MATHJAX_PATH", unset = NA)
    if (mathjax == "local" && is.na(mathjax_local)) {
      rlang::warn(
        glue("Please use `Sys.setenv('RMARKDOWN_MATHJAX_PATH')` to set local mathjax location.",
             "Falling back to online mathjax from https://mathjax.rstudio.com")
      )
    }
    mathjax_path <- ifelse(mathjax == "default" || is.na(mathjax_local),
                           "https://mathjax.rstudio.com/latest",
                           mathjax_local)
    file.path(mathjax_path, "MathJax.js?config=TeX-AMS-MML_HTMLorMML")
  } else mathjax

  if (!is.null(mathjax_url)) {
    pandoc_args <- c(pandoc_args, "--mathjax", "--variable",
                     paste0("mathjax-url:", mathjax_url))
  }

  rmarkdown::output_format(
    knitr = rmarkdown::knitr_options_html(
      fig_width, fig_height, fig_retina, keep_md, dev
    ),
    pandoc = rmarkdown::pandoc_options(
      to = "html5",
      from = "markdown+ascii_identifiers+tex_math_single_backslash",
      args = c(
        if (!is.null(css)) paste("--css", css),
        pandoc_args,
        "--template",
        cleanrmd_file("template", "cleanrmd.html")
      ),
    ),
    clean_supporting = FALSE,
    base_format = rmarkdown::html_document_base(
      template = NULL,
      theme = NULL,
      mathjax = mathjax,
      extra_dependencies = deps,
      ...
    )
  )
}

cleanrmd_file <- function(...) {
  system.file(..., package = "cleanrmd", mustWork = TRUE)
}
