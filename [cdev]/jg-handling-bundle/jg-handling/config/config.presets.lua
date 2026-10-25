Config.Presets = {}

-- Acceleration
Config.Presets.Acceleration = {
  {
    name = "Supercar",
    desc = "Fastest realistic acceleration, up to the top speed specified.",
    values = { fDriveInertia = 1.0, fInitialDriveForce = 0.5, fInitialDragCoeff = 7.0 },
  },
  {
    name = "Sportscar",
    desc = "Quick realistic acceleration, up to the top speed specified.",
    values = { fDriveInertia = 1.0, fInitialDriveForce = 0.35, fInitialDragCoeff = 7.0 },
  },
  {
    name = "Normal",
    desc = "Acceleration profile for an average vehicle in GTA, up to the top speed specified.",
    values = { fDriveInertia = 1.0, fInitialDriveForce = 0.2, fInitialDragCoeff = 7.0 },
  },
  {
    name = "Drift",
    desc = "Exaggerated acceleration curve designed for drifting. All other presets must be set to drift.",
    values = { fDriveInertia = 1.0, fInitialDriveForce = 0.7, fInitialDragCoeff = 26.0 },
  },
}

-- Transmission
Config.Presets.Transmission = {
  {
    name = "Manual (6 gears)",
    desc = "'Manual' gearbox (1s shift time)",
    values = { nInitialDriveGears = 6, fClutchChangeRateScaleUpShift = 1.0, fClutchChangeRateScaleDownShift = 1.0 },
  },
  {
    name = "Automatic (6 gears)",
    desc = "'Automatic' gearbox (0.4s shift time). Good average gearbox for most vehicles.",
    values = { nInitialDriveGears = 6, fClutchChangeRateScaleUpShift = 2.5, fClutchChangeRateScaleDownShift = 2.5 },
  },
  {
    name = "Sports Automatic (7 gears)",
    desc = "Fast sports gearbox (0.26s shift time, 7 gears)",
    values = { nInitialDriveGears = 7, fClutchChangeRateScaleUpShift = 3.8, fClutchChangeRateScaleDownShift = 3.8 },
  },
  {
    name = "Dual-clutch Automatic (7 gears)",
    desc = "Track-focused gearbox (<0.2s shift time, 7 gears)",
    values = { nInitialDriveGears = 7, fClutchChangeRateScaleUpShift = 5.0, fClutchChangeRateScaleDownShift = 5.0 },
  },
}

-- Drivetrain
Config.Presets.Drivetrain = {
  {
    name = "FWD",
    desc = "Fully front-wheel drive. 100% of the vehicle's power goes to the front wheels.",
    values = { fDriveBiasFront = 1.0 },
  },
  {
    name = "FWD Bias",
    desc = "All-wheel drive with a front-wheel bias. 75% of the power to the front wheels, 25% to rear.",
    values = { fDriveBiasFront = 0.75 },
  },
  {
    name = "AWD",
    desc = "All-wheel drive. 50% power to the front, 50% power to the rear.",
    values = { fDriveBiasFront = 0.5 },
  },
  {
    name = "RWD Bias",
    desc = "All-wheel drive with a rear-wheel bias. 75% of the power to the rear wheels, 25% to front.",
    values = { fDriveBiasFront = 0.25 },
  },
  {
    name = "RWD (Required for drift setup)",
    desc = "Fully rear-wheel drive. 100% of the power goes to the rear wheels. Required for a drift setup.",
    values = { fDriveBiasFront = 0.0 },
  },
}

-- Brakes
Config.Presets.Brakes = {
  {
    name = "Standard Brakes",
    desc = "Normal braking profile for an average vehicle in GTA.",
    values = { fBrakeForce = 1.0, fBrakeBiasFront = 0.55, fHandBrakeForce = 0.7 },
  },
  {
    name = "Sport Brakes",
    desc = "Performance braking for sports, super or track vehicles.",
    values = { fBrakeForce = 2.0, fBrakeBiasFront = 0.5, fHandBrakeForce = 0.7 },
  },
  {
    name = "Drift Tuned Brakes",
    desc = "Brakes tuned for a drifting setup; with more powerful hand brake & low front bias.",
    values = { fBrakeForce = 0.83, fBrakeBiasFront = 0.24, fHandBrakeForce = 0.86 },
  },
}

