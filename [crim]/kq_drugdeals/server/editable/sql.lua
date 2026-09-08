
local function SqlQuery(query, data)
    return exports.oxmysql:fetchSync(query, data or {})
end

local function SqlMutate(query, data)
    return exports.oxmysql:insertSync(query, data)
end

DB = {}
DB.SqlMutate = SqlMutate
DB.SqlQuery = SqlQuery

DB.GetDrugs = function()
    local query = [[
        SELECT drug_id, item, label, base_price,
               use_meta_pricing, meta_key, meta_kind, meta_steps, prop, street_chance,
               street_min_quantity, street_max_quantity, app_min_quantity, app_max_quantity,
               app_min_rating, street, app, active, created_at, updated_at
        FROM kq_drugdeals_drugs;
    ]]

    return SqlQuery(query) or {}
end

DB.SaveDrug = function(drug, createdBy)
    local mutation = [[
        INSERT INTO kq_drugdeals_drugs (drug_id, item, label, base_price,
                                        use_meta_pricing, meta_key, meta_kind, meta_steps, prop, street_chance,
                                        street_min_quantity, street_max_quantity, app_min_quantity, app_max_quantity,
                                        app_min_rating, street, app, active, created_by)
        VALUES (@drug_id, @item, @label, @base_price,
                @use_meta_pricing, @meta_key, @meta_kind, @meta_steps, @prop, @street_chance,
                @street_min_quantity, @street_max_quantity, @app_min_quantity, @app_max_quantity,
                @app_min_rating, @street, @app, @active, @created_by)
        ON DUPLICATE KEY UPDATE
            item = @item,
            label = @label,
            base_price = @base_price,
            use_meta_pricing = @use_meta_pricing,
            meta_key = @meta_key,
            meta_kind = @meta_kind,
            meta_steps = @meta_steps,
            prop = @prop,
            street_chance = @street_chance,
            street_min_quantity = @street_min_quantity,
            street_max_quantity = @street_max_quantity,
            app_min_quantity = @app_min_quantity,
            app_max_quantity = @app_max_quantity,
            app_min_rating = @app_min_rating,
            street = @street,
            app = @app,
            active = @active;
    ]]

    return SqlMutate(mutation, {
        ['@drug_id'] = drug.id,
        ['@item'] = drug.item,
        ['@label'] = drug.label,
        ['@base_price'] = drug.basePrice,
        ['@use_meta_pricing'] = drug.useMetaPricing and 1 or 0,
        ['@meta_key'] = drug.metaKey,
        ['@meta_kind'] = drug.metaKind,
        ['@meta_steps'] = json.encode(drug.metaSteps),
        ['@prop'] = drug.prop or '',
        ['@street_chance'] = drug.streetChance,
        ['@street_min_quantity'] = drug.streetMinQuantity,
        ['@street_max_quantity'] = drug.streetMaxQuantity,
        ['@app_min_quantity'] = drug.appMinQuantity,
        ['@app_max_quantity'] = drug.appMaxQuantity,
        ['@app_min_rating'] = drug.appMinRating,
        ['@street'] = drug.street and 1 or 0,
        ['@app'] = drug.app and 1 or 0,
        ['@active'] = drug.active and 1 or 0,
        ['@created_by'] = createdBy or '',
    })
end

DB.SetDrugActive = function(drugId, active)
    local mutation = [[
        UPDATE kq_drugdeals_drugs SET active = @active WHERE drug_id = @drug_id;
    ]]

    return SqlMutate(mutation, {
        ['@drug_id'] = drugId,
        ['@active'] = active and 1 or 0,
    })
end

DB.DeleteDrug = function(drugId)
    local mutation = [[
        DELETE FROM kq_drugdeals_drugs WHERE drug_id = @drug_id;
    ]]

    return SqlMutate(mutation, {
        ['@drug_id'] = drugId,
    })
end


DB.GetHotspots = function()
    local query = [[
        SELECT hotspot_id, name, `x`, `y`, `z`, radius, points, drugs, accept_multiplier, active, created_at, updated_at
        FROM kq_drugdeals_hotspots;
    ]]

    return SqlQuery(query) or {}
end

