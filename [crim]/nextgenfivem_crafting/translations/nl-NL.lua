Translation = {
    ['error_occurred'] = 'Er is een fout opgetreden. (%s)',
    ['not_allowed'] = 'Je hebt geen toestemming om deze editor te gebruiken.',
    ['afk_timeout'] = 'Je bent verwijderd vanwege inactiviteit (AFK).',

    ['errors'] = {
        ['couldnt_get_inventory'] = 'Kan de inventaris niet ophalen.',
        ['no_player_id'] = 'Geen speler-ID opgegeven.',
        ['invalid_quantity'] = 'Ongeldige hoeveelheid opgegeven.',
        ['couldnt_get_recipe'] = 'Kan het recept niet ophalen.',
        ['not_enough_level'] = 'Je niveau is niet hoog genoeg om dit item te maken.',
        ['not_enough_category_level'] = 'Je categoriëniveau is niet hoog genoeg om dit item te maken.',
        ['missing_ingredients'] = 'Niet genoeg ingrediënten om dit item te maken.',
        ['missing_blueprint'] = 'Een blauwdruk is vereist om dit item te maken.',
        ['no_session'] = 'Geen sessie gevonden.',
        ['invalid_session_data'] = 'Ongeldige sessiegegevens opgegeven.',
        ['not_finished'] = 'Het maken is nog niet voltooid.',
        ['invalid_data'] = 'Ongeldige gegevens opgegeven.',
        ['not_enough_space'] = 'Je hebt niet genoeg ruimte om dit te doen.',
        ['queue_limit_reached'] = 'Je hebt het maximale aantal fabricaten in de wachtrij bereikt.',
        ['max_craft_amount_exceeded'] = 'Je kunt niet meer dan %s voorwerpen tegelijk maken.'
    },

    ['crafting'] = {
        ['title_small'] = 'Werkbank',
        ['title_big'] = 'Craft tafel',
        ['recipes'] = 'Beschikbare Recepten',
        ['level'] = 'Niveau',
        ['level_short'] = 'Niv',
        ['use'] = 'Gebruik',
        ['pickup'] = 'Oppakken',
        ['no_access'] = 'Je hebt hier geen toegang toe.',
        ['not_using'] = 'Je gebruikt dit momenteel niet.',
        ['already_using'] = 'Je bent dit al aan het gebruiken.',
        ['already_in_use'] = 'Dit wordt momenteel door iemand anders gebruikt.',
        ['craft'] = 'Item maken',
        ['crafting'] = 'Bezig met Craften...',
        ['crafting_queue'] = 'Vervaardigingswachtrij',
        ['exit'] = 'Afsluiten',
        ['missing_items'] = 'Je mist %s %s',
        ['item'] = 'Item',
        ['items'] = 'Items',
        ['cancel_craft'] = 'Craften annuleren',
        ['requirements'] = 'Vereisten',
        ['ingredients'] = 'Ingrediënten',
        ['blueprints'] = 'Blauwdrukken',
        ['result_items'] = 'Resultaatitems',
        ['error_fetching_recipes'] = 'Fout bij het ophalen van recepten.',
        ['no_recipes'] = 'Geen recepten gevonden.',
        ['bench_placed'] = 'Werkbank geplaatst.',
        ['not_near_bench'] = 'Je bent niet dicht genoeg bij de werkbank.',
        ['no_blueprints_needed'] = 'Geen blauwdrukken vereist.',
        ['cooldown_crafts_remaining'] = '%s fabricaten over',
        ['cooldown_available_in'] = 'Beschikbaar over %s',
        ['cooldown_on_cooldown'] = 'In cooldown',
        ['cooldown_window'] = 'Venster: %s',
        -- v1.2.1: Failure Chance
        ['craft_failed'] = 'Mislukt!',
        ['craft_partial'] = '%s/%s Geslaagd',
        -- v1.2.1: View Locked Recipes
        ['recipe_locked'] = 'Vergrendeld',
        ['recipe_locked_level'] = 'Bereik het vereiste niveau om dit recept te ontgrendelen.',
        ['recipe_locked_blueprint'] = 'Een blauwdruk is vereist om dit recept te ontgrendelen.',

        ['stored_queue'] = {
            ['title'] = 'Opgeslagen Wachtrij',
            ['description'] = 'Je hebt een eerder opgeslagen wachtrij. Wil je deze gebruiken?',
            ['use_queue'] = 'Wachtrij gebruiken',
        }
    },

    ['item-descriptions'] = {
        ['portable_bench'] = 'Een draagbare werkbank voor type (%s). Gebruik dit om de werkbank te plaatsen.',
        ['blueprint'] = 'Een vervaardigingsblauwdruk voor %s.'
    },

    ['item-labels'] = {
        ['portable_bench'] = 'Vervaardigingswerkbank (%s)',
        ['blueprint'] = 'Blauwdruk (%s)'
    },

    ['editor'] = {
        ['title'] = 'Crafting editor',
        ['description'] =
        'Gebruik deze editor om de werkbank te plaatsen. Zorg ervoor dat deze volledig zichtbaar is met voldoende ruimte voor interactie.',
        -- v1.4.0: Walk Placement
        ['hint'] = {
            ['title'] = 'Gebeurt er niets?',
            ['description'] =
            'Zonder muiscursor kun je de gizmo niet gebruiken. Schakel over naar loopplaatsing — daarvoor heb je alleen het toetsenbord nodig.',
            ['action'] = 'Schakel over naar loopplaatsing'
        },
        ['ghost'] = {
            ['title'] = 'Loopplaatsing',
            ['description'] =
            'Loop naar de plek waar je de werkbank wilt hebben en plaats hem daar. Gebruik de toetsen hieronder om hem bij te stellen, een muis is niet nodig.'
        },
        ['controls'] = {
            ['gizmoSelect'] = 'Selecteer Tool',
            ['gizmoTranslation'] = 'Verplaatsmodus',
            ['gizmoRotation'] = 'Rotatiemodus',
            ['gizmoLocal'] = 'Relatief/Wereld',
            ['gizmoSnapToGround'] = 'Snappen naar Grond',
            ['gizmoClose'] = 'Plaatsen',
            ['gizmoCancel'] = 'Annuleren',
            -- v1.4.0: Walk Placement
            ['gizmoSwitchMode'] = 'Loopplaatsing',
            ['moveCamera'] = 'Camera Aanpassen',
            ['movePlayer'] = 'Lopen',
            ['rotateWheel'] = 'Draaien',
            ['ghostRotateLeft'] = 'Links Draaien',
            ['ghostRotateRight'] = 'Rechts Draaien',
            ['ghostMoveAway'] = 'Verder Weg',
            ['ghostMoveCloser'] = 'Dichterbij',
            ['ghostMoveUp'] = 'Omhoog',
            ['ghostMoveDown'] = 'Omlaag',
            ['ghostToggleSnap'] = 'Snappen naar Grond Aan/Uit',
            ['ghostConfirm'] = 'Plaatsen',
            ['ghostCancel'] = 'Annuleren',
            ['ghostSwitchMode'] = 'Gizmo-plaatsing'
        },

        ['app'] = {
            ['title'] = 'Vervaardigingseditor',
            ['search'] = 'Zoeken',
            ['refresh'] = 'Vernieuwen',
            -- v1.2.1: Version & Changelog System
            ['version'] = {
                ['outdated'] = 'Update beschikbaar',
                ['uptodate'] = 'Up-to-date',
                ['behind'] = '%s updates achter',
                ['changelogs'] = 'Wijzigingslogboek',
                ['no_changelogs'] = 'Geen wijzigingslogboek beschikbaar.',
                ['new'] = 'Nieuw',
                ['current'] = 'Huidig',
                ['hotfixes'] = 'Hotfixes',
                ['hotfix_available'] = 'Hotfix beschikbaar',
                ['hotfix_desc'] =
                'Lees de release-opmerkingen om te bepalen of deze hotfix van toepassing is op uw server.',
            },
            ['columns'] = {
                ['id'] = 'ID',
                ['name'] = 'Naam',
                ['created_at'] = 'Aangemaakt op',
                ['locations'] = 'Locaties',
                ['bench_type'] = 'Werkbanktype',
                ['created_by'] = 'Aangemaakt door',
                ['is_portable'] = 'Draagbaar',
                ['coordinates'] = 'Coördinaten',
            },
            ['rows_per_page'] = 'Rijen per pagina',
            ['page_of'] = 'Pagina %s van %s',
            ['selected'] = '%s geselecteerd',
            ['edit'] = 'Bewerken',
            ['delete'] = 'Verwijderen',
            ['reset'] = 'Resetten',
            ['no_results'] = 'Geen resultaten...',
            ['clear_filters'] = 'Filters wissen',

            ['benches'] = { -- Werkbankenpagina
                ['label'] = 'Werkbanken',
                ['description'] =
                'Bekijk en beheer alle beschikbare werkbanken. Je kunt aanmaken, bewerken en verwijderen.',
                ['types'] = {
                    ['label'] = 'Types',
                    ['create_button'] = 'Nieuw Werkbanktype',
                    ['no_locations'] = 'Geen locaties',
                    ['locations'] = '%s locatie(s)',
                    ['add_location'] = 'Locatie Toevoegen',
                    ['view_locations'] = 'Locaties Bekijken',
                    ['actions'] = {
                        ['view_locations'] = 'Locaties Bekijken',
                        ['add_location'] = 'Locatie Toevoegen',
                        ['give_portable_item'] = 'Geef Draagbaar Item aan Speler',
                    },
                    ['map'] = {
                        ['title'] = 'Locaties voor werkbanktype "%s"',
                        ['error'] = 'Fout bij ophalen van locaties',
                        ['no_locations'] = 'Geen locaties gevonden...',
                        ['coordinates'] = 'Coördinaten',
                        ['actions'] = {
                            ['teleport_to'] = 'Teleporteren naar Locatie',
                            ['edit'] = 'Bewerken',
                            ['remove'] = 'Verwijderen',
                        }
                    }
                },
                ['locations'] = {
                    ['label'] = 'Locaties',
                    ['create_button'] = 'Nieuwe Werkbanklocatie',
                    ['actions'] = {
                        ['teleport_to'] = 'Teleporteren naar Locatie',
                        ['copy_id'] = 'ID Kopiëren',
                        ['copy_bench_type_id'] = 'Werkbanktype-ID Kopiëren',
                    }
                }
            },

            ['recipes'] = { -- Receptenpagina
                ['label'] = 'Recepten',
                ['description'] =
                'Bekijk en beheer alle beschikbare recepten. Je kunt categorieën aanmaken, bewerken en verwijderen. Open een categorie om de recepten te bekijken, en klik op een recept om de details te zien.',
                ['no_categories_found'] = 'Geen categorieën gevonden.',
                ['create_a_category'] = 'Maak een categorie aan!',
                ['category_title'] = 'Categorie: %s',
                ['create_button'] = 'Categorie Aanmaken',
                ['edit_button'] = 'Categorie Bewerken',
                ['delete_button'] = 'Categorie Verwijderen',
                ['no_recipes_found'] = 'Geen recepten gevonden...',
                ['recipes_error'] = 'Laden van recepten mislukt.',
                ['create_recipe'] = 'Recept Aanmaken',
                ['crafting_time_desc'] = 'De tijd die nodig is om dit item te maken.',
                ['xp'] = '%s XP',
                ['xp_reward_desc'] = 'De XP-beloning voor het maken van dit item.',
                ['prop_model_desc'] = 'Het prop-model dat wordt weergegeven tijdens het maken van dit item.',
                ['results'] = 'Resultaten',
                ['results_desc'] = 'Dit zijn de resultaten van het maken van dit item.',
                ['level'] = 'Niveau',
                ['level_desc'] = 'Het vereiste niveau om dit item te maken.',
                ['category_level'] = 'Categoriëniveau',
                ['category_level_desc'] = 'Het niveau van de categorie dat vereist is om dit item te maken.',
                ['ingredients'] = 'Ingrediënten',
                ['ingredients_desc'] = 'Dit zijn de ingrediënten die nodig zijn om dit item te maken.',
                ['blueprints'] = 'Blauwdrukken',
                ['blueprints_desc'] = 'Dit zijn de blauwdrukken die nodig zijn om dit item te maken.',
            },

            ['blueprints'] = { -- Blauwdrukkenpagina
                ['label'] = 'Blauwdrukken',
                ['description'] =
                'Bekijk en beheer alle blauwdrukken. Je kunt blauwdrukken aanmaken, bewerken en verwijderen vanaf deze pagina. Blauwdrukken worden gebruikt om recepten te definiëren.',
                ['search'] = 'Zoek blauwdrukken...',
                ['error'] = 'Er is een fout opgetreden bij het ophalen van de blauwdrukken.',
                ['create_button'] = 'Blauwdruk Aanmaken',
            },

            ['forms'] = {
                ['name'] = 'Naam',
                ['create'] = 'Aanmaken',
                ['update'] = 'Bijwerken',
                ['save'] = 'Opslaan',
                ['delete'] = 'Verwijderen',
                ['cancel'] = 'Annuleren',
                ['edit'] = 'Bewerken',

                ['bench_type'] = {
                    ['new_title'] = 'Nieuw Werkbanktype',
                    ['edit_title'] = 'Bewerk Werkbanktype: %s',
                    ['delete_title'] = 'Verwijder Werkbanktype: %s',
                    ['delete_description'] =
                    'Weet je zeker dat je het werkbanktype %s wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt. Alle werkbanklocaties die dit type gebruiken worden verwijderd.',
                    ['name'] = 'Naam',
                    ['model'] = 'Model',
                    ['choose_a_model'] = 'Kies een model',
                    ['none_model'] = 'Geen (aangepast)',
                    ['none_model_desc'] =
                    'Geen model. Wordt gebruikt voor het gebruiken van de werkbank op reeds bestaande modellen.',
                    ['no_model'] = 'Geen model',
                    ['no_models'] = 'Geen modellen gevonden',
                    ['change'] = 'Wijzigen',
                    ['fullaccess'] = 'Volledige Toegang',
                    ['fullaccess_description'] = 'Toegang geven tot alle categorieën voor dit werkbanktype?',
                    ['categories'] = 'Categorieën',
                    ['categories_description'] = 'Dit zijn de categorieën waartoe dit werkbanktype toegang heeft.',
                    ['manage_recipe_restrictions'] = 'Beheer receptbeperkingen',
                    ['recipe_restrictions'] = {
                        ['title'] = '%s Categorie - Receptbeperkingen',
                        ['description'] =
                        'Stel beperkingen in voor deze categorie. Sta toe of weiger recepten om gemaakt te worden.',
                        ['set_denied_as_default'] = 'Stel "weigeren" in als standaard',
                        ['set_denied_as_default_desc'] =
                        'Let op: Dit weigert standaard alle recepten. Als je bijvoorbeeld slechts enkele recepten wilt toestaan, stel je dit in op waar. Dit zal ook alle huidige beperkingen resetten.',
                        ['no_recipes'] = 'Geen recepten... Voeg eerst recepten toe voordat je beperkingen instelt.',
                        ['recipe_error'] = 'Kon recepten niet laden...',
                        ['denied_recipes'] = 'Geweigerde Recepten',
                        ['allowed_recipes'] = 'Toegestane Recepten',
                    },
                    ['access'] = 'Toegang',
                    ['access_description'] = 'De toegangs-ID voor dit werkbanktype.',
                    ['selected'] = '%s geselecteerd',
                    ['none'] = 'Geen',
                    ['no_categories'] =
                    'Geen categorieën gevonden. Maak eerst een categorie aan voordat je een werkbanktype toevoegt.',
                    ['categories_error'] = 'Er is een fout opgetreden bij het ophalen van de categorieën.',
                    ['change_rank_options'] = 'Wijzig rangopties',
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
                    ['new_title'] = 'Nieuwe Werkbanklocatie',
                    ['edit_title'] = 'Bewerk Werkbanklocatie',
                    ['delete_title'] = 'Verwijder Werkbanklocatie: %s',
                    ['delete_description'] =
                    'Weet je zeker dat je de werkbanklocatie voor werkbanktype %s wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.',
                    ['add_location_for_bench_type'] = 'Voeg locatie toe voor werkbanktype "%s"',
                    ['bench_type'] = 'Werkbanktype',
                    ['bench_type_description'] = 'Type werkbank.',
                    ['location'] = 'Locatie',
                    ['location_description'] = 'Locatie van de werkbank. Gebruik de knop om deze te plaatsen.',
                    ['location_description_2'] =
                    'Zorg ervoor dat de gehele werkbank zichtbaar is, en er voldoende ruimte is voor de speler om ermee te interageren.',
                    ['is_portable'] = 'Is Draagbaar',
                    ['is_portable_description'] = 'Is de werkbank draagbaar? (Kan door spelers verplaatst worden)',
                    -- v1.2.1: Shared Mode Overrides
                    ['shared_levels_override'] = 'Override Shared Levels',
                    ['shared_levels_override_description'] =
                    'Override the bench type shared levels setting for this location. Leave unchecked to inherit from bench type.',
                    ['shared_queue_override'] = 'Override Shared Queue',
                    ['shared_queue_override_description'] =
                    'Override the bench type shared queue setting for this location. Leave unchecked to inherit from bench type.',
                    ['place_out'] = 'Plaatsen',
                    ['select_bench_type_first'] = 'Selecteer eerst een werkbanktype.',
                    ['select_bench_type'] = 'Selecteer werkbanktype',
                    ['search_bench_types'] = 'Zoek werkbanktypes...',
                    ['no_bench_types'] = 'Geen werkbanktypes gevonden.',
                    ['loading_bench_types'] = 'Werkbanktypes worden geladen...',
                    ['bench_types_error'] = 'Fout bij het laden van werkbanktypes.',
                },

                ['give_portable_item'] = {
                    ['title'] = 'Geef Draagbaar Item aan Speler',
                    ['player_id'] = 'Speler ID',
                    ['give_item'] = 'Geef Item'
                },

                ['category'] = {
                    ['new_title'] = 'Nieuwe Categorie',
                    ['edit_title'] = 'Bewerk Categorie: %s',
                    ['delete_title'] = 'Verwijder Categorie: %s',
                    ['delete_description'] =
                    'Weet je zeker dat je de categorie %s wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.',
                    ['delete_warning'] =
                    'Waarschuwing: Dit zal ook alle recepten in deze categorie verwijderen en kan niet ongedaan worden gemaakt.',
                    ['title'] = 'Titel',
                    ['description'] = 'Beschrijving',
                    ['use_image_url'] = 'Gebruik Afbeeldings-URL',
                    ['use_image_url_desc'] = 'Gebruik een afbeeldings-URL in plaats van een icoon',
                    ['icon'] = 'Icoon',
                    ['icon_desc'] = 'Zoek een icoon op https://fonts.google.com/icons',
                    ['image'] = 'Afbeeldings-URL',
                },

                ['recipe'] = {
                    ['new_title'] = 'Nieuw Recept',
                    ['edit_title'] = 'Bewerk Recept: %s',
                    ['delete_title'] = 'Verwijder Recept: %s',
                    ['delete_description'] =
                    'Weet je zeker dat je het recept %s wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.',
                    ['title'] = 'Titel',
                    ['description'] = 'Beschrijving',
                    ['required_level'] = 'Vereist Niveau',
                    ['required_level_desc'] =
                    'Vereist globaal niveau om dit recept te maken. Laat leeg als er geen vereiste is.',
                    ['required_category_level'] = 'Vereist Categorie Niveau',
                    ['required_category_level_desc'] =
                    'Vereist categorie-niveau om dit recept te maken. Laat leeg als er geen vereiste is.',
                    ['crafting_time'] = 'Tijd om te maken (in seconden)',
                    ['crafting_time_desc'] = 'Hoe lang het duurt om dit recept te maken (in seconden).',
                    ['xp_reward'] = 'XP Beloning',
                    ['xp_reward_desc'] = 'Hoeveel XP je krijgt voor het maken van dit recept. (standaard is 25)',
                    ['prop_model'] = 'Prop Model',
                    ['prop_model_desc'] =
                    'Prop-model dat wordt weergegeven bij het maken van dit recept. Laat leeg voor geen prop. (bijv. prop_tool_hammer)',
                    ['prop_rot'] = 'Prop Rotatie',
                    ['prop_rot_desc'] = 'Rotatie van het prop-model.',
                    ['prop_offset'] = 'Prop Positie',
                    ['prop_offset_desc'] =
                    'Positie van het prop-model. Pas aan om het prop te centreren. X: voor/achter, Y: links/rechts, Z: omhoog/omlaag',
                    ['blueprints'] = 'Blauwdrukken',
                    ['blueprints_desc'] = 'Blauwdrukken die nodig zijn om dit recept te maken.',
                    ['ingredients'] = 'Ingrediënten',
                    ['ingredients_desc'] = 'Ingrediënten die nodig zijn om dit recept te maken. Minimaal 1 vereist.',
                    ['results'] = 'Resultaten',
                    ['results_desc'] = 'Resultaten van het maken van dit recept. Minimaal 1 vereist.',
                    ['cooldown_limit'] = 'Cooldown limiet',
                    ['cooldown_limit_desc'] = 'Max totaal gemaakt binnen venster. Zet 0/leeg om uit te schakelen.',
                    ['cooldown_window'] = 'Cooldown venster',
                    ['cooldown_window_desc'] = 'Lengte van cooldown venster (dagen, uren, minuten, seconden).',
                    -- v1.2.1: Failure Chance
                    ['failure_chance'] = 'Faalkans (%)',
                    ['failure_chance_desc'] =
                    'Kans dat het craften mislukt (0-100). Ingrediënten worden verbruikt bij mislukking.',
                    ['failure_mode'] = 'Faalmodus',
                    ['failure_mode_desc'] =
                    'batch = één worp voor de hele craft, individual = elk item wordt apart geworpen.',

                    ['add'] = 'Toevoegen'
                },

                ['blueprint'] = {
                    ['new_title'] = 'Nieuwe Blauwdruk',
                    ['edit_title'] = 'Bewerk Blauwdruk: %s',
                    ['delete_title'] = 'Verwijder Blauwdruk: %s',
                    ['delete_description'] =
                    'Weet je zeker dat je de blauwdruk %s wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.',
                    ['label'] = 'Label',
                    ['description'] = 'Beschrijving',
                    ['uses'] = 'Aantal keren te gebruiken',
                    ['uses_description'] =
                    'Alleen gebruikt met `enableBlueprintItems`, `removeBlueprintOnCraft` en `blueprintDurability` ingeschakeld.'
                },

                ['select_blueprint'] = {
                    ['label'] = 'Blauwdruk',
                    ['select_blueprint'] = 'Selecteer blauwdruk',
                    ['search_blueprints'] = 'Zoek blauwdrukken...',
                    ['loading'] = 'Blauwdrukken worden geladen...',
                    ['error'] = 'Fout bij het laden van blauwdrukken.',
                    ['duplicate'] = 'Blauwdruk is al toegevoegd. Selecteer een andere blauwdruk.',
                    ['no_found'] = 'Geen blauwdrukken gevonden.'
                },

                ['select_item'] = {
                    ['label'] = 'Item',
                    ['count'] = 'Aantal',
                    ['select_item'] = 'Selecteer item',
                    ['search_items'] = 'Zoek items...',
                    ['loading'] = 'Items worden geladen...',
                    ['error'] = 'Fout bij het laden van items.',
                    ['no_found'] = 'Geen items gevonden.',
                    ['set_metadata'] = 'Stel metadata in',
                    ['metadata_title'] = 'Metadata voor: %s',
                },

                ['errors'] = {
                    ['name_is_required'] = 'Naam is verplicht.',
                    ['name_too_short'] = 'Naam moet minimaal 2 tekens bevatten.',
                    ['category_is_required'] = 'Minimaal één categorie is vereist.',
                    ['item_is_required'] = 'Item is verplicht.',
                    ['min_one_item'] = 'Je moet minimaal één item toevoegen.',
                }
            }
        }
    },

    ['command'] = {
        ['error'] = 'Commandofout',
        ['not_allowed'] = 'Je hebt geen toestemming om dit commando te gebruiken.',
        ['no_subcommand'] = 'Ongeldig subcommando. Gebruik /crafting help voor een lijst met commando’s.',
        ['no_player'] = 'Geen speler gevonden met dat ID.',
        ['no_blueprint_found'] = 'Geen blauwdruk gevonden met die naam of ID.',
        ['already_has_blueprint'] = 'De speler bezit deze blauwdruk al.',
        ['gave_blueprint'] = 'Blauwdruk %s gegeven aan speler %s.',
        ['removed_blueprint'] = 'Blauwdruk %s verwijderd van speler %s.',
        ['set_level'] = 'Speler %s ingesteld op level %s.',
        ['set_category_level'] = 'Categorielevel %s ingesteld voor speler %s.',
        ['no_category_found'] = 'Geen categorie gevonden met die naam of ID.',
        ['category_level'] = 'Categorielevel',
        ['player_level'] = 'Levels voor %s (%s)',
        ['invalid_level'] = 'Ongeldig level opgegeven.',
        ['gave_portable_item'] = 'Draagbare werkbank (%s) gegeven aan speler %s.',
        ['missing_arguments'] = 'Ontbrekende argumenten. Gebruik /crafting help voor de details van het commando.',
        ['help'] = {
            ['title'] = 'Craftingcommando\'s',
            ['description'] = 'Lijst met beschikbare commando\'s',
            ['subcommands'] = {
                ['help'] = 'Toon helpmenu',
                ['blueprints'] = 'Bekijk je blauwdrukken',
                ['level'] = 'Bekijk je level',
                ['editor'] = 'Open de craftingeditor',
                ['getblueprints'] = 'Bekijk blauwdrukken van speler',
                ['giveblueprint'] = 'Geef een blauwdruk aan een speler',
                ['removeblueprint'] = 'Verwijder een blauwdruk van een speler',
                ['getlevel'] = 'Bekijk level van speler',
                ['setlevel'] = 'Stel level van speler in',
                ['setcategorylevel'] = 'Stel categorielevel van speler in',
                ['editbench'] = 'Bewerk de dichtstbijzijnde werkbank',
                ['removebench'] = 'Verwijder de dichtstbijzijnde werkbank',
                ['giveportableitem'] = 'Geef een draagbare werkbank aan een speler'
            },
            ["params"] = {
                ["id"] = "Speler-ID",
                ["blueprint"] = "Blauwdruk-ID",
                ["level"] = "Level",
                ["category"] = "Categorie",
                ["bench"] = "Werkbank ID/Naam"
            }
        }
    },

    ["discord_logs"] =
    "## Speler %s heeft %sx %s gemaakt (ID: %s)\nWerkbanktype: `%s (%s)`\nWerkbanklocatie: `%s`\nResultaatitems: `%s`\nIngrediënten: `%s`"
}
