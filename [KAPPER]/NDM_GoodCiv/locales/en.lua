Locales = Locales or {}

Locales.en = {
    carrier_on = 'You are now a GoodCiv volunteer. You will be alerted to emergencies when no medics are available.',
    carrier_off = 'You are no longer a GoodCiv volunteer.',
    carrier_blocked_job = 'Emergency services can\'t sign up as GoodCiv volunteers.',
    carrier_no_item = 'You need a %s to sign up as a GoodCiv volunteer.',
    carrier_no_perm = 'You are not certified to be a GoodCiv volunteer.',

    medic_requested = 'Your call has been passed to emergency services.',
    medic_requested_goodciv = 'No medics are available. Nearby GoodCiv volunteers have been alerted.',
    medic_none_available = 'No medics or GoodCiv volunteers are available right now.',
    medic_not_needed = 'GoodCiv only responds when someone is down.',
    medic_cooldown = 'You already have an active call.',

    alert_title = 'GoodCiv emergency',
    alert_filled = 'Enough responders are on the way.',
    alert_closed = 'The emergency has ended.',
    accepted = 'You are responding. Follow the GPS to the patient.',
    not_available = 'This call is no longer available.',
    responder_en_route = 'A GoodCiv volunteer is on the way (%s).',
    responder_dropped = 'Your GoodCiv responder had to leave the call.',

    too_far = 'You are too far from the patient.',
    busy = 'You are already doing something.',
    need_item = 'You need a %s.',
    already_controlled = 'The bleeding is already controlled.',
    no_major_bleed = 'There is no major bleeding to control.',
    is_breathing = 'The patient is breathing. CPR is not needed.',
    not_breathing = 'The patient is not breathing. Start CPR.',
    tourniquet_done = 'Tourniquet applied. Major bleeding controlled.',
    cpr_success = 'You feel a pulse. The patient is breathing again.',
    cpr_fail = 'Still no pulse. Keep going.',
    recovery_done = 'Patient placed in the recovery position.',
    assess_done = 'Assessment complete.',
    not_stable = 'The patient must be breathing with bleeding controlled before you move them.',
    no_vehicle = 'No suitable vehicle nearby.',
    vehicle_full = 'That vehicle has no free seat.',
    loaded = 'Patient loaded. Drive carefully to %s.',
    unloaded = 'Patient unloaded.',
    not_at_hospital = 'You need to be at a hospital to hand over.',
    crash = 'That crash hurt your patient. Check them!',
    handover_done = 'Patient handed over to %s. Thank you for helping.',
    handover_patient = 'A GoodCiv volunteer brought you to %s.',
    reward = 'You received £%s for your help.',
    resolved = 'The patient has been revived. Call closed.',
    medic_took_over = 'A medic has taken over the call. Thank you.',

    help_treat = 'Press ~INPUT_%s~ to treat the patient',
    help_handover = 'Press ~INPUT_%s~ to hand over the patient',

    medic_alert = 'Medical call: %s',

    -- Bring round
    assess_first = 'Assess the patient first.',
    not_stable_revive = 'The patient must be breathing with bleeding controlled before you bring them round.',
    brought_round = 'The patient is coming round. Thank you for helping.',
    brought_round_patient = 'A GoodCiv volunteer brought you round. You are badly hurt: check in at a hospital.',

    -- Down state
    down_title = 'You are unconscious',
    down_hint = 'Type /%s to call a GoodCiv volunteer',
    down_respawn_in = 'Respawn available in %s',
    down_respawn_hold = 'Hold E to respawn at hospital%s',
    respawn_fee = 'You were charged $%s for hospital treatment.',

    -- Injury / check-in
    injured_title = 'Injured',
    injured_goto = 'Check in at %s to be treated.',
    injured_external = 'Get to a hospital to be treated.',
    help_checkin = 'Press ~INPUT_PICKUP~ to check in',
    help_checkin_fee = 'Press ~INPUT_PICKUP~ to check in ($%s)',
    checkin_progress = 'Being treated at %s',
    checkin_not_needed = 'You don\'t need treatment.',
    checkin_no_money = 'Treatment costs $%s. You can\'t afford it.',
    checkin_done = 'You have been treated at %s.',
    checkin_external = 'You have been treated. Your injuries are healed.',
    too_far_checkin = 'Get closer to the check-in point.',

    -- Admin
    no_permission = 'You don\'t have permission to do that.',
    no_player = 'No such player.',
    cfg_need_label = 'Give the check-in point a name.',
    cfg_builtin = 'Built-in hospitals are edited in config.lua.',
    cfg_added = 'Check-in point "%s" added at your position.',
    cfg_saved = 'Check-in point "%s" saved.',
    cfg_moved = 'Check-in point "%s" moved to your position.',
    cfg_removed = 'Check-in point "%s" removed.',
}