DB.SaveHotspot = function(hotspot, createdBy)
    local mutation = [[
        INSERT INTO kq_drugdeals_hotspots (hotspot_id, name, `x`, `y`, `z`, radius, points, drugs, accept_multiplier, active, created_by)
        VALUES (@hotspot_id, @name, @x, @y, @z, @radius, @points, @drugs, @accept_multiplier, @active, @created_by)
        ON DUPLICATE KEY UPDATE
            name = @name,
            `x` = @x, `y` = @y, `z` = @z,
            radius = @radius,
            points = @points,
            drugs = @drugs,
            accept_multiplier = @accept_multiplier,
            active = @active;
    ]]

    return SqlMutate(mutation, {
        ['@hotspot_id'] = hotspot.id,
        ['@name'] = hotspot.name,
        ['@x'] = hotspot.coords.x,
        ['@y'] = hotspot.coords.y,
        ['@z'] = hotspot.coords.z,
        ['@radius'] = hotspot.radius,
        ['@points'] = json.encode(hotspot.points),
        ['@drugs'] = json.encode(hotspot.drugs),
        ['@accept_multiplier'] = hotspot.approachChance or -1,
        ['@active'] = hotspot.active and 1 or 0,
        ['@created_by'] = createdBy or '',
    })
end

DB.SetHotspotActive = function(hotspotId, active)
    local mutation = [[
        UPDATE kq_drugdeals_hotspots SET active = @active WHERE hotspot_id = @hotspot_id;
    ]]

    return SqlMutate(mutation, {
        ['@hotspot_id'] = hotspotId,
        ['@active'] = active and 1 or 0,
    })
end

DB.DeleteHotspot = function(hotspotId)
    local mutation = [[
        DELETE FROM kq_drugdeals_hotspots WHERE hotspot_id = @hotspot_id;
    ]]

    return SqlMutate(mutation, {
        ['@hotspot_id'] = hotspotId,
    })
end


DB.GetOrganizations = function()
    local query = [[
        SELECT org_id, name, sell_spots, unlock_mode, buyin_cash, buyin_drug_id, buyin_drug_amount, buy_prices, fixer_spots, description, enemies, boss_model, member_models, jobs, jobs_enabled, metadata, active, created_at, updated_at
        FROM kq_drugdeals_organizations;
    ]]

    return SqlQuery(query) or {}
end

DB.SaveOrganization = function(org, createdBy)
    local mutation = [[
        INSERT INTO kq_drugdeals_organizations (org_id, name, sell_spots, unlock_mode, buyin_cash, buyin_drug_id, buyin_drug_amount, buy_prices, fixer_spots, description, enemies, boss_model, member_models, jobs, jobs_enabled, metadata, active, created_by)
        VALUES (@org_id, @name, @sell_spots, @unlock_mode, @buyin_cash, @buyin_drug_id, @buyin_drug_amount, @buy_prices, @fixer_spots, @description, @enemies, @boss_model, @member_models, @jobs, @jobs_enabled, @metadata, @active, @created_by)
        ON DUPLICATE KEY UPDATE
            name = @name,
            sell_spots = @sell_spots,
            unlock_mode = @unlock_mode,
            buyin_cash = @buyin_cash,
            buyin_drug_id = @buyin_drug_id,
            buyin_drug_amount = @buyin_drug_amount,
            buy_prices = @buy_prices,
            fixer_spots = @fixer_spots,
            description = @description,
            enemies = @enemies,
            boss_model = @boss_model,
            member_models = @member_models,
            jobs = @jobs,
            jobs_enabled = @jobs_enabled,
            metadata = @metadata,
            active = @active;
    ]]

    return SqlMutate(mutation, {
        ['@org_id'] = org.id,
        ['@name'] = org.name,
        ['@sell_spots'] = json.encode(org.sellSpots),
        ['@unlock_mode'] = org.unlockMode,
        ['@buyin_cash'] = org.buyinCash,
        ['@buyin_drug_id'] = org.buyinDrugId or '',
        ['@buyin_drug_amount'] = org.buyinDrugAmount,
        ['@buy_prices'] = json.encode(org.buyPrices),
        ['@fixer_spots'] = json.encode(org.fixerSpots),
        ['@description'] = org.description,
        ['@enemies'] = json.encode(org.enemies),
        ['@boss_model'] = org.bossModel or '',
        ['@member_models'] = json.encode(org.memberModels),
        ['@jobs'] = json.encode(org.jobs),
        ['@jobs_enabled'] = org.jobsEnabled and 1 or 0,
        ['@metadata'] = json.encode({ limits = org.limits }),
        ['@active'] = org.active and 1 or 0,
        ['@created_by'] = createdBy or '',
    })
