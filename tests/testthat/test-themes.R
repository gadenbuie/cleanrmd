# test_that()

describe("use_cleanrmd()", {
  it("returns an htmltools tag list with cleanrmd dependency with theme picker if no theme", {
    x <- use_cleanrmd()
    expect_s3_class(x, "shiny.tag.list")

    is_dep <- vapply(
      x,
      function(d) identical(class(d), "html_dependency"),
      logical(1)
    )
    expect_true(all(is_dep))

    dep_names <- lapply(x[is_dep], function(dep) dep$name)
    expect_true("cleanrmd" %in% unlist(dep_names))

    expect_equal(x[[1]]$script, "theme-picker.js")
    expect_equal(x[[1]]$stylesheet, "theme-picker.css")
    expect_match(x[[1]]$head, "theme-picker-themes")
    expect_true(x[[1]]$all_files)
  })

  it("returns an htmltools tag list with specific cleanrmd dependency", {
    x <- use_cleanrmd("new.css")
    expect_s3_class(x, "shiny.tag.list")

    is_dep <- vapply(
      x,
      function(d) identical(class(d), "html_dependency"),
      logical(1)
    )
    expect_true(all(is_dep))

    dep_names <- lapply(x[is_dep], function(dep) dep$name)
    expect_true("cleanrmd" %in% unlist(dep_names))

    expect_null(x[[1]]$script)
    expect_equal(x[[1]]$stylesheet, "new.css")
    expect_null(x[[1]]$head)
    expect_true(x[[1]]$all_files)
  })

  it("errors with bad input", {
    expect_error(use_cleanrmd("floofly"))
    expect_error(use_cleanrmd(c("picocss", "minicss")))
  })

  it("errors with a bad default theme", {
    expect_error(use_cleanrmd(default = "floofly"))
    expect_error(use_cleanrmd("new.css", default = "floofly"), NA)
  })
})

describe("theme picker JSON", {
  picker_json <- function(x) {
    json <- sub('^.*application/json">', "", x$head)
    json <- sub("</script>.*$", "", json)
    jsonlite::fromJSON(json)
  }

  it("embeds the theme list and default theme", {
    json <- picker_json(cleanrmd_theme_dependency())
    expect_setequal(names(json), c("default", "themes"))
    expect_equal(json$default, "new.css")
    expect_true(all(c("name", "src") %in% names(json$themes)))
    expect_true("water" %in% json$themes$name)
  })

  it("honors a custom default theme", {
    json <- picker_json(cleanrmd_theme_dependency(default = "sakura"))
    expect_equal(json$default, "sakura")
  })
})

describe("cleanrmd_theme_picker()", {
  it("returns an htmlDependency", {
    x <- cleanrmd_theme_dependency()
    expect_s3_class(x, "html_dependency")
  })

  it("errors with bad input", {
    expect_error(cleanrmd_theme_dependency("floofly"))
    expect_error(cleanrmd_theme_dependency(c("picocss", "minicss")))
  })
})
