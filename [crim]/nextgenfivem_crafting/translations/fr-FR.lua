Translation = {
    ['error_occurred'] = 'Une erreur est survenue. (%s)',
    ['not_allowed'] = 'Vous n\'êtes pas autorisé à utiliser cet éditeur.',
    ['afk_timeout'] = 'Vous avez été expulsé pour inactivité.',

    ['errors'] = {
        ['couldnt_get_inventory'] = 'Impossible de récupérer l\'inventaire.',
        ['no_player_id'] = 'ID de joueur manquant.',
        ['invalid_quantity'] = 'Quantité invalide.',
        ['couldnt_get_recipe'] = 'Impossible de récupérer la recette.',
        ['not_enough_level'] = 'Votre niveau est insuffisant pour fabriquer ceci.',
        ['not_enough_category_level'] = 'Votre niveau de catégorie est insuffisant pour fabriquer ceci.',
        ['missing_ingredients'] = 'Vous n\'avez pas assez d\'ingrédients pour fabriquer ceci.',
        ['missing_blueprint'] = 'Il vous manque un plan pour fabriquer ceci.',
        ['no_session'] = 'Aucune session trouvée.',
        ['invalid_session_data'] = 'Données de session invalides.',
        ['not_finished'] = 'La fabrication n\'est pas encore terminée.',
        ['invalid_data'] = 'Données invalides.',
        ['not_enough_space'] = 'Vous n\'avez pas assez d\'espace pour faire cela.',
        ['queue_limit_reached'] = 'Vous avez atteint le nombre maximum de fabrications en file d\'attente.',
        ['max_craft_amount_exceeded'] = 'Vous ne pouvez pas fabriquer plus de %s objets à la fois.'
    },

    ['crafting'] = {
        ['title_small'] = 'Établi',
        ['title_big'] = 'Fabrication',
        ['recipes'] = 'Recettes',
        ['level'] = 'Niveau',
        ['level_short'] = 'Niveau',
        ['use'] = 'Utiliser',
        ['pickup'] = 'Ramasser',
        ['no_access'] = 'Vous n\'avez pas accès à ceci.',
        ['not_using'] = 'Vous n\'êtes pas en train d\'utiliser ceci.',
        ['already_using'] = 'Vous utilisez déjà ceci.',
        ['already_in_use'] = 'Quelqu\'un d\'autre utilise ceci en ce moment.',
        ['craft'] = 'Fabriquer',
        ['crafting'] = 'Fabrication en cours...',
        ['crafting_queue'] = 'File d\'attente de fabrication',
        ['exit'] = 'Quitter',
        ['missing_items'] = 'Il vous manque %s %s',
        ['item'] = 'Objet',
        ['items'] = 'Objets',
        ['cancel_craft'] = 'Annuler la fabrication',
        ['requirements'] = 'Exigences',
        ['ingredients'] = 'Ingrédients',
        ['blueprints'] = 'Plans',
        ['result_items'] = 'Objets résultants',
        ['error_fetching_recipes'] = 'Une erreur est survenue lors de la récupération des recettes.',
        ['no_recipes'] = 'Aucune recette trouvée.',
        ['bench_placed'] = 'Établi placé.',
        ['not_near_bench'] = 'Vous n\'êtes pas près de l\'établi.',
        ['no_blueprints_needed'] = 'Aucun plan requis.',
        ['cooldown_crafts_remaining'] = '%s fabrications restantes',
        ['cooldown_available_in'] = 'Disponible dans %s',
        ['cooldown_on_cooldown'] = 'En cooldown',
        ['cooldown_window'] = 'Fenêtre: %s',
        -- v1.2.1: Failure Chance
        ['craft_failed'] = 'Échoué !',
        ['craft_partial'] = '%s/%s Réussi(s)',
        -- v1.2.1: View Locked Recipes
        ['recipe_locked'] = 'Verrouillé',
        ['recipe_locked_level'] = 'Atteignez le niveau requis pour débloquer cette recette.',
        ['recipe_locked_blueprint'] = 'Un plan est requis pour débloquer cette recette.',

        ['stored_queue'] = {
            ['title'] = 'File d\'attente sauvegardée',
            ['description'] = 'Vous avez une file d\'attente sauvegardée. Voulez-vous l\'utiliser ?',
            ['use_queue'] = 'Utiliser la file',
        }
    },

    ['item-descriptions'] = {
        ['portable_bench'] = 'Un établi portable de type (%s). Utilisez pour placer l\'établi.',
        ['blueprint'] = 'Un plan de fabrication pour %s.'
    },

    ['item-labels'] = {
        ['portable_bench'] = 'Établi (%s)',
        ['blueprint'] = 'Plan (%s)'
    },

    ['editor'] = {
        ['title'] = 'Éditeur de Fabrication',
        ['description'] =
        'Utilisez cet éditeur pour placer l\'établi. Assurez-vous qu\'il est entièrement visible et qu\'il y a suffisamment d\'espace pour interagir avec.',
        -- v1.4.0: Walk Placement
        ['hint'] = {
            ['title'] = 'Il ne se passe rien ?',
            ['description'] =
            'Sans curseur de souris, le gizmo est inutilisable. Passez au placement à pied — il ne nécessite que le clavier.',
            ['action'] = 'Passer au placement à pied'
        },
        ['ghost'] = {
            ['title'] = 'Placement à pied',
            ['description'] =
            'Marchez jusqu\'à l\'endroit où vous voulez l\'établi et placez-le. Utilisez les touches ci-dessous pour l\'ajuster, aucune souris n\'est nécessaire.'
        },
        ['controls'] = {
            ['gizmoSelect'] = 'Sélectionner',
            ['gizmoTranslation'] = 'Mode Déplacement',
            ['gizmoRotation'] = 'Mode Rotation',
            ['gizmoLocal'] = 'Relatif/Monde',
            ['gizmoSnapToGround'] = 'Aligner au sol',
            ['gizmoClose'] = 'Placer',
            ['gizmoCancel'] = 'Annuler',
            -- v1.4.0: Walk Placement
            ['gizmoSwitchMode'] = 'Placement à pied',
            ['moveCamera'] = 'Déplacer la caméra',
            ['movePlayer'] = 'Se déplacer',
            ['rotateWheel'] = 'Pivoter',
            ['ghostRotateLeft'] = 'Pivoter à gauche',
            ['ghostRotateRight'] = 'Pivoter à droite',
            ['ghostMoveAway'] = 'Éloigner',
            ['ghostMoveCloser'] = 'Rapprocher',
            ['ghostMoveUp'] = 'Monter',
            ['ghostMoveDown'] = 'Descendre',
            ['ghostToggleSnap'] = 'Alignement au sol',
            ['ghostConfirm'] = 'Placer',
            ['ghostCancel'] = 'Annuler',
            ['ghostSwitchMode'] = 'Placement gizmo'
        },

        ['app'] = {
            ['title'] = 'Éditeur d\'artisanat',
            ['search'] = 'Rechercher',
            ['refresh'] = 'Rafraîchir',
            -- v1.2.1: Version & Changelog System
            ['version'] = {
                ['outdated'] = 'Mise à jour disponible',
                ['uptodate'] = 'À jour',
                ['behind'] = '%s mises à jour en retard',
                ['changelogs'] = 'Notes de version',
                ['no_changelogs'] = 'Aucune note de version disponible.',
                ['new'] = 'Nouveau',
                ['current'] = 'Actuel',
                ['hotfixes'] = 'Correctifs',
                ['hotfix_available'] = 'Correctif disponible',
                ['hotfix_desc'] =
                'Lisez les notes de version pour déterminer si ce correctif s\'applique à votre serveur.',
            },
            ['columns'] = {
                ['id'] = 'ID',
                ['name'] = 'Nom',
                ['created_at'] = 'Créé le',
                ['locations'] = 'Emplacements',
                ['bench_type'] = 'Type d\'établi',
                ['created_by'] = 'Créé par',
                ['is_portable'] = 'Est portable',
                ['coordinates'] = 'Coordonnées',
            },
            ['rows_per_page'] = 'Lignes par page',
            ['page_of'] = 'Page %s sur %s',
            ['selected'] = '%s sélectionné(s)',
            ['edit'] = 'Modifier',
            ['delete'] = 'Supprimer',
            ['reset'] = 'Réinitialiser',
            ['no_results'] = 'Aucun résultat...',
            ['clear_filters'] = 'Effacer les filtres',

            ['benches'] = {
                ['label'] = 'Établis',
                ['description'] =
                'Afficher et gérer tous les établis disponibles. Vous pouvez en créer, modifier et supprimer.',
                ['types'] = {
                    ['label'] = 'Types',
                    ['create_button'] = 'Nouveau type d\'établi',
                    ['no_locations'] = 'Aucun emplacement',
                    ['locations'] = '%s emplacement(s)',
                    ['add_location'] = 'Ajouter un emplacement',
                    ['view_locations'] = 'Voir les emplacements',
                    ['actions'] = {
                        ['view_locations'] = 'Voir les emplacements',
                        ['add_location'] = 'Ajouter un emplacement',
                        ['give_portable_item'] = 'Donner un objet portable au joueur',
                    },
                    ['map'] = {
                        ['title'] = 'Emplacements pour le type d\'établi "%s"',
                        ['error'] = 'Erreur lors de la récupération des emplacements',
                        ['no_locations'] = 'Aucun emplacement trouvé...',
                        ['coordinates'] = 'Coordonnées',
                        ['actions'] = {
                            ['teleport_to'] = 'Se téléporter à l\'emplacement',
                            ['edit'] = 'Modifier',
                            ['remove'] = 'Supprimer',
                        }
                    }
                },
                ['locations'] = {
                    ['label'] = 'Emplacements',
                    ['create_button'] = 'Nouvel emplacement d\'établi',
                    ['actions'] = {
                        ['teleport_to'] = 'Se téléporter à l\'emplacement',
                        ['copy_id'] = 'Copier l\'ID',
                        ['copy_bench_type_id'] = 'Copier l\'ID du type d\'établi',
                    }
                }
            },

            ['recipes'] = {
                ['label'] = 'Recettes',
                ['description'] =
                'Afficher et gérer toutes les recettes disponibles. Vous pouvez en créer, modifier et supprimer. Ouvrez une catégorie pour voir les recettes qu\'elle contient et cliquez sur une recette pour voir ses détails.',
                ['no_categories_found'] = 'Aucune catégorie trouvée.',
                ['create_a_category'] = 'Créer une catégorie !',
                ['category_title'] = 'Catégorie : %s',
                ['create_button'] = 'Créer une catégorie',
                ['edit_button'] = 'Modifier la catégorie',
                ['delete_button'] = 'Supprimer la catégorie',
                ['no_recipes_found'] = 'Aucune recette trouvée...',
                ['recipes_error'] = 'Échec du chargement des recettes.',
                ['create_recipe'] = 'Créer une recette',
                ['crafting_time_desc'] = 'Le temps nécessaire pour fabriquer cet objet.',
                ['xp'] = '%s XP',
                ['xp_reward_desc'] = 'La récompense en XP pour la fabrication de cet objet.',
                ['prop_model_desc'] = 'Le modèle de prop à afficher lors de la fabrication de cet objet.',
                ['results'] = 'Résultats',
                ['results_desc'] = 'Voici les résultats de la fabrication de cet objet.',
                ['level'] = 'Niveau',
                ['level_desc'] = 'Le niveau requis pour fabriquer cet objet.',
                ['category_level'] = 'Niveau de catégorie',
                ['category_level_desc'] = 'Le niveau de la catégorie requis pour fabriquer cet objet.',
                ['ingredients'] = 'Ingrédients',
                ['ingredients_desc'] = 'Voici les ingrédients nécessaires pour fabriquer cet objet.',
                ['blueprints'] = 'Plans',
                ['blueprints_desc'] = 'Voici les plans nécessaires pour fabriquer cet objet.',
            },

            ['blueprints'] = {
                ['label'] = 'Plans',
                ['description'] =
                'Afficher et gérer tous les plans. Vous pouvez créer, modifier et supprimer des plans depuis cette page. Les plans sont utilisés pour définir des recettes d\'artisanat.',
                ['search'] = 'Rechercher des plans...',
                ['error'] = 'Une erreur s\'est produite lors de la récupération des plans.',
                ['create_button'] = 'Créer un plan',
            },

            ['forms'] = {
                ['name'] = 'Nom',
                ['create'] = 'Créer',
                ['update'] = 'Mettre à jour',
                ['save'] = 'Enregistrer',
                ['delete'] = 'Supprimer',
                ['cancel'] = 'Annuler',
                ['edit'] = 'Modifier',

                ['bench_type'] = {
                    ['new_title'] = 'Nouveau type d\'établi',
                    ['edit_title'] = 'Modifier le type d\'établi : %s',
                    ['delete_title'] = 'Supprimer le type d\'établi : %s',
                    ['delete_description'] =
                    'Êtes-vous sûr de vouloir supprimer le type d\'établi %s ? Cette action est irréversible. Tous les emplacements d\'établi utilisant ce type seront supprimés.',
                    ['name'] = 'Nom',
                    ['model'] = 'Modèle',
                    ['choose_a_model'] = 'Choisir un modèle',
                    ['none_model'] = 'Aucun (personnalisé)',
                    ['none_model_desc'] = 'Aucun modèle. Utilisé pour utiliser l\'établi sur des modèles déjà existants.',
                    ['no_model'] = 'Aucun modèle',
                    ['no_models'] = 'Aucun modèle trouvé',
                    ['change'] = 'Modifier',
                    ['fullaccess'] = 'Accès complet',
                    ['fullaccess_description'] = 'Autoriser ce type d\'établi à accéder à toutes les catégories ?',
                    ['categories'] = 'Catégories',
                    ['categories_description'] = 'Voici les catégories auxquelles ce type d\'établi a accès.',
                    ['manage_recipe_restrictions'] = 'Gérer les restrictions de recette',
                    ['recipe_restrictions'] = {
                        ['title'] = 'Catégorie %s - Restrictions de recette',
                        ['description'] =
                        'Définissez des restrictions pour cette catégorie. Autorisez ou interdisez la fabrication de certaines recettes.',
                        ['set_denied_as_default'] = 'Définir comme refusé par défaut',
                        ['set_denied_as_default_desc'] =
                        'Remarque : Cela refusera toutes les recettes par défaut. Par exemple, si vous ne voulez autoriser que quelques recettes, vous pouvez activer cette option. Cela réinitialisera également toutes les restrictions de recette actuelles.',
                        ['no_recipes'] = 'Aucune recette... Ajoutez-en avant de définir des restrictions.',
                        ['recipe_error'] = 'Échec du chargement des recettes...',
                        ['denied_recipes'] = 'Recettes refusées',
                        ['allowed_recipes'] = 'Recettes autorisées',
                    },
                    ['access'] = 'Accès',
                    ['access_description'] = 'L\'identifiant d\'accès pour ce type d\'établi.',
                    ['selected'] = '%s sélectionné(s)',
                    ['none'] = 'Aucun',
                    ['no_categories'] =
                    'Aucune catégorie trouvée. Créez une catégorie avant d\'ajouter un type d\'établi.',
                    ['categories_error'] = 'Une erreur est survenue lors de la récupération des catégories.',
                    ['change_rank_options'] = 'Modifier les options de rang',
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
                    ['new_title'] = 'Nouvel emplacement d\'établi',
                    ['edit_title'] = 'Modifier l\'emplacement de l\'établi',
                    ['delete_title'] = 'Supprimer l\'emplacement de l\'établi : %s',
                    ['delete_description'] =
                    'Êtes-vous sûr de vouloir supprimer l\'emplacement de l\'établi pour le type d\'établi %s ? Cette action est irréversible.',
                    ['add_location_for_bench_type'] = 'Ajouter un emplacement pour le type d\'établi "%s"',
                    ['bench_type'] = 'Type d\'établi',
                    ['bench_type_description'] = 'Type de l\'établi.',
                    ['location'] = 'Emplacement',
                    ['location_description'] = 'Emplacement de l\'établi. Utilisez le bouton pour le placer.',
                    ['location_description_2'] =
                    'Assurez-vous que l\'ensemble de l\'établi est visible et qu\'il y a suffisamment d\'espace pour que le joueur puisse interagir avec.',
                    ['is_portable'] = 'Est portable',
                    ['is_portable_description'] = 'L\'établi est-il portable ? (Peut être déplacé par les joueurs)',
                    -- v1.2.1: Shared Mode Overrides
                    ['shared_levels_override'] = 'Override Shared Levels',
                    ['shared_levels_override_description'] =
                    'Override the bench type shared levels setting for this location. Leave unchecked to inherit from bench type.',
                    ['shared_queue_override'] = 'Override Shared Queue',
                    ['shared_queue_override_description'] =
                    'Override the bench type shared queue setting for this location. Leave unchecked to inherit from bench type.',
                    ['place_out'] = 'Placer',
                    ['select_bench_type_first'] = 'Veuillez d’abord sélectionner un type de banc.',
                    ['select_bench_type'] = 'Sélectionner le type de banc',
                    ['search_bench_types'] = 'Rechercher des types de banc...',
                    ['no_bench_types'] = 'Aucun type de banc trouvé.',
                    ['loading_bench_types'] = 'Chargement des types de banc...',
                    ['bench_types_error'] = 'Erreur lors du chargement des types de banc.',
                },

                ['give_portable_item'] = {
                    ['title'] = 'Donner un objet portable au joueur',
                    ['player_id'] = 'ID du joueur',
                    ['give_item'] = 'Donner l\'objet'
                },

                ['category'] = {
                    ['new_title'] = 'Nouvelle catégorie',
                    ['edit_title'] = 'Modifier la catégorie : %s',
                    ['delete_title'] = 'Supprimer la catégorie : %s',
                    ['delete_description'] =
                    'Êtes-vous sûr de vouloir supprimer la catégorie %s ? Cette action est irréversible.',
                    ['delete_warning'] =
                    'Avertissement : Cela supprimera également toutes les recettes de cette catégorie et ne peut pas être annulé.',
                    ['title'] = 'Titre',
                    ['description'] = 'Description',
                    ['use_image_url'] = 'Utiliser une URL d\'image',
                    ['use_image_url_desc'] = 'Utiliser une URL d\'image au lieu d\'une icône',
                    ['icon'] = 'Icône',
                    ['icon_desc'] = 'Trouvez une icône sur https://fonts.google.com/icons',
                    ['image'] = 'URL de l\'image',
                },

                ['recipe'] = {
                    ['new_title'] = 'Nouvelle recette',
                    ['edit_title'] = 'Modifier la recette : %s',
                    ['delete_title'] = 'Supprimer la recette : %s',
                    ['delete_description'] =
                    'Êtes-vous sûr de vouloir supprimer la recette %s ? Cette action est irréversible.',
                    ['title'] = 'Titre',
                    ['description'] = 'Description',
                    ['required_level'] = 'Niveau requis',
                    ['required_level_desc'] =
                    'Niveau global requis pour fabriquer cette recette. Laissez vide pour aucune exigence.',
                    ['required_category_level'] = 'Niveau de catégorie requis',
                    ['required_category_level_desc'] =
                    'Niveau de catégorie requis pour fabriquer cette recette. Laissez vide pour aucune exigence.',
                    ['crafting_time'] = 'Temps de fabrication (en secondes)',
                    ['crafting_time_desc'] = 'Temps nécessaire pour fabriquer cette recette (en secondes).',
                    ['xp_reward'] = 'Récompense en XP',
                    ['xp_reward_desc'] = 'Quantité d\'XP attribuée pour fabriquer cette recette. (par défaut 25)',
                    ['prop_model'] = 'Modèle de prop',
                    ['prop_model_desc'] =
                    'Modèle de prop à afficher lors de la fabrication de cette recette. Laissez vide pour aucun prop. (ex. prop_tool_hammer)',
                    ['prop_rot'] = 'Rotation du prop',
                    ['prop_rot_desc'] = 'Rotation du modèle de prop.',
                    ['prop_offset'] = 'Décalage du prop',
                    ['prop_offset_desc'] =
                    'Décalage du modèle de prop. Ajustez pour centrer le prop. X : avant/arrière, Y : gauche/droite, Z : haut/bas',
                    ['blueprints'] = 'Plans',
                    ['blueprints_desc'] = 'Plans requis pour fabriquer cette recette.',
                    ['ingredients'] = 'Ingrédients',
                    ['ingredients_desc'] = 'Ingrédients requis pour fabriquer cette recette. Minimum 1 requis.',
                    ['results'] = 'Résultats',
                    ['results_desc'] = 'Résultats de la fabrication de cette recette. Minimum 1 requis.',
                    ['cooldown_limit'] = 'Limite de cooldown',
                    ['cooldown_limit_desc'] = 'Max total fabriqué dans la fenêtre. Mettez 0/vide pour désactiver.',
                    ['cooldown_window'] = 'Fenêtre de cooldown',
                    ['cooldown_window_desc'] = 'Longueur de la fenêtre de cooldown (jours, heures, minutes, secondes).',
                    -- v1.2.1: Failure Chance
                    ['failure_chance'] = 'Chance d\'échec (%)',
                    ['failure_chance_desc'] =
                    'Chance que la fabrication échoue (0-100). Les ingrédients sont consommés en cas d\'échec.',
                    ['failure_mode'] = 'Mode d\'échec',
                    ['failure_mode_desc'] =
                    'batch = un tirage pour toute la fabrication, individual = chaque objet est tiré séparément.',

                    ['add'] = 'Ajouter'
                },

                ['blueprint'] = {
                    ['new_title'] = 'Nouveau plan',
                    ['edit_title'] = 'Modifier le plan : %s',
                    ['delete_title'] = 'Supprimer le plan : %s',
                    ['delete_description'] =
                    'Êtes-vous sûr de vouloir supprimer le plan %s ? Cette action est irréversible.',
                    ['label'] = 'Étiquette',
                    ['description'] = 'Description',
                    ['uses'] = 'Utilisations',
                    ['uses_description'] =
                    'Utilisé uniquement avec `enableBlueprintItems`, `removeBlueprintOnCraft` et `blueprintDurability` activés.'
                },

                ['select_blueprint'] = {
                    ['label'] = 'Plan',
                    ['select_blueprint'] = 'Sélectionner un plan',
                    ['search_blueprints'] = 'Rechercher des plans...',
                    ['loading'] = 'Chargement des plans...',
                    ['error'] = 'Erreur lors du chargement des plans.',
                    ['duplicate'] = 'Plan déjà ajouté. Veuillez sélectionner un plan différent.',
                    ['no_found'] = 'Aucun plan trouvé.'
                },

                ['select_item'] = {
                    ['label'] = 'Objet',
                    ['count'] = 'Quantité',
                    ['select_item'] = 'Sélectionner un objet',
                    ['search_items'] = 'Rechercher des objets...',
                    ['loading'] = 'Chargement des objets...',
                    ['error'] = 'Erreur lors du chargement des objets.',
                    ['no_found'] = 'Aucun objet trouvé.',
                    ['set_metadata'] = 'Définir les métadonnées',
                    ['metadata_title'] = 'Métadonnées pour : %s',
                },

                ['errors'] = {
                    ['name_is_required'] = 'Le nom est requis.',
                    ['name_too_short'] = 'Le nom doit contenir au moins 2 caractères.',
                    ['category_is_required'] = 'Au moins une catégorie est requise.',
                    ['item_is_required'] = 'L\'objet est requis',
                    ['min_one_item'] = 'Vous devez ajouter au moins un objet.',
                }
            }
        }
    },

    ['command'] = {
        ['error'] = 'Erreur',
        ['not_allowed'] = 'Vous n\'êtes pas autorisé à utiliser cette commande.',
        ['no_subcommand'] = 'Sous-commande invalide. Tapez /crafting help pour une liste des commandes.',
        ['no_player'] = 'Aucun joueur trouvé avec cet ID.',
        ['no_blueprint_found'] = 'Aucun plan trouvé avec ce nom ou ID.',
        ['already_has_blueprint'] = 'Le joueur possède déjà ce plan.',
        ['gave_blueprint'] = 'Plan %s donné au joueur %s.',
        ['removed_blueprint'] = 'Plan %s retiré du joueur %s.',
        ['set_level'] = 'Niveau %s défini pour le joueur %s.',
        ['set_category_level'] = 'Niveau de catégorie %s défini pour le joueur %s.',
        ['no_category_found'] = 'Aucune catégorie trouvée avec ce nom ou ID.',
        ['category_level'] = 'Niveau de catégorie',
        ['player_level'] = 'Niveaux pour %s (%s)',
        ['invalid_level'] = 'Niveau invalide.',
        ['gave_portable_item'] = 'Objet portable de type établi (%s) donné au joueur %s.',
        ['missing_arguments'] = 'Arguments manquants. Tapez /crafting help pour les détails de commande.',
        ['help'] = {
            ['title'] = 'Commandes de Fabrication',
            ['description'] = 'Liste des commandes disponibles',
            ['subcommands'] = {
                ['help'] = 'Afficher le menu d\'aide',
                ['blueprints'] = 'Voir vos plans',
                ['level'] = 'Voir votre niveau',
                ['editor'] = 'Ouvrir l\'éditeur',
                ['getblueprints'] = 'Voir les plans d\'un joueur',
                ['giveblueprint'] = 'Donner un plan à un joueur',
                ['removeblueprint'] = 'Retirer un plan d\'un joueur',
                ['getlevel'] = 'Voir le niveau d\'un joueur',
                ['setlevel'] = 'Définir le niveau d\'un joueur',
                ['setcategorylevel'] = 'Définir le niveau de catégorie d\'un joueur',
                ['editbench'] = 'Modifier l\'établi le plus proche',
                ['removebench'] = 'Retirer l\'établi le plus proche',
                ['giveportableitem'] = 'Donner un établi portable à un joueur'
            },
            ["params"] = {
                ["id"] = "ID du joueur",
                ["blueprint"] = "ID du plan",
                ["level"] = "Niveau",
                ["category"] = "Catégorie",
                ["bench"] = "ID/Nom de l\'établi"
            }
        }
    },

    ["discord_logs"] =
    "## Joueur %s a fabriqué %sx %s (ID : %s)\nType d'établi : `%s (%s)`\nEmplacement de l'établi : `%s`\nObjets résultants : `%s`\nObjets d'ingrédients : `%s`"
}
