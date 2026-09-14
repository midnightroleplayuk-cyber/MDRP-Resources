# Pluto full-revive compatibility patch

This patch changes QBX Admin Menu revive so it uses Pluto Ambulance Creator's own revive plus the exact `/heal <id>` command path.

## Why
A QBX revive restores life/health, but Pluto stores additional medical state such as fractures. Pluto's manual `/heal` command clears that state correctly on this server.

## Flow
1. QBX Admin Menu calls Pluto `RevivePlayer(targetSrc)`.
2. 750 ms later the server executes `heal <targetSrc>`.
3. The administering client's command context also executes `heal <targetSrc>` for compatibility with a client-registered command.
4. The target gets a final native health/visual-damage cleanup.

## Test
Break a bone, then use QBX Admin Menu -> Players -> General -> Revive. Also test the self-revive admin option.

Watch the server/client console for any `Unknown command heal` or Pluto permission errors. If `/heal ID` works manually but the menu still does not, those console lines will identify whether Pluto's command requires the admin player's command source instead of console execution.
