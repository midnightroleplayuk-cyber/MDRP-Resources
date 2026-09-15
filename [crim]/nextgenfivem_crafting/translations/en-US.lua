Translation = {
    ['error_occurred'] = 'An error occurred. (%s)',
    ['not_allowed'] = 'You do not have permission to use this editor.',
    ['afk_timeout'] = 'You have been kicked for being AFK.',

    ['errors'] = {
        ['couldnt_get_inventory'] = 'Unable to retrieve inventory.',
        ['no_player_id'] = 'Player ID not provided.',
        ['invalid_quantity'] = 'Invalid quantity specified.',
        ['couldnt_get_recipe'] = 'Unable to retrieve recipe.',
        ['not_enough_level'] = 'Your level is not high enough to craft this item.',
        ['not_enough_category_level'] = 'Your category level is not high enough to craft this item.',
        ['missing_ingredients'] = 'Insufficient ingredients to craft this item.',
        ['missing_blueprint'] = 'A blueprint is required to craft this item.',
        ['no_session'] = 'No session found.',
        ['invalid_session_data'] = 'Invalid session data provided.',
        ['not_finished'] = 'Crafting is not yet complete.',
        ['invalid_data'] = 'Invalid data provided.',
        ['not_enough_space'] = 'You do not have enough space to do this.',
        ['queue_limit_reached'] = 'You have reached the maximum number of crafts in queue.',
        ['max_craft_amount_exceeded'] = 'You cannot craft more than %s items at once.'
    },

    ['crafting'] = {
        ['title_small'] = 'Workbench',
        ['title_big'] = 'Crafting',
        ['recipes'] = 'Available Recipes',
        ['level'] = 'Level',
        ['level_short'] = 'Lvl',
        ['use'] = 'Use',
        ['pickup'] = 'Pick Up',
        ['no_access'] = 'You do not have access to this.',
        ['not_using'] = 'You are not currently using this.',
        ['already_using'] = 'You are already using this.',
        ['already_in_use'] = 'This is currently in use by someone else.',
        ['craft'] = 'Craft',
        ['crafting'] = 'Crafting...',
        ['crafting_queue'] = 'Crafting Queue',
        ['exit'] = 'Exit',
        ['missing_items'] = 'You are missing %s %s',
        ['item'] = 'Item',
        ['items'] = 'Items',
        ['cancel_craft'] = 'Cancel Crafting',
        ['requirements'] = 'Requirements',
        ['ingredients'] = 'Ingredients',
        ['blueprints'] = 'Blueprints',
        ['result_items'] = 'Resulting Items',
        ['error_fetching_recipes'] = 'Error while fetching recipes.',
        ['no_recipes'] = 'No recipes found.',
        ['bench_placed'] = 'Workbench placed.',
        ['not_near_bench'] = 'You are not close to the workbench.',
        ['no_blueprints_needed'] = 'No blueprints needed.',
        ['cooldown_crafts_remaining'] = '%s crafts remaining',
        ['cooldown_available_in'] = 'Available in %s',
        ['cooldown_on_cooldown'] = 'On cooldown',
        ['cooldown_window'] = 'Window: %s',
        -- v1.2.0: Failure Chance
        ['craft_failed'] = 'Failed!',
        ['craft_partial'] = '%s/%s Succeeded',
        -- v1.2.1: View Locked Recipes
        ['recipe_locked'] = 'Locked',
        ['recipe_locked_level'] = 'Reach the required level to unlock this recipe.',
        ['recipe_locked_blueprint'] = 'A blueprint is required to unlock this recipe.',

        ['stored_queue'] = {
            ['title'] = 'Saved Queue',
            ['description'] = 'You have a saved queue from before. Would you like to use it?',
            ['use_queue'] = 'Use Queue',
        }
    },

    ['item-descriptions'] = {
        ['portable_bench'] = 'A portable workbench for type (%s). Use to set up the bench.',
        ['blueprint'] = 'A crafting blueprint for %s.'
    },

    ['item-labels'] = {
        ['portable_bench'] = 'Crafting Workbench (%s)',
        ['blueprint'] = 'Blueprint (%s)'
    },

    ['editor'] = {
        ['title'] = 'Crafting Editor',
        ['description'] =
        'Use this editor to place the workbench. Ensure it is fully visible with enough space for interaction.',
        -- v1.4.0: Walk Placement
        ['hint'] = {
            ['title'] = 'Nothing happening?',
            ['description'] =
            'If you have no mouse cursor, the gizmo cannot be used. Switch to walk placement instead — it only needs the keyboard.',
            ['action'] = 'Switch to walk placement'
        },
        ['ghost'] = {
            ['title'] = 'Walk Placement',
            ['description'] =
            'Walk to where you want the workbench and place it. Use the keys below to adjust it, no mouse needed.'
        },
        ['controls'] = {
            ['gizmoSelect'] = 'Select Tool',
            ['gizmoTranslation'] = 'Move Mode',
            ['gizmoRotation'] = 'Rotate Mode',
            ['gizmoLocal'] = 'Relative/World',
            ['gizmoSnapToGround'] = 'Snap to Ground',
            ['gizmoClose'] = 'Place',
            ['gizmoCancel'] = 'Cancel',
            -- v1.4.0: Walk Placement
            ['gizmoSwitchMode'] = 'Walk Placement',
            ['moveCamera'] = 'Adjust Camera',
            ['movePlayer'] = 'Walk',
            ['rotateWheel'] = 'Rotate',
            ['ghostRotateLeft'] = 'Rotate Left',
            ['ghostRotateRight'] = 'Rotate Right',
            ['ghostMoveAway'] = 'Push Away',
            ['ghostMoveCloser'] = 'Pull Closer',
            ['ghostMoveUp'] = 'Raise',
            ['ghostMoveDown'] = 'Lower',
            ['ghostToggleSnap'] = 'Toggle Ground Snap',
            ['ghostConfirm'] = 'Place',
            ['ghostCancel'] = 'Cancel',
            ['ghostSwitchMode'] = 'Gizmo Placement'
        },

        ['app'] = {
            ['title'] = 'Crafting Editor',
            ['search'] = 'Search',
            ['refresh'] = 'Refresh',
            -- v1.2.1: Version & Changelog System
            ['version'] = {
                ['outdated'] = 'Update Available',
                ['uptodate'] = 'Up to Date',
                ['behind'] = '%s updates behind',
                ['changelogs'] = 'Changelogs',
                ['no_changelogs'] = 'No changelogs available.',
                ['new'] = 'New',
                ['current'] = 'Current',
                ['hotfixes'] = 'Hotfixes',
                ['hotfix_available'] = 'Hotfix Available',
                ['hotfix_desc'] = 'Read the release notes to determine if this hotfix applies to your server.',
                ['dismiss_hotfix'] = 'Dismiss this hotfix',
            },
            ['columns'] = {
                ['id'] = 'ID',
                ['name'] = 'Name',
                ['created_at'] = 'Created At',
                ['locations'] = 'Locations',
                ['bench_type'] = 'Bench Type',
                ['created_by'] = 'Created By',
                ['is_portable'] = 'Is Portable',
                ['coordinates'] = 'Coordinates',
            },
            ['rows_per_page'] = 'Rows per page',
            ['page_of'] = 'Page %s of %s',
            ['selected'] = '%s selected',
            ['edit'] = 'Edit',
            ['delete'] = 'Delete',
            ['reset'] = 'Reset',
            ['no_results'] = 'No results...',
            ['clear_filters'] = 'Clear filters',

            ['benches'] = { -- Benches Page
                ['label'] = 'Benches',
                ['description'] = 'View and manage all available benches. You can create, edit, and delete.',
                ['types'] = {
                    ['label'] = 'Types',
                    ['create_button'] = 'New Bench Type',
                    ['no_locations'] = 'No locations',
                    ['locations'] = '%s location(s)',
                    ['add_location'] = 'Add Location',
                    ['view_locations'] = 'View locations',
                    ['actions'] = {
                        ['view_locations'] = 'View Locations',
                        ['add_location'] = 'Add Location',
                        ['give_portable_item'] = 'Give Portable Item to Player',
                    },
                    ['map'] = {
                        ['title'] = 'Locations for bench type "%s"',
                        ['error'] = 'Error fetching locations',
                        ['no_locations'] = 'No locations found...',
                        ['coordinates'] = 'Coordinates',
                        ['actions'] = {
                            ['teleport_to'] = 'Teleport to Location',
                            ['edit'] = 'Edit',
                            ['remove'] = 'Remove',
                        }
                    }
                },
                ['locations'] = {
                    ['label'] = 'Locations',
                    ['create_button'] = 'New Bench Location',
                    ['actions'] = {
                        ['teleport_to'] = 'Teleport to Location',
                        ['copy_id'] = 'Copy ID',
                        ['copy_bench_type_id'] = 'Copy Bench Type ID',
                    }
                }
            },

            ['recipes'] = { -- Recipes Page
                ['label'] = 'Recipes',
                ['description'] =
                'View and manage all available recipes. You can create, edit, and delete. Open a category to view the recipes within it, and click on a recipe to view its details.',
                ['no_categories_found'] = 'No categories found.',
                ['create_a_category'] = 'Create a category!',
                ['category_title'] = 'Category: %s',
                ['create_button'] = 'Create Category',
                ['edit_button'] = 'Edit Category',
                ['delete_button'] = 'Delete Category',
                ['no_recipes_found'] = 'No recipes found...',
                ['recipes_error'] = 'Failed to load recipes.',
                ['create_recipe'] = 'Create Recipe',
                ['crafting_time_desc'] = 'The time it takes to craft this item.',
                ['xp'] = '%s XP',
                ['xp_reward_desc'] = 'The XP reward for crafting this item.',
                ['prop_model_desc'] = 'The prop model to display when crafting this item.',
                ['results'] = 'Results',
                ['results_desc'] = 'These are the results of crafting this item.',
                ['level'] = 'Level',
                ['level_desc'] = 'The level required to craft this item.',
                ['category_level'] = 'Category Level',
                ['category_level_desc'] = 'The level of the category required to craft this item.',
                ['ingredients'] = 'Ingredients',
                ['ingredients_desc'] = 'These are the ingredients required to craft this item.',
                ['blueprints'] = 'Blueprints',
                ['blueprints_desc'] = 'These are the blueprints required to craft this item',
            },

            ['blueprints'] = { -- Blueprints Page
                ['label'] = 'Blueprints',
                ['description'] =
                'View and manage all blueprints. You can create, edit, and delete blueprints from this page. Blueprints are used to define crafting recipes.',
                ['search'] = 'Search blueprints...',
                ['error'] = 'An error occurred while fetching blueprints.',
                ['create_button'] = 'Create Blueprint',
            },

            ['forms'] = {
                ['name'] = 'Name',
                ['create'] = 'Create',
                ['update'] = 'Update',
                ['save'] = 'Save',
                ['delete'] = 'Delete',
                ['cancel'] = 'Cancel',
                ['edit'] = 'Edit',

                ['bench_type'] = {
                    ['new_title'] = 'New Bench Type',
                    ['edit_title'] = 'Edit Bench Type: %s',
                    ['delete_title'] = 'Delete Bench Type: %s',
                    ['delete_description'] =
                    'Are you sure you want to delete the bench type %s? This action cannot be undone. All bench locations using this type will be deleted.',
                    ['name'] = 'Name',
                    ['model'] = 'Model',
                    ['choose_a_model'] = 'Choose a model',
                    ['none_model'] = 'None (custom)',
                    ['none_model_desc'] = 'No model. Used for using the crafting bench on already existing models.',
                    ['no_model'] = 'No model',
                    ['no_models'] = 'No models found',
                    ['change'] = 'Change',
                    ['fullaccess'] = 'Full Access',
                    ['fullaccess_description'] = 'Allow this bench type access to all categories?',
                    ['categories'] = 'Categories',
                    ['categories_description'] = 'These are the categories this bench type has access to.',
                    ['manage_recipe_restrictions'] = 'Manage recipe restrictions',
                    ['recipe_restrictions'] = {
                        ['title'] = '%s Category - Recipe Restrictions',
                        ['description'] =
                        'Set restrictions for this category. Allow or disallow recipes from being crafted.',
                        ['set_denied_as_default'] = 'Set denied as default',
                        ['set_denied_as_default_desc'] =
                        'Note: This will deny all recipes by default. For example if you only want to allow a few recipes, you can set this to true. This will also reset all current recipe restrictions.',
                        ['no_recipes'] = 'No recipes... Add some before setting restrictions.',
                        ['recipe_error'] = 'Failed to load recipes...',
                        ['denied_recipes'] = 'Denied Recipes',
                        ['allowed_recipes'] = 'Allowed Recipes',
                    },
                    ['access'] = 'Access',
                    ['access_description'] = 'The access identifier for this bench type.',
                    ['selected'] = '%s selected',
                    ['none'] = 'None',
                    ['no_categories'] = 'No categories found. Create a category before adding a bench type.',
                    ['categories_error'] = 'There was an error fetching categories.',
                    ['change_rank_options'] = 'Change rank options',
                    -- v1.2.1: Shared Mode
                    ['shared_levels'] = 'Shared Levels',
                    ['shared_levels_description'] = 'All players at this bench type share the same level progression.',
                    ['shared_queue'] = 'Shared Queue',
                    ['shared_queue_description'] = 'All players at this bench can see and claim each other\'s crafts.',
                    ['shared_queue_claim'] = 'Queue Claim Mode',
                    ['shared_queue_claim_description'] = 'Who can claim completed crafts.',
                    ['shared_queue_claim_anyone'] = 'Anyone',
                    ['shared_queue_claim_owner'] = 'Original crafter only',
                    ['shared_queue_cancel'] = 'Queue Cancel Mode',
                    ['shared_queue_cancel_description'] = 'Who can cancel in-progress crafts.',
                    ['shared_queue_cancel_anyone'] = 'Anyone',
                    ['shared_queue_cancel_owner'] = 'Original crafter only',
                },

                ['bench_location'] = {
                    ['new_title'] = 'New Bench Location',
                    ['edit_title'] = 'Edit Bench Location',
                    ['delete_title'] = 'Delete Bench Location: %s',
                    ['delete_description'] =
                    'Are you sure you want to delete the bench location for Bench Type %s? This action cannot be undone.',
                    ['add_location_for_bench_type'] = 'Add location for bench type "%s"',
                    ['bench_type'] = 'Bench Type',
                    ['bench_type_description'] = 'Type of the bench.',
                    ['location'] = 'Location',
                    ['location_description'] = 'Location of the bench. Use the button to place it out.',
                    ['location_description_2'] =
                    'Make sure that the entire bench is visible, and there is enough space for the player to interact with it.',
                    ['is_portable'] = 'Is Portable',
                    ['is_portable_description'] = 'Is the bench portable? (Can be moved by players)',
                    -- v1.2.1: Shared Mode Overrides
                    ['shared_levels_override'] = 'Override Shared Levels',
                    ['shared_levels_override_description'] =
                    'Override the bench type shared levels setting for this location. Leave unchecked to inherit from bench type.',
                    ['shared_queue_override'] = 'Override Shared Queue',
                    ['shared_queue_override_description'] =
                    'Override the bench type shared queue setting for this location. Leave unchecked to inherit from bench type.',
                    ['place_out'] = 'Place out',
                    ['select_bench_type_first'] = 'Please select a bench type first.',
                    ['select_bench_type'] = 'Select bench type',
                    ['search_bench_types'] = 'Search bench types...',
                    ['no_bench_types'] = 'No bench types found.',
                    ['loading_bench_types'] = 'Loading bench types...',
                    ['bench_types_error'] = 'Error loading bench types.',
                },

                ['give_portable_item'] = {
                    ['title'] = 'Give Portable Item to Player',
                    ['player_id'] = 'Player Id',
                    ['give_item'] = 'Give Item'
                },

                ['category'] = {
                    ['new_title'] = 'New Category',
                    ['edit_title'] = 'Edit Category: %s',
                    ['delete_title'] = 'Delete Category: %s',
                    ['delete_description'] =
                    'Are you sure you want to delete the category %s? This action cannot be undone.',
                    ['delete_warning'] =
                    'Warning: This will also delete all recipes in this category and cannot be undone.',
                    ['title'] = 'Title',
                    ['description'] = 'Description',
                    ['use_image_url'] = 'Use Image URL',
                    ['use_image_url_desc'] = 'Use an image URL instead of an icon',
                    ['icon'] = 'Icon',
                    ['icon_desc'] = 'Find an icon at https://fonts.google.com/icons',
                    ['image'] = 'Image URL',
                },

                ['recipe'] = {
                    ['new_title'] = 'New Recipe',
                    ['edit_title'] = 'Edit Recipe: %s',
                    ['delete_title'] = 'Delete Recipe: %s',
                    ['delete_description'] =
                    'Are you sure you want to delete the recipe %s? This action cannot be undone.',
                    ['title'] = 'Title',
                    ['description'] = 'Description',
                    ['required_level'] = 'Required level',
                    ['required_level_desc'] =
                    'Required global level to craft this recipe. Leave blank for no requirement.',
                    ['required_category_level'] = 'Required category level',
                    ['required_category_level_desc'] =
                    'Required category level to craft this recipe. Leave blank for no requirement.',
                    ['crafting_time'] = 'Crafting time (in seconds)',
                    ['crafting_time_desc'] = 'How long it takes to craft this recipe (in seconds).',
                    ['xp_reward'] = 'XP reward',
                    ['xp_reward_desc'] = 'How much XP is awarded for crafting this recipe. (default is 25)',
                    ['prop_model'] = 'Prop Model',
                    ['prop_model_desc'] =
                    'Prop model to display when crafting this recipe. Leave blank for no prop. (e.g. prop_tool_hammer)',
                    ['prop_rot'] = 'Prop Rotation',
                    ['prop_rot_desc'] = 'Rotation of the prop model.',
                    ['prop_offset'] = 'Prop Offset',
                    ['prop_offset_desc'] =
                    'Offset of the prop model. Adjust to center the prop. X: forward/backward, Y: left/right Z: up/down',
                    ['blueprints'] = 'Blueprints',
                    ['blueprints_desc'] = 'Blueprints required to craft this recipe.',
                    ['ingredients'] = 'Ingredients',
                    ['ingredients_desc'] = 'Ingredients required to craft this recipe. Minimum 1 is required.',
                    ['results'] = 'Results',
                    ['results_desc'] = 'Results of crafting this recipe. Minimum 1 is required.',
                    ['cooldown_limit'] = 'Cooldown limit',
                    ['cooldown_limit_desc'] = 'Max total crafted within window. Set 0/empty to disable.',
                    ['cooldown_window'] = 'Cooldown window',
                    ['cooldown_window_desc'] = 'Length of cooldown window (days, hours, minutes, seconds).',
                    -- v1.2.0: Failure Chance
                    ['failure_chance'] = 'Failure Chance (%)',
                    ['failure_chance_desc'] = 'Chance that crafting fails (0-100). Ingredients are consumed on failure.',
                    ['failure_mode'] = 'Failure Mode',
                    ['failure_mode_desc'] = 'batch = one roll for entire craft, individual = each item rolls separately.',

                    ['add'] = 'Add'
                },

                ['blueprint'] = {
                    ['new_title'] = 'New Blueprint',
                    ['edit_title'] = 'Edit Blueprint: %s',
                    ['delete_title'] = 'Delete Blueprint: %s',
                    ['delete_description'] =
                    'Are you sure you want to delete the blueprint %s? This action cannot be undone.',
                    ['label'] = 'Label',
                    ['description'] = 'Description',
                    ['uses'] = 'Uses',
                    ['uses_description'] =
                    'Only used with `enableBlueprintItems`, `removeBlueprintOnCraft` and `blueprintDurability` enabled.',
                    ['item'] = 'Blueprint Item',
                    ['item_description'] =
                    'Optional. Select a specific inventory item for this blueprint. If not set, the format pattern will be used.'
                },

                ['select_blueprint'] = {
                    ['label'] = 'Blueprint',
                    ['select_blueprint'] = 'Select blueprint',
                    ['search_blueprints'] = 'Search blueprints...',
                    ['loading'] = 'Loading blueprints...',
                    ['error'] = 'Error loading blueprints.',
                    ['duplicate'] = 'Blueprint already added. Please select a different blueprint.',
                    ['no_found'] = 'No blueprints found.'
                },

                ['select_item'] = {
                    ['label'] = 'Item',
                    ['count'] = 'Count',
                    ['select_item'] = 'Select item',
                    ['search_items'] = 'Search items...',
                    ['loading'] = 'Loading items...',
                    ['error'] = 'Error loading items.',
                    ['no_found'] = 'No items found.',
                    ['set_metadata'] = 'Set metadata',
                    ['metadata_title'] = 'Metadata for: %s',
                },

                ['errors'] = {
                    ['name_is_required'] = 'Name is required.',
                    ['name_too_short'] = 'Name must be at least 2 characters.',
                    ['category_is_required'] = 'At least one category is required.',
                    ['item_is_required'] = 'Item is required',
                    ['min_one_item'] = 'You must add at least one item.',
                }
            }
        }
    },

    ['command'] = {
        ['error'] = 'Command Error',
        ['not_allowed'] = 'You do not have permission to use this command.',
        ['no_subcommand'] = 'Invalid subcommand. Use /crafting help for a list of commands.',
        ['no_player'] = 'No player found with that ID.',
        ['no_blueprint_found'] = 'No blueprint found with that name or ID.',
        ['already_has_blueprint'] = 'The player already owns this blueprint.',
        ['gave_blueprint'] = 'Blueprint %s given to player %s.',
        ['removed_blueprint'] = 'Blueprint %s removed from player %s.',
        ['set_level'] = 'Set player %s to level %s.',
        ['set_category_level'] = 'Set category level %s for player %s.',
        ['no_category_found'] = 'No category found with that name or ID.',
        ['category_level'] = 'Category Level',
        ['player_level'] = 'Levels for %s (%s)',
        ['invalid_level'] = 'Invalid level specified.',
        ['gave_portable_item'] = 'Gave portable item for bench type (%s) to player %s.',
        ['missing_arguments'] = 'Arguments missing. Use /crafting help for command details.',
        ['help'] = {
            ['title'] = 'Crafting Commands',
            ['description'] = 'List of available commands',
            ['subcommands'] = {
                ['help'] = 'Display help menu',
                ['blueprints'] = 'View your blueprints',
                ['level'] = 'View your level',
                ['editor'] = 'Open crafting editor',
                ['getblueprints'] = 'View player blueprints',
                ['giveblueprint'] = 'Give a blueprint to a player',
                ['removeblueprint'] = 'Remove a blueprint from a player',
                ['getlevel'] = 'View player level',
                ['setlevel'] = 'Set player level',
                ['setcategorylevel'] = 'Set player category level',
                ['editbench'] = 'Edit the nearest bench',
                ['removebench'] = 'Remove the nearest bench',
                ['giveportableitem'] = 'Give a portable workbench item to a player'
            },
            ["params"] = {
                ["id"] = "Player ID",
                ["blueprint"] = "Blueprint ID",
                ["level"] = "Level",
                ["category"] = "Category",
                ["bench"] = "Bench ID/Name"
            }
        }
    },

    ["discord_logs"] =
    "## Player %s crafted %sx %s (ID: %s)\nBench type: `%s (%s)`\nBench location: `%s`\nResult items: `%s`\nIngredient items: `%s`"
}
