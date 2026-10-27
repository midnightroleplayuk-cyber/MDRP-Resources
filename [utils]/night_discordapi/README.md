# Night Discord API

A comprehensive FiveM resource for integrating Discord functionality into your server. This resource provides easy access to Discord user data, guild membership, roles, and more through a simple API.

## 📋 Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Exports](#exports)
- [Usage Examples](#usage-examples)
- [Support](#support)

## ✨ Features

- **Discord User Management**: Check if users are members of specific Discord servers
- **Role Verification**: Verify user roles across multiple Discord servers
- **User Data Retrieval**: Get Discord user information, avatars, and member details
- **Guild Information**: Retrieve Discord server/guild information
- **Caching System**: Built-in caching for improved performance
- **Rate Limiting**: Automatic Discord API rate limit handling
- **Multi-Guild Support**: Support for multiple Discord servers
- **Custom Role Mapping**: Map Discord role IDs to custom names

## 🚀 Installation

1. **Download the resource** and place it in your server's resources folder
2. **Configure the resource** by editing `config/config.lua`
3. **Add to your server.cfg somewhere ON TOP as one of the first starting resources**:
   ```
   ensure night_discordapi
   ```
4. **Restart your server**

## ⚙️ Configuration

Edit `config/config.lua` to configure the resource:

**Note**: This resource requires a Discord bot to function. You must set up your custom bot: https://docs.nights-software.com/resources/discordAPI/#-creating-your-own-discord-bot.

```lua
Config = {
    -- Discord Bot Token (https://docs.nights-software.com/resources/discordAPI/#-creating-your-own-discord-bot)
    Discord_Bot_Token = "bot_token_here",
    
    -- Discord Guild/Server Configuration
    Discord_Guild_Names = {
        ["YOUR_GUILD_ID"] = "Your Guild Name",
        ["ANOTHER_GUILD_ID"] = "Another Guild Name",
    },
    
    -- Discord Role Mapping
    Discord_Role_Names = {
        ["ROLE_ID"] = "Role_Name",
        ["ANOTHER_ROLE_ID"] = "Another_Role",
    },
    
    -- Logging Level (0 = INFO/ERROR/WARN only, 1+ = includes DEBUG)
    Discord_API_Log_Level = 1,
}
```

### Configuration Details

- **Discord_Bot_Token**: Your Discord bot token
- **Discord_Guild_Names**: Map Discord server IDs to readable names
- **Discord_Role_Names**: Map Discord role IDs to custom role names
- **Discord_API_Log_Level**: Control logging verbosity

## 📚 Exports

### Guild Membership Functions

#### `IsUserPartOfThisGuild(src, force, guildName)`
Check if a player is a member of a specific Discord server.

**Parameters:**
- `src` (string): Player source ID
- `force` (boolean): Force refresh cache (required)
- `guildName` (string): Name of the Discord server (as defined in config) (required)

**Returns:** `boolean` - true if user is a member, false if not, nil on error

**Example:**
```lua
local isMember = exports['night_discordapi']:IsUserPartOfThisGuild(source, false, "Your Guild Name")
if isMember then
    print("Player is a member of the Discord server!")
end
```

#### `IsUserPartOfAnyOfTheseGuilds(src, force, guildNames)`
Check if a player is a member of any of the specified Discord servers.

**Parameters:**
- `src` (string): Player source ID
- `force` (boolean): Force refresh cache (optional)
- `guildNames` (table): Array of Discord server names (optional)

**Returns:** `boolean` - true if user is a member of any server, false if not, nil on error

**Example:**
```lua
local guildNames = {"Guild 1", "Guild 2", "Guild 3"}
local isMember = exports['night_discordapi']:IsUserPartOfAnyOfTheseGuilds(source, false, guildNames)
if isMember then
    print("Player is a member of at least one Discord server!")
end
```

#### `IsUserPartOfAllOfTheseGuilds(src, force, guildNames)`
Check if a player is a member of all specified Discord servers.

**Parameters:**
- `src` (string): Player source ID
- `force` (boolean): Force refresh cache (optional)
- `guildNames` (table): Array of Discord server names (optional)

**Returns:** `boolean` - true if user is a member of all servers, false if not, nil on error

**Example:**
```lua
local guildNames = {"Guild 1", "Guild 2"}
local isMember = exports['night_discordapi']:IsUserPartOfAllOfTheseGuilds(source, false, guildNames)
if isMember then
    print("Player is a member of all Discord servers!")
end
```

### User Data Functions

#### `GetDiscordUser(src, force)`
Get Discord user information for a player.

**Parameters:**
- `src` (string): Player source ID
- `force` (boolean): Force refresh cache (optional)

**Returns:** `table` - User data containing id, name, avatar, or nil on error

**Example:**
```lua
local userData = exports['night_discordapi']:GetDiscordUser(source, false)
if userData then
    print("Discord ID: " .. userData.id)
    print("Username: " .. userData.name)
    print("Avatar: " .. (userData.avatar or "No avatar"))
end
```

#### `GetDiscordMember(src, force, guildNames)`
Get Discord member information for a player in specific servers.

**Parameters:**
- `src` (string): Player source ID
- `force` (boolean): Force refresh cache (optional)
- `guildNames` (table): Array of Discord server names (optional)

**Returns:** `table` - Member data containing id, name, nick, avatar, discriminator, roles, or nil on error

**Example:**
```lua
local memberData = exports['night_discordapi']:GetDiscordMember(source, false, {"Your Guild Name"})
if memberData then
    print("Member ID: " .. memberData.id)
    print("Nickname: " .. (memberData.nick or "No nickname"))
    print("Roles: " .. table.concat(memberData.roles, ", "))
end
```

### Role Functions

#### `GetDiscordMemberRoles(src, force, guildNames)`
Get all Discord roles for a player across specified servers.

**Parameters:**
- `src` (string): Player source ID
- `force` (boolean): Force refresh cache (optional)
- `guildNames` (table): Array of Discord server names (optional)

**Returns:** `table` - Array of role names, or nil on error

**Example:**
```lua
local roles = exports['night_discordapi']:GetDiscordMemberRoles(source, false, {"Guild 1", "Guild 2"})
if roles then
    for _, role in ipairs(roles) do
        print("Role: " .. role)
    end
end
```

> **Note:** This returns **role names** filtered through `Config.Discord_Role_Names` — only roles you have mapped in the config are included. If you need the **raw Discord role IDs** (so your own resource can match by ID against its own mapping table), use `GetDiscordMemberRoleIds` below.

#### `GetDiscordMemberRoleIds(src, force, guildNames)`
Get the **raw, unfiltered** Discord role IDs for a player across the specified servers. Unlike `GetDiscordMemberRoles`, this **does not** filter against `Config.Discord_Role_Names` — you receive every role ID Discord returns for that member. Useful for downstream resources that maintain their own role-mapping tables and need to match by stable role ID rather than role name.

**Parameters:**
- `src` (number/string): Player source ID
- `force` (boolean): Force refresh cache (optional)
- `guildNames` (table): Array of Discord server names — uses all configured guilds when omitted (optional)

**Returns:** `table` - Array of role ID strings (e.g. `"123456789012345678"`), or `nil` on error. Empty array when the member is in the guild but holds no roles.

**Example:**
```lua
local roleIds = exports['night_discordapi']:GetDiscordMemberRoleIds(source, false, {"Your Guild"})
if roleIds then
    for _, id in ipairs(roleIds) do
        print("Role ID: " .. id)
    end
end
```

> **Tip:** Results are cached separately from `GetDiscordMemberRoles` (same TTL/eviction behaviour), so calling both in the same session does **not** double-spend Discord API requests.

#### `IsMemberPartOfThisRole(src, roleName, force, guildNames)`
Check if a player has a specific Discord role.

**Parameters:**
- `src` (string): Player source ID
- `roleName` (string): Name of the role to check
- `force` (boolean): Force refresh cache (optional)
- `guildNames` (table): Array of Discord server names (optional)

**Returns:** `boolean` - true if user has the role, false if not, nil on error

**Example:**
```lua
local hasRole = exports['night_discordapi']:IsMemberPartOfThisRole(source, "Admin", false, {"Your Guild"})
if hasRole then
    print("Player has Admin role!")
end
```

#### `IsMemberPartOfAnyOfTheseRoles(src, roleNames, force, guildNames)`
Check if a player has any of the specified Discord roles.

**Parameters:**
- `src` (string): Player source ID
- `roleNames` (table): Array of role names to check
- `force` (boolean): Force refresh cache (optional)
- `guildNames` (table): Array of Discord server names (optional)

**Returns:** `boolean` - true if user has any of the roles, false if not, nil on error

**Example:**
```lua
local roleNames = {"Admin", "Moderator", "VIP"}
local hasRole = exports['night_discordapi']:IsMemberPartOfAnyOfTheseRoles(source, roleNames, false, {"Your Guild"})
if hasRole then
    print("Player has at least one of the specified roles!")
end
```

#### `IsMemberPartOfAllOfTheseRoles(src, roleNames, force, guildNames)`
Check if a player has all of the specified Discord roles.

**Parameters:**
- `src` (string): Player source ID
- `roleNames` (table): Array of role names to check
- `force` (boolean): Force refresh cache (optional)
- `guildNames` (table): Array of Discord server names (optional)

**Returns:** `boolean` - true if user has all roles, false if not, nil on error

**Example:**
```lua
local roleNames = {"Admin", "Moderator"}
local hasAllRoles = exports['night_discordapi']:IsMemberPartOfAllOfTheseRoles(source, roleNames, false, {"Your Guild"})
if hasAllRoles then
    print("Player has all specified roles!")
end
```

### Guild Information Functions

#### `GetDiscordGuild(guildName, force)`
Get information about a Discord server/guild.

**Parameters:**
- `guildName` (string): Name of the Discord server (as defined in config)
- `force` (boolean): Force refresh cache (optional)

**Returns:** `table` - Guild data containing id, name, icon, ownerid, roles, or nil on error

**Example:**
```lua
local guildData = exports['night_discordapi']:GetDiscordGuild("Your Guild Name", false)
if guildData then
    print("Guild ID: " .. guildData.id)
    print("Guild Name: " .. guildData.name)
    print("Owner ID: " .. guildData.ownerid)
end
```

### Configuration Functions

These read straight from `config.lua` so other resources can enumerate the mappings this resource knows about — useful for rendering admin dropdowns ("pick a configured role / guild") without hard-coding lists in every consumer.

#### `GetConfiguredRoles()`
Returns the configured role-name table from `config.lua` as `{ [roleID] = roleName }`.

**Parameters:** None.

**Returns:** `table` - `{ [roleID] = roleName }`, or `nil` if the resource config is invalid.

**Example:**
```lua
local roles = exports['night_discordapi']:GetConfiguredRoles()
if roles then
    for roleId, roleName in pairs(roles) do
        print(roleId, "->", roleName)
    end
end
```

#### `GetConfiguredGuilds()`
Returns the configured guild table from `config.lua` as `{ [guildID] = guildName }`.

**Parameters:** None.

**Returns:** `table` - `{ [guildID] = guildName }`, or `nil` if the resource config is invalid.

**Example:**
```lua
local guilds = exports['night_discordapi']:GetConfiguredGuilds()
if guilds then
    for guildId, guildName in pairs(guilds) do
        print(guildId, "->", guildName)
    end
end
```

## 💡 Usage Examples

### Basic Permission System
```lua
-- Check if player has admin role
local hasAdmin = exports['night_discordapi']:IsMemberPartOfThisRole(source, "Admin", false, {"Your Guild"})
if hasAdmin then
    -- Give admin permissions
    TriggerClientEvent('chat:addMessage', source, {
        color = {255, 0, 0},
        multiline = true,
        args = {"System", "You have admin permissions!"}
    })
end
```

### Multi-Server Role Check
```lua
-- Check if player has role in any of multiple servers
local guildNames = {"Main Server", "Staff Server", "VIP Server"}
local roleNames = {"Admin", "Moderator", "VIP"}
local hasPermission = exports['night_discordapi']:IsMemberPartOfAnyOfTheseRoles(source, roleNames, false, guildNames)

if hasPermission then
    -- Example: Grant access to restricted area
    TriggerClientEvent('restrictedArea:grantAccess', source)
end
```

### User Information Display
```lua
-- Get and display user information
local userData = exports['night_discordapi']:GetDiscordUser(source, false)
if userData then
    TriggerClientEvent('chat:addMessage', -1, {
        color = {0, 255, 0},
        multiline = true,
        args = {"Discord", userData.name .. " joined the server!"}
    })
end
```

### Guild Membership Verification
```lua
-- Verify player is member of specific guild
local isMember = exports['night_discordapi']:IsUserPartOfThisGuild(source, false, "Whitelisted Guild")
if not isMember then
    DropPlayer(source, "You must be a member of our Discord server to join this server.")
end
```

### Advanced Role System
```lua
-- Check multiple roles across multiple servers
local guildNames = {"Police Department", "Fire Department", "EMS"}
local requiredRoles = {"Officer", "Firefighter", "Paramedic"}

local hasRequiredRole = exports['night_discordapi']:IsMemberPartOfAnyOfTheseRoles(source, requiredRoles, false, guildNames)
if hasRequiredRole then
    -- Allow access to emergency services
    TriggerClientEvent('emergency:grantAccess', source)
else
    TriggerClientEvent('chat:addMessage', source, {
        color = {255, 0, 0},
        multiline = true,
        args = {"System", "You need to be verified in our Discord server to access emergency services."}
    })
end
```

## 🔧 Advanced Configuration

### Custom Role Mapping
```lua
Discord_Role_Names = {
    ["123456789012345678"] = "Admin",
    ["987654321098765432"] = "Moderator",
    ["555666777888999000"] = "VIP",
    -- Add more role mappings as needed
}
```

### Multiple Guild Support
```lua
Discord_Guild_Names = {
    ["123456789012345678"] = "Main Server",
    ["987654321098765432"] = "Staff Server",
    ["555666777888999000"] = "VIP Server",
    -- Add more guilds as needed
}
```

## 🛠️ Troubleshooting

### Common Issues

1. **Bot Token Invalid**: Ensure your Discord bot token is correct and the bot has proper permissions
2. **Guild Not Found**: Make sure the bot is invited to all configured Discord servers
3. **Role Not Found**: Verify role IDs are correct and the bot has permission to view roles
4. **Rate Limiting**: The resource handles Discord API rate limits automatically

### Debug Mode
Enable debug logging by setting `Discord_API_Log_Level = 1` in your config to see detailed API request information.

## 📞 Support

- **Documentation**: https://docs.nights-software.com/resources/discordAPI/
- **Discord Support**: https://discord.nights-software.com/
- **Installation Video**: Available on the documentation page

## 📄 License

This resource is developed and maintained by Nights Software.