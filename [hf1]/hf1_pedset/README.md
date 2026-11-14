# admin-pedchange (QBox / op-clothing)

## Install
1. Place the `admin-pedchange` folder in your server's resources directory.
2. Add this line to `server.cfg` (outside of Lua files):

   add_ace group.admin admin-pedchange.use allow

3. Ensure your QBox admins are actually assigned to the `group.admin` ACE principal (e.g. QBox's existing ACE setup). This script does not assign admins.
4. Start resources in this order:

   ensure ox_lib
   ensure op-clothing
   ensure admin-pedchange

5. Restart the server and run `/pedchange 12` (replace 12 with an online server ID).

## Notes
- Only players with the ACE permission `admin-pedchange.use` can use this command. The supplied ACE line grants it to `group.admin`.
- The target receives custom ped permission, then the op-clothing creator opens with `allowModelChange = true`.
- Custom ped permission is NOT automatically revoked after the menu closes. This is intentional for testing; remove manually with the documented `RevokeCustomPedPermission(target)` export if needed.
- A successful export call means it was requested, not that the target client necessarily displayed the menu.
- If it fails, check the **server console** for `[admin-pedchange]` lines. The F8 console is not where server-side Lua errors are printed.
- `chat:addMessage` is not used anywhere in this version.
