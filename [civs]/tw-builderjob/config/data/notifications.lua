-- ============================================================================
-- NOTIFICATION TEXTS — key -> { text, type }
-- ============================================================================
-- The text comes from locales/*.lua; only the `type` (info|success|error) is
-- set here. Edit wording in the locale files, not here.
-- ============================================================================

Config.NotificationText = {
    ['wrongjob'] = {
        text = TL('wrongjob'),
        type = "error"
    },
    ['jobcooldown'] = {
        text = TL('jobcooldown'),
        type = "error"
    },
    ['playerfaraway'] = {
        text = TL('playerfaraway'),
        type = "info"
    },
    ['lobbyfull'] = {
        text = TL('lobbyfull'),
        type = "success"
    },
    ['jobnotstarted'] = {
        text = TL('jobnotstarted'),
        type = "error"
    },
    ['jobalreadystarted'] = {
        text = TL('jobalreadystarted'),
        type = "error"
    },
    ['jobstartrefused'] = {
        text = TL('jobstartrefused'),
        type = "error"
    },
    ['maxlevel'] = {
        text = TL('maxlevel'),
        type = "error"
    },
    ['joblevelnotenough'] = {
        text = TL('joblevelnotenough'),
        type = "error"
    },
    ['playeralreadyinlobby'] = {
        text = TL('playeralreadyinlobby'),
        type = "error"
    },

    ['missionnotselected'] = {
        text = TL('missionnotselected'),
        type = "error"
    },
    ['playerleftlobby'] = {
        text = TL('playerleftlobby'),
        type = "error"
    },
    ['resetJob'] = {
        text = TL('resetJob'),
        type = "error"
    },
    ['notowner'] = {
        text = TL('notowner'),
        type = "error"
    },
    ['usedtbxid'] = {
        text = TL('usedtbxid'),
        type = "error"
    },
    ['successfullyExp'] = {
        text = TL('successfullyExp'),
        type = "success"
    },
    ['notfoundtbxid'] = {
        text = TL('notfoundtbxid'),
        type = "error"
    },
    ['getontruck'] = {
        text = TL('getontruck'),
        type = "info"
    },
    ['alreadyarea'] = {
        text = TL('alreadyarea'),
        type = "error"
    },
    ['alreadyHaveItem'] = {
        text = TL('alreadyHaveItem'),
        type = "error"
    },
    ['isownernotleave'] = {
        text = TL('isownernotleave'),
        type = "error"
    },
    ['bonusjobtask'] = {
        text = TL('bonusjobtask'),
        type = "success"
    },
    ['settingssaved'] = {
        text = TL('settingssaved'),
        type = "success"
    },

    ['operationInProgress'] = {
        text = TL('operationInProgress'),
        type = "error"
    },
    ['cannotPickupWithCase'] = {
        text = TL('cannotPickupWithCase'),
        type = "error"
    },
    ['alreadyCarryingItem'] = {
        text = TL('alreadyCarryingItem'),
        type = "error"
    },
    ['returningCase'] = {
        text = TL('returningCase'),
        type = "info"
    },
    ['caseReturned'] = {
        text = TL('caseReturned'),
        type = "success"
    },
    ['cannotTakeItemAbove'] = {
        text = TL('cannotTakeItemAbove'),
        type = "error"
    },
    ['noItemsLeft'] = {
        text = TL('noItemsLeft'),
        type = "info"
    },

    ['cannotUseTableWithCase'] = {
        text = TL('cannotUseTableWithCase'),
        type = "error"
    },
    ['cannotUseTableWithItem'] = {
        text = TL('cannotUseTableWithItem'),
        type = "error"
    },
    ['enterTableId'] = {
        text = TL('enterTableId'),
        type = "info"
    },
    ['tableNotFound'] = {
        text = TL('tableNotFound'),
        type = "error"
    },
    ['modelLoadFailed'] = {
        text = TL('modelLoadFailed'),
        type = "error"
    },

    ['selectAnotherPosition'] = {
        text = TL('selectAnotherPosition'),
        type = "info"
    },
    ['alreadyPlacing'] = {
        lkey = 'alreadyInPlacement',
        text = TL('alreadyInPlacement'),
        type = "error"
    },
    ['notLobbyMember'] = {
        lkey = 'cannotPlaceNotMember',
        text = TL('cannotPlaceNotMember'),
        type = "error"
    },
    ['pressAlreadyRunning'] = {
        lkey = 'pressMachineRunning',
        text = TL('pressMachineRunning'),
        type = "error"
    },
    ['pressBroken'] = {
        lkey = 'pressMachineBroken',
        text = TL('pressMachineBroken'),
        type = "error"
    },
    ['operationCompleted'] = {
        text = TL('operationCompleted'),
        type = "success"
    },
    ['cannotPickupObjectWithCase'] = {
        text = TL('cannotPickupObjectWithCase'),
        type = "error"
    },
    ['noObjectToCarry'] = {
        text = TL('noObjectToCarry'),
        type = "error"
    },

    ['inviteAccepted'] = {
        text = TL('inviteAccepted'),
        type = "success"
    },
    ['inviteDeclined'] = {
        text = TL('inviteDeclined'),
        type = "info"
    },

    ['invalidRewardSplit'] = {
        text = TL('invalidRewardSplit'),
        type = "error"
    },
    ['rewardSplitUpdated'] = {
        text = TL('rewardSplitUpdated'),
        type = "success"
    },
    ['rewardSplitNotAllowed'] = {
        text = TL('rewardSplitNotAllowed'),
        type = "error"
    },
}

-- Level thresholds. Index = level, value = XP needed to reach it.
