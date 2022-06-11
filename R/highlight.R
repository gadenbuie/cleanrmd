pandoc_html_highlight_args <- function(highlight) {

  pandoc_styles <- pandoc_highlight_styles()

  if (is.null(highlight)) {
    "--no-highlight"
  } else if (highlight %in% prism_themes() || grepl("^prism:", highlight)) {
    c("--no-highlight", rmarkdown::pandoc_variable_arg("use-prism", prism_sheet(highlight)))
  } else {
    if (identical(highlight, "default")) {
      highlight <- "arrow"
    }
    highlight <- match.arg(highlight, pandoc_styles)
    if (highlight %in% c("arrow", "rstudio")) {
      highlight <- system.file(
        "rmarkdown", "highlight", paste0(highlight, ".theme"),
        package = "rmarkdown"
      )
    }
    c("--highlight-style", highlight)
  }
}

pandoc_highlight_styles <- function() {
  c(
    "default",
    "arrow",
    "rstudio",
    # pandoc --list-highlight-styles
    "pygments",
    "tango",
    "espresso",
    "zenburn",
    "kate",
    "monochrome",
    "breezedark",
    "haddock"
  )
}

prism_themes <- function() {
  c(
    "prism",
    "prism-coy",
    "prism-dark",
    "prism-funky",
    "prism-okaidia",
    "prism-solarizedlight",
    "prism-tomorrow",
    "prism-twilight"
  )
}

prism_sheet <- function(x) {
  if (x %in% prism_themes()) {
    sprintf(
      '<link href="https://unpkg.com/prismjs@latest/themes/%s.min.css" rel="stylesheet" data-external="1"/>',
      x
    )
  } else {
    sprintf(
      '<link href="%s" rel="stylesheet"/>',
      sub("^prism:", "", x)
    )
  }
}
