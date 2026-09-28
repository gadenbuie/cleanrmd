p38 <- rmarkdown::pandoc_available("3.8")
no_highlight <- if (p38) {
  c("--syntax-highlighting", "none")
} else {
  "--no-highlight"
}
style_flag <- if (p38) "--syntax-highlighting" else "--highlight-style"

test_that("pandoc_html_highlight_args", {
  expect_equal(pandoc_html_highlight_args(NULL), no_highlight)
  expect_equal(pandoc_html_highlight_args("default")[1], style_flag)
  expect_match(pandoc_html_highlight_args("default")[2], "arrow[.]theme")
  expect_equal(
    pandoc_html_highlight_args("pygments"),
    c(style_flag, "pygments")
  )
  expect_error(pandoc_html_highlight_args("spaceman"))
})

test_that("prism highlighting", {
  expect_prism_theme <- function(args, theme) {
    expect_equal(args[1:length(no_highlight)], no_highlight)
    expect_match(args[length(args)], "use-prism")
    expect_match(args[length(args)], theme)
  }

  expect_prism_theme(pandoc_html_highlight_args("prism"), "prism.min.css")
  expect_prism_theme(
    pandoc_html_highlight_args("prism-coy"),
    "prism-coy.min.css"
  )
  expect_prism_theme(
    pandoc_html_highlight_args("prism:my-theme.css"),
    'href="my-theme.css"'
  )
})
