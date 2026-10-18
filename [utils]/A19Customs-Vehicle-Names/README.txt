A19CUSTOMS VEHICLE NAMES
========================

This standalone FiveM resource registers the display names for all vehicles
included in A19Customs Civilian Subscription Pack 1 and Pack 2.

RECOMMENDED INSTALLATION - STANDALONE RESOURCE
1. Place the A19Customs-Vehicle-Names folder inside your server resources folder.
2. Add the following line to server.cfg:

   ensure A19Customs-Vehicle-Names

3. Fully restart the server.

This resource is standalone and does not require ESX, QBCore, Qbox or any
other framework. It can be used alongside any framework or dealership script.

ALTERNATIVE INSTALLATION - COPY AND PASTE
The OPTIONAL-Copy-Paste folder contains one self-contained vehicle_names.lua.
Advanced users can copy this file, or its complete contents, into an existing
client-side resource that is already started by their server.

Do not start vehicle_names.lua directly in server.cfg. A loose Lua file will not
run unless it is loaded by a FiveM resource as a client script.

IMPORTANT
When using the recommended installation, keep the folder as its own resource.
Do not mix the standalone files with the vehicle pack resources.
The resource registers both each vehicles.meta gameName label and its spawn
code, improving compatibility with scripts that use either value.
