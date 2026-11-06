-- Policies & procedures seeded into the database on first start (only when the table is empty).
-- After that, edit them in-game from the Procedures tab (requires Config.Grades.editSops).

DefaultSops = {
    { category = 'Aide-mémoire', title = 'Incident command — arrival', body = [[1. Send informative message on arrival.
2. Confirm incident commander and command point.
3. Carry out dynamic risk assessment.
4. Identify water supplies (nearest hydrants on MDT).
5. Check SSRI / risk information for the address.
6. Request assistance early: make pumps as required.]] },

    { category = 'Aide-mémoire', title = 'Message types', body = [[Assistance message — "Make pumps 4, make aerial 1".
Informative message — what you have, what you are doing, what you need.
Stop message — no further assistance required.
Priority (status 0) — crew in danger, all units hold traffic.]] },

    { category = 'SOP', title = 'RTC — persons trapped', body = [[Scene safety: fend off with appliance, hazard warning lights on.
Stabilise the vehicle before any entry.
Glass management before cutting.
Check the Rescue tab for HV systems, airbag locations and cut zones.
Electric/hybrid: chock wheels, remove key, isolate 12V, wait for capacitors.
Plan A (fast extrication) and Plan B (full release) agreed with ambulance.]] },

    { category = 'SOP', title = 'Breathing apparatus', body = [[BA entry control board at the point of entry.
Minimum two wearers per team.
Record time of whistle and entry pressure.
Emergency team on standby before committing further crews.]] },

    { category = 'SOP', title = 'Hazardous materials', body = [[Approach from upwind and uphill.
Identify the substance: UN number and Emergency Action Code from placards.
Look it up on the HazMat tab.
Request HazMat officer early.
Establish inner and outer cordons. Decontamination before leaving the inner cordon.]] },

    { category = 'Policy', title = 'Automatic fire alarms', body = [[Confirm with premises before full attendance where policy allows.
Check the alarm panel location on the risk record.
Reset only after the cause is found and the premises are safe.]] },
}