end

DB.SetOrganizationActive = function(orgId, active)
    local mutation = [[
        UPDATE kq_drugdeals_organizations SET active = @active WHERE org_id = @org_id;
    ]]

    return SqlMutate(mutation, {
        ['@org_id'] = orgId,
        ['@active'] = active and 1 or 0,
    })
end

DB.DeleteOrganization = function(orgId)
    local mutation = [[
        DELETE FROM kq_drugdeals_organizations WHERE org_id = @org_id;
    ]]

    return SqlMutate(mutation, {
        ['@org_id'] = orgId,
    })
end


DB.GetDeliveryLocations = function()
    local query = [[
        SELECT delivery_id, name, `x`, `y`, `z`, `h`, allow_npc, allow_deaddrop, allow_favour, active, created_at, updated_at
        FROM kq_drugdeals_delivery_locations;
    ]]

    return SqlQuery(query) or {}
end

DB.SaveDeliveryLocation = function(location, createdBy)
    local mutation = [[
        INSERT INTO kq_drugdeals_delivery_locations (delivery_id, name, `x`, `y`, `z`, `h`, allow_npc, allow_deaddrop, allow_favour, active, created_by)
        VALUES (@delivery_id, @name, @x, @y, @z, @h, @allow_npc, @allow_deaddrop, @allow_favour, @active, @created_by)
        ON DUPLICATE KEY UPDATE
            name = @name,
            `x` = @x, `y` = @y, `z` = @z, `h` = @h,
            allow_npc = @allow_npc,
            allow_deaddrop = @allow_deaddrop,
            allow_favour = @allow_favour,
            active = @active;
    ]]

    return SqlMutate(mutation, {
        ['@delivery_id'] = location.id,
        ['@name'] = location.name,
        ['@x'] = location.coords.x,
        ['@y'] = location.coords.y,
        ['@z'] = location.coords.z,
        ['@h'] = location.coords.h,
        ['@allow_npc'] = location.npc and 1 or 0,
        ['@allow_deaddrop'] = location.deaddrop and 1 or 0,
        ['@allow_favour'] = location.favour and 1 or 0,
        ['@active'] = location.active and 1 or 0,
        ['@created_by'] = createdBy or '',
    })
end

DB.SetDeliveryLocationActive = function(deliveryId, active)
    local mutation = [[
        UPDATE kq_drugdeals_delivery_locations SET active = @active WHERE delivery_id = @delivery_id;
    ]]

    return SqlMutate(mutation, {
        ['@delivery_id'] = deliveryId,
        ['@active'] = active and 1 or 0,
    })
end

DB.DeleteDeliveryLocation = function(deliveryId)
    local mutation = [[
        DELETE FROM kq_drugdeals_delivery_locations WHERE delivery_id = @delivery_id;
    ]]

    return SqlMutate(mutation, {
        ['@delivery_id'] = deliveryId,
    })
end


DB.GetVehicleLocations = function()
    local query = [[
        SELECT vehicle_id, name, `x`, `y`, `z`, `h`, active, created_at, updated_at
        FROM kq_drugdeals_vehicle_locations;
    ]]

    return SqlQuery(query) or {}
end

DB.SaveVehicleLocation = function(location, createdBy)
    local mutation = [[
        INSERT INTO kq_drugdeals_vehicle_locations (vehicle_id, name, `x`, `y`, `z`, `h`, active, created_by)
        VALUES (@vehicle_id, @name, @x, @y, @z, @h, @active, @created_by)
        ON DUPLICATE KEY UPDATE
            name = @name,
            `x` = @x, `y` = @y, `z` = @z, `h` = @h,
            active = @active;
    ]]

    return SqlMutate(mutation, {
        ['@vehicle_id'] = location.id,
        ['@name'] = location.name,
        ['@x'] = location.coords.x,
        ['@y'] = location.coords.y,
        ['@z'] = location.coords.z,
        ['@h'] = location.coords.h,
        ['@active'] = location.active and 1 or 0,
        ['@created_by'] = createdBy or '',
    })
