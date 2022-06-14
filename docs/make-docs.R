library(xml2)

rd_files <- fs::dir_ls(here::here("man"), regexp = "Rd$")

rd_to_html <- function(rd_file) {
  tmp_h <- tempfile(fileext = ".html")
  on.exit(unlink(tmp_h))

  tools::Rd2HTML(rd_file, out = tmp_h, permissive = TRUE)
  paste(readLines(tmp_h), collapse = "\n")
}

html_to_md <- function(html) {
  tmp_h <- tempfile(fileext = ".html")
  tmp_md <- sub("[.]html$", ".md", tmp_h)
  on.exit(unlink(c(tmp_h, tmp_md)))

  html <- html |> as.character() |> paste(collapse = "\n")
  writeLines(html, tmp_h)
  rmarkdown::pandoc_convert(tmp_h, to = "commonmark_x+pipe_tables", output = tmp_md)
  paste(readLines(tmp_md), collapse = "\n")
}

rewrite_rd <- function(rd_file) {

  h <-
    rd_to_html(rd_file) |>
    read_html() |>
    xml_find_first('//*[@class="container"]')

  title <- h |> xml_find_first("//td") |> xml_text()

  section <- h |> xml_find_first("//h2")
  subtitle <- section |> xml_text()

  section_new <- xml_new_root("h2", "REPLACE_ME_TITLE")
  xml_replace(section, section_new)

  xml_find_first(h, "//table") |> xml_remove()

  ex_heading <- h |> xml_find_first('//h3[text()="Examples"]')
  examples <- ex_heading |> xml_find_first("./following-sibling::pre")
  example_code <- examples |> xml_text() |> trimws()
  example_code <- gsub("## Not run: ", "if (interactive()) {", example_code, fixed = TRUE)
  example_code <- gsub("## End(Not run)", "}", example_code, fixed = TRUE)

  xml_remove(ex_heading)
  xml_remove(examples)

  md <- h |> xml_children() |> html_to_md()
  md <- sub("REPLACE_ME_TITLE", sprintf("`%s()` - %s {#%s}", title, subtitle, title), md)

  list(
    title = title,
    content = md,
    examples = example_code
  )
}

reference_md <- function(ref) {
  whisker::whisker.render(
    "{{{ content }}}

### Examples

```{r}
{{{ examples }}}
```
", data = ref)
}

refs <- lapply(rd_files, rewrite_rd)
refs <- lapply(refs, reference_md) |> unlist()

file.copy("_reference.Rmd", "reference.Rmd", overwrite = TRUE)
cat(refs, file = "reference.Rmd", sep = "\n", append = TRUE)

devtools::build_rmd("docs/reference.Rmd")
devtools::build_rmd("docs/index.Rmd")
