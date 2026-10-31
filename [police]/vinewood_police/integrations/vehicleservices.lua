-- vinewood-vehicleservices. Verified against 1.5.1.
--   GetVehicleStatus(plate)       { insurance = { status, ... }, mot = { status, expires, ... }, tax = { status, expires, ... } }
--   IsInsuredToDrive(plate, cid)  boolean
-- Statuses: insurance 'insured'|'void'|'expired'|'none'|'exempt'; mot 'valid'|'dangerous'|'expired'|'failed'|'none'|'exempt';
-- tax 'taxed'|'sorn'|'untaxed'|'none'|'exempt'
VPO.Integrations.Define('vehicleservices', {
    resources = { 'vinewood-vehicleservices', 'vinewood-motinsurance' },
    minVersion = '1.5.0',
    setup = function(res)
        local v = exports[res]
        local a = { resource = res }
        function a.Status(plate) return v:GetVehicleStatus(plate) end
        function a.InsuredToDrive(plate, cid) return v:IsInsuredToDrive(plate, cid) == true end
        return a
    end,
})
