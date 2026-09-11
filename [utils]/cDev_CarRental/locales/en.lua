--[[
    cDev Car Rental — locales/en.lua
]]

Locale = Locale or {}

if Config.Locale == 'en' then
    Locale['ui_title'] = 'Vehicle Rental'
    Locale['ui_hours'] = 'Hours'
    Locale['ui_rent'] = 'Rent Now'
    Locale['ui_testdrive'] = 'Test Drive'
    Locale['ui_close'] = 'Close'
    Locale['ui_duration'] = 'Duration'
    Locale['ui_hour_short'] = 'h'
    Locale['ui_hour_one'] = '1 Hour'
    Locale['ui_hours_fmt'] = '%s Hours'
    Locale['ui_deposit_fmt'] = '%s deposit'
    Locale['ui_hourly_fmt'] = '+%s/hr'
    Locale['ui_per_hr_fmt'] = '%s/hr'

    Locale['ui_sign_modal_title'] = 'Rental agreement'
    Locale['ui_sign_modal_sub'] = 'Sign below, then confirm to complete your rental.'
    Locale['ui_sign_here'] = 'Sign here with mouse or finger'
    Locale['ui_clear_signature'] = 'Clear'
    Locale['ui_confirm_rental'] = 'Confirm & pay'
    Locale['ui_cancel'] = 'Cancel'
    Locale['ui_plate_pending'] = 'Assigned at pickup'

    Locale['notify_rented'] = 'You have rented a %s!'
    Locale['notify_notenough'] = 'You do not have enough money!'
    Locale['notify_returned'] = 'Vehicle returned. Thank you!'
    Locale['notify_testdrive'] = 'Test drive: %s — %d seconds.'
    Locale['notify_testdrive_end'] = 'Test drive ended.'
    Locale['notify_testdrive_time'] = 'Your test drive time is up.'
    Locale['notify_testdrive_exit'] = 'Test drive ended because you left the vehicle.'
    Locale['notify_already_renting'] = 'You already have a rental vehicle!'
    Locale['notify_already_testdriving'] = 'You are already on a test drive!'
    Locale['notify_spawn_failed'] = 'Failed to spawn vehicle. Please try again.'
    Locale['notify_limit'] = 'You have reached the maximum rental limit!'
    Locale['notify_no_rental'] = 'You do not have a rental vehicle!'
    Locale['notify_wrong_location'] = 'You must return the vehicle at the original rental location!'
    Locale['notify_sign_before_rent'] = 'You must sign this before I rent you this vehicle!'
    Locale['notify_signature_required'] = 'Please sign the rental agreement to continue.'

    Locale['target_label'] = 'Car Rental'
    Locale['target_return'] = 'Return Vehicle'

    Locale['debug_vehicle_spawned'] = 'Vehicle spawned: %s'
    Locale['debug_vehicle_deleted'] = 'Vehicle deleted: %s'
end
