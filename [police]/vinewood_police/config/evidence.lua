---------------------------------------------------------------------------
-- Evidence kept by vinewood_police: seizures when vinewood-mdt isn't running, and anything seized
-- from NPCs (which the MDT can't hold). With the MDT, player seizures still go into MDT evidence bags.
---------------------------------------------------------------------------
Config.Evidence = {
    Command = 'evidence',      -- opens the evidence store (at a station: desk or locker)
    Types = { 'Drugs', 'Weapon', 'Cash', 'Stolen property', 'Phone or electronic device', 'Documents', 'Clothing', 'Other' },
    -- Where officers can open the store: custody desks and equipment lockers.
    AtCustodyDesk = true,
    AtLocker = true,
}
