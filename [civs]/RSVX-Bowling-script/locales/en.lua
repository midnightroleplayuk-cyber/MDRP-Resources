local strings = {
    target_open = 'Book lane (%s%d per player)',
    target_open_free = 'Book lane',
    target_join = 'Join game',
    target_start = 'Start game',
    target_leave = 'Leave game',
    target_watch = 'Show / hide scores',
    target_board = 'Leaderboard',

    lane_taken = 'That lane is already in use.',
    lane_full = 'That lane is full.',
    already_playing = 'You are already on a lane.',
    too_far = 'You need to be at the lane.',
    no_money = 'You can\'t afford a game (%s%d).',
    paid = 'Paid %s%d for a game.',
    booked = 'Lane %d booked. Others can join at the console, then start the game.',
    joined = '%s joined lane %d.',
    left = '%s left the lane.',
    started = 'Game on. %s bowls first.',
    your_turn = 'Your turn. Head to the approach.',
    pickup = '[E] Pick up ball',
    missed_turn = '%s ran out of time. Counted as a miss.',
    winner = '%s wins lane %d with %d.',
    solo_done = 'Final score: %d.',
    not_host = 'Only the player who booked the lane can start it.',

    strike = 'STRIKE',
    spare = 'SPARE',
    gutter = 'GUTTER',
    pins = '%d',

    board_title = 'Bowling leaderboard',
    board_empty = 'No games recorded yet.',
    board_row = 'Best %d  |  %d games  |  %d strikes',

    admin_added = 'Added %d lane(s). First id: %d.',
    admin_removed = 'Lane %d removed.',
    admin_missing = 'No saved lane with that id. Lanes from config.lua are removed there.',
    admin_usage = 'Usage: /%s add [count] | remove <id> | edit <id> | copy <from> [to] | list | preview | pair <id> <id> | unpair <id> | screen <id> | screenreset <id> | panel <id> | panelremove <id>',
    admin_lane_saved = 'Lane %d saved.',
    admin_copied = 'Copied lane %d\'s setup to %d lane(s).',
    admin_lane_help = 'Arrows: move   PgUp PgDn: height   Q E: turn   Scroll: lane length   Alt+Scroll: pin spacing   Ctrl+Scroll: pin height   Shift: faster   X: fine   Enter: save   Backspace: cancel',
    admin_pair_usage = 'Usage: /%s pair <lane id> <lane id>',
    admin_paired = 'Lanes %d and %d now share a scoreboard and control panel.',
    admin_unpaired = 'Lane %d is no longer paired.',
    admin_panel_saved = 'Control panel for lane %d saved.',
    admin_panel_removed = 'Control panel for lane %d removed.',
    admin_no_lane = 'No lane with that id. Use the list action to see them.',
    admin_screen_saved = 'Screen for lane %d saved.',
    admin_screen_reset = 'Screen for lane %d put back to its default.',
    admin_reset_later = 'Reset saved. It takes effect once no games are running, or on restart.',
    admin_size_title = 'Screen size',
    admin_size_width = 'Width (metres)',
    admin_size_height = 'Height (metres)',
    admin_screen_far = 'Get closer to that lane first.',
    admin_screen_help = 'Left Right: sideways   Down: bring towards you   Up: push away   PgUp PgDn: height   Q E: turn   R F: tilt   Scroll: size (Alt width, Ctrl height)   G: exact size   Shift: faster   X: fine   Enter: save   Backspace: cancel',
}

function L(key, ...)
    local s = strings[key] or key
    if select('#', ...) > 0 then return s:format(...) end
    return s
end
