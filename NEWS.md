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
