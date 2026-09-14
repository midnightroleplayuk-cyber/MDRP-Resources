# Pluto revive integration test

Only the two original QBX revive actions were changed.

- Player list -> General -> Revive now calls the documented Pluto **server** export:
  `exports['plt_ambulance_job']:InternalRevive(selectedPlayer.id)`
- Admin Options -> Revive self now calls the documented Pluto **client** export:
  `exports['plt_ambulance_job']:RevivePlayer()`
- If Pluto is not started, both fall back to the original qbx_medical behavior.

No `/heal`, native HP reset, `clearPlayerInjury`, or other workaround has been added.

Test with a broken bone/injury first, then use QBX Admin Menu -> Players -> select player -> General -> Revive.
