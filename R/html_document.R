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
#'   document's `<head>`? Only enable if you are including FontAwesome icons in
#'   your HTML document.
#' @param title_in_header If `TRUE` (default), the title, subtitle, author, and
#'   date are placed in a `<header>` tag. This is semantically correct HTML but
#'   some CSS frameworks work better with this structure than others.
#' @inheritParams rmarkdown::html_document
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
  deps <- c(
    list(cleanrmd_theme_dep(theme)),
    extra_dependencies,
    list(extra_css_dependencies(css))
  )

  if (is.null(theme)) {
    if (isTRUE(self_contained)) {
      stop(
        "html_document_clean() requires a `theme` when `self_contained = TRUE`.",
        call. = TRUE
      )
    }
    themes_json <- paste0(
      '<script id="theme-picker-themes" type="application/json">',
      cleanrmd_theme_json(),
      "</script>"
    )
    tmp_json <- tempfile(fileext = ".html")
    writeLines(themes_json, tmp_json)
  }

  # disable fontawesome if !use_fontawesome
  # add to pandoc_args rmarkdown::pandoc_toc_args(toc, toc_depth)
  pandoc_args <- c(
    pandoc_args,
    if (!isTRUE(use_fontawesome)) c("--variable", "disable-fontawesome"),
    if (isTRUE(title_in_header)) c("--variable", "title-in-header"),
    if (is.null(theme)) {
      c("--include-before-body", tmp_json)
    },
    pandoc_html_highlight_args(highlight),
    rmarkdown::pandoc_toc_args(toc, toc_depth)
  )

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

extra_css_dependencies <- function(css = NULL) {
  # because I load the cleanrmd css as an htmlDependency()
  # and as a result that css will always be last in the <head>
  # so to add additional css files that we (hopefully) want
  # to be loaded last, I have to insert them as htmldep too
  if (is.null(css)) return(NULL)
  htmltools::htmlDependency(
    name = "cleanrmd-extra-css",
    version = "9.9.9",
    package = "cleanrmd",
    src = "",
    head = format(
      htmltools::tagList(
        lapply(css, function(x) {
          htmltools::tags$link(rel = "stylesheet", href = x)
        })
      )
    ),
    all_files = FALSE
  )
}
