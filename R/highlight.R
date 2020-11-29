pandoc_html_highlight_args <- function(highlight) {

  # pandoc --list-highlight-styles
  pandoc_highlight_styles <- c(
    "default", "tango", "pygments", "kate", "monochrome", "espresso",
    "zenburn", "haddock", "breezedark"
  )

  if (is.null(highlight)) {
    "--no-highlight"
  } else {
    if (identical(highlight, "default")) {
      highlight <- "pygments"
    }
    highlight <- match.arg(highlight, pandoc_highlight_styles)
    c("--highlight-style", highlight)
  }
}
