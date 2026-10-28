Locales = Locales or {}

-- English is the fallback for every other language, so it must stay complete.
Locales['en'] = {
    Messages = {
        NoPermission = 'You do not have permission to use police tape.',
        MissingItem = 'You need police tape to do that.',
        StepOne = 'Step 1 of 2',
        StepTwo = 'Step 2 of 2',
        FirstAnchorTitle = 'Set the first anchor',
        FirstAnchorMeta = 'Aim at a post, wall or fence, then confirm.',
        FirstAnchorPostMeta = 'Aim at the ground for a post, or at a wall or pole.',
        SecondAnchorTitle = 'Set the second anchor',
        Span = 'Span %.1f m',
        SpanTooShort = 'Too short: %.1f m (at least %.1f m)',
        SpanTooLong = 'Too long: %.1f m (at most %.1f m)',
        NoSurface = 'Aim at a surface in range.',
        NotSteady = 'Stand still on your feet to place.',
        NotOnVehicles = 'Tape cannot be tied to vehicles or people.',
        OnFootOnly = 'You can only hang tape on foot.',
        KeyStyle = 'Change style',
        KeyConfirmAnchor = 'Confirm anchor',
        KeyHang = 'Hang tape',
        KeyBack = 'Back',
        ScrollKey = 'Scroll',
        Cancel = 'Cancel',
        TooShort = 'Those anchors are too close together.',
        TooLong = 'Those anchors are too far apart.',
        TooFar = 'That point is too far away.',
        TooCrowded = 'There is already too much tape in this area.',
        Placed = 'Police tape placed.',
        Removed = 'Police tape removed.',
        Restyled = 'Tape style changed.',
        NothingAimed = 'Look at a tape first.',
        RemoveHint = 'Remove tape',
        RemoveHoldHint = 'Hold to remove',
        RestyleHint = 'Change style',
        ModelFailed = 'The tape model could not be loaded.',
        TooFast = 'Slow down a little and try again.',
        Cleared = 'Removed %d tape(s).',
        NoAdminPermission = 'Only admins can clear police tape.',
    },

    -- Shown in Settings > Key Bindings > FiveM.
    CommandsHelpText = {
        Place = 'Police tape: Start placing',
        Confirm = 'Police tape: Confirm anchor',
        Cancel = 'Police tape: Back / cancel',
        CycleLeft = 'Police tape: Previous style',
        CycleRight = 'Police tape: Next style',
        AimRemove = 'Police tape: Remove the tape you look at',
        AimRestyle = 'Police tape: Change the style of the tape you look at',
    },

    -- Shown under the chat commands while typing them.
    ChatSuggestions = {
        Place = 'Hang police tape between two points',
        Remove = 'Remove the police tape you are looking at',
        Restyle = 'Cycle the style of the police tape you are looking at',
        Clear = 'Remove all police tape nearby, or everywhere with "all"',
        ClearArgument = 'Radius in metres, or "all"',
    },
}
