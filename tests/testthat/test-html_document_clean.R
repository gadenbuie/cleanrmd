test_that("html_document_clean() requires a theme for self_contained", {
  expect_error(html_document_clean(theme = NULL, self_contained = TRUE))
  expect_silent(html_document_clean(theme = "no-class", self_contained = TRUE))
})
