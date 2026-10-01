document.addEventListener('DOMContentLoaded', function () {
  var resourceDir = ''
  var scripts = document.getElementsByTagName('script')
  for (var i = 0; i < scripts.length; i++) {
    var src = scripts[i].src || ''
    if (src.indexOf('theme-picker.js') >= 0) {
      resourceDir = src.replace('theme-picker.js', '')
      break
    }
  }

  // The early-init script (inlined in <head>, see theme-picker-init.js)
  // has usually already applied the theme stylesheet and stashed the
  // picker state. Fall back to the full setup if it didn't run.
  var state = window.__cleanrmdThemePicker
  var data, themes, defaultTheme, initialSrc

  if (state) {
    data = state.data
    themes = data.themes || []
    defaultTheme = data.default || 'new.css'
    initialSrc = state.initialSrc
    if (state.resourceDir) {
      resourceDir = state.resourceDir
    }
  } else {
    data = JSON.parse(document.getElementById('theme-picker-themes').textContent)
    themes = data.themes
    defaultTheme = data.default || 'new.css'

    var getStoredTheme = function () {
      try {
        return window.localStorage.getItem('cleanrmd-theme')
      } catch (e) {
        return null
      }
    }
    var themeSrcs = themes.map(function (t) { return t.src })
    var stored = getStoredTheme()
    initialSrc =
      stored !== null && (stored === '' || themeSrcs.indexOf(stored) >= 0)
        ? stored
        : (themes.filter(function (t) { return t.name === defaultTheme })[0] ||
            themes[0]).src
  }

  var themePickerCssLink = document.getElementById('theme-picker-style')
  if (!themePickerCssLink) {
    themePickerCssLink = document.createElement('link')
    themePickerCssLink.id = 'theme-picker-style'
    themePickerCssLink.rel = 'stylesheet'
    document.head.appendChild(themePickerCssLink)
  }

  var setCSS = function (href) {
    themePickerCssLink.setAttribute('href', resourceDir + href)
  }

  var picker = document.createElement('div')
  picker.id = 'theme-picker'
  document.body.appendChild(picker)

  var tps = document.createElement('select')

  var optBlank = document.createElement('option')
  optBlank.setAttribute('value', '')
  optBlank.textContent = '-- Bare HTML --'
  tps.appendChild(optBlank)

  for (var j = 0; j < themes.length; j++) {
    var opt = document.createElement('option')
    opt.setAttribute('value', themes[j].src)
    opt.textContent = themes[j].name
    tps.appendChild(opt)
  }

  picker.appendChild(tps)

  tps.value = initialSrc
  if (!state) {
    // The early-init script didn't run, so apply the theme now.
    setCSS(initialSrc)
  }

  var storeTheme = function (value) {
    try {
      window.localStorage.setItem('cleanrmd-theme', value)
    } catch (e) {
      // fail silently if storage is unavailable
    }
  }

  picker.addEventListener('change', function () {
    var themeHref = document.querySelector('#theme-picker select').value
    storeTheme(themeHref)
    setCSS(themeHref)
  })
})
