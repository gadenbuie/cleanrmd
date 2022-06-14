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

  const themes = JSON.parse(document.getElementById('theme-picker-themes').textContent)
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
    if (theme.name === 'new.css') {
      opt.selected = true
      setCSS(theme.src)
    }
    tps.appendChild(opt)
  }

  picker.appendChild(tps)

  picker.addEventListener('change', () => {
    const themeHref = document.querySelector('#theme-picker select').value
    setCSS(themeHref)
  })
})
