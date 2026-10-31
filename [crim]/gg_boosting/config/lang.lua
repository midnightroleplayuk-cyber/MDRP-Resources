lang = {}
lang.translations = {
    defaults = {
        success = "Success",
        error = "Error",
        failed = "Failed",
        money = "Not Enough Money",
        item_space = "Not enough space in pockets",
        item_empty = "Nothing to get here",  
        acquire = "Acquire",
        operation = "Operation",
        delivery = "Delivery",
        debounce = "Slow down, try again shortly.",
    },
    player = {
        level = "Level",
    },
    missions = {
        acquire = {
            mug_owner = {
                no_key_vehicle = "No keys in here take them from the owner outside.",
                target_take_keys = "Take Keys",
                unarmed_action = "They won't budge, you're unarmed... maybe rough them up?",
            },
            test_drive = {
                ask_driver = "You need to ask the driver to test drive.",
                target_driver = "Ask to Test Drive",  
            },
            hack_keyless = {
                vehicle_kickout = "Use the DigiScanner to get the keyfob signal",
                found_signal = "Keyfob Signal Found",
            },
            gang_theft = {
                vehicle_kickout = "No keys in here kill the gang members and search their body for keys.",
                target_member = "Search For Keys",
                progress_searching = "Searching For Keys",
                no_key = "No Key Found",
            },
            military_theft = {
                vehicle_kickout = "No keys in here kill the military members and search their body for keys.",
                target_member = "Search For Keys",
                progress_searching = "Searching For Keys",
                no_key = "No Key Found",
            },
        },
        operation = {
            remove_tracker = {
                progress_bar = "Scrambling Tracker %s/%s",
                wrong_seat = "In car but not driver or passenger",
                passenger_seat = "Must be in the Passenger Seat to Hack.",
                require_driver = "Must have someone driving to hack.",
                not_in_vehicle = "You Must be in a Vehicle to Use this",
                failed_hack = "You failed scrambling tracker",
            },
            repaint_car = {
                arrived_loc = "Stop vehicle and get out and use the rattle can on it.",
                left_loc = "Vehicle left location bring it back to repaint it.",
                dist_veh = "Vehicle too far from paint booth.",
                dist_ply = "You are too far from the vehicle to paint.",
                progress_shaking = "Shaking Can",
                progress_spraying = "Spraying Coat",
            },
            disable_alarm = {
                progress_cut = "Cutting Alarm",
            },
            plate_swap = {
                dist_veh = "You are not near the vehicle",
                dist_moveback = "Move a bit further back. Try again.",
                dist_behindveh = "You must be behind the vehicle",
                dist_aligncenter = "Align with the center rear and try again.",
                progress_plate = "Applying New Plate",
            },
            jam_radio_towers = {
                warning_standback = "Stand Back Signal Jammer is Armed",
                jam_success = "Towers Signal was Successfully Jammed.",
                error_inveh = "You must exit your vehicle to do this.",
                dist_tower = "Out of range of any radio tower.",
                failed_jamming = "You messed up jamming the tower",
                progress_arming = "Arming Signal Jammer",
            },
            ego_boast = {
                hotspot_blip = "Hot Spot",

            },
        },
        delivery = {
            drop_location = {
                delivery_blip = "Delivery Point",
                dist_deliver = "Deliver the vehicle to the marked point.",
                dist_arrive = "Exit the vehicle to complete the job.",
                dist_left = "Return to the delivery point.",
            },
            hand_off = {
                delivery_blip = "Hand Off Point",
                target_ped = "Hand Over Vehicle",
                dist_veh = "The vehicle is not close enough",
                veh_occupied = "The vehicle is occupied",
            },
            chop_shop = {
                delivery_blip = "Chop Shop Point",
                target_ped = "Chop Vehicle",
            },
            vin_scratch = {
                delivery_blip = "Vin Scratch Point",
                target_ped = "Vin Scratch Vehicle",
            },
        },  
        extras = {
            completed_job = "Boost Successfully Completed",
            failed_job = "Boost Failed...",
            completed_popup = {l = "Job Completed", d = "Payout: %s %s and Reputation: %s", p = "Completed"},
            item_debounce = "Slow down, try again shortly.",
            found_keys = "Found the Vehicle Keys on the Body.",
            waypoint_store = "Waypoint Set Check your GPS.",
            dispatch_distress = "Distress Call | Plate: %s",
            dispatch_tracker = "Tracker Ping | Plate: %s",
            dispatch_radio = "Tower Ping | Plate: %s",
            dispatch_veh_class = "CLASS [%s]",
        },
    },
    tasks_info = {
        find_vehicle = {l = "Find The Vehicle", d = "Head to the gps location of the vehicle.", p = "Find Vehicle"},
        mug_owner = {l = "Mug the Owner", d = "Intimidate the vehicle owner to get the keys."},
        test_drive = {l = "Test Drive Vehicle", d = "Speak with the owner and get the keys to test drive."},
        lockpick_vehicle = {l = "Lockpick the Vehicle", d = "Use lockpicks to break into the vehicle."},
        hack_keyless = {l = "Hack Keyless Entry", d = "Use your Digiscanner to track the nearest key fob signal and move closer to the ping."},
        stop_vehicle = {l = "Stop Fleeing Vehicle", d = "Shoot the driver of the fleeing vehicle to stop them."},
        gang_theft = {l = "Steal Car from Gang", d = "Take out gang members and search bodies for keys."},
        military_theft = {l = "Steal Car from Military", d = "Take out military members and search bodies for keys."},
        remove_tracker = {l = "Remove Basic GPS Tracker", d = "Use a Tracker Scrambler to disable the tracker."},
        disable_alarm = {l = "Disable Security Alarm", d = "Use the Wire Cutter to disable the security alarm."},
        plate_swap = {l = "Plate Swap", d = "Go to the back of the vehicle and put a stolen plate on."},
        repaint_car = {l = "Repaint the Car", d = "Take vehicle to location and use rattle can next to vehicle."},
        jam_radio_towers = {l = "Jam Tracking Towers", d = "Use your signal jammer to disable nearby radio towers."},
        ego_boast = {l = "Provoke the Streets", d = "Take the boosted vehicle through every GPS checkpoint, drawing attention and showing no fear."},
        drop_location = {l = "Deliver to Drop-Off Point", d = "Leave the vehicle at the drop off point."},
        hand_off = {l = "Hand Off to Contact", d = "Meet up with the contact and give them the keys."},
        chop_shop = {l = "Deliver to Chop Shop", d = "Take the vehicle to the chop shop and get paid."},
        vin_scratch = {l = "VIN Scratch", d = "Take the vehicle to the location to get the VIN scratched."},
    },
    tasks_settings = {
        default = {dispatch = "Crime In Progress"},
        mug_owner = {dispatch = "Vehicle Mugging in Progress"},
        test_drive = {dispatch = "Vehicle Stolen During Test Drive"},
        lockpick_vehicle = {dispatch = "Vehicle Lockpicking in Progress"},
        hack_keyless = {dispatch = "Suspicious Behavior Near Vehicle"},
        stop_vehicle = {dispatch = "Driver in Distress – Fleeing Pursuers"},
        gang_theft = {dispatch = "Gang Conflict – Vehicle Theft in Progress"},
        military_theft = {dispatch = "High-Security Vehicle Stolen from Military Compound"},
        remove_tracker = {dispatch = "Stolen Vehicle Tracker Alert"},
        plate_swap = {dispatch = "Suspicious Activity – Vehicle Plates Being Swapped"},
        repaint_car = {dispatch = "Suspicious Activity – Vehicle Being Resprayed"},
        ego_boast = {dispatch = "Reckless Driving Report – Suspected Stolen Vehicle"},
        disable_alarm = {dispatch = "Stolen Vehicle Alarm Triggered"},
        jam_radio_towers = {dispatch = "Suspicious Activity Near Radio Tower"},
        drop_location = {dispatch = "Stolen Vehicle Drop-Off Spotted"},
        hand_off = {dispatch = "Suspicious Vehicle Hand-Off in Progress"},
        chop_shop = {dispatch = "Suspicious Activity – Vehicle Being Dismantled"},
    },
    progression = {
        vehicle_class = {l = "%s Class Access", d = "Unlock %s class vehicle contracts from market and unlocks"},
        buff_reputation = {l = "+%s%% Rep Bonus", d = "Earn +%s%% more reputation from contracts"},
        buff_currency = {l = "+%s%% %s Bonus", d = "Earn +%s%% more %s from contracts"},
        shop_item = {l = "Unlock Shop Item", d = "Unlock ability to purchase store item"},
        vin_scratch = {l = "Vin Scratch Unlock", d = "Unlock the ability to start VIN scratch contracts"},
    },
    group = {
        already_in_group = "You must leave your current group",
        inv_no_exist = "Incorrect Alias Invited",
        inv_fail = "Person is Unavailable",
        inv_sent_multiple = "Person was already invited.",
        mission_started = "Mission already in progress.",
    },
    build = {
        target_collect_package = "Collect Packages",
        target_purchase_tablet = "Buy Boosting Tablet £%s",
    },
    admin = {
        actions = {
            add_currency = "Added %s %s to %s balance",
            remove_currency = "Removed %s %s from %s balance",
            add_reputation = "Added %s Reputation to %s",
            remove_reputation = "Removed %s Reputation to %s",
            add_contract = "Added Contract %s to %s",
            delete_sv_contract = "Deleted Server Contract %s",
            add_market = "Added Contract %s to the Market",
        },
        image = {
            no_image_needed = "No Images to Reimage",
        },
        extra = {
            request_id = "No Vehicle with id: %s",
        },
        mods = {
            not_in_vehicle = "You are not in a vehicle",
            wrong_vehicle = "Wrong vehicle, expected %s",
            model_missing = "Vehicle does not exist in framework vehicles",
            class_blocked = "Invalide Vehicle Class %s",
        },
    },
    interface_cb = {
        account = {
            create_alias_taken = "Try a New Alias, Alias may already be used.",
            create_missing = "No Alias Sent",
        },
        contract = {
            police_check = "Not Enough Police",
            not_enough_currency = "Not Enough %s",
            inactive_member = "Group Member %s is Inactive",
            transfer_level = "%s is to low level",
            wrong_alias = "No one with alias %s found",
            vin_ply_limit    = "You hit your vinscratch limit. Try later.",
            vin_global_limit = "The vinscratch limit is hit. Try later.",
        },
    },
    webhooks = {
        common = {
            footer = "Boosting Logs",
        },
        boost_complete = {
            success_title = "%s Boost Completed",
            fail_title = "%s Boost Failed",
            success_message = "%s, successfully delivered a %s and earned %s %s",
            fail_message = "%s, failed delivering a %s..."
        },
        
    },
    marquee = {
        boost_success = "%s COMPLETED BOOST FOR CLASS %s",
        boost_fail = "%s FAILED BOOST FOR CLASS %s",
    },
}
lang.ui_translations = {
    common = {
        time_units = {
            days_short = "d",
            hours_short = "h",
            minutes_short = "m",
            seconds_short = "s",
            expired = "EXPIRED",
        },
        currency = {
            rep = "REP",
        },
        status = {
            locked = "LOCKED",
            contract = "CONTRACT",
        },
    },
    account = {
        create_title_01 = "ENTER THE",
        create_title_02 = "UNDERGROUND",
        create_desc_01 = "Register your alias and step into the city's underground network of high stakes boosting. Steal the hottest cars under the radar, fence them for big payouts but remember, the risks are real. Are you ready to take the heat for the ultimate score?",
        create_point_01 = { t = "Stay Anonymous", d = "Your alias keeps you hidden and untouchable." },
        create_point_02 = { t = "Immediate Action", d = "Once you're in, the jobs come fast. Boost smart, stay hidden." },
        create_input = { Label = "Choose Your Alias", Input = "Enter your alias...", desc = "Letters and numbers only" },
        create_input_validate = {
            err1 = "Connection error. Please try again.",
            err2 = "Minimum 3 characters required",
            err3 = "Maximum 20 characters allowed",
            err4 = "Only letters and numbers allowed",
            err5 = "Alias cannot be empty",
        },
        create_button = { default = "JOIN THE RISK", loading = "CREATING ALIAS..." },
    },
    settings = {
        profile_title = "PROFILE SETTINGS",
        profile_desc = "Update your underground identity",
        current_alias = "Current Alias",
        new_alias_label = "New Alias",
        new_alias_placeholder = "Enter new alias...",
        save_button = "SAVE CHANGES",
        save_button_loading = "UPDATING...",
        character_count = "Letters and numbers only",
        footer_text = "Your alias keeps you anonymous in the underground scene",
    },
    progression = {
        title = "PLAYER PROGRESS",
        level_current = "Current Level",
        level_max = "MAX",
        level_max_reached = "Maximum Level Reached",
        reputation_progress = "Reputation Progress",
        total_reputation = "Total Reputation",
        max_level_achieved = "MAXIMUM LEVEL ACHIEVED",
        rep_bonus = "REP",
        unlock_progression = "Unlock Progression",
        class_suffix = "Class",
        next_unlock_text = "Next unlock at Level",
        free_boosts_title = "Free Boosts Available",
        free_boosts_desc = "Level up to discover higher class vehicles in unlocks, and ability to purchase higher class vehicles from the market.",
        level_title = "LEVEL",
        reputation_required = "Reputation Required",
        unlocks_title = "Unlocks",
        locked_rewards = "Locked Rewards",
        locked_rewards_count = "reward available when unlocked",
        locked_rewards_count_plural = "rewards available when unlocked",
        no_rewards_title = "No Rewards",
        no_rewards_desc = "This level doesn't provide any unlocks.",
        navigation_hint = "Scroll or use",
        navigation_hint_suffix = "to view levels",
    },
    tablet_base = {
        tabs = {
            home = "HOME",
            unlocks = "UNLOCKS",
            market = "MARKET",
            store = "STORE",
            contract_history = "CONTRACT HISTORY",
            leaderboard = "LEADERBOARD",
            admin = "ADMIN",
        },
        inner_pages = {
            settings = "Settings",
            progress = "Progress",
        },
        navigation = {
            back = "Back",
        },
        notifications = {
            title = "Notifications",
            no_notifications = "No notifications",
            invite_text = "invited you to a group",
            time_ago_suffix = "ago",
            time_units = {
                seconds = "seconds",
                minutes = "minutes",
                hours = "hours",
                days = "days",
            },
            actions = {
                join = "Join",
                decline = "Decline",
            },
        },
        level = {
            prefix = "LVL",
        },
        errors = {
            failed_join_group = "Failed to Join Group",
            failed_decline_group = "Failed to Join Group",
        },
    },
    tablet_home = {
        marquee = {
            default_text = "BOOSTING NETWORK ONLINE • CONTRACTS LOADING • STAND BY FOR ASSIGNMENTS • CREW AVAILABLE • VEHICLES READY",
        },
        active_contract = {
            title = "ACTIVE CONTRACT",
            type_label = "BOOSTING",
            active_label = "ACTIVE",
            class_suffix = "CLASS BOOST CONTRACT",
            vin_scratch = "VIN SCRATCH",
            open_button = "Open Contract",
        },
        no_active_contract = {
            title = "NO ACTIVE CONTRACT",
            boost_ready = "Boost Ready",
            select_contract = "Select a contract to begin boosting operations",
        },
        contracts = {
            title = "YOUR CONTRACTS",
            on_market = "ON MARKET",
            open_contract = "OPEN CONTRACT",
            no_contracts_title = "NO CONTRACTS AVAILABLE",
            no_contracts_desc = "Unlock new contracts or purchase a contract off the marketplace.",
            unlock_button = "Unlock Contracts",
            browse_button = "Browse Marketplace",
        },
        currency = {
            rep = "REP",
        },
    },
    tablet_unlocks = {
        title = "UNLOCK CONTRACT",
        next_unlock = "NEXT CONTRACT UNLOCK",
        buttons = {
            claim = "CLAIM CONTRACT",
            claiming = "CLAIMING...",
        },
    },
    tablet_market = {
        titles = {
            buy = "Contract Market Place",
            sell = "Your Contracts",
        },
        tabs = {
            buy = "Buy",
            sell = "Sell",
        },
        search = {
            buy_placeholder = "Search vehicles or sellers...",
            sell_placeholder = "Search vehicles...",
        },
        filters = {
            all_classes = "All Classes",
            class_prefix = "Class",
            sort_options = {
                price = "Price",
                time_left = "Time Left",
                payout = "Payout",
                class = "Class",
            },
        },
        contract_status = {
            listed = "Listed",
            not_listed = "Not Listed",
            on_market = "On Market",
        },
        buttons = {
            view = "VIEW",
            view_contract = "VIEW CONTRACT",
            sell = "SELL",
        },
        messages = {
            level_too_low = "Level too low",
            expires_too_soon = "Contract expires too soon to sell",
            no_contracts_buy = "No contracts found",
            no_contracts_sell = "No contracts available.",
            boost_expires = "Boost expires:",
            price_range_error = "Price must be between {min} - {max} {currency}",
        },
    },
    tablet_store = {
        titles = {
            store = "Store",
            processing = "PROCESSING PACKAGES",
        },
        timers = {
            stock_refill = "STOCK REFILL",
            orders_disabled = "ORDERS DISABLED",
        },
        search = {
            placeholder = "Search items...",
        },
        filters = {
            all_items = "All Items",
            available = "Available",
            locked = "Locked",
            out_of_stock = "Out of Stock",
        },
        buttons = {
            back_to_store = "BACK TO STORE",
            set_waypoint = "SET PICKUP WAYPOINT",
            packages = "PACKAGES",
            order = "ORDER",
            ordering = "ORDERING",
            restocking_soon = "RESTOCKING SOON",
            out_of_stock = "OUT OF STOCK",
        },
        status = {
            processing = "PROCESSING",
            items_processing = "ITEMS PROCESSING",
            stock = "STOCK",
            qty = "QTY",
        },
        messages = {
            no_packages = "No packages being processed",
            no_items_found = "No items found",
        },
    },
    tablet_contracthistory = {
        title = "CONTRACT HISTORY",
        stats = {
            success_rate = "SUCCESS RATE",
            recent_boosts = "RECENT BOOSTS",
            avg_payout = "AVG PAYOUT",
        },
        search = {
            placeholder = "Search vehicle...",
        },
        filters = {
            all_status = "All Status",
            success = "Success",
            failed = "Failed",
        },
        status = {
            success = "SUCCESS",
            failed = "FAILED",
        },
        messages = {
            no_contracts = "No contracts found",
        },
    },
    tablet_leaderboard = {
        title = "Leaderboard",
        your_rank = "YOUR RANK",
        stats = {
            level = "LEVEL",
            total_currency = "Total {currency}",
            total_boosts = "Total Boosts",
            earnings = "Earnings",
            boosts = "Boosts",
        },
    },
    open_contract = {
        loading_message = "Contract data is incomplete or still loading...",
        timer_remaining = "TIME REMAINING",
        contract_title = {
            active = "Active Contract For",
            inactive = "Contract For",
        },
        boost_types = {
            regular = {
                title = "Regular Boost",
                desc = "Traditional boost with group payout split",
                payout = "Payout",
                payout_desc = "Split between all group members",
                reputation = "Reputation",
                reputation_desc = "Boost reputation points",
                upfront_cost = "Upfront Cost",
                upfront_cost_desc = "No payment required to start",
                free = "FREE",
            },
            vin_scratch = {
                title = "VIN Scratch Boost",
                desc = "Pay upfront and keep the vehicle",
                vehicle_reward = "Vehicle Reward",
                vehicle_desc = "Keep the boosted vehicle permanently",
                cost_desc = "Payment required before starting",
                locked_desc = "Locked - Requires Level",
            },
        },
        buttons = {
            back = "Back",
            transfer_contract = "TRANSFER CONTRACT",
            start_contract = "START CONTRACT",
            start_regular = "START REGULAR BOOST",
            start_vin_scratch = "START VIN SCRATCH BOOST",
            only_leader = "ONLY LEADER CAN START",
            already_started = "CONTRACT ALREADY STARTED",
            starting = "STARTING...",
            started = "STARTED",
            confirm = "CONFIRM",
            cancel = "CANCEL",
            transferring = "TRANSFERRING...",
            cancel_contract = "CANCEL CONTRACT",
            keep = "KEEP",
            yes_cancel = "YES, CANCEL",
            cancelling = "CANCELLING...",
            cancelled = "CANCELLED",
        },
        sections = {
            mission_objectives = "MISSION OBJECTIVES",
            rewards = "REWARDS",
            requirements = "REQUIREMENTS",
        },
        task_status = {
            completed = "COMPLETED",
            todo = "TO-DO",
        },
        task_types = {
            acquire = "ACQUIRE",
            operation = "OPERATION",
            delivery = "DELIVERY",
        },
        rewards = {
            split_note = "Split with group",
            vehicle = "Vehicle",
            rep = "Rep",
        },
        requirements = {
            no_items = "No items required",
            acquire_item = "ACQUIRE ITEM",
            operation_item = "OPERATION ITEM",
            delivery_item = "DELIVERY ITEM",
            required = "REQUIRED",
        },
        transfer = {
            fee_label = "Transfer Fee:",
            placeholder = "Enter alias (e.g. bigdog44)",
        },
        cancel = {
            title = "CANCEL CONTRACT",
            desc = "You can cancel this active contract if needed.",
            confirm_title = "Are you sure you would like to cancel this contract?",
            confirm_desc = "You will lose this contract and any progress made.",
        },
        class_boost_contract = "Class {class} Boost Contract",
        level_format = "LEVEL {current}/{required}",
    },

    view_contract = {
        marketplace = {
            listing = "Marketplace Listing",
            sold = "SOLD",
            expired = "EXPIRED",
        },
        availability = {
            title = "Contract No Longer Available",
            desc = "This contract has been purchased by another person or is no longer available in the marketplace.",
            back_button = "Back to Marketplace",
        },
        buttons = {
            purchased = "CONTRACT PURCHASED",
            not_available = "NO LONGER AVAILABLE",
            your_contract = "YOUR CONTRACT",
            listing_expired = "LISTING EXPIRED",
            purchasing = "PURCHASING...",
            purchase_contract = "PURCHASE CONTRACT",
        },
        contract_details = {
            title = "CONTRACT DETAILS",
            price = "Price",
            boost_expires = "Boost Expires",
            class = "Class",
            seller = "Seller",
        },
        contract_for = "Contract For {vehicle}",
    },

    tablet_admin = {
        tabs = {
            dashboard = "Dashboard",
            players = "Players",
            contracts = "Contracts",
            tools = "Tools",
        },
    },

    admin_dashboard = {
        header = {
            title = "Boosting Operations",
            desc = "Monitor vehicle theft activities and manage operations",
        },
        stats = {
            total_boosters = "TOTAL BOOSTERS",
            currency_earned = "CURRENCY EARNED",
            boosts_completed = "BOOSTS COMPLETED",
            total_contracts = "TOTAL CONTRACTS",
        },
        recent_actions = {
            title = "Recent Admin Actions",
            empty_title = "No recent admin actions",
            empty_desc = "Any action within the admin panel will be logged here",
        },
        top_boosters = {
            title = "Top Boosters",
            level_prefix = "LVL",
        },
        activity_types = {
            currency = "Currency",
            reputation = "Reputation",
            boost = "Boost",
            contract = "Contract",
            broadcast = "Broadcast",
            system = "System",
            default = "Activity",
        },
    },

    admin_players = {
        header = {
            title = "Player Management",
            desc = "Manage players boosting data.",
        },
        search = {
            placeholder = "Search players...",
        },
        table = {
            alias = "ALIAS",
            id = "ID",
            action = "ACTION",
            view = "VIEW",
        },
        pagination = {
            previous = "Previous",
            next = "Next",
            breaks = "...",
        },
        back_button = "Back",
        loading = "Fetching player data...",
        stats = {
            reputation = "Reputation",
            level = "Level",
            owned_contracts = "Owned Contracts",
        },
        manage_currency = {
            title = "Manage Currency",
            label = '{currency} Amount',
            add = "ADD",
            remove = "REMOVE",
        },
        manage_reputation = {
            title = "Manage Reputation",
            label = "Rep Amount",
            add = "ADD",
            remove = "REMOVE",
        },
        give_contract = {
            title = "Give Boost Contract",
            labels = {
                vehicle_id = "Vehicle ID",
                payout = "Payout ({currency})",
                timer = "Timer (Minutes)",
                reputation = "Reputation Reward",
            },
            preview_title = "Contract Preview",
            preview = {
                vehicle = "Vehicle:",
                timer = "Timer:",
                payout = "Payout:",
                rep = "Rep:",
            },
            button = "Give Contract",
        },
        owned_contracts = {
            title = "Owned Contracts",
            on_market = "ON MARKET",
            no_contracts = "No owned contracts",
            cid = "CID:",
            vehicle = "Vehicle:",
            class = "Class:",
            rep = "Rep:",
            payout = "Payout:",
            expired = "Expired",
        },
    },

    admin_contracts = {
        header = {
            title = "Contract Management",
            desc = "Manage vehicle boost contracts and configurations",
        },
        search = {
            placeholder = "Search contracts...",
        },
        filter = {
            all = "All Classes",
            class_label = "Class",
        },
        buttons = {
            create = "Create Contract",
            back = "Back to Contract List",
            create_new = "Create New Contract",
            edit = "Edit Contract",
            update = "Update Vehicle Contract",
            save = "Create Vehicle Contract",
            cannot_save = {
                no_changes = "Make changes to enable updating",
                not_exist = "Vehicle does not exist - cannot create contract",
                copy_first = "Copy vehicle settings to enable saving",
            },
        },
        labels = {
            edit_desc = "Editing {label}",
            create_desc = "You must be in the vehicle you want to turn into a contract. The look of the vehicle will be the contract vehicle.",
            paint_config = "Paint Configuration",
            primary = "Primary",
            secondary = "Secondary",
            vehicle_class = "Vehicle Class",
            select_class = "Select Class",
            boost_class = "Boost class set to",
            copy_settings = "Copy Vehicle Settings",
            copy_current = "Copy Current Vehicle Settings",
            copied = "Settings Copied!",
            copy_success = "Vehicle settings have been copied successfully",
            copy_requirement = "You must be in the vehicle you want to create a contract for",
            must_be_in = "You must be in the {label} vehicle to copy settings",
            not_detected = "Vehicle not detected",
            reimage_required = "Re-image Required!",
            reimage = "Re-image Vehicle",
            spawn = "Spawn Vehicle",
            edit_settings = "Edit Vehicle Settings",
            delete = "Delete Contract",
            needs_reimaging = "Needs Re-imaging",
            id = "ID",
            vehicle = "Vehicle",
            class = "Class",
            modified = "Modified",
            contracts_count = "{count} contracts",
            contracts_count_filtered = "(from {total} total)",
        },
        pagination = {
            previous = "Previous",
            next = "Next",
            breaks = "...",
        },
        errors = {
            vehicle_not_exist = "Vehicle model does not exist in the frameworks vehicle. If it does exist follow this simple guide.",
            mismatch = "Vehicle mismatch: Expected {expected}, got {got}",
            generic_copy = "Error copying vehicle settings. Please try again.",
            must_copy = "You must be in the correct vehicle to copy settings. Please enter the vehicle and try again.",
        },
    },

    admin_tools = {
        header = {
            title = "Administrative Tools",
            desc = "System management and administrative controls",
        },
        marketplace = {
            title = "Add to Marketplace",
            labels = {
                vehicle_id = "Vehicle ID",
                payout = "Payout ({currency})",
                market_cost = "Market Contract Cost ({currency})",
                contract_timer = "Contract Timer (Minutes)",
                rep = "Reputation Reward",
                market_timer = "Market Timer (Minutes)",
            },
            preview_title = "Marketplace Preview",
            preview = {
                vehicle = "Vehicle:",
                timer = "Contract Timer:",
                payout = "Payout:",
                rep = "Rep:",
                market_cost = "Market Cost:",
                market_timer = "Market Timer:",
            },
            button = {
                add = "ADD TO MARKETPLACE",
                adding = "ADDING...",
            },
            result = {
                success = "Success",
                failed = "Unknown error occurred",
                failed_connect = "Failed to connect to server",
            },
        },
        imaging = {
            title = "Vehicle Imaging",
            loading = {
                all = "Photographing all vehicles...",
                needed = "Photographing vehicles needing images...",
                specific = "Photographing specific vehicle...",
                hint = "This could take a while, please give the script time to photograph vehicles.",
            },
            result = {
                success_all = "All vehicles screenshot completed successfully! Please restart gg_boosting to update images on panel.",
                success_needed = "Vehicles needing images screenshot completed successfully! Please restart gg_boosting to update images on panel.",
                success_specific = "Vehicle screenshot completed successfully! Please restart gg_boosting to update images on panel.",
                failed = "Failed to screenshot vehicle. Please try again.",
                failed_connect = "Failed to connect to server.",
            },
            buttons = {
                screenshot_all = "Screenshot All Vehicles",
                screenshot_needed = "Screenshot Vehicles Needing Images",
                screenshot_specific = "Screenshot Specific",
                confirm_all = "YES, SCREENSHOT ALL",
                confirm_needed = "YES, SCREENSHOT NEEDED",
                cancel = "CANCEL",
            },
            confirm = {
                all = "Are you sure? This will take longer based on count of contracts ({count} contracts).",
                needed = "Screenshot only vehicles that don't have images yet? ({count} vehicles need images)",
            },
            specific = {
                label = "Vehicle ID",
                placeholder = "5",
            },
        },
    },

    boost_crew = {
        title = "BOOST CREW",
        input_placeholder = "Enter alias...",
        empty_slot_non_leader = "Empty slot - only leader can invite",
        invite_success = "has been invited",
        errors = {
            invite_failed = "Error inviting user:",
            kick_failed = "Error kicking user:",
            leave_failed = "Error leaving group:",
        },
    },

    popup_base = {
        phase_label = "Phase",
        timer_label = "Time Remaining",
        progress = {
            label = "Progress",
            value = '{current}/{total}',
        },
        keybind = "Keybind",
        errors = {
            no_task = "No active task",
        },
    },

    vehicle_image = {
        no_image = "No Image Found",
    },
}



-- IGNORE CODE LANG FUNCTION
lang.alert_missing_lang = true
function lang:get(key, ...)
    if type(key) ~= "string" then return tostring(key or "") end
    local function resolve(tbl, k) local c=tbl for p in k:gmatch("[^%.]+") do if type(c)~="table" then return nil end c=c[p] if not c then return nil end end return c end
    local t = self.translations and resolve(self.translations, key)
    if not t then if self.alert_missing_lang then print("Missing translation: "..key) end return key end
    local fmt, args = tostring(t), {...}
    if #args == 0 then return fmt end
    if not fmt:gsub("%%%%",""):find("%%") then if self.alert_missing_lang then print("Lang format error: no specifiers for key: "..key) end return fmt end
    local ok, out = pcall(string.format, fmt, table.unpack(args))
    if not ok then if self.alert_missing_lang then print("Lang format error for key: "..key.." -> "..tostring(out)) end return fmt end
    return out
end
lang.mounted = true