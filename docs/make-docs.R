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
  rmarkdown::pandoc_convert(
    tmp_h,
    to = "commonmark_x+pipe_tables",
    output = tmp_md
  )
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
  example_code <- gsub(
    "## Not run: ",
    "if (interactive()) {",
    example_code,
    fixed = TRUE
  )
  example_code <- gsub("## End(Not run)", "}", example_code, fixed = TRUE)

  xml_remove(ex_heading)
  xml_remove(examples)

  md <- h |> xml_children() |> html_to_md()
  md <- sub(
    "REPLACE_ME_TITLE",
    sprintf("`%s()` - %s {#%s}", title, subtitle, title),
    md
  )

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
",
    data = ref
  )
}

refs <- lapply(rd_files, rewrite_rd)
refs <- lapply(refs, reference_md) |> unlist()

render_docs <- function(refs) {
  docs_dir <- here::here("docs")
  site_dir <- Sys.getenv(
    "CLEANRMD_DOCS_OUTPUT",
    unset = file.path(tempdir(), "cleanrmd-docs-site")
  )
  if (!grepl("^(/|~)", site_dir)) {
    site_dir <- here::here(site_dir)
  }
  reference_template <- file.path(docs_dir, "_reference.Rmd")
  index_rmd <- file.path(docs_dir, "index.Rmd")
  reference_rmd <- tempfile(
    pattern = ".reference-",
    tmpdir = docs_dir,
    fileext = ".Rmd"
  )

  on.exit(unlink(reference_rmd), add = TRUE)

  source_assets <- fs::dir_ls(docs_dir, recurse = TRUE, type = "file")
  relative_assets <- fs::path_rel(source_assets, start = docs_dir)
  source_assets <- source_assets[
    !grepl("[.](R|Rmd|html)$", relative_assets, ignore.case = TRUE) &
      !grepl("(^|/)[.]", relative_assets) &
      !grepl("^(libs|index_files|reference_files)(/|$)", relative_assets)
  ]

  generated_paths <- c(
    "index.html",
    "reference.html",
    "libs",
    "index_files",
    "reference_files"
  )

  if (dir.exists(site_dir)) {
    unlink(site_dir, recursive = TRUE)
  }
  dir.create(site_dir, recursive = TRUE)

  writeLines(readLines(reference_template), reference_rmd)
  cat(refs, file = reference_rmd, sep = "\n", append = TRUE)

  rmarkdown::render(
    input = reference_rmd,
    output_file = "reference.html",
    output_dir = docs_dir
  )
  rmarkdown::render(
    input = index_rmd,
    output_file = "index.html",
    output_dir = docs_dir
  )

  for (path in generated_paths) {
    source <- file.path(docs_dir, path)
    destination <- file.path(site_dir, path)
    if (dir.exists(source)) {
      fs::dir_copy(source, destination, overwrite = TRUE)
    } else if (file.exists(source)) {
      file.copy(source, destination, overwrite = TRUE)
    }
  }
  for (asset in source_assets) {
    relative_path <- fs::path_rel(asset, start = docs_dir)
    destination <- file.path(site_dir, relative_path)
    dir.create(dirname(destination), recursive = TRUE, showWarnings = FALSE)
    file.copy(asset, destination, overwrite = TRUE)
  }
  file.create(file.path(site_dir, ".nojekyll"))
}

render_docs(refs)