end

DB.SetVehicleLocationActive = function(vehicleId, active)
    local mutation = [[
        UPDATE kq_drugdeals_vehicle_locations SET active = @active WHERE vehicle_id = @vehicle_id;
    ]]

    return SqlMutate(mutation, {
        ['@vehicle_id'] = vehicleId,
        ['@active'] = active and 1 or 0,
    })
end

DB.DeleteVehicleLocation = function(vehicleId)
    local mutation = [[
        DELETE FROM kq_drugdeals_vehicle_locations WHERE vehicle_id = @vehicle_id;
    ]]

    return SqlMutate(mutation, {
        ['@vehicle_id'] = vehicleId,
    })
end


DB.GetCorners = function()
    local query = [[
        SELECT corner_id, name, `x`, `y`, `z`, radius, drugs, max_players, buyer_interval,
            different_drug_chance, allow_vehicle, jobs, jobs_enabled, active, created_at, updated_at
        FROM kq_drugdeals_corners;
    ]]

    return SqlQuery(query) or {}
end

DB.SaveCorner = function(corner, createdBy)
    local mutation = [[
        INSERT INTO kq_drugdeals_corners (corner_id, name, `x`, `y`, `z`, radius, drugs, max_players,
            buyer_interval, different_drug_chance, allow_vehicle, jobs, jobs_enabled, active, created_by)
        VALUES (@corner_id, @name, @x, @y, @z, @radius, @drugs, @max_players,
            @buyer_interval, @different_drug_chance, @allow_vehicle, @jobs, @jobs_enabled, @active, @created_by)
        ON DUPLICATE KEY UPDATE
            name = @name,
            `x` = @x, `y` = @y, `z` = @z,
            radius = @radius,
            drugs = @drugs,
            max_players = @max_players,
            buyer_interval = @buyer_interval,
            different_drug_chance = @different_drug_chance,
            allow_vehicle = @allow_vehicle,
            jobs = @jobs,
            jobs_enabled = @jobs_enabled,
            active = @active;
    ]]

    return SqlMutate(mutation, {
        ['@corner_id'] = corner.id,
        ['@name'] = corner.name,
        ['@x'] = corner.coords.x,
        ['@y'] = corner.coords.y,
        ['@z'] = corner.coords.z,
        ['@radius'] = corner.radius,
        ['@drugs'] = json.encode(corner.drugs),
        ['@max_players'] = corner.maxPlayers,
        ['@buyer_interval'] = corner.buyerInterval,
        ['@different_drug_chance'] = corner.differentDrugChance,
        ['@allow_vehicle'] = corner.allowVehicle and 1 or 0,
        ['@jobs'] = json.encode(corner.jobs),
        ['@jobs_enabled'] = corner.jobsEnabled and 1 or 0,
        ['@active'] = corner.active and 1 or 0,
        ['@created_by'] = createdBy or '',
    })
end

DB.SetCornerActive = function(cornerId, active)
    local mutation = [[
        UPDATE kq_drugdeals_corners SET active = @active WHERE corner_id = @corner_id;
    ]]

    return SqlMutate(mutation, {
        ['@corner_id'] = cornerId,
        ['@active'] = active and 1 or 0,
    })
end

DB.DeleteCorner = function(cornerId)
    local mutation = [[
        DELETE FROM kq_drugdeals_corners WHERE corner_id = @corner_id;
    ]]

    return SqlMutate(mutation, {
        ['@corner_id'] = cornerId,
    })
end


DB.GetPlayerRep = function(characterId)
    local query = [[
        SELECT stars, deals_completed FROM kq_drugdeals_player_rep WHERE character_id = @character_id;
    ]]

    local rows = SqlQuery(query, {
        ['@character_id'] = characterId,
    })

    return rows and rows[1] or nil
end

