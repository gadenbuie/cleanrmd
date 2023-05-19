# Run with wd == "cleanrmd"

stopifnot("DESCRIPTION" %in% dir(getwd()))

# Load css themes
themes <- yaml::yaml.load_file("data-raw/themes.yml")

download_file <- function(src, name, dest) {
  dest <- fs::path("inst", "resources", name, dest)
  if (fs::path_dir(dest) != "inst/resources") {
    fs::dir_create(fs::path_dir(dest))
  }
  download.file(src, dest)
}

# Download css files
purrr::walk(themes, function(theme) {
  download_file(theme$src,theme$name, theme$file)
  if ("extra" %in% names(theme)) {
    purrr::walk(theme$extra, ~ download_file(.x$src, theme$name, .x$dest))
  }
})

# Store themes as internal data frame
cleanrmd_theme_list <- purrr::map_dfr(themes, ~ .x[c("name", "url", "src", "file")])
usethis::use_data(cleanrmd_theme_list, internal = TRUE, overwrite = TRUE)
