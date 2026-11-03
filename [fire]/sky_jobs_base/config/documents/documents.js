// Editable document renderer. This file is loaded directly, never compiled into the UI bundle.
// See README.md for the versioned model, template markers and lifecycle contract.
export const apiVersion = 1

function readField(data, path) {
  let value = data
  for (const key of path.split('.')) {
    if (value == null || !Object.prototype.hasOwnProperty.call(value, key)) {
      throw new Error(`Unknown document field: ${path}`)
    }
    value = value[key]
  }
  return value
}

export async function mount(root, model, actions, options = {}) {
  if (!['identity', 'licenses', 'service'].includes(model.type) || model.version !== apiVersion) {
    throw new Error(`Unsupported document model: version ${model.version}, type ${model.type}`)
  }
  const type = model.type
  const assetBase = options.assetBase || new URL('.', import.meta.url).href
  const response = await fetch(new URL(`${type}.html`, assetBase), { signal: options.signal, cache: 'no-cache' })
  if (!response.ok) throw new Error(`Could not load ${type}.html: HTTP ${response.status}`)
  const html = await response.text()
  if (options.signal?.aborted) throw new DOMException('Document mount was aborted', 'AbortError')
  root.innerHTML = html
  const lists = new Map()
  let disposed = false

  function bind(element, data) {
    if (element.tagName === 'TEMPLATE') return
    const markers = element.dataset
    if (markers.if) element.toggleAttribute('hidden', !readField(data, markers.if))
    if (markers.ifNot) element.toggleAttribute('hidden', Boolean(readField(data, markers.ifNot)))
    for (const [marker, attribute] of [['title', 'title'], ['alt', 'alt'], ['ariaLabel', 'aria-label'], ['indexField', 'data-license-index']]) {
      if (!markers[marker]) continue
      const value = readField(data, markers[marker])
      if (value == null) element.removeAttribute(attribute)
      else element.setAttribute(attribute, String(value))
    }
    for (const attribute of ['src', 'href', 'poster']) {
      const value = element.getAttribute(attribute)
      if (value && !value.startsWith('#')) {
        const resolved = new URL(value, assetBase).href
        if (resolved !== value) element.setAttribute(attribute, resolved)
      }
    }
    if (markers.image) {
      if (element.tagName !== 'IMG') throw new Error('data-image requires an img element')
      const source = readField(data, markers.image)
      if (!source) element.removeAttribute('src')
      else if (element.getAttribute('src') !== source) element.setAttribute('src', source)
    }
    if ('portrait' in markers) {
      element.classList.toggle('has-portrait', Boolean(data.portrait))
      element.setAttribute('aria-label', data.portrait ? data.holder.name : data.labels.unavailable)
    }
    if ('document' in markers) {
      element.dataset.template = data.service.template
      element.dataset.background = data.service.background
      element.style.setProperty('--service-color', data.service.color)
      element.style.setProperty('--service-tint', data.service.color ? `${data.service.color}30` : '')
    }
    if (markers.field) {
      const text = String(readField(data, markers.field) ?? '')
      if (element.textContent !== text) element.textContent = text
      return
    }
    if (markers.list) {
      const items = readField(data, markers.list)
      if (!Array.isArray(items)) throw new Error(`Document list is not an array: ${markers.list}`)
      let state = lists.get(element)
      if (!state) {
        const template = Array.from(element.children).find(child => child.tagName === 'TEMPLATE')
        if (!template || template.content.childElementCount !== 1) {
          throw new Error(`Document list ${markers.list} requires a template with one root element`)
        }
        state = { template, rows: new Map() }
        lists.set(element, state)
      }
      const next = new Map()
      let previous = state.template
      items.forEach((item, index) => {
        const rowData = { ...data, item }
        const key = markers.key ? readField(rowData, markers.key) : index
        if (next.has(key)) throw new Error(`Duplicate document list key: ${String(key)}`)
        const row = state.rows.get(key) || state.template.content.firstElementChild.cloneNode(true)
        bind(row, rowData)
        if (previous.nextElementSibling !== row) previous.after(row)
        previous = row
        next.set(key, row)
      })
      for (const [key, row] of state.rows) if (!next.has(key)) row.remove()
      state.rows = next
      return
    }
    for (const child of element.children) bind(child, data)
  }

  function update(data) {
    if (disposed) return
    if (data.version !== apiVersion || data.type !== type) {
      throw new Error('Document type/version changed; mount a new view for that document')
    }
    for (const child of root.children) bind(child, data)
  }

  function click(event) {
    if (!(event.target instanceof Element)) return
    const button = event.target.closest('[data-action]')
    if (!button || !root.contains(button) || button.disabled) return
    event.preventDefault()
    if (button.dataset.action === 'close') actions.close()
    else if (button.dataset.action === 'openLicense') actions.openLicense(Number(button.dataset.licenseIndex))
    else throw new Error(`Unknown document action: ${button.dataset.action}`)
  }

  update(model)
  root.addEventListener('click', click)
  return {
    update,
    dispose() {
      disposed = true
      root.removeEventListener('click', click)
      lists.clear()
      root.replaceChildren()
    },
  }
}
