#' Clean Rmarkdown HTML Document
#'
#' Clean HTML documents with R Markdown.
#'
#' @section MathJax: Note that MathJax is disabled by default to reduce the
#'   overall size of the final document. You can enable MathJax by setting
#'   `mathjax = "default"`, see [rmarkdown::html_document()] for more options.
#'
#' @examples
#' if (interactive()) {
#'   html_document_clean()
#' }
#'
#' \dontrun{
#' rmarkdown::render("input.Rmd", html_document_clean())
#' }
#'
#' @param theme The class-less CSS theme to use, one of [cleanrmd_themes()].
#' @param use_fontawesome Should links to FontAwesome be included in the HTML
#'   document's `<head>`? Only enable if you are including FontAwesome icons in
#'   your HTML document.
#' @param title_in_header If `TRUE` (default), the title, subtitle, author, and
#'   date are placed in a `<header>` tag. This is semantically correct HTML but
#'   some CSS frameworks work better with this structure than others.
#' @param highlight Syntax highlight engine and style, either a built-in Pandoc
#'   highlighting theme, a theme provided by \pkg{rmarkdown}, or a
#'   [prismjs](https://prismjs.com/index.html) theme (see below). Pass
#'   \code{NULL} to prevent syntax highlighting.
#'
#'   **Pandoc themes.** By default, uses Pandoc's highlighting style. Pandoc's
#'   built-in styles include "tango", "pygments", "kate", "monochrome",
#'   "espresso", "zenburn", "haddock" and "breezedark".
#'
#'   Two custom styles are also included, "arrow", an accessible color scheme,
#'   and "rstudio", which mimics the default IDE theme. Alternatively, supply a
#'   path to a `.theme` to use
#'   [a custom Pandoc style](https://pandoc.org/MANUAL.html#syntax-highlighting).
#'   Note that custom themes require Pandoc 2.0+.
#'
#'   **Prism themes.** To use the [prismjs](https://prismjs.com/index.html)
#'   syntax highlighter, pass one of "prism", "prism-coy", "prism-dark",
#'   "prism-funky", "prism-okaidia", "prism-solarizedlight", "prism-tomorrow",
#'   or "prism-twilight". To use an alternate Prism theme file, pass the URL or
#'   path to the theme's CSS file prefixed with "prism:", e.g.
#'   `prism:my-theme.css`. Note that the Prism dependencies are not embedded
#'   into self-contained documents so they will require an active internet
#'   connection to work.
#'
#' @inheritParams rmarkdown::html_document
#'
#' @return An R Markdown output format that can be used with `output:` in an
#'   `.Rmd` or for use with [rmarkdown::render()].
#'
#' @seealso [use_cleanrmd()] for using cleanrmd themes in places other than in
#'   R Markdown documents
#'
#' @export
html_document_clean <- function(
  ...,
  theme = "no-class",
  css = NULL,
  toc = FALSE,
  toc_depth = 3,
  title_in_header = TRUE,
  mathjax = NULL,
  use_fontawesome = FALSE,
  fig_width = 10,
  fig_height = 7,
  fig_retina = 2,
  keep_md = FALSE,
  dev = "png",
  highlight = "default",
  pandoc_args = NULL,
  extra_dependencies = NULL,
  md_extensions = NULL,
  self_contained = !is.null(theme)
) {
  if (is.null(theme) && isTRUE(self_contained)) {
    stop(
      "html_document_clean() requires a `theme` when `self_contained = TRUE`.",
      call. = TRUE
    )
  }

  deps <- c(
    list(cleanrmd_theme_dependency(theme)),
    extra_dependencies,
    suppress_header_attrs()
  )

  # disable fontawesome if !use_fontawesome
  # add to pandoc_args rmarkdown::pandoc_toc_args(toc, toc_depth)
  pandoc_args <- c(
    pandoc_args,
    if (!isTRUE(use_fontawesome)) c("--variable", "disable-fontawesome"),
    if (isTRUE(title_in_header)) c("--variable", "title-in-header"),
    pandoc_html_highlight_args(highlight),
    rmarkdown::pandoc_toc_args(toc, toc_depth)
  )

  for (sheet in css) {
    pandoc_args <- c(pandoc_args, "--css", sheet)
  }

  mathjax_url <- if (!is.null(mathjax) && mathjax %in% c("default", "local")) {
    mathjax_local <- Sys.getenv("RMARKDOWN_MATHJAX_PATH", unset = NA)
    if (mathjax == "local" && is.na(mathjax_local)) {
      warning(
        paste(
          "Please use `Sys.setenv('RMARKDOWN_MATHJAX_PATH')` to set local mathjax location.",
          "Falling back to online mathjax from https://mathjax.rstudio.com"
        )
      )
    }
    mathjax_path <- ifelse(
      mathjax == "default" || is.na(mathjax_local),
      "https://mathjax.rstudio.com/latest",
      mathjax_local
    )
    file.path(mathjax_path, "MathJax.js?config=TeX-AMS-MML_HTMLorMML")
  } else {
    mathjax
  }

  if (!is.null(mathjax_url)) {
    pandoc_args <- c(
      pandoc_args,
      "--mathjax",
      "--variable",
      paste0("mathjax-url:", mathjax_url)
    )

    mathjax <- NULL
  }

  rmarkdown::output_format(
    knitr = rmarkdown::knitr_options_html(
      fig_width,
      fig_height,
      fig_retina,
      keep_md,
      dev
    ),
    pandoc = rmarkdown::pandoc_options(
      to = "html5",
      from = rmarkdown::rmarkdown_format(md_extensions),
      args = c(
        pandoc_args,
        "--template",
        cleanrmd_file("template", "cleanrmd.html")
      ),
    ),
    clean_supporting = self_contained,
    base_format = rmarkdown::html_document_base(
      template = NULL,
      theme = NULL,
      mathjax = mathjax,
      extra_dependencies = deps,
      self_contained = self_contained,
      bootstrap_compatible = FALSE,
      ...
    )
  )
}

cleanrmd_file <- function(...) {
  system.file(..., package = "cleanrmd", mustWork = TRUE)
}

suppress_header_attrs <- function() {
  attr(htmltools::suppressDependencies("header-attrs")[[1]], "html_dependencies")
}
