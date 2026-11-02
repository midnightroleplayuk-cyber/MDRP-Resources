local statsCache = {}

function calculateStats(vehicle)
  local model = GetEntityModel(vehicle)
  local brand = GetLabelText(GetMakeNameFromVehicleModel(model))
  if brand == "NULL" or brand == "null" then
    brand = "IMPORT"
  end
  if statsCache[model] then return statsCache[model] end

  local isBoat = IsThisModelABoat(model) or tonumber(model) == -1706603682 or (GetVehicleClass(vehicle) == 14)
  local fInitialDriveMaxFlatVel = getFieldFromHandling(vehicle, "fInitialDriveMaxFlatVel")
  local fInitialDriveForce = getFieldFromHandling(vehicle, "fInitialDriveForce")
  local fClutchChangeRateScaleUpShift = getFieldFromHandling(vehicle, "fClutchChangeRateScaleUpShift")
  local fDriveBiasFront = getFieldFromHandling(vehicle, "fDriveBiasFront")
  local fTractionCurveMax = getFieldFromHandling(vehicle, "fTractionCurveMax")
  local fTractionCurveMin = getFieldFromHandling(vehicle, "fTractionCurveMin")
  local fLowSpeedTractionLossMult = getFieldFromHandling(vehicle, "fLowSpeedTractionLossMult")
  local fSuspensionReboundDamp = getFieldFromHandling(vehicle, "fSuspensionReboundDamp")
  local fAntiRollBarForce = getFieldFromHandling(vehicle, "fAntiRollBarForce")
  local fBrakeForce = getFieldFromHandling(vehicle, "fBrakeForce")

  local drivetrainMod = fDriveBiasFront > 0.5 and (1.0 - fDriveBiasFront) or fDriveBiasFront

  local force = fInitialDriveForce
  if fInitialDriveForce > 0 and fInitialDriveForce < 1 then
      force = (force + drivetrainMod * 0.15) * 1.1
  end

  local spid = math.ceil(fInitialDriveMaxFlatVel * 1.3)
  local speed = (spid / 300) * 10
  local accel = (fInitialDriveMaxFlatVel * force + (fClutchChangeRateScaleUpShift * 0.7)) / 10

  local lowSpeedTraction = 1.0
  if fLowSpeedTractionLossMult >= 1.0 then
      lowSpeedTraction = lowSpeedTraction + (fLowSpeedTractionLossMult - lowSpeedTraction) * 0.15
  else
      lowSpeedTraction = lowSpeedTraction - (lowSpeedTraction - fLowSpeedTractionLossMult) * 0.15
  end
  local handling = (fTractionCurveMax + (fSuspensionReboundDamp + fAntiRollBarForce) / 3) * (fTractionCurveMin / lowSpeedTraction) + drivetrainMod

  local braking = ((fTractionCurveMin / fTractionCurveMax) * fBrakeForce) * 7
  if isBoat or not tonumber(braking) then
    braking = 0.0
  end

  local class = exports["av_laptop"]:getClass(vehicle)
  local info = {}
  info['acceleration'] = {name = Lang['acceleration'], value = accel}
  info['handling'] = {name = Lang['handling'], value = handling}
  info['speed'] = {name = Lang['speed'], value = speed}
  info['braking'] = {name = Lang['braking'], value = braking}
  statsCache[model] = {info = info, class = class, brand = brand}
  return statsCache[model]
end

function getFieldFromHandling(vehicle, field)
  return GetVehicleHandlingFloat(vehicle, 'CHandlingData', field)
end
