test_that("pandoc_html_highlight_args", {
  expect_equal(pandoc_html_highlight_args(NULL), "--no-highlight")
  expect_equal(pandoc_html_highlight_args("default"), c("--highlight-style", "pygments"))
  expect_equal(pandoc_html_highlight_args("pygments"), c("--highlight-style", "pygments"))
  expect_error(pandoc_html_highlight_args("spaceman"))
})