-- Traction
Config.Presets.Traction = {
  {
    name = "Normal Traction",
    desc = "Realistic level of traction for an average vehicle in GTA.",
    values = { fTractionCurveMax = 2.1, fTractionCurveMin = 1.8, fTractionCurveLateral = 22.5, fSteeringLock = 40.0, fTractionBiasFront = 0.5, fLowSpeedTractionLossMult = 1.0, fTractionLossMult = 1.0 },
  },
  {
    name = "Sport Traction",
    desc = "Slightly more grippy, designed for cars lower to the ground with better cornering performance.",
    values = { fTractionCurveMax = 2.7, fTractionCurveMin = 2.4, fTractionCurveLateral = 22.5, fSteeringLock = 42.0, fTractionBiasFront = 0.5, fLowSpeedTractionLossMult = 1.0, fTractionLossMult = 1.05 },
  },
  {
    name = "Track Traction",
    desc = "Almost on rails, only realistic in cars that would stick to the road in a track setting.",
    values = { fTractionCurveMax = 3.5, fTractionCurveMin = 3.2, fTractionCurveLateral = 22.5, fSteeringLock = 45.0, fTractionBiasFront = 0.5, fLowSpeedTractionLossMult = 1.0, fTractionLossMult = 1.25 },
  },
  {
    name = "Offroad Traction",
    desc = "Traction profile tuned for offroad vehicles.",
    values = { fTractionCurveMax = 2.5, fTractionCurveMin = 2.2, fTractionCurveLateral = 22.5, fSteeringLock = 45.0, fTractionBiasFront = 0.5, fLowSpeedTractionLossMult = 1.0, fTractionLossMult = 0.0 },
  },
  {
    name = "Drift Traction",
    desc = "Exaggerated sliding, increased steering lock & low grip, required for a drift setup.",
    values = { fTractionCurveMax = 1.4, fTractionCurveMin = 1.35, fTractionCurveLateral = 29.5, fSteeringLock = 59.0, fTractionBiasFront = 0.5, fLowSpeedTractionLossMult = 0.15, fTractionLossMult = 1.0 },
  },
}

-- Suspension
Config.Presets.Suspension = {
  {
    name = "Soft Suspension",
    desc = "Softer suspension designed for offroad vehicles.",
    values = { fSuspensionBiasFront = 0.5, fSuspensionForce = 1.0, fSuspensionCompDamp = 1.0, fSuspensionReboundDamp = 1.0 },
  },
  {
    name = "Standard Suspension",
    desc = "Normal suspension for average GTA vehicles.",
    values = { fSuspensionBiasFront = 0.5, fSuspensionForce = 1.5, fSuspensionCompDamp = 1.2, fSuspensionReboundDamp = 1.2 },
  },
  {
    name = "Sport Suspension",
    desc = "Slightly more stiff suspension for sports cars.",
    values = { fSuspensionBiasFront = 0.5, fSuspensionForce = 3.0, fSuspensionCompDamp = 1.5, fSuspensionReboundDamp = 1.5 },
  },
  {
    name = "Stiff Suspension",
    desc = "Reserve this for cars designed for the track, otherwise it won't feel realistic.",
    values = { fSuspensionBiasFront = 0.5, fSuspensionForce = 5.0, fSuspensionCompDamp = 1.8, fSuspensionReboundDamp = 1.8 },
  },
}

-- Downforce
Config.Presets.Wings = {
  {
    name = "No Wing",
    desc = "Recommended. Downforce is calculated by the game.",
    values = { fDownforceModifier = 1.0 },
  },
  {
    name = "Track Wing (use with caution!)",
    desc = "Adds downforce that will make the vehicle stick to the ground. Use sparingly, on a dedicated track or F1 car.",
    values = { fDownforceModifier = 5.0 },
  },
}