DB.SavePlayerRep = function(characterId, stars, dealsCompleted)
    local mutation = [[
        INSERT INTO kq_drugdeals_player_rep (character_id, stars, deals_completed)
        VALUES (@character_id, @stars, @deals_completed)
        ON DUPLICATE KEY UPDATE
            stars = @stars,
            deals_completed = @deals_completed;
    ]]

    return SqlMutate(mutation, {
        ['@character_id'] = characterId,
        ['@stars'] = stars,
        ['@deals_completed'] = dealsCompleted,
    })
end


DB.GetMarket = function()
    local query = [[
        SELECT drug_id, drift FROM kq_drugdeals_market;
    ]]

    return SqlQuery(query) or {}
end

DB.SaveMarketDrift = function(drugId, drift)
    local mutation = [[
        INSERT INTO kq_drugdeals_market (drug_id, drift)
        VALUES (@drug_id, @drift)
        ON DUPLICATE KEY UPDATE
            drift = @drift;
    ]]

    return SqlMutate(mutation, {
        ['@drug_id'] = drugId,
        ['@drift'] = drift,
    })
end

DB.DeleteMarketDrift = function(drugId)
    local mutation = [[
        DELETE FROM kq_drugdeals_market WHERE drug_id = @drug_id;
    ]]

    return SqlMutate(mutation, {
        ['@drug_id'] = drugId,
    })
end


-- `expired` is computed by the DB: Lua has no wall clock in this resource
DB.GetPlayerContacts = function(characterId)
    local query = [[
        SELECT contact_id, name, avatar, persona, delivery_method, ped_model, drugs, standing,
               deals, never_buys, status, farewell_sent, home_x, home_y, created_at,
               (status = 'active' AND expires_at < NOW()) AS expired
        FROM kq_drugdeals_contacts
        WHERE character_id = @character_id;
    ]]

    return SqlQuery(query, {
        ['@character_id'] = characterId,
    }) or {}
end

DB.SaveContact = function(contact, ttlDays)
    local mutation = [[
        INSERT INTO kq_drugdeals_contacts (contact_id, character_id, name, avatar, persona,
                                           delivery_method, ped_model, drugs, standing, never_buys,
                                           deals, home_x, home_y, status, expires_at)
        VALUES (@contact_id, @character_id, @name, @avatar, @persona,
                @delivery_method, @ped_model, @drugs, @standing, @never_buys,
                @deals, @home_x, @home_y, 'active', DATE_ADD(NOW(), INTERVAL @ttl_days DAY));
    ]]

    return SqlMutate(mutation, {
        ['@contact_id'] = contact.id,
        ['@character_id'] = contact.characterId,
        ['@name'] = contact.name,
        ['@avatar'] = contact.avatar,
        ['@persona'] = contact.persona,
        ['@delivery_method'] = contact.deliveryMethod,
        ['@ped_model'] = contact.pedModel or '',
        ['@drugs'] = json.encode(contact.drugs),
        ['@standing'] = contact.standing,
        ['@never_buys'] = contact.neverBuys and 1 or 0,
        ['@deals'] = contact.deals,
        ['@home_x'] = contact.home and contact.home.x or nil,
        ['@home_y'] = contact.home and contact.home.y or nil,
        ['@ttl_days'] = ttlDays,
    })
end

DB.SaveContactStanding = function(contactId, standing)
    local mutation = [[
        UPDATE kq_drugdeals_contacts SET standing = @standing WHERE contact_id = @contact_id;
    ]]

    return SqlMutate(mutation, {
        ['@contact_id'] = contactId,
        ['@standing'] = standing,
    })
end

DB.IncrementContactDeals = function(contactId)
    local mutation = [[
        UPDATE kq_drugdeals_contacts SET deals = deals + 1 WHERE contact_id = @contact_id;
    ]]

    return SqlMutate(mutation, {
        ['@contact_id'] = contactId,
    })
end

DB.SetContactStatus = function(contactId, status)
    local mutation = [[
        UPDATE kq_drugdeals_contacts SET status = @status WHERE contact_id = @contact_id;
    ]]

    return SqlMutate(mutation, {
        ['@contact_id'] = contactId,
        ['@status'] = status,
    })
end

