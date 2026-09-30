/* cleanrmd theme picker: early theme application.
 *
 * This script is inlined into <head> immediately after the theme picker
 * JSON. Because it runs while the document head is still being parsed —
 * before anything is painted — it resolves the reader's saved theme (or
 * the default theme) and starts loading its stylesheet right away,
 * avoiding a flash of unstyled content before the picker UI appears.
 *
 * It stashes the resolved state on `window.__cleanrmdThemePicker` for
 * `theme-picker.js`, which builds the picker UI once the DOM is ready.
 */
(function () {
  var STORAGE_KEY = 'cleanrmd-theme'
  try {
    var data = JSON.parse(
      document.getElementById('theme-picker-themes').textContent
    )
    var themes = data.themes || []
    var defaultTheme = data.default || 'new.css'

    var resourceDir = ''
    for (var i = 0; i < document.scripts.length; i++) {
      var src = document.scripts[i].src || ''
      if (src.indexOf('theme-picker.js') >= 0) {
        resourceDir = src.replace('theme-picker.js', '')
        break
      }
    }

    var stored
    try {
      stored = window.localStorage.getItem(STORAGE_KEY)
    } catch (e) {
      stored = null
    }
    var srcs = themes.map(function (t) { return t.src })
    var initialSrc =
      stored !== null && (stored === '' || srcs.indexOf(stored) >= 0)
        ? stored
        : (themes.filter(function (t) { return t.name === defaultTheme })[0] ||
            themes[0]).src

    var link = document.createElement('link')
    link.id = 'theme-picker-style'
    link.rel = 'stylesheet'
    link.href = resourceDir + initialSrc
    document.head.appendChild(link)

    window.__cleanrmdThemePicker = {
      data: data,
      initialSrc: initialSrc,
      resourceDir: resourceDir
    }
  } catch (e) {
    // If anything goes wrong, do nothing here: theme-picker.js will set
    // up the stylesheet and picker as before once the DOM is ready.
  }
})()
