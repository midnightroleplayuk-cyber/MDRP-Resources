# vinewood-mdt integration

`vinewood-vehicleservices` doesn't need the MDT, but when both run the MDT can show a MID
(insurance), MOT and VED (tax) panel on vehicle checks, and raise ANPR hits for uninsured, un-MOT'd,
untaxed or SORN vehicles. Three small additions to `vinewood-mdt` (v2.2.0).

## 1. Vehicle record (server)

Where the MDT builds the vehicle record table `v` (the same place it sets `v.markers`
and `v.anpr`), add:

```lua
if GetResourceState('vinewood-vehicleservices') == 'started' then
    local s = exports['vinewood-vehicleservices']:GetVehicleStatus(v.plate)
    v.mid, v.mot, v.ved = s.insurance, s.mot, s.tax
end
```

## 2. ANPR hits (server)

In the ANPR read handler, after the keeper checks loop and before
`if ANPR.UnregisteredPlates then`, add:

```lua
if ANPR.MotInsurance ~= false and GetResourceState('vinewood-vehicleservices') == 'started' then
    local list = {}
    for _, r in pairs(registered) do list[#list + 1] = r.plate end
    local st = exports['vinewood-vehicleservices']:GetStatusBulk(list)
    for k in pairs(registered) do
        local s = st[k]
        if s then
            if s.exempt then
                -- Crown / emergency vehicle: nothing to flag
            elseif not s.insured then
                add(k, 'No insurance on MID', 'red', 'Stop. Check insurance - seize under s.165 if uninsured.')
            end
            if s.exempt then
            elseif s.mot == 'dangerous' then
                add(k, 'MOT failed - dangerous defects', 'red', 'Stop. Vehicle not fit to be driven.')
            elseif s.mot ~= 'valid' then
                add(k, 'No current MOT', 'amber', 'Stop if safe. Deal with no MOT.')
            end
            if s.exempt then
            elseif s.tax == 'sorn' then
                add(k, 'SORN vehicle on the road', 'amber', 'Stop. Vehicle declared off road.')
            elseif s.tax ~= 'taxed' then
                add(k, 'Untaxed', 'amber', 'Stop if safe. Report for no VED.')
            end
        end
    end
end
```

`GetStatusBulk` keys results by the plate upper-cased with spaces and symbols removed,
which matches `ANPR_Key` for UK-format plates. Set `Config.ANPR.MotInsurance = false`
to turn these hits off.

## 3. Vehicle page (web/app.js)

Add two helpers near the other view helpers:

```js
const MID_TEXT = { exempt: 'Exempt', insured: 'Insured', void: 'Not insured (keeper changed)', expired: 'Insurance expired', none: 'No insurance' };
const MOT_TEXT = { exempt: 'Exempt', valid: 'Valid', dangerous: 'Failed - dangerous', expired: 'Expired', failed: 'Failed', none: 'No MOT' };
function midRow(m) {
    if (!m) return '';
    if (m.status === 'exempt') return `<dt>MID:</dt><dd><span class="chip">Exempt</span> ${esc(m.exemptLabel || '')}</dd>`;
    const bad = m.status !== 'insured';
    const who = m.policyNo ? ` ${esc(m.coverLabel)} - ${esc(m.holder || '')} - ${esc(m.policyNo)} - ${m.status === 'insured' ? 'expires' : 'expired'} ${esc(m.expires)}` : '';
    const drv = m.policyNo ? `<br><small>Drivers: ${m.anyDriver ? 'Any driver' : ['Policyholder', ...(m.drivers || []).map((d) => esc(d.name))].join(', ')}</small>` : '';
    return `<dt>MID:</dt><dd><span class="chip${bad ? ' warn' : ''}">${MID_TEXT[m.status] || esc(m.status)}</span>${who}${drv}</dd>`;
}
function motRow(m) {
    if (!m) return '';
    if (m.status === 'exempt') return `<dt>MOT:</dt><dd><span class="chip">Exempt</span></dd>`;
    const bad = m.status !== 'valid';
    const last = m.last ? `<br><small>Last test ${esc(m.last.result.toUpperCase())} ${esc(m.last.date)} at ${esc(m.last.garage || '-')}${m.last.mileage != null ? `, ${m.last.mileage} miles` : ''}${(m.last.defects || []).length ? ': ' + m.last.defects.map((d) => esc(d.label)).join(', ') : ''}</small>` : '';
    return `<dt>MOT:</dt><dd><span class="chip${bad ? ' warn' : ''}">${MOT_TEXT[m.status] || esc(m.status)}</span>${m.expires ? ' expiry ' + esc(m.expires) : ''}${last}</dd>`;
}
```

```js
const VED_TEXT = { exempt: 'Exempt', taxed: 'Taxed', sorn: 'SORN', untaxed: 'Untaxed', none: 'Untaxed' };
function vedRow(t) {
    if (!t) return '';
    if (t.status === 'exempt') return `<dt>VED:</dt><dd><span class="chip">Exempt</span></dd>`;
    const extra = t.status === 'taxed' ? ` until ${esc(t.expires)}${t.band ? ' - ' + esc(t.band) : ''}`
        : t.status === 'sorn' ? ` since ${esc(t.since)}`
        : t.keeperChanged ? ' (ended on change of keeper)'
        : t.expires ? ` expired ${esc(t.expires)}` : '';
    return `<dt>VED:</dt><dd><span class="chip${t.status !== 'taxed' ? ' warn' : ''}">${VED_TEXT[t.status] || esc(t.status)}</span>${extra}</dd>`;
}
```

Then, in `viewVehicle`, directly after the `<dt>ANPR:</dt>...` row:

```js
${midRow(v.mid)}${motRow(v.mot)}${vedRow(v.ved)}
```
