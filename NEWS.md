# cleanrmd (development version)

* Added five new themes: `basic.css`, `bolt.css`, `classlesscss`,
  `mvp.css`, and `neat.css` (#12, #15, #17, #22).

* Updated the bundled `bullframe` theme to bullframe.css v6
  (classless build) (thanks @marcop135 #40).

* The HTML template now applies `body { margin-inline: auto }` after
  the theme's stylesheet, so themes that reset the body margins
  without providing their own width container (e.g. `bullframe`) no
  longer pin the content to the left edge of the page.

* The `water` theme now uses the "automatic" stylesheet that follows
  the reader's system light/dark mode preference. The always-dark
  `water-dark` theme remains available (#33).

* Updated all bundled CSS themes to their latest versions. The
  `vanilla` theme now downloads from its GitHub repository
  (`bradleytaunt/vanilla-css`) because the previous `vanillacss.com`
  domain now redirects to an unrelated site.

* The theme picker now remembers the reader's most recently selected
  theme in their browser's local storage. Documents can choose the
  initial theme with the new `default` argument to `use_cleanrmd()`;
  the default remains `"new.css"` (#31).

* The theme picker now applies the saved or default theme stylesheet
  while the page is still loading — before the document body is
  parsed — avoiding a flash of unstyled content before the picker UI
  appears. The picker UI itself is built once the DOM is ready.

* `html_document_clean()` now passes `--syntax-highlighting` instead of
  the deprecated `--no-highlight` and `--highlight-style` flags when
  rendering with Pandoc >= 3.8, avoiding Pandoc deprecation warnings
  (rstudio/rmarkdown#2640).

# cleanrmd 0.1.1

* The `html_document_clean()` template now sets a few fallback CSS rules
  _before_ loading the framework's CSS bundle. This should make the CSS
  more consistent with each framework but also patch gaps where the
  default body styles aren't quite what's expected (thanks @Jeevun #36, #37).

* Updated all CSS bundles to their latest versions.

* cleanrmd now bundles the Libertinus font for `latex.css` (thanks @edarin #35).

* The `html_document_clean()` format now supports `toc-title` when passed as a
  top-level YAML argument or as a pandoc argument (#30).
# cleanrmd 0.1.0

* First CRAN release of cleanrmd
