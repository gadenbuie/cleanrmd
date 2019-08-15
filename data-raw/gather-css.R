
# Run with wd == "cleanrmd"

stopifnot("DESCRIPTION" %in% dir(getwd()))

# Load css themes
themes <- yaml::yaml.load_file("data-raw/themes.yml")

# Download css files
purrr::walk(themes, ~ {
  download.file(.$src, file.path("inst", "resources", .$file))
})

# Store themes as internal data frame
cleanrmd_theme_list <- purrr::map_dfr(themes, ~ .)
usethis::use_data(cleanrmd_theme_list, internal = TRUE, overwrite = TRUE)
