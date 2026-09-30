document.addEventListener('DOMContentLoaded', function () {
  const resourceDir = [...document.getElementsByTagName("script")]
    .filter(e => e.src.match('theme-picker.js'))
    .map(e => e.src)[0]
    .replace('theme-picker.js', '')

  const themePickerCssLink = document.createElement('link')
  themePickerCssLink.id = 'theme-picker-style'
  themePickerCssLink.rel = 'stylesheet'
  document.head.appendChild(themePickerCssLink)

  const picker = document.createElement('div')
  picker.id = 'theme-picker'
  document.body.appendChild(picker)

  const data = JSON.parse(document.getElementById('theme-picker-themes').textContent)
  const themes = data.themes
  const defaultTheme = data.default || 'new.css'
  const STORAGE_KEY = 'cleanrmd-theme'

  const getStoredTheme = () => {
    try {
      return window.localStorage.getItem(STORAGE_KEY)
    } catch (e) {
      // localStorage may be unavailable (e.g. sandboxed iframes, private mode)
      return null
    }
  }

  const storeTheme = (value) => {
    try {
      window.localStorage.setItem(STORAGE_KEY, value)
    } catch (e) {
      // fail silently if storage is unavailable
    }
  }

  const tps = document.createElement('select')

  const setCSS = (href) => {
    document
      .getElementById('theme-picker-style')
      .setAttribute('href', resourceDir + href)
  }

  const optBlank = document.createElement('option')
  optBlank.setAttribute('value', '')
  optBlank.textContent = '-- Bare HTML --'
  tps.appendChild(optBlank)

  for (const theme of themes) {
    const opt = document.createElement('option')
    opt.setAttribute('value', theme.src)
    opt.textContent = theme.name
    tps.appendChild(opt)
  }

  picker.appendChild(tps)

  // Restore the reader's last selection, falling back to the default theme
  // when nothing was stored or the stored theme no longer exists.
  const themeSrcs = themes.map(t => t.src)
  const stored = getStoredTheme()
  const initialSrc = stored !== null && (stored === '' || themeSrcs.includes(stored))
    ? stored
    : (themes.find(t => t.name === defaultTheme) || themes[0]).src

  tps.value = initialSrc
  setCSS(initialSrc)

  picker.addEventListener('change', () => {
    const themeHref = document.querySelector('#theme-picker select').value
    storeTheme(themeHref)
    setCSS(themeHref)
  })
})
