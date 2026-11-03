// Standalone browser example. No FiveM connection, framework or npm build is required.
import { mount } from './documents.js'

const root = document.getElementById('preview')
const error = document.getElementById('error')
const controls = Object.fromEntries(['document', 'count', 'template', 'background', 'name', 'branding', 'portrait']
  .map(id => [id, document.getElementById(id)]))
const labels = { firstName: 'Given names', lastName: 'Surname', name: 'Name', birthdate: 'Date of birth',
  gender: 'Gender', height: 'Height', rank: 'Rank', number: 'Service number', licenses: 'Licenses',
  noLicenses: 'This person has no licenses.', open: 'Open', close: 'Close', unavailable: 'Not provided' }
const licenseNames = ['Driving license', 'Weapon license', 'Motorcycle license', 'Heavy goods vehicle license',
  'Commercial aviation', 'Helicopter pilot', 'Fishing permit', 'Hunting permit', 'Taxi operator',
  'Passenger transport', 'Business permit', 'Security certification', 'Medical qualification',
  'Emergency vehicle driver', 'Maritime navigation', 'Diving certification', 'Dangerous goods transport',
  'Firearms instructor', 'Agricultural machinery', 'Construction machinery', 'Private aircraft',
  'Professional racing', 'Wildlife protection', 'Commercial boat operator']
let view
let controller
let sequence = 0
let currentType

function sampleModel() {
  const type = controls.document.value
  const missing = controls.name.value === 'missing'
  const names = controls.name.value === 'long' ? ['Alexandria Marie', 'Winterfeldt-Montgomery'] : ['Alex', 'Morgan']
  const licenses = licenseNames.slice(0, Number(controls.count.value))
    .map((label, index) => ({ type: `license_${index}`, label, cardIndex: null }))
  const portrait = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 150"><path fill="#556778" d="M0 150v-20c0-18 25-26 40-32h40c15 6 40 14 40 32v20Z"/><path fill="#bba691" d="M43 82h34v27l-17 19-17-19Z"/><ellipse fill="#d8c0a6" cx="60" cy="56" rx="30" ry="39"/><path fill="#453c39" d="M30 60C18 16 43 9 61 9c29 0 36 21 29 51l-7-25c-18 11-31-10-46 2Z"/></svg>'
  return {
    version: 1, type, title: { identity: 'Identity card', licenses: 'Licenses', service: 'Service ID' }[type],
    holder: { name: missing ? labels.unavailable : names.join(' '), firstname: missing ? labels.unavailable : names[0],
      lastname: missing ? labels.unavailable : names[1], splitName: !missing,
      birthdate: missing ? labels.unavailable : '1994-08-21', gender: missing ? labels.unavailable : 'Male',
      height: missing ? labels.unavailable : '184 cm' },
    portrait: controls.portrait.checked ? `data:image/svg+xml,${encodeURIComponent(portrait)}` : '',
    issuer: controls.branding.checked ? 'Example County' : '',
    logo: controls.branding.checked ? new URL('./logo.svg', import.meta.url).href : '',
    licenses, hasLicenses: licenses.length > 0,
    service: { job: 'police', department: 'Police Department', rank: 'Sergeant', number: 'PD-042',
      template: controls.template.value, background: controls.background.value, color: '#3177b7' },
    code: [`${{ identity: 'ID', licenses: 'LIC', service: 'SRV' }[type]}<<${missing ? '' : `${names[1]}<<${names[0]}`.toUpperCase()}`.padEnd(40, '<').slice(0, 40),
      (type === 'licenses' ? 'LICENSES<' + licenses.map(license => license.type.toUpperCase()).join('<<')
        : type === 'service' ? 'ORG<POLICE<<RANK<SERGEANT' : missing ? 'DOB<<<<<<<<<H<' : 'DOB<19940821<<M<H184').padEnd(40, '<').slice(0, 40)],
    labels,
  }
}

function fit() {
  const margin = innerHeight * 16 / 1080
  const scale = Math.min(1, (innerWidth - margin * 2) / Math.max(1, root.offsetWidth), (innerHeight - margin * 2) / Math.max(1, root.offsetHeight))
  root.style.left = `${innerWidth / 2}px`
  root.style.top = `${innerHeight / 2}px`
  root.style.transform = `translate(-50%, -50%) scale(${scale})`
}

async function render() {
  const request = ++sequence
  const model = sampleModel()
  root.hidden = false
  error.hidden = true
  try {
    if (view && currentType === model.type) view.update(model)
    else {
      controller?.abort()
      controller = new AbortController()
      view?.dispose()
      view = undefined
      const mountPoint = document.createElement('div')
      root.replaceChildren(mountPoint)
      const mounted = await mount(mountPoint, model, {
        close() { root.hidden = true },
        openLicense(index) { console.info(`[Document preview] Native card ${index} selected (sample action only)`) },
      }, { signal: controller.signal })
      if (request !== sequence) { mounted.dispose(); return }
      view = mounted
      currentType = model.type
    }
    root.setAttribute('aria-label', model.title)
    fit()
  } catch (failure) {
    if (request !== sequence) return
    console.error('[Document preview] Renderer failed', failure)
    error.textContent = String(failure.message || failure)
    error.hidden = false
  }
}

for (const control of Object.values(controls)) control.addEventListener('change', render)
document.getElementById('reopen').addEventListener('click', render)
window.addEventListener('keydown', event => {
  if (event.key === 'Escape' || event.key === 'Enter') { event.preventDefault(); root.hidden = true }
})
window.addEventListener('resize', fit)
const observer = new ResizeObserver(fit)
observer.observe(root)
window.addEventListener('pagehide', () => { sequence++; controller?.abort(); view?.dispose(); observer.disconnect() }, { once: true })
void render()
