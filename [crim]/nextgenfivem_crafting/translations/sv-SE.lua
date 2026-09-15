Translation = {
    ['error_occurred'] = 'Ett fel inträffade. (%s)',
    ['not_allowed'] = 'Du har inte behörighet att använda den här redigeraren.',
    ['afk_timeout'] = 'Du har blivit utloggad för att vara AFK.',

    ['errors'] = {
        ['couldnt_get_inventory'] = 'Kunde inte hämta inventariet.',
        ['no_player_id'] = 'Spelar-ID saknas.',
        ['invalid_quantity'] = 'Ogiltig mängd.',
        ['couldnt_get_recipe'] = 'Kunde inte hämta receptet.',
        ['not_enough_level'] = 'Du har inte tillräcklig nivå för att tillverka detta.',
        ['not_enough_category_level'] = 'Du har inte tillräcklig kategori-nivå för att tillverka detta.',
        ['missing_ingredients'] = 'Du har inte tillräckligt med ingredienser för att tillverka detta.',
        ['missing_blueprint'] = 'Du saknar ritningen för att tillverka detta.',
        ['no_session'] = 'Ingen session hittades.',
        ['invalid_session_data'] = 'Ogiltig sessionsdata.',
        ['not_finished'] = 'Tillverkningen är inte klar än.',
        ['invalid_data'] = 'Ogiltig data.',
        ['not_enough_space'] = 'Du har inte tillräckligt med utrymme för att göra detta.',
        ['queue_limit_reached'] = 'Du har nått maximalt antal tillverkningar i kön.',
        ['max_craft_amount_exceeded'] = 'Du kan inte tillverka mer än %s föremål åt gången.'
    },

    ['crafting'] = {
        ['title_small'] = 'Arbetsbänk',
        ['title_big'] = 'Tillverkning',
        ['recipes'] = 'Recept',
        ['level'] = 'Nivå',
        ['level_short'] = 'Nivå',
        ['use'] = 'Använd',
        ['pickup'] = 'Plocka upp',
        ['no_access'] = 'Du har inte tillgång till detta.',
        ['not_using'] = 'Du använder inte detta.',
        ['already_using'] = 'Du använder redan detta.',
        ['already_in_use'] = 'Någon annan använder detta just nu.',
        ['craft'] = 'Tillverka',
        ['crafting'] = 'Tillverkar...',
        ['crafting_queue'] = 'Tillverkningskö',
        ['exit'] = 'Avsluta',
        ['missing_items'] = 'Du saknar %s %s',
        ['item'] = 'Föremål',
        ['items'] = 'Föremål',
        ['cancel_craft'] = 'Avbryt tillverkning',
        ['requirements'] = 'Krav',
        ['ingredients'] = 'Ingredienser',
        ['blueprints'] = 'Ritningar',
        ['result_items'] = 'Resulterande föremål',
        ['error_fetching_recipes'] = 'Ett fel inträffade vid hämtning av recept.',
        ['no_recipes'] = 'Inga recept hittades.',
        ['bench_placed'] = 'Arbetsbänk placerad.',
        ['not_near_bench'] = 'Du är inte nära arbetsbänken.',
        ['no_blueprints_needed'] = 'Inga ritningar behövs.',
        ['cooldown_crafts_remaining'] = '%s tillverkningar kvar',
        ['cooldown_available_in'] = 'Tillgänglig om %s',
        ['cooldown_on_cooldown'] = 'På cooldown',
        ['cooldown_window'] = 'Fönster: %s',
        -- v1.2.1: Failure Chance
        ['craft_failed'] = 'Misslyckades!',
        ['craft_partial'] = '%s/%s Lyckades',
        -- v1.2.1: View Locked Recipes
        ['recipe_locked'] = 'Låst',
        ['recipe_locked_level'] = 'Nå den nivå som krävs för att låsa upp detta recept.',
        ['recipe_locked_blueprint'] = 'En ritning krävs för att låsa upp detta recept.',

        ['stored_queue'] = {
            ['title'] = 'Sparad kö',
            ['description'] = 'Du har en sparad kö från tidigare. Vill du använda den?',
            ['use_queue'] = 'Använd kö',
        }
    },

    ['item-descriptions'] = {
        ['portable_bench'] = 'En bärbar arbetsbänk av typ (%s). Använd för att placera bänken.',
        ['blueprint'] = 'En ritning för att tillverka %s.'
    },

    ['item-labels'] = {
        ['portable_bench'] = 'Arbetsbänk (%s)',
        ['blueprint'] = 'Ritning (%s)'
    },

    ['editor'] = {
        ['title'] = 'Tillverkningsredigerare',
        ['description'] =
        'Använd den här redigeraren för att placera arbetsbänken. Se till att den är fullt synlig och att det finns tillräckligt med utrymme för interaktion.',
        -- v1.4.0: Walk Placement
        ['hint'] = {
            ['title'] = 'Händer inget?',
            ['description'] =
            'Om du inte har någon muspekare går gizmon inte att använda. Byt till gåplacering istället — den kräver bara tangentbordet.',
            ['action'] = 'Byt till gåplacering'
        },
        ['ghost'] = {
            ['title'] = 'Gåplacering',
            ['description'] =
            'Gå dit du vill ha arbetsbänken och placera den. Använd tangenterna nedan för att justera den, ingen mus behövs.'
        },
        ['controls'] = {
            ['gizmoSelect'] = 'Välj',
            ['gizmoTranslation'] = 'Flyttläge',
            ['gizmoRotation'] = 'Rotationsläge',
            ['gizmoLocal'] = 'Relativ/Värld',
            ['gizmoSnapToGround'] = 'Fäst på marken',
            ['gizmoClose'] = 'Placera',
            ['gizmoCancel'] = 'Avbryt',
            -- v1.4.0: Walk Placement
            ['gizmoSwitchMode'] = 'Gåplacering',
            ['moveCamera'] = 'Flytta kamera',
            ['movePlayer'] = 'Gå',
            ['rotateWheel'] = 'Rotera',
            ['ghostRotateLeft'] = 'Rotera vänster',
            ['ghostRotateRight'] = 'Rotera höger',
            ['ghostMoveAway'] = 'Flytta bort',
            ['ghostMoveCloser'] = 'Flytta närmare',
            ['ghostMoveUp'] = 'Höj',
            ['ghostMoveDown'] = 'Sänk',
            ['ghostToggleSnap'] = 'Fäst på marken av/på',
            ['ghostConfirm'] = 'Placera',
            ['ghostCancel'] = 'Avbryt',
            ['ghostSwitchMode'] = 'Gizmo-placering'
        },

        ['app'] = {
            ['title'] = 'Crafting Editor',
            ['search'] = 'Sök',
            ['refresh'] = 'Uppdatera',
            -- v1.2.1: Version & Changelog System
            ['version'] = {
                ['outdated'] = 'Uppdatering tillgänglig',
                ['uptodate'] = 'Uppdaterad',
                ['behind'] = '%s uppdateringar efter',
                ['changelogs'] = 'Ändringslogg',
                ['no_changelogs'] = 'Inga ändringsloggar tillgängliga.',
                ['new'] = 'Ny',
                ['current'] = 'Nuvarande',
                ['hotfixes'] = 'Snabbfixar',
                ['hotfix_available'] = 'Snabbfix tillgänglig',
                ['hotfix_desc'] = 'Läs versionsinformationen för att avgöra om denna snabbfix gäller din server.',
                ['dismiss_hotfix'] = 'Ignorera denna snabbfix',
            },
            ['columns'] = {
                ['id'] = 'ID',
                ['name'] = 'Namn',
                ['created_at'] = 'Skapad den',
                ['locations'] = 'Platser',
                ['bench_type'] = 'Bänktyp',
                ['created_by'] = 'Skapad av',
                ['is_portable'] = 'Är portabel',
                ['coordinates'] = 'Koordinater',
            },
            ['rows_per_page'] = 'Rader per sida',
            ['page_of'] = 'Sida %s av %s',
            ['selected'] = '%s markerad',
            ['edit'] = 'Redigera',
            ['delete'] = 'Ta bort',
            ['reset'] = 'Återställ',
            ['no_results'] = 'Inga resultat...',
            ['clear_filters'] = 'Rensa filter',

            ['benches'] = { -- Benches Page
                ['label'] = 'Bänkar',
                ['description'] = 'Visa och hantera alla tillgängliga bänkar. Du kan skapa, redigera och ta bort.',
                ['types'] = {
                    ['label'] = 'Typer',
                    ['create_button'] = 'Ny bänktyp',
                    ['no_locations'] = 'Inga platser',
                    ['locations'] = '%s plats(er)',
                    ['add_location'] = 'Lägg till plats',
                    ['view_locations'] = 'Visa platser',
                    ['actions'] = {
                        ['view_locations'] = 'Visa platser',
                        ['add_location'] = 'Lägg till plats',
                        ['give_portable_item'] = 'Ge portabelt objekt till spelare',
                    },
                    ['map'] = {
                        ['title'] = 'Platser för bänktypen "%s"',
                        ['error'] = 'Fel vid hämtning av platser',
                        ['no_locations'] = 'Inga platser hittades...',
                        ['coordinates'] = 'Koordinater',
                        ['actions'] = {
                            ['teleport_to'] = 'Teleportera till plats',
                            ['edit'] = 'Redigera',
                            ['remove'] = 'Ta bort',
                        }
                    }
                },
                ['locations'] = {
                    ['label'] = 'Platser',
                    ['create_button'] = 'Ny bänkplats',
                    ['actions'] = {
                        ['teleport_to'] = 'Teleportera till plats',
                        ['copy_id'] = 'Kopiera ID',
                        ['copy_bench_type_id'] = 'Kopiera bänktypens ID',
                    }
                }
            },

            ['recipes'] = { -- Recipes Page
                ['label'] = 'Recept',
                ['description'] =
                'Visa och hantera alla tillgängliga recept. Du kan skapa, redigera och ta bort. Öppna en kategori för att se recepten inom den, och klicka på ett recept för att se dess detaljer.',
                ['no_categories_found'] = 'Inga kategorier hittades.',
                ['create_a_category'] = 'Skapa en kategori!',
                ['category_title'] = 'Kategori: %s',
                ['create_button'] = 'Skapa kategori',
                ['edit_button'] = 'Redigera kategori',
                ['delete_button'] = 'Ta bort kategori',
                ['no_recipes_found'] = 'Inga recept hittades...',
                ['recipes_error'] = 'Det gick inte att ladda recepten.',
                ['create_recipe'] = 'Skapa recept',
                ['crafting_time_desc'] = 'Tiden det tar att skapa detta objekt.',
                ['xp'] = '%s XP',
                ['xp_reward_desc'] = 'XP-belöningen för att skapa detta objekt.',
                ['prop_model_desc'] = 'Modellen som visas när detta objekt skapas.',
                ['results'] = 'Resultat',
                ['results_desc'] = 'Dessa är resultaten av att skapa detta objekt.',
                ['level'] = 'Nivå',
                ['level_desc'] = 'Nivån som krävs för att skapa detta objekt.',
                ['category_level'] = 'Kategorinivå',
                ['category_level_desc'] = 'Kategorins nivå som krävs för att skapa detta objekt.',
                ['ingredients'] = 'Ingredienser',
                ['ingredients_desc'] = 'Dessa är ingredienserna som krävs för att skapa detta objekt.',
                ['blueprints'] = 'Ritningar',
                ['blueprints_desc'] = 'Dessa är ritningarna som krävs för att skapa detta objekt',
            },

            ['blueprints'] = { -- Blueprints Page
                ['label'] = 'Ritningar',
                ['description'] =
                'Visa och hantera alla ritningar. Du kan skapa, redigera och ta bort ritningar från denna sida. Ritningar används för att definiera tillverkningsrecept.',
                ['search'] = 'Sök ritningar...',
                ['error'] = 'Ett fel uppstod vid hämtning av ritningar.',
                ['create_button'] = 'Skapa ritning',
            },

            ['forms'] = {
                ['name'] = 'Namn',
                ['create'] = 'Skapa',
                ['update'] = 'Uppdatera',
                ['save'] = 'Spara',
                ['delete'] = 'Ta bort',
                ['cancel'] = 'Avbryt',
                ['edit'] = 'Redigera',

                ['bench_type'] = {
                    ['new_title'] = 'Ny bänktyp',
                    ['edit_title'] = 'Redigera bänktyp: %s',
                    ['delete_title'] = 'Ta bort bänktyp: %s',
                    ['delete_description'] =
                    'Är du säker på att du vill ta bort bänktypen %s? Denna åtgärd kan inte ångras. Alla bänkplatser som använder denna typ kommer att tas bort.',
                    ['name'] = 'Namn',
                    ['model'] = 'Modell',
                    ['choose_a_model'] = 'Välj en modell',
                    ['none_model'] = 'Ingen (anpassad)',
                    ['none_model_desc'] =
                    'Ingen modell. Används för att använda tillverkningsbänken på redan befintliga modeller.',
                    ['no_model'] = 'Ingen modell',
                    ['no_models'] = 'Inga modeller hittades',
                    ['change'] = 'Ändra',
                    ['fullaccess'] = 'Full åtkomst',
                    ['fullaccess_description'] = 'Tillåt denna bänktyp åtkomst till alla kategorier?',
                    ['categories'] = 'Kategorier',
                    ['categories_description'] = 'Dessa är kategorierna som denna bänktyp har åtkomst till.',
                    ['manage_recipe_restrictions'] = 'Hantera receptbegränsningar',
                    ['recipe_restrictions'] = {
                        ['title'] = '%s Kategori - Receptbegränsningar',
                        ['description'] =
                        'Ställ in begränsningar för denna kategori. Tillåt eller neka recept från att tillverkas.',
                        ['set_denied_as_default'] = 'Ställ in nekat som standard',
                        ['set_denied_as_default_desc'] =
                        'Observera: Detta nekar alla recept som standard. Om du endast vill tillåta några recept, kan du ställa in detta till sant. Detta kommer också att återställa alla nuvarande receptbegränsningar.',
                        ['no_recipes'] = 'Inga recept... Lägg till några innan du ställer in begränsningar.',
                        ['recipe_error'] = 'Det gick inte att ladda recepten...',
                        ['denied_recipes'] = 'Nekade recept',
                        ['allowed_recipes'] = 'Tillåtna recept',
                    },
                    ['access'] = 'Åtkomst',
                    ['access_description'] = 'Åtkomstidentifieraren för denna bänktyp.',
                    ['selected'] = '%s vald',
                    ['none'] = 'Ingen',
                    ['no_categories'] = 'Inga kategorier hittades. Skapa en kategori innan du lägger till en bänktyp.',
                    ['categories_error'] = 'Ett fel uppstod vid hämtning av kategorier.',
                    ['change_rank_options'] = 'Ändra rankningsalternativ',
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
                    ['new_title'] = 'Ny bänkplats',
                    ['edit_title'] = 'Redigera bänkplats',
                    ['delete_title'] = 'Ta bort bänkplats: %s',
                    ['delete_description'] =
                    'Är du säker på att du vill ta bort bänkplatsen för bänktypen %s? Denna åtgärd kan inte ångras.',
                    ['add_location_for_bench_type'] = 'Lägg till plats för bänktypen "%s"',
                    ['bench_type'] = 'Bänktyp',
                    ['bench_type_description'] = 'Typ av bänk.',
                    ['location'] = 'Plats',
                    ['location_description'] = 'Bänkens plats. Använd knappen för att placera ut den.',
                    ['location_description_2'] =
                    'Se till att hela bänken är synlig och att det finns tillräckligt med utrymme för spelaren att interagera med den.',
                    ['is_portable'] = 'Är portabel',
                    ['is_portable_description'] = 'Är bänken portabel? (Kan flyttas av spelare)',
                    -- v1.2.1: Shared Mode Overrides
                    ['shared_levels_override'] = 'Override Shared Levels',
                    ['shared_levels_override_description'] =
                    'Override the bench type shared levels setting for this location. Leave unchecked to inherit from bench type.',
                    ['shared_queue_override'] = 'Override Shared Queue',
                    ['shared_queue_override_description'] =
                    'Override the bench type shared queue setting for this location. Leave unchecked to inherit from bench type.',
                    ['place_out'] = 'Placera ut',
                    ['select_bench_type_first'] = 'Vänligen välj en bänktyp först.',
                    ['select_bench_type'] = 'Välj bänktyp',
                    ['search_bench_types'] = 'Sök bänktyper...',
                    ['no_bench_types'] = 'Inga bänktyper hittades.',
                    ['loading_bench_types'] = 'Laddar bänktyper...',
                    ['bench_types_error'] = 'Fel vid inläsning av bänktyper.',
                },

                ['give_portable_item'] = {
                    ['title'] = 'Ge portabelt objekt till spelare',
                    ['player_id'] = 'Spelar-ID',
                    ['give_item'] = 'Ge objekt'
                },

                ['category'] = {
                    ['new_title'] = 'Ny kategori',
                    ['edit_title'] = 'Redigera kategori: %s',
                    ['delete_title'] = 'Ta bort kategori: %s',
                    ['delete_description'] =
                    'Är du säker på att du vill ta bort kategorin %s? Denna åtgärd kan inte ångras.',
                    ['delete_warning'] =
                    'Varning: Detta kommer också att ta bort alla recept i denna kategori och kan inte ångras.',
                    ['title'] = 'Titel',
                    ['description'] = 'Beskrivning',
                    ['use_image_url'] = 'Använd bild-URL',
                    ['use_image_url_desc'] = 'Använd en bild-URL istället för en ikon',
                    ['icon'] = 'Ikon',
                    ['icon_desc'] = 'Hitta en ikon på https://fonts.google.com/icons',
                    ['image'] = 'Bild-URL',
                },

                ['recipe'] = {
                    ['new_title'] = 'Nytt recept',
                    ['edit_title'] = 'Redigera recept: %s',
                    ['delete_title'] = 'Ta bort recept: %s',
                    ['delete_description'] =
                    'Är du säker på att du vill ta bort receptet %s? Denna åtgärd kan inte ångras.',
                    ['title'] = 'Titel',
                    ['description'] = 'Beskrivning',
                    ['required_level'] = 'Krävd nivå',
                    ['required_level_desc'] = 'Krävd global nivå för att skapa detta recept. Lämna tomt för inget krav.',
                    ['required_category_level'] = 'Krävd kategorinivå',
                    ['required_category_level_desc'] =
                    'Krävd kategorinivå för att skapa detta recept. Lämna tomt för inget krav.',
                    ['crafting_time'] = 'Tillverkningstid (i sekunder)',
                    ['crafting_time_desc'] = 'Hur lång tid det tar att skapa detta recept (i sekunder).',
                    ['xp_reward'] = 'XP-belöning',
                    ['xp_reward_desc'] = 'Hur mycket XP som tilldelas för att skapa detta recept. (standard är 25)',
                    ['prop_model'] = 'Prop-modell',
                    ['prop_model_desc'] =
                    'Prop-modellen som visas vid tillverkning. Lämna tomt för ingen prop. (t.ex. prop_tool_hammer)',
                    ['prop_rot'] = 'Prop-rotation',
                    ['prop_rot_desc'] = 'Rotation av prop-modellen.',
                    ['prop_offset'] = 'Prop-förskjutning',
                    ['prop_offset_desc'] =
                    'Förskjutning av prop-modellen. Justera för att centrera propen. X: framåt/bakåt, Y: vänster/höger Z: upp/ned',
                    ['blueprints'] = 'Ritningar',
                    ['blueprints_desc'] = 'Ritningar som krävs för att skapa detta recept.',
                    ['ingredients'] = 'Ingredienser',
                    ['ingredients_desc'] = 'Ingredienser som krävs för att skapa detta recept. Minst 1 krävs.',
                    ['results'] = 'Resultat',
                    ['results_desc'] = 'Resultat av att skapa detta recept. Minst 1 krävs.',
                    ['cooldown_limit'] = 'Cooldown gräns',
                    ['cooldown_limit_desc'] = 'Max antal tillverkningar inom fönster. Sätt 0/tom för att inaktivera.',
                    ['cooldown_window'] = 'Cooldown fönster',
                    ['cooldown_window_desc'] = 'Längd på cooldown fönster (dagar, timmar, minuter, sekunder).',
                    -- v1.2.1: Failure Chance
                    ['failure_chance'] = 'Misslyckanderisk (%)',
                    ['failure_chance_desc'] =
                    'Chans att tillverkningen misslyckas (0-100). Ingredienser förbrukas vid misslyckande.',
                    ['failure_mode'] = 'Misslyckandeläge',
                    ['failure_mode_desc'] =
                    'batch = ett kast för hela tillverkningen, individual = varje föremål kastas separat.',

                    ['add'] = 'Lägg till'
                },

                ['blueprint'] = {
                    ['new_title'] = 'Ny ritning',
                    ['edit_title'] = 'Redigera ritning: %s',
                    ['delete_title'] = 'Ta bort ritning: %s',
                    ['delete_description'] =
                    'Är du säker på att du vill ta bort ritningen %s? Denna åtgärd kan inte ångras.',
                    ['label'] = 'Etikett',
                    ['description'] = 'Beskrivning',
                    ['uses'] = 'Användningar',
                    ['uses_description'] =
                    'Används endast med `enableBlueprintItems`, `removeBlueprintOnCraft` och `blueprintDurability` aktiverat.'
                },

                ['select_blueprint'] = {
                    ['label'] = 'Ritning',
                    ['select_blueprint'] = 'Välj ritning',
                    ['search_blueprints'] = 'Sök ritningar...',
                    ['loading'] = 'Laddar ritningar...',
                    ['error'] = 'Fel vid inläsning av ritningar.',
                    ['duplicate'] = 'Ritning redan tillagd. Vänligen välj en annan ritning.',
                    ['no_found'] = 'Inga ritningar hittades.'
                },

                ['select_item'] = {
                    ['label'] = 'Föremål',
                    ['count'] = 'Antal',
                    ['select_item'] = 'Välj föremål',
                    ['search_items'] = 'Sök föremål...',
                    ['loading'] = 'Laddar föremål...',
                    ['error'] = 'Fel vid inläsning av föremål.',
                    ['no_found'] = 'Inga föremål hittades.',
                    ['set_metadata'] = 'Ange metadata',
                    ['metadata_title'] = 'Metadata för: %s',
                },

                ['errors'] = {
                    ['name_is_required'] = 'Namn krävs.',
                    ['name_too_short'] = 'Namnet måste vara minst 2 tecken långt.',
                    ['category_is_required'] = 'Minst en kategori krävs.',
                    ['item_is_required'] = 'Objekt krävs',
                    ['min_one_item'] = 'Du måste lägga till minst ett objekt.',
                }
            }
        }
    },

    ['command'] = {
        ['error'] = 'Fel',
        ['not_allowed'] = 'Du har inte behörighet att använda detta kommando.',
        ['no_subcommand'] = 'Ogiltigt underkommando. Skriv /crafting help för en lista över kommandon.',
        ['no_player'] = 'Ingen spelare hittades med det ID:t.',
        ['no_blueprint_found'] = 'Ingen ritning hittades med det namnet eller ID:t.',
        ['already_has_blueprint'] = 'Spelaren har redan denna ritning.',
        ['gave_blueprint'] = 'Ritning %s gavs till spelare %s.',
        ['removed_blueprint'] = 'Ritning %s togs bort från spelare %s.',
        ['set_level'] = 'Spelare %s har nu nivå %s.',
        ['set_category_level'] = 'Kategori-nivå %s satt för spelare %s.',
        ['no_category_found'] = 'Ingen kategori hittades med det namnet eller ID:t.',
        ['category_level'] = 'Kategorinivå',
        ['player_level'] = 'Nivåer för %s (%s)',
        ['invalid_level'] = 'Ogiltig nivå.',
        ['gave_portable_item'] = 'Gav bärbart föremål för arbetsbänk typ (%s) till spelare %s.',
        ['missing_arguments'] = 'Argument saknas. Skriv /crafting help för kommandodetaljer.',
        ['help'] = {
            ['title'] = 'Tillverkningskommandon',
            ['description'] = 'Lista över tillgängliga kommandon',
            ['subcommands'] = {
                ['help'] = 'Visa hjälpmeny',
                ['blueprints'] = 'Visa dina ritningar',
                ['level'] = 'Visa din nivå',
                ['editor'] = 'Öppna redigeraren',
                ['getblueprints'] = 'Visa en spelares ritningar',
                ['giveblueprint'] = 'Ge en ritning till en spelare',
                ['removeblueprint'] = 'Ta bort en ritning från en spelare',
                ['getlevel'] = 'Visa en spelares nivå',
                ['setlevel'] = 'Sätt en spelares nivå',
                ['setcategorylevel'] = 'Sätt en spelares kategori-nivå',
                ['editbench'] = 'Redigera närmaste bänk',
                ['removebench'] = 'Ta bort närmaste bänk',
                ['giveportableitem'] = 'Ge en bärbar arbetsbänk till en spelare'
            },
            ["params"] = {
                ["id"] = "Spelar-ID",
                ["blueprint"] = "Ritning-ID",
                ["level"] = "Nivå",
                ["category"] = "Kategori",
                ["bench"] = "Bänk ID/Namn"
            }
        }
    },

    ["discord_logs"] =
    "## Spelare %s skapade %sx %s (ID: %s)\nBänktyp: `%s (%s)`\nBänkplats: `%s`\nResultatföremål: `%s`\nIngrediensföremål: `%s`"
}
