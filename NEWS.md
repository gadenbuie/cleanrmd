# cleanrmd (development version)

# cleanrmd 0.2.0

## New themes and theme picker

* `cleanrmd` adds five themes: `basic.css`, `bolt.css`, `classlesscss`,
  `mvp.css`, and `neat.css` (#12, #15, #17, #22).

* The theme picker remembers the reader's most recently selected theme in
  browser local storage. `use_cleanrmd()` gains a `default` argument for
  choosing the initial theme; the default remains `"new.css"` (#31).

* The theme picker applies the saved or default stylesheet before the
  document body is parsed, preventing a flash of unstyled content. The
  picker UI is built once the DOM is ready.

## Theme updates

* The bundled `bullframe` theme is updated to bullframe.css v6 (classless
  build) (@marcop135, #40).

* The `water` theme uses the automatic stylesheet to follow the reader's
  system light/dark preference. The always-dark `water-dark` theme remains
  available (#33).

* All bundled CSS themes are refreshed. The `vanilla` theme now uses its
  GitHub repository (`bradleytaunt/vanilla-css`), since `vanillacss.com`
  redirects to an unrelated site.

## Other improvements

* The HTML template centers themes that reset body margins but don't provide
  their own width container, such as `bullframe`.

* `html_document_clean()` uses `--syntax-highlighting` with Pandoc 3.8 and
  later, avoiding deprecation warnings from `--no-highlight` and
  `--highlight-style` (rstudio/rmarkdown#2640).

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
