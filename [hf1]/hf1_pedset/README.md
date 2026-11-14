# Admin Ped Change (QBox / op-clothing)

## Installation
1. Put `admin-pedchange` in your server's resources folder.
2. Make sure `op-clothing` starts first.
3. Add `ensure admin-pedchange` after `ensure op-clothing` in server.cfg.
4. Make sure your administrators inherit the ACE principal `group.admin`.
   Example (replace with your actual license):
   `add_principal identifier.license:YOUR_LICENSE_HERE group.admin`

## Usage
An admin types `/pedchange 12` to open the character creator on player 12's screen.
Model changes are enabled, and op-clothing custom ped permission is granted to the target before opening.

## Notes
- QBox-compatible: uses FiveM ACE group permissions and op-clothing server exports.
- This grants custom ped permission through op-clothing, which may remain after the editor closes. The documentation does not specify its lifetime. If you want temporary access, a separate cleanup strategy must be tested against your version of op-clothing.
- Requires custom ped models to be installed/configured in op-clothing.
- The command uses the built-in chat notification event. If your chat resource is disabled, notifications may not display; the command still runs.
