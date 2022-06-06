# test_that()

describe("use_cleanrmd()", {
  it("returns an htmltools tag list with cleanrmd dependency with theme picker if no theme", {
    x <- use_cleanrmd()
    expect_s3_class(x, "shiny.tag.list")

    is_dep <- vapply(x, function(d) identical(class(d), "html_dependency"), logical(1))
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

    is_dep <- vapply(x, function(d) identical(class(d), "html_dependency"), logical(1))
    expect_true(all(is_dep))

    dep_names <- lapply(x[is_dep], function(dep) dep$name)
    expect_true("cleanrmd" %in% unlist(dep_names))

    expect_null(x[[1]]$script)
    expect_equal(x[[1]]$stylesheet, "new.css")
    expect_null(x[[1]]$head)
    expect_false(x[[1]]$all_files)
  })

  it("errors with bad input", {
    expect_error(use_cleanrmd("floofly"))
    expect_error(use_cleanrmd(c("picocss", "minicss")))
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
