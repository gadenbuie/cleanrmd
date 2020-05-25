
# Run with wd == "cleanrmd"

stopifnot("DESCRIPTION" %in% dir(getwd()))

# Load css themes
themes <- yaml::yaml.load_file("data-raw/themes.yml")

download_file <- function(src, dest) {
  dest <- fs::path("inst", "resources", dest)
  if (fs::path_dir(dest) != "inst/resources") {
    fs::dir_create(fs::path_dir(dest))
  }
  download.file(src, dest)
}

# Download css files
purrr::walk(themes, ~ {
  download_file(.x$src, .x$file)
  if ("extra" %in% names(.x)) {
    purrr::walk(.x$extra, ~ download_file(.$src, .$dest))
  }
})

# Store themes as internal data frame
cleanrmd_theme_list <- purrr::map_dfr(themes, ~ .x[c("name", "url", "src", "file")])
usethis::use_data(cleanrmd_theme_list, internal = TRUE, overwrite = TRUE)
