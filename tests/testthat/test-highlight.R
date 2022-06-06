test_that("pandoc_html_highlight_args", {
  expect_equal(pandoc_html_highlight_args(NULL), "--no-highlight")
  expect_equal(pandoc_html_highlight_args("default"), c("--highlight-style", "arrow"))
  expect_equal(pandoc_html_highlight_args("pygments"), c("--highlight-style", "pygments"))
  expect_error(pandoc_html_highlight_args("spaceman"))
})

test_that("prism highlighting", {
  use_prism <- pandoc_html_highlight_args("prism")
  expect_equal(use_prism[1], "--no-highlight")
  expect_match(use_prism[3], "use-prism")
  expect_match(use_prism[3], "prism.min.css")

  use_prism <- pandoc_html_highlight_args("prism-coy")
  expect_equal(use_prism[1], "--no-highlight")
  expect_match(use_prism[3], "use-prism")
  expect_match(use_prism[3], "prism-coy.min.css")

  use_prism <- pandoc_html_highlight_args("prism:my-theme.css")
  expect_equal(use_prism[1], "--no-highlight")
  expect_match(use_prism[3], "use-prism")
  expect_match(use_prism[3], 'href="my-theme.css"')
})