DB.MarkContactFarewell = function(contactId)
    local mutation = [[
        UPDATE kq_drugdeals_contacts SET farewell_sent = 1 WHERE contact_id = @contact_id;
    ]]

    return SqlMutate(mutation, {
        ['@contact_id'] = contactId,
    })
end

DB.DeleteContact = function(contactId)
    local mutation = [[
        DELETE FROM kq_drugdeals_contacts WHERE contact_id = @contact_id;
    ]]

    return SqlMutate(mutation, {
        ['@contact_id'] = contactId,
    })
end

DB.ExpireContacts = function()
    local mutation = [[
        UPDATE kq_drugdeals_contacts SET status = 'deleted'
        WHERE status = 'active' AND expires_at < NOW();
    ]]

    return SqlMutate(mutation)
end

DB.GetOrgUnlocks = function(characterId)
    local query = [[
        SELECT org_id FROM kq_drugdeals_player_orgs
        WHERE character_id = @character_id AND unlocked = 1;
    ]]

    return SqlQuery(query, {
        ['@character_id'] = characterId,
    }) or {}
end

DB.SaveOrgUnlock = function(characterId, orgId)
    local mutation = [[
        INSERT INTO kq_drugdeals_player_orgs (character_id, org_id, unlocked, standing)
        VALUES (@character_id, @org_id, 1, @standing)
        ON DUPLICATE KEY UPDATE
            unlocked = 1;
    ]]

    return SqlMutate(mutation, {
        ['@character_id'] = characterId,
        ['@org_id'] = orgId,
        ['@standing'] = Config.org.standing.default,
    })
end

DB.RemoveOrgUnlock = function(characterId, orgId)
    local mutation = [[
        UPDATE kq_drugdeals_player_orgs SET unlocked = 0
        WHERE character_id = @character_id AND org_id = @org_id;
    ]]

    return SqlMutate(mutation, {
        ['@character_id'] = characterId,
        ['@org_id'] = orgId,
    })
end

-- re-locks only; the standing on the row survives the reset
DB.DeleteOrgUnlocks = function(orgId)
    local mutation = [[
        UPDATE kq_drugdeals_player_orgs SET unlocked = 0 WHERE org_id = @org_id;
    ]]

    return SqlMutate(mutation, {
        ['@org_id'] = orgId,
    })
end

DB.GetOrgStandings = function(characterId)
    local query = [[
        SELECT org_id, standing FROM kq_drugdeals_player_orgs
        WHERE character_id = @character_id;
    ]]

    return SqlQuery(query, {
        ['@character_id'] = characterId,
    }) or {}
end

-- one-shot inactivity decay over the whole table; the DB does the clock math
DB.DecayOrgStandings = function(floor, intervalSeconds, pointsPerLevel)
    local mutation = [[
        UPDATE kq_drugdeals_player_orgs
        SET standing = GREATEST(@floor,
                standing - @points * FLOOR(TIMESTAMPDIFF(SECOND, standing_updated_at, NOW()) / @interval)),
            standing_updated_at = current_timestamp()
        WHERE standing > @floor
          AND TIMESTAMPDIFF(SECOND, standing_updated_at, NOW()) >= @interval;
    ]]

    return SqlMutate(mutation, {
        ['@floor'] = floor,
        ['@interval'] = intervalSeconds,
        ['@points'] = pointsPerLevel,
    })
end

DB.SaveOrgStanding = function(characterId, orgId, standing)
    local mutation = [[
        INSERT INTO kq_drugdeals_player_orgs (character_id, org_id, standing)
        VALUES (@character_id, @org_id, @standing)
        ON DUPLICATE KEY UPDATE
            standing = @standing,
            standing_updated_at = current_timestamp();
    ]]

    return SqlMutate(mutation, {
        ['@character_id'] = characterId,
        ['@org_id'] = orgId,
        ['@standing'] = standing,
    })
end

-- runs a raw setup-import query, returns affected rows (setup.lua imports).
-- updateSync (not executeSync) because oxmysql's execute returns the raw
-- OkPacket for an INSERT, while update returns the affectedRows number
DB.SqlImport = function(query)
    return exports.oxmysql:updateSync(query, {})
end
