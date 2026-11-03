JobConfigLocales["sky_crimesystem:fr"] = {
    Nui = {
        workshopConfig = {
            creatorCommand = "Commande directe",
            roleDefaults = {
                title = "Rôles",
                description = "Choisissez le grade minimum pour chaque permission par défaut. Les permissions de grade enregistrées dans le menu du patron sont prioritaires.",
                bossHint = "Les grades de patron et de sous-chef conservent toujours tous les droits.",
                empty = "Aucun grade disponible pour ce métier pour le moment.",
                gradesTitle = "Grades du métier",
                noDefault = "Aucun droit par défaut",
                rankOption = "{grade} – {label}",
            },
            weaponDefaultsDescription = "Les valeurs communes s’appliquent aux champs hérités. Modifier une valeur sur sa page de réglages la rend personnalisée. Les entrées existantes conservent leurs valeurs.",
            weaponStreetDescription = "Lors d'un contact de vente de drogue, le serveur peut parfois acheter une arme autorisée. Le choix, le prix et le paiement restent décidés par le serveur.",
            weaponGroups = {
                general = "Valeurs générales",
                access = "Valeurs d’accès",
                collection = "Valeurs de collecte",
                production = "Valeurs de production",
                market = "Valeurs du marché",
                delivery = "Valeurs des commandes",
                street = "Vente d’armes dans la rue",
            },
            weaponOptions = {
                scrap_search = "Fouiller le tas de ferraille",
                player = "Par joueur",
                global = "Monde entier",
                money = "Espèces",
                bank = "Compte bancaire",
                black_money = "Argent sale",
                timing = "Arrêtez l'indicateur dans la zone optimale.",
                precision = "Chaque coupe doit être effectuée dans la fenêtre de précision.",
                pressure = "Arrêtez la presse à sa pression optimale.",
            },

            reputation = {
                remove = "Supprimer",
                title = "Réputation",
                action = "Décision",
                points = "Points par action terminée",
                enabled = "Active",
                search = "Rechercher des actions",
                added = "Déjà ajoutée",
                noResults = "Aucune action correspondante trouvée.",
                empty = "Aucune action pour le moment. Utilisez le bouton plus pour en ajouter une.",
                name = "Nom de la règle",
                target = "Cible (facultative)",
            },
            configs = {
                sky_crimesystem = {
                    entries = "Factions",
                    subtitle = "Configurez les métiers du crime et leurs lieux communs.",
                    title = "Système de crime",
                },
            },
            creatorSections = {
                mainbaseZones = {
                    entryLabel = "Base principale",
                    entryPluralLabel = "Bases principales",
                    label = "Zone de base principale",
                },
                presetTerritories = {
                    label = "Districts prédéfinis",
                    entryLabel = "District prédéfini",
                    entryPluralLabel = "Districts prédéfinis",
                },
                customTerritories = {
                    label = "Territoires personnalisés",
                    entryLabel = "Territoire personnalisé",
                    entryPluralLabel = "Territoires personnalisés",
                },
                objectsSection = {
                    label = "Objets d'interrogatoire",
                    entryLabel = "Objet",
                    entryPluralLabel = "Objets d'interrogatoire",
                },
                blockedZonesSection = {
                    label = "Zones d'exclusion",
                    entryLabel = "Zone",
                    entryPluralLabel = "Zones d'exclusion",
                },
                toolsSection = {
                    label = "Outils",
                    entryLabel = "Outil",
                    entryPluralLabel = "Outils",
                },
                sessionsSection = {
                    label = "Sessions en cours",
                    entryLabel = "Séance",
                    entryPluralLabel = "Sessions en cours",
                },
                orphansSection = {
                    label = "Objets orphelins",
                    entryLabel = "Objet",
                    entryPluralLabel = "Objets orphelins",
                },
            },
            darknetActions = {
                currentLocation = "Utiliser l'emplacement actuel",
            },
            drugSettings = {
                drugGrowthCurve = {
                    description = "Des valeurs plus élevées ralentissent considérablement la croissance en cas de mauvais entretien, tout en préservant de puissants bonus pour un bon entretien.",
                    label = "Courbe de réponse aux soins",
                },
                drugGrowthMaxMultiplier = {
                    description = "Multiplicateur de croissance maximal atteint dans des conditions excellentes.",
                    label = "Multiplicateur de soins parfaits",
                },
                drugGrowthMinMultiplier = {
                    description = "Multiplicateur de croissance utilisé lorsque les conditions de la plante sont critiques.",
                    label = "Multiplicateur de soins critiques",
                },
                drugGrowthQualityBonusMax = {
                    description = "Bonus de croissance supplémentaire maximal accordé par la qualité de la plante.",
                    label = "Bonus de croissance qualité",
                },
            },
            errors = {
                invalid_role_permission_defaults = "Choisissez des grades minimums valides pour les permissions des rôles.",
                base_raid_locked = "La base est en train de subir un raid. Ses lieux de stockage et sa configuration sont verrouillés.",
                base_storage_outside_zone = "Tous les points de stockage, de casier et de stockage de heist doivent se trouver à l'intérieur de la zone de la base.",
                base_zone_invalid_polygon = "Placez au moins trois points distincts sans croiser les bords, puis vérifiez la hauteur (3–200 m) et le bucket de routage.",
                base_zone_point_limit = "Une zone de mainbase supporte au maximum 64 points de délimitation.",
                base_zone_required = "Configurez d'abord une zone de mainbase valide pour ce job de criminel.",
                crime_interrogation_invalid_model = "Saisissez un modèle d'objet valide.",
                crime_interrogation_invalid_coords = "Placez l'objet à une position valide.",
                crime_interrogation_invalid_zone_points = "Placez au moins trois points de délimitation valides.",
                crime_interrogation_duplicate_id = "Un objet avec cet ID existe déjà.",
                crime_interrogation_tool_invalid = "Vérifiez la définition de l'outil.",
                crime_interrogation_tool_id_invalid = "Saisissez un ID d'outil valide.",
                crime_interrogation_tool_label_missing = "Saisissez un nom pour l'outil.",
                crime_interrogation_effect_missing = "Configurez un effet pour l'outil.",
                crime_interrogation_effect_type_unknown = "Sélectionnez un type d'effet pris en charge.",
                crime_interrogation_effect_status_missing = "Indiquez l'état affecté par cet outil.",
                crime_interrogation_minigame_missing = "Configurez un mini-jeu pour l'outil.",
                crime_interrogation_minigame_type_unknown = "Sélectionnez un type de mini-jeu pris en charge.",
                crime_interrogation_keys_missing = "Configurez les commandes de l'outil.",
                crime_interrogation_keys_invalid = "Vérifiez les commandes configurées de l'outil.",
                crime_interrogation_keys_duplicate = "N'attribuez chaque action et commande de l'outil qu'une seule fois.",
                crime_interrogation_anim_invalid = "Vérifiez le dictionnaire et le clip d'animation de l'outil.",
                crime_interrogation_anim_missing = "Configurez une animation pour l'utilisateur de l'outil.",
                crime_interrogation_occupied = "Quelqu'un est déjà attaché à cet objet.",
                crime_interrogation_not_found = "Cela n'existe plus.",
            },
            extensions = {
                baseZone = {
                    description = "Placez les points de limite 3 à 64 dans l'ordre. Le point le plus bas définit le bas ; la hauteur s'étend vers le haut à partir de là. Les points sont sauvegardés en tant que brouillon ; utilisez Sauvegarder pour appliquer la zone. Seuls les stocks, les casiers et le stockage de braquage à l'intérieur de la zone sont accessibles pendant les raids. Les points à l'extérieur n'empêchent ni la sauvegarde ni le début d'un raid. Les limites existantes restent actives jusqu'à ce que vous sauvegardiez.",
                    fields = {
                        bucket = "Seau d'acheminement",
                        configured = "Configuré",
                        height = "Hauteur (mètres)",
                        radius = "Rayon (mètres)",
                        x = "Centre X",
                        y = "Centre Y",
                        z = "Centre Z",
                    },
                    label = "Zone de base principale",
                },
                invalidSelection = "Sélection invalide : {value}",
            },
            locationDescriptions = {
                crimeStationPosition = "Point principal de cet emplacement de job. Si le blip sur la carte est activé sous Job → Blips, il apparaîtra ici.",
            },
            locationTypes = {
                crimeStationPosition = "Lieu / Blip sur la carte",
                heistCrafting = "Atelier de braquage",
                heistStorage = "Dépôt de braquage",
            },
            membershipMigration = {
                cancel = "Annuler",
                confirm = "Migrer et sauvegarder",
                message = "Les adhésions actuelles aux organisations seront migrées vers le modèle sélectionné. L'emploi normal reste distinct en mode indépendant.",
                title = "Changer le modèle d'adhésion ?",
            },
            moneywashActions = {
                currentLocation = "Utiliser la position actuelle",
                invalidLocations = "Vérifiez les ID, les noms, les sélections d'intérieurs et les coordonnées. Chaque lieu nécessite un ID unique.",
                position = "Poste",
            },
            moneywashBusiness = {
                moneywashBuildNodes = { label = "Emplacements", description = "Placez les équipements compatibles sur ces points. Coordonnées relatives à l’intérieur choisi." },
                mwBuildNodes = "Emplacements",
                moneywashPublicEquipment = { label = "Équipement public", description = "Affectez lave-linge, générateurs et ventilateurs aux sites publics et points compatibles." },
                mwPublicEquipment = "Équipement public",
                moneywashMaterials = { label = "Matériaux", description = "Utilisez les noms exacts de l’inventaire. Poids en grammes ; installez les objets manquants." },
                mwMaterials = "Matériaux",
                moneywashMaterialRecipes = { label = "Recettes de matériaux", description = "Entrées, sorties et durée par unité. Les transformateurs utilisent ces recettes." },
                mwMaterialRecipes = "Recettes de matériaux",
                moneywashProductionRecipes = { label = "Recettes d’impression", description = "Papier, encre et durées par unité. Espèces après séchage et contrôle qualité." },
                mwProductionRecipes = "Recettes d’impression",
                moneywashCollectors = { label = "Collecteurs", description = "Configurez rendement, outils, délai et position de chaque collecteur." },
                mwCollectors = "Collecteurs",
                moneywashProcessors = { label = "Transformateurs", description = "Choisissez recette de matériaux et position de chaque transformateur." },
                mwProcessors = "Transformateurs",

                control = "Panneau de contrôle",
                editor = {
                    addBusiness = "Ajouter une entreprise",
                    addInterior = "Ajouter un intérieur",
                    advanced = "Détails techniques",
                    asset_ipl = "IPL : Entrez le nom exact de l'IPL et la position de l'intérieur.",
                    asset_mlo = "MLO : Utilise la position d'un intérieur déjà installé. L'accès utilise actuellement l'entrée de l'entreprise.",
                    asset_shell = "Shell : sa ressource de modèle doit être installée et active sur le serveur.",
                    businessHelp = "Nommez l'entreprise, choisissez son intérieur et fixez le prix d'achat.",
                    businessListHelp = "Gérez les entrées et les prix d'achat de vos entreprises.",
                    businesses = "Entreprises",
                    capture = "Définir en jeu",
                    captureOrigin = "Définir la position de l'intérieur",
                    chooseInterior = "Choisir un intérieur",
                    coordinates = "Modifier les coordonnées",
                    editSections = "Configuration",
                    emptyBusinessHelp = "Liez une entrée de carte à un intérieur. Vos organisations pourront ensuite acheter l'entreprise vide.",
                    emptyBusinesses = "Votre première entreprise",
                    emptyInteriorHelp = "Connectez une IPL, une shell ou un MLO installé, puis définissez les points utilisés par l'entreprise.",
                    emptyInteriors = "Votre premier intérieur",
                    entranceHelp = "Définissez l'entrée où les joueurs doivent acheter et entrer dans l'entreprise.",
                    freecamHelp = "Freecam : WASD pour se déplacer, Q/E haut/bas, Shift plus vite, Ctrl plus lent. Clic droit : regarder. Glisser le gizmo, R pivoter/déplacer, Enter placer, Backspace annuler.",
                    general = "Général",
                    heading = "Cap",
                    interiorHelp = "Choisissez le type d'intérieur et son asset.",
                    interiorListHelp = "Préparez des espaces vides. Les joueurs placeront leurs propres machines et équipements.",
                    interiors = "Intérieurs",
                    listEmpty = "Aucune entrée.",
                    locationTypes = "Gestion des emplacements",
                    newBusiness = "Nouvelle entreprise",
                    newInterior = "Nouvel intérieur",
                    noResults = "Aucune entrée correspondante.",
                    notSet = "Non défini",
                    offsetHelp = "Les valeurs saisies sont des décalages par rapport à l'origine. La position mondiale est affichée ci-dessus.",
                    origin = "Origine",
                    originHelp = "Position de l'intérieur. Tous les autres points sont relatifs à celle-ci.",
                    originRequired = "Définissez d'abord la position de l'intérieur sous Général.",
                    outsideRange = "En dehors de la zone de {range} mètres",
                    point_control = "Déplacez et pivotez le panneau mural avec le gizmo pour le mettre en place. La hauteur confirmée de l'objet est conservée exactement. Basculez son marqueur sous Interactions → Money Wash: control panel.",
                    point_entry = "Les joueurs arrivent et partent d'ici. En partant, ils retournent automatiquement à l'entrée de leur entreprise à l'extérieur.",
                    point_position = "Ce point est situé à l'extérieur de l'entreprise.",
                    point_storage = "Déplacez et pivotez l'étagère avec le gizmo jusqu'à ce qu'elle repose sur le sol. Les membres accèdent ici à l'équipement acheté. Basculez son marqueur sous Interactions → Money Wash: storage.",
                    points = "Paragraphes",
                    pointsHelp = "Sélectionnez un point et définissez-le directement en jeu.",
                    rangeNote = "Un rayon de {range} mètres s'applique autour de l'origine de l'intérieur, sans restriction de hauteur.",
                    remove = "Supprimer",
                    repairRange = "Déplacez ces points plus près de l'origine de l'intérieur.",
                    saveHint = "Appliquez les modifications en cliquant sur Enregistrer en haut.",
                    search = "Rechercher …",
                    set = "Définir",
                    teleport = "Téléportation",
                    viewInteriors = "Voir les intérieurs",
                    visit = "Visiter",
                    visitHint = "Déplacez-vous librement. Appuyez sur Backspace pour retourner à l'éditeur.",
                    visitTitle = "Visite de l'intérieur",
                },
                entry = "Entrée et sortie",
                fields = {
                    mode = "Mode d’accès",
                    ownerKind = "Type de propriétaire",
                    productionEnabled = "Extension d’impression disponible",
                    feePercent = "Frais (%) / -1 = globaux",
                    storageCapacity = "Capacité du stock (objets)",
                    maximumOrders = "Commandes simultanées par joueur",
                    gridPower = "Puissance réseau / 0 = générateur",
                    autoService = "Entretien public automatique",
                    maximumPendingOutputs = "Maximum de paiements en attente",
                    placementRange = "Rayon de placement (m)",
                    placementHeight = "Plage verticale de placement (m)",
                    interiorId = "ID de l’intérieur",
                    equipmentId = "ID de l’équipement",
                    nodeId = "ID de l’emplacement",
                    generatorNode = "ID de l’emplacement du générateur",
                    maxOffset = "Écart maximal du point (m)",
                    maxHeight = "Écart vertical maximal (m)",
                    weight = "Poids de l’objet (g)",
                    inputItem = "Matériau d’entrée",
                    secondItem = "Deuxième matériau d’entrée",
                    outputItem = "Matériau de sortie",
                    requiredTool = "Outil requis",
                    baseQuality = "Qualité initiale (%)",
                    minimumQuality = "Qualité minimale (%)",
                    inspectionCards = "Cartes de contrôle",
                    inspectionPenalty = "Perte de qualité par erreur (%)",
                    rejectPercent = "Billets rejetés (%)",
                    accessoryModel = "Modèle accessoire",
                    accessoryMaximum = "Maximum d’accessoires visibles",
                    accessoryActiveOnly = "Accessoires pendant la production uniquement",
                    animDict = "Dictionnaire d’animation",
                    animClip = "Séquence d’animation",
                    cooldown = "Délai (secondes)",
                    minimum = "Rendement minimum",
                    maximum = "Rendement maximum",
                    productionPrice = "Impression de billets · Prix d'achat",
                    recipeId = "Recette ID",
                    inputAmount = "Matériau / par unité",
                    secondAmount = "Matériau / par unité",
                    outputAmount = "Matériau / par unité",
                    paperItem = "Papier d’impression",
                    inkItem = "Encre d’impression",
                    paperAmount = "Papier d’impression / par unité",
                    inkAmount = "Encre d’impression / par unité",
                    notesPerUnit = "Billets / par unité",
                    valuePerNote = "Espèces / Billets",
                    maximumUnits = "Unités (max.)",
                    printSeconds = "Imprimer / par unité (Secondes)",
                    inspectionSeconds = "Contrôler / par unité (Secondes)",
                    rinseSeconds = "Laver / par unité (Secondes)",
                    drySeconds = "Sécher / par unité (Secondes)",
                    accessoryUnit = "Billets / par unité",
                    accessoryX = "Modèle accessoire · X (m)",
                    accessoryY = "Modèle accessoire · Y (m)",
                    accessoryZ = "Modèle accessoire · Z (m)",
                    accessoryStep = "Modèle accessoire · Z (m)",

                    capacity = "Capacité par cycle",
                    controlHeading = "Orientation du panneau de contrôle",
                    controlHeight = "Hauteur de montage au-dessus du point (m)",
                    controlModel = "Modèle de panneau mural",
                    controlX = "Panneau de contrôle X",
                    controlY = "Panneau de contrôle Y",
                    controlZ = "Panneau de contrôle Z",
                    disableSets = "Ensembles d'entités cachés (séparés par des virgules)",
                    enableSets = "Ensembles d'entités activés (séparés par des virgules)",
                    entryX = "Décalage d'entrée X",
                    entryY = "Décalage d'entrée Y",
                    entryZ = "Décalage d'entrée Z",
                    heading = "Direction de l'orientation",
                    id = "ID unique",
                    interior = "Intérieur",
                    ipl = "Nom de l'IPL",
                    kind = "Type",
                    label = "Nom",
                    model = "Nom du modèle",
                    power = "Unités de puissance",
                    price = "Prix d'achat",
                    radius = "Rayon de placement (m)",
                    repairPrice = "Prix de réparation (0 = gratuit)",
                    seconds = "Durée du cycle (secondes)",
                    storageHeading = "Orientation du point de stockage",
                    storageModel = "Modèle d'étagère",
                    storageX = "Point de stockage X",
                    storageY = "Point de stockage Y",
                    storageZ = "Point de stockage Z",
                    wear = "Usure par cycle (%)",
                    x = "Origine X",
                    y = "Origine Y",
                    z = "Origine Z",
                },
                interactions = {
                    control = "Money Wash : panneau de contrôle",
                    storage = "Money Wash : stockage",
                },
                item = "Entrée",
                moneywashBucketStart = {
                    description = "Réserve cette plage exclusivement pour le blanchiment d'argent. Les modifications s'appliquent lors de la prochaine entrée.",
                    label = "Début de la plage d'instance",
                },
                moneywashEquipment = {
                    description = "Les joueurs achètent et placent des appareils. La capacité, la durée et l'usure s'appliquent aux laveuses. La puissance dépend de l'alimentation du générateur ou de la demande de l'appareil. Les modifications s'appliquent aux nouveaux achats.",
                    label = "Équipement achetable",
                },
                moneywashInteriors = {
                    description = "Configurez les intérieurs vides (IPL, shell ou MLO). L'entrée, le panneau de contrôle, le stockage et les limites de construction sont relatifs à l'origine. Quitter renvoie les joueurs à l'entrée de leur entreprise.",
                    label = "Intérieurs (IPL, shell ou MLO)",
                },
                moneywashMaximumEquipment = {
                    description = "Nombre maximum d'appareils et de kits de réparation achetés par entreprise.",
                    label = "Limite d'équipement",
                },
                moneywashPreviewBucketStart = {
                    description = "La visite ajoute l'ID du joueur à cette valeur pour une instance admin privée. Réservez-la séparément des entreprises et autres ressources. Les modifications s'appliquent à la prochaine prévisualisation.",
                    label = "Début de la zone d'instance d'aperçu",
                },
                moneywashProperties = {
                    description = "Définissez une entrée, choisissez un intérieur et fixez le prix d'achat. Les commerces achetés conservent leur intérieur et leur aménagement sauvegardés.",
                    label = "Entrées des commerces",
                },
                moneywashRepairShops = {
                    description = "Définissez les boutiques de réparation, téléportez-vous vers elles et fixez le prix du service. Elles vendent des kits de réparation et entretiennent les machines stockées.",
                    label = "Emplacements des boutiques",
                },
                moneywashShops = {
                    description = "Placez des boutiques pour les laveuses, les générateurs et les ventilateurs. Les commandes sont envoyées à l'entreprise sélectionnée de l'organisation.",
                    label = "Emplacements des boutiques",
                },
                mwEquipment = "Magasin d'équipement",
                mwInteriors = "Intérieurs vides",
                mwProperties = "Emplacements",
                mwRepairShops = "Atelier de réparation",
                mwSettings = "Paramètres de l'entreprise",
                names = {
                    mwPublicLaundry = "Blanchisserie publique",
                    mwPaperPulp = "Pâte à papier",
                    mwPrintingPaper = "Papier d’impression",
                    mwPrintingInk = "Encre d’impression",
                    mwPaperRecipe = "Fabriquer du papier d’impression",
                    mwPrintingRecipe = "Billets standards",
                    mwPaperCollector = "Collecteur de papier",
                    mwInkCollector = "Collecteur d’encre",
                    mwPaperProcessor = "Transformateur de papier",
                    mwPrinter = "Presse à imprimer",
                    mwInspectionTable = "Table de contrôle",
                    mwDryingCabinet = "Armoire de séchage",
                    mwNode1 = "1 · Laver",
                    mwNode2 = "2 · Laver",
                    mwNode3 = "3 · Emplacements",
                    mwNode4 = "4 · Imprimer",
                    mwNode5 = "5 · Contrôler",
                    mwNode6 = "6 · Sécher",
                    mwNode7 = "7 · Emplacements",

                    mwInteriorWarehouse = "Entrepôt vide",
                },
                options = {
                    private = "Privé",
                    public = "Public",
                    faction = "Organisation",
                    person = "Personnage",
                    printer = "Presse à imprimer",
                    inspection = "Table de contrôle",
                    dryer = "Armoire de séchage",

                    fan = "Ventilateur",
                    generator = "Générateur",
                    ipl = "IPL",
                    mlo = "MLO",
                    repair = "Kit de réparation",
                    shell = "Modèle Shell",
                    washer = "Machine à laver",
                },
                origin = "Origine",
                storage = "Point de stockage",
            },
            settingFields = {
                cultivationLevel = "Niveau de culture",
                cultivationTitle = "Nom du niveau",
                cultivationRequiredXp = "XP totale requise",
                cultivationAction = "Décision",
                cultivationXp = "XP",
                cultivationCategory = "Catégorie",
                cultivationEntry = "Entrée",
                cultivationRequiredLevel = "Niveau requis",
                alias = "Alias",
                atmHeading = "Cap",
                atmId = "ID",
                atmModel = "Modèle de distributeur",
                centerX = "Centre X",
                centerY = "Centre Y",
                centerZ = "Centre Z",
                deliveryMethod = "Méthode de livraison",
                description = "Descriptif",
                enabled = "Activé",
                groupKey = "Clé de groupe",
                id = "ID",
                itemLabel = "Libellé de la marchandise",
                itemName = "Nom de l'objet d'inventaire",
                knownScammer = "Arnaqueur connu",
                locationName = "Nom du lieu",
                observerW = "Orientation de l'observateur",
                observerX = "Observateur X",
                observerY = "Observateur Y",
                observerZ = "Observateur Z",
                pedModel = "Modèle de ped NPC",
                pickpocketItemChance = "Chômage (%)",
                pickpocketItemMaximum = "Montant maximum",
                pickpocketItemMinimum = "Montant minimum",
                pickpocketItemName = "Nom de l'objet d'inventaire",
                quantity = "Quantité",
                radius = "Rayon",
                rating = "Évaluation affichée",
                ratingCount = "Nombre d'évaluations affichées",
                scamChance = "Chance d'escroquerie du marchand (%)",
                shopCategory = "Catégorie",
                shopClerkHeading = "Orientation de l'employé",
                shopClerkModel = "Modèle d'employé",
                shopClerkRequired = "Employé requis",
                shopClerkX = "Employé X",
                shopClerkY = "Employé Y",
                shopClerkZ = "Employé Z",
                shopCodeEnabled = "Autoriser l'ouverture par code",
                shopDrillEnabled = "Autoriser le perçage",
                shopEnabled = "Activé",
                shopHackEnabled = "Autoriser le piratage",
                shopLocationId = "ID du magasin",
                shopLocationLabel = "Libellé",
                shopRegisterId = "ID de la caisse",
                shopSafeEnabled = "Coffre-fort activé",
                shopSafeHeading = "Orientation du coffre",
                shopSafeX = "Coffre X",
                shopSafeY = "Coffre Y",
                shopSafeZ = "Coffre Z",
                side = "Côté du marché",
                spawns = "Apparitions d'équipe",
                successfulTrades = "Transactions réussies affichées",
                title = "Titre de l'offre",
                unitPrice = "Prix unitaire",
                verified = "Marchand vérifié",
                w = "Cap",
                x = "X",
                y = "Y",
                z = "Z",
                shopClerkPosition = "Position du commis",
                shopRegisterPosition = "Position de la caisse",
                shopSafePosition = "Position du coffre-fort",
                registerId = "ID de la caisse",
                registerX = "Coordonnée X de la caisse",
                registerY = "Coordonnée Y de la caisse",
                registerZ = "Coordonnée Z de la caisse",
                heading = "Orientation",
                captureLocation = "Relever la position",
            },
            crimeDashboard = {
                jobs = "Gérez les factions, les membres, les permissions et les emplacements.",
                jobCreator = "Sélectionnez une faction pour modifier ses emplacements et ses zones.",
                jobsQuestion = "Où modifier les factions et les emplacements ?",
                jobsAnswer = "Ouvrez {path}, sélectionnez une faction puis Modifier. Vous pouvez y configurer ses paramètres et ses emplacements.",
                creatorsAnswer = "Les créateurs se trouvent dans {path}. Ces liens ouvrent leur éditeur ; les outils de faction commencent par le choix de la faction.",
                missingAnswer = "Les créateurs disponibles dépendent de la ressource choisie et de ses paramètres. Les outils de faction commencent par la faction concernée.",
                creators = {
                    mainbaseZones = "Sélectionnez une faction et configurez la zone de sa base.",
                    presetTerritories = "Consultez les districts prédéfinis et choisissez ceux à activer.",
                    objectsSection = "Gérez les chaises et les chariots à outils permanents pour les interrogatoires.",
                    blockedZonesSection = "Définissez les zones où les objets d’interrogatoire ne peuvent pas être placés.",
                    toolsSection = "Configurez les outils disponibles pendant les interrogatoires.",
                    sessionsSection = "Consultez les interrogatoires en cours et terminez les sessions si nécessaire.",
                    orphansSection = "Examinez et supprimez les objets d’interrogatoire abandonnés.",
                },
            },
            crimeGroupDescriptions = {
                general = {
                    crimeMembership = "Choisissez comment les organisations criminelles stockent et gèrent leurs membres.",
                },
                territories = {
                    zones = "Configurez « Zones de territoire » dans la section « Territoires ».",
                    ownership = "Configurez « Propriété » dans la section « Territoires ».",
                    decay = "Configurez « Déclin » dans la section « Territoires ».",
                    presence = "Configurez « Présence » dans la section « Territoires ».",
                    activity = "Configurez « Score d'activité » dans la section « Territoires ».",
                    ownershipBenefits = "Configurez « Avantages de propriété » dans la section « Territoires ».",
                },
                graffiti = {
                    general = "Configurez « Général » dans la section « Graffiti ».",
                    streaming = "Configurez « Rendu » dans la section « Graffiti ».",
                    moderation = "Configurez « Modération » dans la section « Graffiti ».",
                },
                pvpEvents = {
                    pvpAvailability = "Contrôlez si l'application d'événement PvP est disponible et où elle apparaît.",
                    pvpAutomation = "Configurez les événements récurrents et le traitement du démarrage automatique.",
                    pvpRuntime = "Ajustez la gestion des requêtes, les morts et les respawns pendant les matchs en direct.",
                    pvpModes = "Configurez le mode de jeu présélectionné dans la tablette PvP.",
                    pvpArenas = "Crée la zone circulaire, le point d'observation et les points d'apparition d'équipe utilisés par les événements PvP.",
                    pvpLimits = "Définissez les limites de récompenses et de l'historique de la tablette.",
                    pvpPermissions = "Assigne la gestion des événements et les finances aux permissions ACE et aux métiers.",
                    pvpTakeoverRules = "Contrôle la disponibilité et les conditions de participation pour les prises de contrôle de laboratoires et de campings.",
                    pvpTakeoverZones = "Configurez les zones d'interaction, d'alerte et de capture ainsi que leurs durées.",
                    pvpTakeoverMethods = "Configure le temps nécessaire à chaque méthode pour forcer une entrée.",
                },
                drugs = {
                    creator = "Ouvre l'éditeur de drogues Sky Crime et ferme le configurateur de métier.",
                    creatorSettings = "Configurez « Paramètres de l'éditeur » dans la section « Système de drogues ».",
                    interfaceHud = "Configurez « Positions de l'interface » dans la section « Système de drogues ».",
                    drugsGeneral = "Configurez « Général » dans la section « Système de drogues ».",
                    runtimeAccess = "Configurez « Accès et propriété » dans la section « Système de drogues ».",
                    runtimePayouts = "Configurez « Versements » dans la section « Système de drogues ».",
                    runtimeDispatch = "Configurez « Centrale et police » dans la section « Système de drogues ».",
                    performanceInactiveControlIntervalMs = "Paramètre de fonctionnement pour Performances / Inactif / Contrôles / Intervalle / ms.",
                    performanceInteractionIdleScanIntervalMs = "Paramètre de fonctionnement pour Performances / Interaction / Inactif / Intervalle d'analyse / ms.",
                    performanceInteractionPromptIntervalMs = "Paramètre de fonctionnement pour Performances / Interaction / Invite d'interaction / Intervalle / ms.",
                    performanceInteractionScanIntervalMs = "Paramètre de fonctionnement pour Performances / Interaction / Intervalle d'analyse / ms.",
                    performanceMinimumScanIntervalMs = "Paramètre de fonctionnement pour Performances / Minimum / Intervalle d'analyse / ms.",
                    performanceStreetPedActivationDistance = "Paramètre de fonctionnement pour Performances / Rue / PNJ / Activation / Distance.",
                    performanceStreetPedIdleScanIntervalMs = "Paramètre de fonctionnement pour Performances / Rue / PNJ / Inactif / Intervalle d'analyse / ms.",
                    performanceStreetPedScanIntervalMs = "Paramètre de fonctionnement pour Performances / Rue / PNJ / Intervalle d'analyse / ms.",
                    performanceWorldCachePadding = "Paramètre de fonctionnement pour Performances / Monde / Cache / Marge supplémentaire.",
                    performanceWorldCacheRefreshIntervalMs = "Paramètre de fonctionnement pour Performances / Monde / Cache / Actualisation / Intervalle / ms.",
                    performanceWorldIdleIntervalMs = "Paramètre de fonctionnement pour Performances / Monde / Inactif / Intervalle / ms.",
                },
                drugProduction = {
                    qualityWeights = "Configurez « Qualité / Pondérations » dans la section « Production de drogues ».",
                    qualityTiers = "Configurez « Qualité / Niveaux de qualité » dans la section « Production de drogues ».",
                    packagingGeneral = "Configurez « Général » dans la section « Production de drogues ».",
                    processingFlow = "Configurez « Processus de transformation » dans la section « Production de drogues ».",
                    processingGeneral = "Configurez « Général » dans la section « Production de drogues ».",
                },
                drugOperations = {
                    growingGeneral = "Configurez « Général » dans la section « Activités liées aux drogues ».",
                    plantDefaults = "Configurez « Plante / Valeurs par défaut » dans la section « Activités liées aux drogues ».",
                    harvestWindow = "Configurez « Récolte / Fenêtre temporelle » dans la section « Activités liées aux drogues ».",
                    labsGeneral = "Active : laboratoires et camping-cars en jeu.",
                    labRent = "Configurez « Location et cycle de vie » dans la section « Activités liées aux drogues ».",
                    camperDefaults = "Configurez « Camping-car » dans la section « Activités liées aux drogues ».",
                    labUpgrades = "Multiplicateur pour Labo / Niveau / Amélioration / Prix.",
                    labDefaults = "Configurez « Labo / Valeurs par défaut » dans la section « Activités liées aux drogues ».",
                    powerGeneral = "Configurez « Général » dans la section « Activités liées aux drogues ».",
                    generators = "Configurez « Générateurs » dans la section « Activités liées aux drogues ».",
                    equipmentWear = "Multiplicateur global pour Usure de l'équipement / Traitement.",
                    workersGeneral = "Configurez « Général » dans la section « Activités liées aux drogues ».",
                    cultivationGeneral = "Configurez « Général » dans la section « Activités liées aux drogues ».",
                    cultivationCurve = "Configure le nom et le seuil d’XP totale de chaque niveau de culture.",
                    cultivationExperience = "Configure la quantité d’XP de culture accordée par chaque action.",
                    cultivationUnlocks = "Configure le niveau requis pour les contenants, substrats, équipements, variétés et paliers du scanner.",
                    powerRuntime = "Intervalle en secondes pour mise à jour de la consommation des générateurs et des signatures électriques.",
                    powerHeat = "Configurez « Suspicion et signature électrique » dans la section « Activités liées aux drogues ».",
                    powerModes = "Configurez « Gestion / Modes » dans la section « Activités liées aux drogues ».",
                    powerPriorities = "Configurez « Charge / Priorités » dans la section « Activités liées aux drogues ».",
                },
                drugMarketRisk = {
                    marketGeneral = "Configurez « Général » dans la section « Marché et risques ».",
                    marketPrices = "Configurez « Prix » dans la section « Marché et risques ».",
                    distribution = "Configurez « Distribution » dans la section « Marché et risques ».",
                    threatsGeneral = "Configurez « Général » dans la section « Marché et risques ».",
                    threatHeat = "Configurez « Pression policière » dans la section « Marché et risques ».",
                    threatChances = "Configurez « Probabilités » dans la section « Marché et risques ».",
                    consumptionGeneral = "Configurez « Général » dans la section « Marché et risques ».",
                    consumerDecay = "Configurez « Réduction de la tolérance et de la dépendance » dans la section « Marché et risques ».",
                    consumerEffects = "Configurez « Effets et risques » dans la section « Marché et risques ».",
                },
                drugNetworks = {
                    dynamicMarketActionCooldownSeconds = "Paramètre de fonctionnement pour Marché Dynamique / Délai de récupération de l'action / secondes.",
                    dynamicMarketActionHistoryLimit = "Paramètre de fonctionnement pour Marché Dynamique / Action / Limite de l'historique.",
                    dynamicMarketAmountSaturationWeight = "Paramètre de fonctionnement pour Marché Dynamique / Quantité / Saturation / Poids.",
                    dynamicMarketBaseIntelAccuracy = "Paramètre de fonctionnement pour Marché Dynamique / Valeur de base / Précision du renseignement.",
                    dynamicMarketDefaultAverageQuality = "Paramètre de fonctionnement pour Marché Dynamique / Valeur par défaut / Moyenne / Qualité.",
                    dynamicMarketDefaultResourceElasticity = "Paramètre de fonctionnement pour Marché Dynamique / Valeur par défaut / Ressource / Élasticité.",
                    dynamicMarketDemandCenter = "Paramètre de fonctionnement pour Marché Dynamique / Demande / Valeur centrale.",
                    dynamicMarketDemandPriceImpact = "Paramètre de fonctionnement pour Marché Dynamique / Demande / Prix / Impact.",
                    dynamicMarketDirectionThreshold = "Paramètre de fonctionnement pour Marché Dynamique / Direction / Seuil.",
                    dynamicMarketEnabled = "Paramètre de fonctionnement pour Marché Dynamique / Activé.",
                    dynamicMarketEventChance = "Paramètre de fonctionnement pour Marché Dynamique / Événement / Chance.",
                    dynamicMarketEventDurationMinutes = "Paramètre de fonctionnement pour Marché Dynamique / Événement / Durée / Minutes.",
                    dynamicMarketEventMinimumDurationMinutes = "Paramètre de fonctionnement pour Marché Dynamique / Événement / Minimum / Durée / Minutes.",
                    dynamicMarketEventStrengthMaximum = "Paramètre de fonctionnement pour Marché Dynamique / Événement / Intensité / Maximum.",
                    dynamicMarketEventStrengthMinimum = "Paramètre de fonctionnement pour Marché Dynamique / Événement / Intensité / Minimum.",
                    dynamicMarketEvents = "Configurez « Événements » dans la section « Réseaux de drogues ».",
                    dynamicMarketExactIntelReputation = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements précis / Réputation.",
                    dynamicMarketExactIntelTrust = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements précis / Confiance.",
                    dynamicMarketGlobalZoneLabel = "Paramètre de fonctionnement pour Marché Dynamique / Global / Zone / Libellé.",
                    dynamicMarketHistoryLimit = "Paramètre de fonctionnement pour Marché Dynamique / Limite de l'historique.",
                    dynamicMarketInitialDemand = "Paramètre de fonctionnement pour Marché Dynamique / Valeur initiale / Demande.",
                    dynamicMarketInitialPriceMultiplier = "Paramètre de fonctionnement pour Marché Dynamique / Valeur initiale / Multiplicateur de prix.",
                    dynamicMarketIntelDemandError = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Demande / Erreur.",
                    dynamicMarketIntelMaximumAccuracy = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Maximum / Précision.",
                    dynamicMarketIntelMinimumAccuracy = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Minimum / Précision.",
                    dynamicMarketIntelPoliceError = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Police / Erreur.",
                    dynamicMarketIntelPriceError = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Prix / Erreur.",
                    dynamicMarketIntelPriceMaximum = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Prix / Maximum.",
                    dynamicMarketIntelPriceMinimum = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Prix / Minimum.",
                    dynamicMarketIntelReputationWeight = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Réputation / Poids.",
                    dynamicMarketIntelResourcePriceError = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Ressource / Prix / Erreur.",
                    dynamicMarketIntelSaturationError = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Saturation / Erreur.",
                    dynamicMarketIntelSeedBucketSeconds = "Paramètre de fonctionnement pour Marché Dynamique / Fenêtre de graine des renseignements / secondes.",
                    dynamicMarketIntelStatusAccuracyThreshold = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Statut / Précision / Seuil.",
                    dynamicMarketIntelStatusErrorThreshold = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Statut / Erreur / Seuil.",
                    dynamicMarketIntelSupplyError = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Approvisionnement / Erreur.",
                    dynamicMarketIntelTrustWeight = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Confiance / Poids.",
                    dynamicMarketManipulationCooldownMinutes = "Paramètre de fonctionnement pour Marché Dynamique / Manipulation / Minutes de délai.",
                    dynamicMarketManipulationDemandShift = "Paramètre de fonctionnement pour Marché Dynamique / Manipulation / Demande / Variation.",
                    dynamicMarketManipulationDurationMinutes = "Paramètre de fonctionnement pour Marché Dynamique / Manipulation / Durée / Minutes.",
                    dynamicMarketManipulationHeat = "Paramètre de fonctionnement pour Marché Dynamique / Manipulation / Pression policière.",
                    dynamicMarketManipulationMinimumBatchAmount = "Paramètre de fonctionnement pour Marché Dynamique / Manipulation / Minimum / Lot / Quantité.",
                    dynamicMarketManipulationPaymentAccount = "Paramètre de fonctionnement pour Marché Dynamique / Manipulation / Compte de paiement.",
                    dynamicMarketManipulationPrice = "Paramètre de fonctionnement pour Marché Dynamique / Manipulation / Prix.",
                    dynamicMarketManipulationZoneHeatMultiplier = "Paramètre de fonctionnement pour Marché Dynamique / Manipulation / Zone / Pression policière / Multiplicateur.",
                    dynamicMarketMaximumIntelAgeMinutes = "Paramètre de fonctionnement pour Marché Dynamique / Maximum / Âge du renseignement / Minutes.",
                    dynamicMarketMaximumPriceMultiplier = "Paramètre de fonctionnement pour Marché Dynamique / Maximum / Multiplicateur de prix.",
                    dynamicMarketMinimumIntelAgeMinutes = "Paramètre de fonctionnement pour Marché Dynamique / Minimum / Âge du renseignement / Minutes.",
                    dynamicMarketMinimumMetricWindowMinutes = "Paramètre de fonctionnement pour Marché Dynamique / Minimum / Mesure / Fenêtre temporelle / Minutes.",
                    dynamicMarketMinimumPriceMultiplier = "Paramètre de fonctionnement pour Marché Dynamique / Prix minimum / Multiplicateur.",
                    dynamicMarketMinimumUpdateMinutes = "Paramètre de fonctionnement pour Marché Dynamique / Minimum / Mise à jour / Minutes.",
                    dynamicMarketPoliceDemandWeight = "Paramètre de fonctionnement pour Marché Dynamique / Police / Demande / Poids.",
                    dynamicMarketPolicePriceImpact = "Paramètre de fonctionnement pour Marché Dynamique / Police / Prix / Impact.",
                    dynamicMarketPoorQualityDemandPenalty = "Paramètre de fonctionnement pour Marché Dynamique / Mauvaise qualité / Demande / Pénalité.",
                    dynamicMarketPoorQualityThreshold = "Paramètre de fonctionnement pour Marché Dynamique / Mauvaise qualité / Seuil.",
                    dynamicMarketPremiumQualityDemandBonus = "Paramètre de fonctionnement pour Marché Dynamique / Qualité supérieure / Bonus de demande.",
                    dynamicMarketPremiumQualityThreshold = "Paramètre de fonctionnement pour Marché Dynamique / Qualité supérieure / Seuil.",
                    dynamicMarketProductionSupplyWeight = "Paramètre de fonctionnement pour Marché Dynamique / Production / Approvisionnement / Poids.",
                    dynamicMarketProductionWindowMinutes = "Paramètre de fonctionnement pour Marché Dynamique / Production / Fenêtre temporelle / Minutes.",
                    dynamicMarketQualityCenter = "Paramètre de fonctionnement pour Marché Dynamique / Qualité / Valeur centrale.",
                    dynamicMarketQualityConfidenceImpact = "Paramètre de fonctionnement pour Marché Dynamique / Qualité / Confiance / Impact.",
                    dynamicMarketQualityRange = "Paramètre de fonctionnement pour Marché Dynamique / Qualité / Plage de valeurs.",
                    dynamicMarketRarityBonusMaximum = "Paramètre de fonctionnement pour Marché Dynamique / Rareté / Prime / Maximum.",
                    dynamicMarketRegionalGlobalWeight = "Paramètre de fonctionnement pour Marché Dynamique / Régional / Global / Poids.",
                    dynamicMarketRegionalLocalWeight = "Paramètre de fonctionnement pour Marché Dynamique / Régional / Local / Poids.",
                    dynamicMarketResourceAliases = "Configurez « Ressource / Alias » dans la section « Réseaux de drogues ».",
                    dynamicMarketResourceDirectionFallThreshold = "Paramètre de fonctionnement pour Marché Dynamique / Ressource / Direction / Baisse / Seuil.",
                    dynamicMarketResourceDirectionRiseThreshold = "Paramètre de fonctionnement pour Marché Dynamique / Ressource / Direction / Hausse / Seuil.",
                    dynamicMarketResources = "Configurez « Ressources » dans la section « Réseaux de drogues ».",
                    dynamicMarketSalesWindowMinutes = "Paramètre de fonctionnement pour Marché Dynamique / Ventes / Fenêtre temporelle / Minutes.",
                    dynamicMarketSaturationDemandWeight = "Paramètre de fonctionnement pour Marché Dynamique / Saturation / Demande / Poids.",
                    dynamicMarketSaturationPriceImpact = "Paramètre de fonctionnement pour Marché Dynamique / Saturation / Prix / Impact.",
                    dynamicMarketScarcityDemandWeight = "Paramètre de fonctionnement pour Marché Dynamique / Pénurie / Demande / Poids.",
                    dynamicMarketScarcityPriceImpact = "Paramètre de fonctionnement pour Marché Dynamique / Pénurie / Prix / Impact.",
                    dynamicMarketSeasonEndMonths = "Configurez « Saison / Fin / Mois » dans la section « Réseaux de drogues ».",
                    dynamicMarketSeasonMultipliers = "Configurez « Saison / Multiplicateurs » dans la section « Réseaux de drogues ».",
                    dynamicMarketShortageRumorThreshold = "Paramètre de fonctionnement pour Marché Dynamique / Pénurie / Rumeur / Seuil.",
                    dynamicMarketStatusThresholds = "Configurez « Statut / Seuils » dans la section « Réseaux de drogues ».",
                    dynamicMarketTargetSupply = "Paramètre de fonctionnement pour Marché Dynamique / Cible / Approvisionnement.",
                    dynamicMarketTrendChance = "Paramètre de fonctionnement pour Marché Dynamique / Tendance / Chance.",
                    dynamicMarketTrendDurationMinutes = "Paramètre de fonctionnement pour Marché Dynamique / Tendance / Durée / Minutes.",
                    dynamicMarketTrendMaximumStrength = "Paramètre de fonctionnement pour Marché Dynamique / Tendance / Maximum / Intensité.",
                    dynamicMarketTrendMinimumStrength = "Paramètre de fonctionnement pour Marché Dynamique / Tendance / Minimum / Intensité.",
                    dynamicMarketUpdateMinutes = "Paramètre de fonctionnement pour Marché Dynamique / Mise à jour / Minutes.",
                    dynamicMarketVolatilityMaximum = "Paramètre de fonctionnement pour Marché Dynamique / Volatilité / Maximum.",
                    dynamicMarketVolatilityMinimum = "Paramètre de fonctionnement pour Marché Dynamique / Volatilité / Minimum.",
                    dynamicMarketWeatherMultipliers = "Configurez « Météo / Multiplicateurs » dans la section « Réseaux de drogues ».",
                    dynamicMarketWeatherState = "Paramètre de fonctionnement pour Marché Dynamique / Météo / État.",
                    heatActionCooldownSeconds = "Paramètre de fonctionnement pour Suspicion et risque / Délai de récupération de l'action / secondes.",
                    heatActivityRiskWeights = "Configurez « Activité / Risque / Pondérations » dans la section « Réseaux de drogues ».",
                    heatAggressiveHeatMultiplier = "Paramètre de fonctionnement pour Suspicion et risque / Mode agressif / Pression policière / Multiplicateur.",
                    heatBurnerBurnThreshold = "Paramètre de fonctionnement pour Suspicion et risque / Téléphone jetable / Compromission / Seuil.",
                    heatBurnerHeatPerWholesale = "Paramètre de fonctionnement pour Suspicion et risque / Téléphone jetable / Pression policière / Par vente en gros.",
                    heatBurnerPhoneItem = "Paramètre de fonctionnement pour Suspicion et risque / Téléphone jetable / Objet.",
                    heatCamperOperationalHeatMultiplier = "Paramètre de fonctionnement pour Suspicion et risque / Camping-car en activité / Pression policière / Multiplicateur.",
                    heatCamperOperationalHeatThreshold = "Paramètre de fonctionnement pour Suspicion et risque / Camping-car en activité / Pression policière / Seuil.",
                    heatCamperParkedHeat = "Paramètre de fonctionnement pour Suspicion et risque / Camping-car stationné / Pression policière.",
                    heatContaminatedHeatMultiplier = "Paramètre de fonctionnement pour Suspicion et risque / Contamination / Pression policière / Multiplicateur.",
                    heatContaminatedThreshold = "Paramètre de fonctionnement pour Suspicion et risque / Contamination / Seuil.",
                    heatCultivationFreePlants = "Paramètre de fonctionnement pour Suspicion et risque / Culture / Plantes sans risque supplémentaire.",
                    heatCultivationHeatPerPlant = "Paramètre de fonctionnement pour Suspicion et risque / Culture / Pression policière / Par plante.",
                    heatDealerHiddenMinutes = "Paramètre de fonctionnement pour Suspicion et risque / Dealer / caché / Minutes.",
                    heatDecayPerTick = "Configurez « Déclin / Par cycle de mise à jour » dans la section « Réseaux de drogues ».",
                    heatEnabled = "Paramètre de fonctionnement pour Suspicion et risque / Activé.",
                    heatEnforcementHeat = "Configurez « Présence policière / Pression policière » dans la section « Réseaux de drogues ».",
                    heatEnforcementMultipliers = "Configurez « Présence policière / Multiplicateurs » dans la section « Réseaux de drogues ».",
                    heatEntityTypes = "Configurez « Entité / Types » dans la section « Réseaux de drogues ».",
                    heatEventCooldownMinutes = "Paramètre de fonctionnement pour Suspicion et risque / Événement / Minutes de délai.",
                    heatEventHistoryLimit = "Paramètre de fonctionnement pour Suspicion et risque / Événement / Limite de l'historique.",
                    heatLabHeatSyncThreshold = "Paramètre de fonctionnement pour Suspicion et risque / Labo / Pression policière / Synchronisation / Seuil.",
                    heatLayLowCooldownMinutes = "Paramètre de fonctionnement pour Suspicion et risque / Se faire discret / Minutes de délai.",
                    heatLayLowIdleMinutes = "Paramètre de fonctionnement pour Suspicion et risque / Se faire discret / Inactif / Minutes.",
                    heatLayLowReduction = "Paramètre de fonctionnement pour Suspicion et risque / Se faire discret / Réduction.",
                    heatLockdownMinutes = "Paramètre de fonctionnement pour Suspicion et risque / Confinement / Minutes.",
                    heatMinimumDurationMinutes = "Paramètre de fonctionnement pour Suspicion et risque / Minimum / Durée / Minutes.",
                    heatMinimumEventCooldownSeconds = "Paramètre de fonctionnement pour Suspicion et risque / Minimum / Événement / Temps de recharge (secondes).",
                    heatMinimumIdleSeconds = "Paramètre de fonctionnement pour Suspicion et risque / Minimum / Inactif / secondes.",
                    heatProcessingHeatMultiplier = "Paramètre de fonctionnement pour Suspicion et risque / Traitement / Pression policière / Multiplicateur.",
                    heatRiskWeights = "Configurez « Risque / Pondérations » dans la section « Réseaux de drogues ».",
                    heatRotateBurnerReduction = "Paramètre de fonctionnement pour Suspicion et risque / Changer de téléphone jetable / Réduction.",
                    heatRouteControlMinutes = "Paramètre de fonctionnement pour Suspicion et risque / Itinéraire / Contrôles / Minutes.",
                    heatSaleHeat = "Configurez « Vente / Pression policière » dans la section « Réseaux de drogues ».",
                    heatThresholds = "Configurez « Seuils » dans la section « Réseaux de drogues ».",
                    heatTickMinutes = "Paramètre de fonctionnement pour Suspicion et risque / Cycle de mise à jour / Minutes.",
                    heatWholesaleHeatMultiplier = "Paramètre de fonctionnement pour Suspicion et risque / Vente en gros / Pression policière / Multiplicateur.",
                    heatWorkerLeakAlertRadius = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Rayon d'alerte.",
                    heatWorkerLeakBaseChance = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Valeur de base / Chance.",
                    heatWorkerLeakFactionMultiplier = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Faction / Multiplicateur.",
                    heatWorkerLeakHighSeverityThreshold = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Élevé / Gravité / Seuil.",
                    heatWorkerLeakLoyaltyChanceMultiplier = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Loyauté / Chance / Multiplicateur.",
                    heatWorkerLeakLoyaltyThreshold = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Loyauté / Seuil.",
                    heatWorkerLeakMaximumChance = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Maximum / Chance.",
                    heatWorkerLeakMinimumCooldownSeconds = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Minimum / Temps de recharge (secondes).",
                    heatWorkerLeakRouteMultiplier = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Itinéraire / Multiplicateur.",
                    heatWorkerLeakStrengthMaximum = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Intensité / Maximum.",
                    heatWorkerLeakStrengthMinimum = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Intensité / Minimum.",
                    heatWorkerLeakStrengthMultiplier = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Intensité / Multiplicateur.",
                    heatWorkerLeakStressChanceMultiplier = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Stress / Chance / Multiplicateur.",
                    heatWorkerLeakStressThreshold = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Stress / Seuil.",
                    contactsActionCooldownSeconds = "Paramètre de fonctionnement pour Réseau de contacts / Délai de récupération de l'action / secondes.",
                    contactsActiveHotspotCount = "Paramètre de fonctionnement pour Réseau de contacts / Nombre de points chauds actifs.",
                    contactsBurnerHintTrust = "Paramètre de fonctionnement pour Réseau de contacts / Indice burner / Confiance.",
                    contactsBurnerOfferMaximumMultiplier = "Paramètre de fonctionnement pour Réseau de contacts / Téléphone jetable / Offre / Maximum / Multiplicateur.",
                    contactsBurnerOfferMinimumMultiplier = "Paramètre de fonctionnement pour Réseau de contacts / Téléphone jetable / Offre / Minimum / Multiplicateur.",
                    contactsBuyerCooldownMinutes = "Paramètre de fonctionnement pour Réseau de contacts / Acheteur / Minutes de délai.",
                    contactsBuyerDeliveryDistance = "Paramètre de fonctionnement pour Réseau de contacts / Acheteur / Distance de livraison.",
                    contactsBuyerPremiumSuccessScore = "Paramètre de fonctionnement pour Réseau de contacts / Acheteur / Premium / Succès / Score.",
                    contactsBuyerPremiumTrustGain = "Paramètre de fonctionnement pour Réseau de contacts / Acheteur / Premium / Confiance / gain.",
                    contactsBuyerRequestHeatRiskWeight = "Paramètre de fonctionnement pour Réseau de contacts / Acheteur / Demande / Recherche & Risque / Poids.",
                    contactsBuyerStandardTrustGain = "Paramètre de fonctionnement pour Réseau de contacts / Acheteur / Norme / Confiance / gain.",
                    contactsContactActiveDelaySeconds = "Configurez « Délai d'activation du contact / secondes » dans la section « Réseaux de drogues ».",
                    contactsContactDemandRange = "Configurez « Contact / Demande / Plage de valeurs » dans la section « Réseaux de drogues ».",
                    contactsContactLossTrust = "Paramètre de fonctionnement pour Réseau de contacts / Contact / Perte / Confiance.",
                    contactsDarknetExactIntelMinutes = "Paramètre de fonctionnement pour Réseau de contacts / Darknet / Renseignements précis / Minutes.",
                    contactsDarknetHotspotIntelPrice = "Paramètre de fonctionnement pour Réseau de contacts / Darknet / Point sensible / Renseignements / Prix.",
                    contactsDarknetIntelPrice = "Paramètre de fonctionnement pour Réseau de contacts / Darknet / Renseignements / Prix.",
                    contactsDealerBasePrice = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Prix de base.",
                    contactsDealerHireCapacity = "Configurez « Dealer / Recrutement / capacité » dans la section « Réseaux de drogues ».",
                    contactsDealerHireRisk = "Configurez « Dealer / Recrutement / Risque » dans la section « Réseaux de drogues ».",
                    contactsDealerHireSkill = "Configurez « Dealer / Recrutement / Compétence » dans la section « Réseaux de drogues ».",
                    contactsDealerOffers = "Configurez « Offres du concessionnaire » dans la section « Réseaux de drogues ».",
                    contactsDealerProtectionHours = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Protection / Heures.",
                    contactsDealerProtectionPrice = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Protection / Prix.",
                    contactsDealerSaleMax = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Vente / Maximum.",
                    contactsDealerSaleMin = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Vente / Minimum.",
                    contactsDealerSimulation = "Configurez « Dealer / Simulation » dans la section « Réseaux de drogues ».",
                    contactsDealerTickMinutes = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Cycle de mise à jour / Minutes.",
                    contactsDealerWage = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Salaire.",
                    contactsDealerWageDecay = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Salaire / Déclin.",
                    contactsDealerWageLoyaltyGain = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Salaire / Loyauté / gain.",
                    contactsDealerWeaknesses = "Configurez « Dealer / Faiblesses » dans la section « Réseaux de drogues ».",
                    contactsDefaultContactDemand = "Paramètre de fonctionnement pour Réseau de contacts / Valeur par défaut / Contact / Demande.",
                    contactsDefaultContactRisk = "Paramètre de fonctionnement pour Réseau de contacts / Valeur par défaut / Contact / Risque.",
                    contactsDefaultDealerCapacity = "Paramètre de fonctionnement pour Réseau de contacts / Dealer par défaut / capacité.",
                    contactsDefaultDealerRisk = "Paramètre de fonctionnement pour Réseau de contacts / Dealer par défaut / Risque.",
                    contactsDefaultDealerSkill = "Paramètre de fonctionnement pour Réseau de contacts / Dealer par défaut / Compétence.",
                    contactsDefaultHotspotRadius = "Paramètre de fonctionnement pour Réseau de contacts / Valeur par défaut / Point sensible / Rayon.",
                    contactsDemandResetMinutes = "Paramètre de fonctionnement pour Réseau de contacts / Réinitialisation de la demande (minutes).",
                    contactsEnabled = "Paramètre de fonctionnement pour Réseau de contacts / Activé.",
                    contactsExactLocationTrust = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement exact / Confiance.",
                    contactsFactionDiscoveryReputation = "Paramètre de fonctionnement pour Réseau de contacts / Faction / Découverte / Réputation.",
                    contactsFactionHintTrust = "Paramètre de fonctionnement pour Réseau de contacts / Faction / Indice / Confiance.",
                    contactsFailedDeliveryCooldownMinutes = "Paramètre de fonctionnement pour Réseau de contacts / Livraison échouée / Minutes de délai.",
                    contactsFakeDealEncounter = "Configurez « Fausse transaction / Rencontre » dans la section « Réseaux de drogues ».",
                    contactsFallbackPreferredDrug = "Paramètre de fonctionnement pour Réseau de contacts / Valeur de remplacement / Drogue préférée.",
                    contactsFallbackProductLabel = "Paramètre de fonctionnement pour Réseau de contacts / Valeur de remplacement / Nom du produit.",
                    contactsGuideBookItem = "Paramètre de fonctionnement pour Réseau de contacts / Guide / Livre / Objet.",
                    contactsGuideBookTrust = "Paramètre de fonctionnement pour Réseau de contacts / Guide / Livre / Confiance.",
                    contactsHireDealerPrice = "Paramètre de fonctionnement pour Réseau de contacts / Embaucher un dealer / Prix.",
                    contactsHistoryLimit = "Paramètre de fonctionnement pour Réseau de contacts / Limite de l'historique.",
                    contactsHotspotIntelMinutes = "Paramètre de fonctionnement pour Réseau de contacts / Point sensible / Renseignements / Minutes.",
                    contactsHotspotRotationMinutes = "Paramètre de fonctionnement pour Réseau de contacts / Point sensible / Rotation / Minutes.",
                    contactsListingDurationMinutes = "Paramètre de fonctionnement pour Réseau de contacts / Annonce / Durée / Minutes.",
                    contactsMaxOwnedDealers = "Paramètre de fonctionnement pour Réseau de contacts / Maximum / Possédées / Revendeurs.",
                    contactsMinimumBuyerDeliveryDistance = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Acheteur / Distance de livraison.",
                    contactsMinimumContactRotationMinutes = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Rotation des contacts (minutes).",
                    contactsMinimumDemandResetMinutes = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Réinitialisation de la demande (minutes).",
                    contactsMinimumHeatMultiplier = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Pression policière / Multiplicateur.",
                    contactsMinimumHotspotIntelMinutes = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Point sensible / Renseignements / Minutes.",
                    contactsMinimumHotspotRadius = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Point sensible / Rayon.",
                    contactsMinimumHotspotRotationMinutes = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Point sensible / Rotation / Minutes.",
                    contactsMinimumListingDurationMinutes = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Annonce / Durée / Minutes.",
                    contactsMinimumRewardMultiplier = "Paramètre de fonctionnement pour Réseau de contacts / Récompense minimale / Multiplicateur.",
                    contactsMinimumRobberyMultiplier = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Braquage / Multiplicateur.",
                    contactsMinimumSpotPriceMultiplier = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Emplacement / Multiplicateur de prix.",
                    contactsOtherDrugPriceMultiplier = "Paramètre de fonctionnement pour Réseau de contacts / Autre / Drogue / Multiplicateur de prix.",
                    contactsPaymentAccount = "Paramètre de fonctionnement pour Réseau de contacts / Compte de paiement.",
                    contactsPostDeliveryDemandResetSeconds = "Paramètre de fonctionnement pour Réseau de contacts / Après livraison / Demande / Reset / secondes.",
                    contactsPreferredDrugPriceMultiplier = "Paramètre de fonctionnement pour Réseau de contacts / Drogue préférée / Multiplicateur de prix.",
                    contactsRegionLocationTrust = "Paramètre de fonctionnement pour Réseau de contacts / Région / Lieu / Confiance.",
                    contactsRequestAmounts = "Configurez « Demande / Quantités » dans la section « Réseaux de drogues ».",
                    contactsRotationMinutes = "Paramètre de fonctionnement pour Réseau de contacts / Rotation / Minutes.",
                    contactsSpotPools = "Configurez « Emplacement / Réserves de sélection » dans la section « Réseaux de drogues ».",
                    contactsStreetHotspots = "Configurez « Rue / Points sensibles » dans la section « Réseaux de drogues ».",
                    contactsTrustLevels = "Configurez « Confiance / Niveaux » dans la section « Réseaux de drogues ».",
                    businessActionCooldownSeconds = "Paramètre de fonctionnement pour Réseau d'entreprises / Délai de récupération de l'action / secondes.",
                    businessBalance = "Configurez « Solde » dans la section « Réseaux de drogues ».",
                    businessContracts = "Configurez « Contrats » dans la section « Réseaux de drogues ».",
                    businessDefaultBusinessName = "Paramètre de fonctionnement pour Réseau d'entreprises / Valeur par défaut / Nom de l'entreprise.",
                    businessDefaultRankId = "Paramètre de fonctionnement pour Réseau d'entreprises / Valeur par défaut / Grade / ID.",
                    businessDefaultStaffStyle = "Paramètre de fonctionnement pour Réseau d'entreprises / Valeur par défaut / Personnel / Style de travail.",
                    businessDefaultTransport = "Paramètre de fonctionnement pour Réseau d'entreprises / Valeur par défaut / Transports.",
                    businessEnabled = "Paramètre de fonctionnement pour Réseau d'entreprises / Activé.",
                    businessHubs = "Configurez « Centres de distribution » dans la section « Réseaux de drogues ».",
                    businessLimits = "Configurez « Limites » dans la section « Réseaux de drogues ».",
                    businessPayments = "Choisissez quel solde paie pour les achats et les coûts de fonctionnement du Réseau Business.",
                    businessPayoutAccount = "Paramètre de fonctionnement pour Réseau d'entreprises / Paiement / Compte.",
                    businessRanks = "Configurez « Rangs » dans la section « Réseaux de drogues ».",
                    businessReportDays = "Paramètre de fonctionnement pour Réseau d'entreprises / Période du rapport / jours.",
                    businessRouteEndpointTypes = "Configurez « Itinéraire / Point d'arrivée / Types » dans la section « Réseaux de drogues ».",
                    businessRuntime = "Configurez « Fonctionnement en jeu » dans la section « Réseaux de drogues ».",
                    businessSocietyPermission = "Paramètre de fonctionnement pour Réseau d'entreprises / Organisation / Autorisation.",
                    businessStaff = "Configurez « Personnel » dans la section « Réseaux de drogues ».",
                    businessTickMinutes = "Paramètre de fonctionnement pour Réseau d'entreprises / Cycle de mise à jour / Minutes.",
                    businessTransports = "Configurez « Transports » dans la section « Réseaux de drogues ».",
                },
                robbery = {
                    atmAvailability = "Activez ou désactivez le système de braquage de distributeur automatique autonome.",
                    atmLocations = "Gère les emplacements de distributeurs autorisés par le serveur disponibles pour les braquages.",
                    atmPolice = "Configurez le nombre de policiers en service requis pour commencer un braquage.",
                    atmItems = "Configurez les objets requis pour la perceuse, la sangle et la charge explosive.",
                    atmActionTimes = "Fixe la durée des actions d'attachement, de pose, de détonation et de pillage.",
                    atmTimeouts = "Contrôlez la durée pendant laquelle un distributeur automatique forcé reste disponible pour le loot.",
                    atmPayout = "Configurez le compte cible et la plage de récompense aléatoire.",
                    atmDistances = "Fixe les portées pour les interactions avec les joueurs et les véhicules lors des interactions ATM.",
                    atmExplosionEffects = "Configure les paramètres natifs de l'explosion utilisés lors de la détonation.",
                    atmDispatchAlert = "Configurez le rayon, la durée de vie et la priorité de l'alerte de police.",
                    atmDispatchRecipients = "Choisissez quels noms de jobs reçoivent les alertes de braquage de distributeur automatique.",
                    shopAvailability = "Activez les braquages et configurez l'exigence de présence policière.",
                    shopTiming = "Configurez l'intimidation, les actions, le délai et le cooldown.",
                    shopSafe = "Configurez les tentatives sur le clavier et l'objet de perçage.",
                    shopRegisterReward = "Configurez la récompense aléatoire pour chaque caisse.",
                    shopSafeReward = "Configurez la récompense aléatoire du coffre-fort.",
                    shopDispatchSettings = "Configurez les destinataires et les propriétés de l'alerte.",
                    shopLocationTable = "Gère les points de vente avec personnel et les coffres-forts.",
                    pickpocketAvailability = "Activez la fonctionnalité et, en option, limitez-la aux jobs de crime configurés.",
                    pickpocketGameplay = "Choisissez le défi ainsi que les probabilités indépendantes de fuite, d'appel d'urgence et de contre-attaque.",
                    pickpocketItemRewards = "Contrôlez les poches vides et les choix d'objets visibles jusqu'à 0.0001 pour cent.",
                    pickpocketMoney = "Configurez la plage de cash aléatoire générée par le serveur.",
                    pickpocketDistances = "Définissez la portée NPC utilisée par le système radial et de ciblage partagé.",
                    pickpocketRateLimits = "Contrôlez la limitation des requêtes, le cooldown par NPC et l'expiration de session.",
                    pickpocketDispatchSettings = "Configure l'alerte envoyée lorsqu'un NPC appelle les services d'urgence.",
                    heistCrafting = "Choisissez le niveau d'interaction requis lors de la fabrication de l'équipement de braquage. S'applique aux nouvelles tentatives dans tout le système criminel.",
                    heistCreatorMenu = "Créez, éditez et publiez des heists modulaires dans le Heist Creator dédié.",
                    heistExecution = "Fenêtre de démarrage, inactivité et temps de recharge pour les tentatives de braquage.",
                    npcPoliceSupport = "Des officiers NPC armés interviennent à pied lors des alarmes de braquage et soutiennent la police en engageant les braqueurs.",
                },
                baseRaids = {
                    baseRaids = "Accès au raid, conditions et catégories de loot sélectionnables individuellement. Les raids ouverts n'ont pas de limite de temps de transport.",
                },
                weapons = {
                    weaponCreatorMenu = "Gérez les routes d’armes et le blanchiment dans un seul éditeur.",
                    weaponRuntime = "Réglez la disponibilité et l’accès aux routes d’armes.",
                    weaponDefaultsgeneral = "Configurez « Valeurs générales » dans la section « Routes d’armes ».",
                    weaponDefaultsaccess = "Configurez « Valeurs d’accès » dans la section « Routes d’armes ».",
                    weaponDefaultscollection = "Configurez « Valeurs de collecte » dans la section « Routes d’armes ».",
                    weaponDefaultsproduction = "Configurez « Valeurs de production » dans la section « Routes d’armes ».",
                    weaponDefaultsmarket = "Configurez « Valeurs du marché » dans la section « Routes d’armes ».",
                    weaponDefaultsdelivery = "Configurez « Valeurs des commandes » dans la section « Routes d’armes ».",
                    weaponStreet = "Configurez « Vente d’armes dans la rue » dans la section « Routes d’armes ».",
                },
                darknetMarket = {
                    darknetAvailability = "Contrôle l'application tablette et son emplacement.",
                    darknetEconomy = "Configure les soldes des portefeuilles, l'échange de pièces et les taux de paiement.",
                    darknetListings = "Contrôle les limites d'offres, les prix et l'expiration automatique.",
                    darknetChat = "Limite les messages cryptés du marché.",
                    darknetIdentity = "Configure la rotation d'identité, la vérification et les avertissements d'arnaque.",
                    darknetDelivery = "Configure les rencontres physiques et les caisses mondiales volables.",
                    darknetDeliveryLocations = "Configure les pools d'emplacements assignés aléatoirement aux échanges NPC de BlackBay.",
                    darknetPolice = "Groupes de métiers autorisés à publier des pièges et à consulter les enquêtes.",
                    darknetNpcTraders = "Acheteurs et vendeurs NPC persistants avec risque configurable.",
                },
                interrogation = {
                    general = "Configurez « Général » dans la section « Interrogatoire ».",
                    consent = "Configurez « Protection des joueurs » dans la section « Interrogatoire ».",
                    objects = "Configurez « Objets » dans la section « Interrogatoire ».",
                    grab = "Configurez « Saisie » dans la section « Interrogatoire ».",
                    session = "Configurez « Séance » dans la section « Interrogatoire ».",
                    dispatch = "Configurez « Alertes de police » dans la section « Interrogatoire ».",
                    logging = "Configurez « Journalisation » dans la section « Interrogatoire ».",
                    security = "Configurez « Sécurité » dans la section « Interrogatoire ».",
                    presentation = "Configurez « Présentation » dans la section « Interrogatoire ».",
                },
                reputation = {
                    crimeReputation = "Configurez « Réputation » dans la section « Réputation ».",
                },
            },
            settingGroups = {
                weaponRuntime = { label = "Général", description = "Réglez la disponibilité et l’accès aux routes d’armes." },
                weaponCreatorMenu = { label = "Créateur d'entreprises illégales", description = "Gérez les routes d’armes et le blanchiment dans un seul éditeur." },
                atmActionTimes = {
                    description = "Fixe la durée des actions d'attachement, de pose, de détonation et de pillage.",
                    label = "Durées d'action",
                },
                atmAvailability = {
                    description = "Activez ou désactivez le système de braquage de distributeur automatique autonome.",
                    label = "Disponibilité",
                },
                atmDispatchAlert = {
                    description = "Configurez le rayon, la durée de vie et la priorité de l'alerte de police.",
                    label = "Propriétés de l'alerte",
                },
                atmDispatchRecipients = {
                    description = "Choisissez quels noms de jobs reçoivent les alertes de braquage de distributeur automatique.",
                    label = "Destinataires",
                },
                atmDistances = {
                    description = "Fixe les portées pour les interactions avec les joueurs et les véhicules lors des interactions ATM.",
                    label = "Distances d'interaction",
                },
                atmExplosionEffects = {
                    description = "Configure les paramètres natifs de l'explosion utilisés lors de la détonation.",
                    label = "Effets d'explosion",
                },
                atmItems = {
                    description = "Configurez les objets requis pour la perceuse, la sangle et la charge explosive.",
                    label = "Objets requis",
                },
                atmLocations = {
                    description = "Gère les emplacements de distributeurs autorisés par le serveur disponibles pour les braquages.",
                    label = "Emplacements de distributeurs (ATM)",
                },
                atmPayout = {
                    description = "Configurez le compte cible et la plage de récompense aléatoire.",
                    label = "Paiement",
                },
                atmPolice = {
                    description = "Configurez le nombre de policiers en service requis pour commencer un braquage.",
                    label = "Exigence de police",
                },
                atmPulling = {
                    description = "Configurez le mouvement requis pour arracher un distributeur automatique du mur.",
                    label = "Détection d'arrachage",
                },
                atmTimeouts = {
                    description = "Contrôlez la durée pendant laquelle un distributeur automatique forcé reste disponible pour le loot.",
                    label = "Délai de loot",
                },
                baseRaids = {
                    description = "Accès au raid, conditions et catégories de loot sélectionnables individuellement. Les raids ouverts n'ont pas de limite de temps de transport.",
                    label = "Raids de base",
                },
                businessPayments = {
                    description = "Choisissez quel solde paie pour les achats et les coûts de fonctionnement du Réseau Business.",
                    label = "Paiements",
                },
                crimeMembership = {
                    description = "Choisissez comment les organisations criminelles stockent et gèrent leurs membres.",
                    label = "Modèle d'adhésion",
                },
                darknetAvailability = {
                    description = "Contrôle l'application tablette et son emplacement.",
                    label = "Disponibilité",
                },
                darknetChat = {
                    description = "Limite les messages cryptés du marché.",
                    label = "Chat privé",
                },
                darknetDelivery = {
                    description = "Configure les rencontres physiques et les caisses mondiales volables.",
                    label = "Remises et dead drops",
                },
                darknetDeliveryLocations = {
                    description = "Configure les pools d'emplacements assignés aléatoirement aux échanges NPC de BlackBay.",
                    label = "Lieux de remise",
                },
                darknetEconomy = {
                    description = "Configure les soldes des portefeuilles, l'échange de pièces et les taux de paiement.",
                    label = "Cryptomonnaie",
                },
                darknetIdentity = {
                    description = "Configure la rotation d'identité, la vérification et les avertissements d'arnaque.",
                    label = "Alias et réputation",
                },
                darknetListings = {
                    description = "Contrôle les limites d'offres, les prix et l'expiration automatique.",
                    label = "Offres et expiration",
                },
                darknetNpcTraders = {
                    description = "Acheteurs et vendeurs NPC persistants avec risque configurable.",
                    label = "Commerçants NPC",
                },
                darknetPolice = {
                    description = "Groupes de métiers autorisés à publier des pièges et à consulter les enquêtes.",
                    label = "Accès police",
                },
                heistCrafting = {
                    description = "Choisissez le niveau d'interaction requis lors de la fabrication de l'équipement de braquage. S'applique aux nouvelles tentatives dans tout le système criminel.",
                    label = "Atelier de braquage",
                },
                heistCreatorMenu = {
                    description = "Créez, éditez et publiez des heists modulaires dans le Heist Creator dédié.",
                    label = "Menu Créateur",
                },
                heistExecution = {
                    description = "Fenêtre de démarrage, inactivité et temps de recharge pour les tentatives de braquage.",
                    label = "Timing du braquage",
                },
                moneywashEconomy = {
                    description = "Activez les commerces et configurez le compte de dépôt, les frais de service et les distances d'interaction.",
                    label = "Général",
                },
                npcPoliceSupport = {
                    description = "Des officiers NPC armés interviennent à pied lors des alarmes de braquage et soutiennent la police en engageant les braqueurs.",
                    label = "Soutien policier NPC",
                },
                pickpocketAvailability = {
                    description = "Activez la fonctionnalité et, en option, limitez-la aux jobs de crime configurés.",
                    label = "Disponibilité",
                },
                pickpocketDispatchSettings = {
                    description = "Configure l'alerte envoyée lorsqu'un NPC appelle les services d'urgence.",
                    label = "Dispatch d'urgence",
                },
                pickpocketDistances = {
                    description = "Définissez la portée NPC utilisée par le système radial et de ciblage partagé.",
                    label = "Distances d'interaction",
                },
                pickpocketGameplay = {
                    description = "Choisissez le défi ainsi que les probabilités indépendantes de fuite, d'appel d'urgence et de contre-attaque.",
                    label = "Risque et minigame",
                },
                pickpocketItemRewards = {
                    description = "Contrôlez les poches vides et les choix d'objets visibles jusqu'à 0.0001 pour cent.",
                    label = "Loot de poche visible",
                },
                pickpocketMoney = {
                    description = "Configurez la plage de cash aléatoire générée par le serveur.",
                    label = "Récompense en espèces",
                },
                pickpocketRateLimits = {
                    description = "Contrôlez la limitation des requêtes, le cooldown par NPC et l'expiration de session.",
                    label = "Protections serveur",
                },
                pvpArenas = {
                    description = "Crée la zone circulaire, le point d'observation et les points d'apparition d'équipe utilisés par les événements PvP.",
                    label = "Arènes et zones de combat",
                },
                pvpAutomation = {
                    description = "Configurez les événements récurrents et le traitement du démarrage automatique.",
                    label = "Automatisation",
                },
                pvpAvailability = {
                    description = "Contrôlez si l'application d'événement PvP est disponible et où elle apparaît.",
                    label = "Disponibilité",
                },
                pvpLimits = {
                    description = "Définissez les limites de récompenses et de l'historique de la tablette.",
                    label = "Limites et historique",
                },
                pvpModes = {
                    description = "Configurez le mode de jeu présélectionné dans la tablette PvP.",
                    label = "Modes de jeu",
                },
                pvpPermissions = {
                    description = "Assigne la gestion des événements et les finances aux permissions ACE et aux métiers.",
                    label = "Autorisations",
                },
                pvpRuntime = {
                    description = "Ajustez la gestion des requêtes, les morts et les respawns pendant les matchs en direct.",
                    label = "Durée de l'événement",
                },
                pvpTakeoverMethods = {
                    description = "Configure le temps nécessaire à chaque méthode pour forcer une entrée.",
                    label = "Méthodes d'effraction",
                },
                pvpTakeoverRules = {
                    description = "Contrôle la disponibilité et les conditions de participation pour les prises de contrôle de laboratoires et de campings.",
                    label = "Règles de prise de contrôle",
                },
                pvpTakeoverZones = {
                    description = "Configurez les zones d'interaction, d'alerte et de capture ainsi que leurs durées.",
                    label = "Zones et timing",
                },
                shopAvailability = {
                    description = "Activez les braquages et configurez l'exigence de présence policière.",
                    label = "Disponibilité",
                },
                shopDispatchSettings = {
                    description = "Configurez les destinataires et les propriétés de l'alerte.",
                    label = "Alerte police",
                },
                shopLocationTable = {
                    description = "Gère les points de vente avec personnel et les coffres-forts.",
                    label = "Emplacements des magasins",
                },
                shopRegisterReward = {
                    description = "Configurez la récompense aléatoire pour chaque caisse.",
                    label = "Récompense de caisse",
                },
                shopRegisterTable = {
                    description = "Assignez des caisses individuelles aux magasins.",
                    label = "Caisses enregistreuses",
                },
                shopSafe = {
                    description = "Configurez les tentatives sur le clavier et l'objet de perçage.",
                    label = "Coffre-fort",
                },
                shopSafeReward = {
                    description = "Configurez la récompense aléatoire du coffre-fort.",
                    label = "Récompense du coffre-fort",
                },
                shopTiming = {
                    description = "Configurez l'intimidation, les actions, le délai et le cooldown.",
                    label = "Délais",
                },
            },
            settingSections = {
                weapons = "Routes d’armes",
                drugs = "Système de drogues",
                drugProduction = "Production de drogues",
                drugOperations = "Activités liées aux drogues",
                drugMarketRisk = "Marché et risques",
                drugNetworks = "Réseaux de drogues",
                atmRobbery = "Braquage d'ATM",
                baseRaids = "Raids de base",
                crimeOrganizations = "Organisations",
                darknetMarket = "Marché du darknet",
                moneywash = "Blanchiment d'argent",
                pvpEvents = "PvP de faction",
                robbery = "Braquage",
                territories = "Territoires",
                graffiti = "Graffiti",
                interrogation = "Interrogatoire",
            },
            settingSubsections = {
                baseRaidEquipment = "Équipement requis",
                baseRaidBreach = "Effraction",
                baseRaidLoot = "Butin et véhicules",
                graffitiLimits = "Limites et modération",
                interrogationTechnical = "Journalisation et sécurité",
                atmDispatch = "Appel de la police",
                atmEquipment = "Équipement",
                atmExplosion = "Explosion",
                atmOverview = "Aperçu & lieux",
                atmRewards = "Récompenses",
                atmTiming = "Délais",
                atmVehicle = "Véhicule & arrachage",
                baseRaids = "Raids de base",
                crimeMembership = "Adhésion",
                heistCreator = "Créateur de braquage",
                npcPoliceSupport = "Soutien policier NPC",
                pickpocket = "Pickpocketing NPC",
                pvpArenas = "Arènes",
                pvpEquipment = "Modes de jeu",
                pvpOverview = "Aperçu",
                pvpRuntime = "Durée de l'événement",
                pvpTakeovers = "Prises de laboratoires",
                shopRobbery = "Braquages de magasins",
                atmRobbery = "Braquage d'ATM",
            },
            settings = {
                weaponDefaultGeneralInteractionDistance = { label = "Distance d’interaction" },
                weaponDefaultGeneralPedModel = { label = "Modèle de PNJ par défaut" },
                weaponDefaultAccessActiveHourStart = { label = "Heure d’ouverture (UTC)" },
                weaponDefaultAccessActiveHourEnd = { label = "Heure de fermeture (UTC)" },
                weaponDefaultAccessPoliceRequired = { label = "Policiers en service requis" },
                weaponDefaultAccessPoliceJobs = { label = "Métiers de police" },
                weaponDefaultCollectionDurationSeconds = { label = "Durée en secondes" },
                weaponDefaultCollectionCooldownSeconds = { label = "Délai en secondes" },
                weaponDefaultCollectionCooldownScope = { label = "Portée du délai" },
                weaponDefaultCollectionUseMinigame = { label = "Utiliser un mini-jeu" },
                weaponDefaultCollectionMinigame = { label = "Mini-jeu" },
                weaponDefaultCollectionMinigameRounds = { label = "Manches du mini-jeu" },
                weaponDefaultProductionDurationSeconds = { label = "Durée en secondes" },
                weaponDefaultProductionSuccessChance = { label = "Chance de réussite (%)" },
                weaponDefaultProductionFailureConsumesInputs = { label = "Consommer les ingrédients en cas d’échec" },
                weaponDefaultProductionUseMinigame = { label = "Utiliser un mini-jeu" },
                weaponDefaultProductionMinigame = { label = "Mini-jeu" },
                weaponDefaultProductionMinigameRounds = { label = "Manches du mini-jeu" },
                weaponDefaultProductionQualityMin = { label = "Qualité minimale" },
                weaponDefaultProductionQualityMax = { label = "Qualité maximale" },
                weaponDefaultProductionCooldownSeconds = { label = "Délai en secondes" },
                weaponDefaultProductionCooldownScope = { label = "Portée du délai" },
                weaponDefaultMarketPayoutAccount = { label = "Compte de paiement" },
                weaponDefaultMarketPriceMultiplierMin = { label = "Facteur de prix minimal (%)" },
                weaponDefaultMarketPriceMultiplierMax = { label = "Facteur de prix maximal (%)" },
                weaponDefaultMarketRestockSeconds = { label = "Intervalle de réapprovisionnement en secondes" },
                weaponDefaultMarketCooldownSeconds = { label = "Délai en secondes" },
                weaponDefaultMarketCooldownScope = { label = "Portée du délai" },
                weaponDefaultDeliveryContractDurationMinutes = { label = "Délai de commande en minutes" },
                weaponDefaultDeliveryContractBonusPercent = { label = "Bonus de commande (%)" },
                weaponStreetEnabled = { label = "Ventes rares d’armes aux acheteurs de rue" },
                weaponStreetChance = { label = "Chance d’offre d’arme (%)" },
                weaponStreetCooldown = { label = "Délai en secondes" },
                weaponStreetAmount = { label = "Quantité maximale" },
                weaponStreetPriceMin = { label = "Facteur de prix minimal (%)" },
                weaponStreetPriceMax = { label = "Facteur de prix maximal (%)" },
                weaponStreetAccount = { label = "Compte de paiement" },
                weaponStreetDirect = { label = "Vente directe" },
                weaponStreetBulk = { label = "Vente en lot" },
                weaponStreetContract = { label = "Commande du cartel" },
                weaponSystemEnabled = { label = "Système de routes d’armes", description = "Activez la collecte, la fabrication et la vente d’armes aux cartels." },
                weaponRuntimeEnabled = { label = "Actions des routes d’armes", description = "Autorisez l’utilisation des routes d’armes configurées dans le monde du jeu." },
                weaponCreatorAccess = { label = "Accès au créateur d’armes", description = "Choisissez qui peut ouvrir le créateur d’armes.", options = { permission = "Avec autorisation uniquement", jobManagement = "Gestion du métier", ownerOnly = "Propriétaire uniquement" } },
                openWeaponCreator = { label = "Créateur d'entreprises illégales", description = "Gérez les routes d’armes et le blanchiment dans un seul éditeur.", buttonLabel = "Créateur d'entreprises illégales", unsavedTooltip = "Enregistrer d’abord" },

                drugCultivationProgressionEnabled = { label = "Activer les niveaux de culture", description = "Active l’XP de culture, les niveaux et les déblocages liés au niveau." },
                drugCultivationMaxLevel = { label = "Niveau de culture maximal", description = "Niveau de culture maximal atteignable. Les niveaux supérieurs restent inaccessibles." },
                drugCultivationLevels = { label = "Courbe de niveaux", description = "Configure le nom et le seuil d’XP totale de chaque niveau de culture." },
                drugCultivationActionXp = { label = "Récompenses XP", description = "Configure la quantité d’XP de culture accordée par chaque action." },
                drugCultivationUnlocks = { label = "Déblocages de niveau", description = "Configure le niveau requis pour les contenants, substrats, équipements, variétés et paliers du scanner." },
                reputationRewards = { label = "Actions de réputation", description = "Ajoutez des actions, modifiez les points et désactivez ou supprimez des entrées. Seules les entrées actives accordent des points." },
                reputationEnabled = { label = "Activer la réputation criminelle", description = "Attribuer une réputation personnelle." },
                reputationPointsPerLevel = { label = "Points par niveau", description = "Chaque niveau exige ce nombre de points supplémentaires." },
                reputationMinimumJoinPoints = { label = "Réputation minimale pour rejoindre", description = "Total de points requis pour rejoindre une faction criminelle. 0 désactive la condition. Les membres actuels conservent leur accès." },
                reputation_atm = { label = "Braquage de distributeur", description = "Points par action réussie. 0 désactive cette récompense." },
                reputation_shop_register = { label = "Caisse de magasin", description = "Points par action réussie. 0 désactive cette récompense." },
                reputation_shop_safe = { label = "Coffre de magasin", description = "Points par action réussie. 0 désactive cette récompense." },
                reputation_pickpocket = { label = "Vol à la tire", description = "Points par action réussie. 0 désactive cette récompense." },
                reputation_heist = { label = "Braquage terminé", description = "Points par action réussie. 0 désactive cette récompense." },
                reputation_drug_harvest = { label = "Récolte de drogue", description = "Points par action réussie. 0 désactive cette récompense." },
                reputation_drug_processing = { label = "Transformation de drogue", description = "Points par action réussie. 0 désactive cette récompense." },
                reputation_drug_sale = { label = "Vente de drogue", description = "Points par action réussie. 0 désactive cette récompense." },
                reputation_drug_delivery = { label = "Livraison de drogue", description = "Points par action réussie. 0 désactive cette récompense." },
                reputation_drug_contract = { label = "Contrat de distribution", description = "Points par action réussie. 0 désactive cette récompense." },
                reputation_drug_raid = { label = "Raid de drogue", description = "Points par action réussie. 0 désactive cette récompense." },
                reputation_graffiti = { label = "Graffiti", description = "Points par action réussie. 0 désactive cette récompense." },
                reputation_moneywash = { label = "Blanchiment d’argent", description = "Points par action réussie. 0 désactive cette récompense." },
                reputation_base_raid = { label = "Raid de base", description = "Points par action réussie. 0 désactive cette récompense." },
                reputation_pvp_win = { label = "Victoire JcJ", description = "Points par action réussie. 0 désactive cette récompense." },
                atmChargeProp = {
                    description = "Modèle d'objet affiché sur l'ATM pendant que la charge explosive est posée.",
                    label = "Charge explosive",
                },
                atmConsumeDrill = {
                    description = "Consomme la quantité configurée après chaque point de perçage du distributeur terminé avec succès.",
                    label = "Consommer la perceuse",
                },
                atmDrillItem = {
                    description = "Identifiant de l’objet d’inventaire requis pour percer un distributeur arraché. Réglage indépendant de la perceuse des coffres de magasin.",
                    label = "Objet perceuse",
                },
                atmDrillItemAmount = {
                    description = "Nombre d’objets perceuse requis pour chaque point de perçage du distributeur.",
                    label = "Nombre de perceuses requis",
                },
                atmDebug = {
                    description = "Écrit des diagnostics détaillés de braquage d'ATM dans la console du serveur et la console client F8.",
                    label = "Logs de debug ATM",
                },
                atmDispatchDurationSeconds = {
                    description = "Nombre de secondes pendant lesquelles l'alerte ATM reste pertinente pour les récepteurs du dispatch.",
                    label = "Durée de la répartition (Dispatch)",
                },
                atmDispatchEnabled = {
                    description = "Crée un incident de type Jobs Base lorsqu'un ATM est forcé.",
                    label = "Activer l'alerte de la police",
                },
                atmDispatchJobs = {
                    description = "Noms de jobs séparés par des virgules qui reçoivent l'alerte du distributeur (ATM).",
                    label = "Jobs de dispatch",
                },
                atmDispatchPriority = {
                    description = "Valeur de priorité transmise telle quelle à l'intégration du dispatch.",
                    label = "Priorité du dispatch",
                },
                atmDispatchRadius = {
                    description = "Rayon approximatif de l'alerte envoyé à l'intégration du dispatch.",
                    label = "Rayon de déploiement",
                },
                atmEnabled = {
                    description = "Rend les distributeurs configurés disponibles pour les braquages au crochet ou à l'explosif.",
                    label = "Activer les braquages de distributeurs",
                },
                atmExplosionCameraShake = {
                    description = "Intensité de la secousse de caméra pour le client qui provoque l'explosion.",
                    label = "Secousse de caméra lors de l'explosion",
                },
                atmExplosionDamageScale = {
                    description = "Intensité des dégâts et de l'impulsion transmise à la fonction native d'explosion.",
                    label = "Échelle des dégâts d'explosion",
                },
                atmExplosionType = {
                    description = "Type d'explosion GTA utilisé lors de la détonation. Conservez le type par défaut sauf si un autre type a été testé.",
                    label = "Type d'explosion",
                },
                atmDrillDurationSeconds = {
                    label = "Temps de perçage minimal par vis (s)",
                    description = "Temps minimal en secondes pour chacune des quatre vis. Les pauses de refroidissement prolongent la tentative. S'applique aux tentatives de perçage commencées après l'enregistrement.",
                },
                atmExplosiveDurationSeconds = {
                    description = "Nombre de secondes nécessaires pour poser la charge explosive.",
                    label = "Durée de pose de la charge",
                },
                atmExplosiveItem = {
                    description = "Objet d'inventaire consommé après la pose de la charge.",
                    label = "Objet explosif",
                },
                atmExplosiveItemAmount = {
                    description = "Nombre d'objets explosifs consommés pour une charge posée.",
                    label = "Quantité d'explosif consommée",
                },
                atmFuseSeconds = {
                    description = "Nombre de secondes entre la pose et la détonation.",
                    label = "Durée de la mèche",
                },
                atmInteractionDistance = {
                    description = "Portée maximale d'interaction client ; la validation du serveur ajoute une marge de sécurité.",
                    label = "Distance d'interaction",
                },
                atmLocations = {
                    description = "Emplacements de production officiels. Les emplacements créés avec /atmtest restent temporaires.",
                    itemLabel = "Emplacement du distributeur (ATM)",
                    label = "Emplacements de distributeurs (ATM)",
                },
                atmLootDurationSeconds = {
                    description = "Secondes requises pour forcer un ATM fracturé.",
                    label = "Durée du butin",
                },
                atmLootReservationTimeoutSeconds = {
                    description = "Nombre maximum de secondes qu'un joueur peut réserver un ATM en l'ouvrant ; maintenu automatiquement au-dessus de la durée de loot.",
                    label = "Délai d'expiration de la réservation de loot",
                },
                atmLootWindowMinutes = {
                    description = "Minutes pendant lesquelles un ATM forcé reste lootable avant d'être vidé.",
                    label = "Fenêtre de loot",
                },
                atmMinimumPolice = {
                    description = "Nombre de membres de la police en service requis pour commencer un braquage.",
                    label = "Police minimum",
                },
                atmPoliceGroup = {
                    description = "Groupe de job sky_jobs_base comptabilisé pour l'exigence de police.",
                    label = "Groupe de job de police",
                },
                atmPullDistance = {
                    description = "Déplacement du véhicule par rapport à la position de l'ATM requis pour compléter l'effraction.",
                    label = "Distance de traction requise",
                },
                atmPullMinimumSpeed = {
                    description = "Vitesse minimale du véhicule en mètres par seconde lorsque la distance de traction est atteinte.",
                    label = "Vitesse de traction minimale",
                },
                atmReservationTimeoutSeconds = {
                    description = "Nombre maximum de secondes réservées pendant qu'un joueur installe une sangle ou une charge ; maintenu automatiquement au-dessus de la durée de l'action.",
                    label = "Délai d'expiration de la réservation de préparation",
                },
                atmRewardAccount = {
                    description = "Choisissez entre les espèces et l'objet black_money.",
                    label = "Type de paiement du distributeur",
                },
                atmRewardMaximum = {
                    description = "Le plus gros paiement en espèces d'un seul distributeur ; jamais inférieur au minimum.",
                    label = "Récompense maximale",
                },
                atmRewardMinimum = {
                    description = "Plus faible paiement en espèces d'un ATM.",
                    label = "Récompense minimale",
                },
                atmSlingDurationSeconds = {
                    description = "Nombre de secondes requis pour attacher l'élingue.",
                    label = "Durée de l'attache de l'élingue",
                },
                atmSlingItem = {
                    description = "Objet d'inventaire réutilisable requis pour la méthode du véhicule.",
                    label = "Objet de traction (sangle)",
                },
                atmSlingItemAmount = {
                    description = "Nombre d'élingues qui doit être présent. Elles ne sont pas consommées.",
                    label = "Quantité de l'élingue requise",
                },
                atmTestScanDistance = {
                    description = "Distance maximale utilisée par /atmtest lors de la recherche d'un accessoire ATM compatible.",
                    label = "Distance de scan de test ATM",
                },
                atmVehicleMaxDistance = {
                    description = "Distance maximale entre l'ATM et un véhicule éligible lors de l'attache de l'élingue.",
                    label = "Distance d'attache du véhicule",
                },
                baseRaid_breachTimeoutSeconds = {
                    description = "Durée maximale de chaque tentative d’effraction à un stockage (secondes).",
                    label = "Délai d'effraction (secondes)",
                },
                baseRaid_command = {
                    description = "Nom de la commande sans barre oblique. Redémarrez la ressource crime après modification.",
                    label = "Commande de raid",
                },
                baseRaid_crimeItem = {
                    description = "Objet de brèche de gang.",
                    label = "Objet de brèche de gang",
                },
                baseRaid_crimeVehicles = {
                    description = "Accès aux véhicules de gang.",
                    label = "Accès aux véhicules de gang",
                },
                baseRaid_difficulty = {
                    description = "Difficulté du skillcheck.",
                    label = "Difficulté du skillcheck",
                    options = {
                        easy = "Facile",
                        expert = "Expert",
                        hard = "Difficile",
                        normal = "Normale",
                    },
                },
                baseRaid_enabled = {
                    description = "Activer les raids de base.",
                    label = "Activer les raids de base",
                },
                baseRaid_failedCooldownMinutes = {
                    description = "Délai après un raid terminé sans ouvrir de stockage (minutes).",
                    label = "Délai de récupération après échec (minutes)",
                },
                baseRaid_interactionDistance = {
                    description = "Distance d'interaction avec le stockage.",
                    label = "Distance d'interaction avec le stockage",
                },
                baseRaid_lootHeistStorage = {
                    description = "Permet le retrait complet de cette catégorie d'inventaire pendant un raid actif.",
                    label = "Stockage du butin de braquage",
                },
                baseRaid_lootLaboratories = {
                    description = "Permet le retrait complet de cette catégorie d'inventaire pendant un raid actif.",
                    label = "Piller le stockage du laboratoire",
                },
                baseRaid_lootPersonalLockers = {
                    description = "Permet le retrait complet de cette catégorie d'inventaire pendant un raid actif.",
                    label = "Piller les casiers personnels",
                },
                baseRaid_lootStorage = {
                    description = "Permet le retrait complet de cette catégorie d'inventaire pendant un raid actif.",
                    label = "Piller le stockage",
                },
                baseRaid_lootVehicleGloveboxes = {
                    description = "Permet le retrait complet de cette catégorie d'inventaire pendant un raid actif.",
                    label = "Piller les boîtes à gants",
                },
                baseRaid_lootVehicleTrunks = {
                    description = "Permet le retrait complet de cette catégorie d'inventaire pendant un raid actif.",
                    label = "Piller les coffres de véhicules",
                },
                baseRaid_minimumDefenders = {
                    description = "Minimum de défenseurs en ligne.",
                    label = "Minimum de défenseurs en ligne",
                },
                baseRaid_policeItem = {
                    description = "Objet de forçage de la police.",
                    label = "Objet de forçage de la police",
                },
                baseRaid_policeRequireDuty = {
                    description = "La police doit être en service.",
                    label = "La police doit être en service",
                },
                baseRaid_policeVehicles = {
                    description = "Accès aux véhicules de police.",
                    label = "Accès aux véhicules de police",
                },
                baseRaid_protectionHours = {
                    description = "Protection après succès (heures).",
                    label = "Protection après succès (heures)",
                },
                baseRaid_requiredHits = {
                    description = "Nombre de coups de skillcheck requis.",
                    label = "Nombre de coups de skillcheck requis",
                },
                baseRaid_warrantItem = {
                    description = "Un de ces objets est consommé pour chaque début de raid de police valide.",
                    label = "Objet de mandat de perquisition",
                },
                crimeMembershipMode = {
                    description = "Le mode Framework conserve l'intégration actuelle du métier ou du gang natif. Le mode indépendant fait fonctionner l'organisation criminelle en arrière-plan parallèlement au métier normal du joueur et migre automatiquement les adhésions existantes.",
                    label = "Modèle d'adhésion à l'organisation",
                    options = {
                        framework = "Métier Framework / Gang",
                        independent = "Organisation indépendante",
                    },
                },
                darknetAliasChangeCooldownHours = {
                    description = "Âge minimum d'une identité avant qu'elle ne puisse être retirée à nouveau.",
                    label = "Délai entre les changements d'alias (heures)",
                },
                darknetCurrencyCode = {
                    description = "Libellé court affiché pour le grand livre interne de cryptomonnaie.",
                    label = "Code de la devise",
                },
                darknetDeadDropInteractionDistance = {
                    description = "Distance requise pour fouiller et récupérer une caisse.",
                    label = "Distance d'interaction du dead-drop",
                },
                darknetDeadDropLifetimeHours = {
                    description = "Temps avant qu'une caisse non réclamée n'expire.",
                    label = "Durée de vie du dead-drop (heures)",
                },
                darknetDeadDropModel = {
                    description = "Modèle d'objet GTA généré localement pour les dead-drops disponibles.",
                    label = "Modèle de caisse de dead-drop",
                },
                darknetDeadDropPollIntervalMs = {
                    description = "Intervalle utilisé pour rafraîchir les caisses et les rencontres NPC à proximité.",
                    label = "Intervalle de rafraîchissement du monde (ms)",
                },
                darknetDeadDropStreamDistance = {
                    description = "Distance à laquelle les caisses et les contacts de rencontre NPC sont chargés.",
                    label = "Distance de streaming du dead-drop",
                },
                darknetDropLocations = {
                    description = "Lieux assignés aléatoirement pour les échanges de planques avec les NPC. Configurez au moins deux.",
                    itemLabel = "Lieu de la planque",
                    label = "Lieux de la planque",
                },
                darknetEnabled = {
                    description = "Rend l'application tablette du marché noir et son exécution disponibles.",
                    label = "Activer le Darknet Market",
                },
                darknetExchangeBuyPrice = {
                    description = "Montant prélevé sur le compte de paiement pour une pièce.",
                    label = "Prix d'achat par pièce",
                },
                darknetExchangeEnabled = {
                    description = "Permet aux utilisateurs authentifiés de BlackBay d'acheter et de vendre des pièces sur leur page de compte.",
                    label = "Activer l'échange de pièces",
                },
                darknetExchangeMaximumAmount = {
                    description = "Plus grande quantité de pièces entières acceptée lors d'un échange.",
                    label = "Maximum de pièces par échange",
                },
                darknetExchangeMinimumAmount = {
                    description = "Plus petite quantité de pièces entières acceptée lors d'un échange.",
                    label = "Minimum de pièces par échange",
                },
                darknetExchangePaymentAccount = {
                    description = "Compte de la plateforme utilisé pour les achats de pièces et les paiements de vente.",
                    label = "Compte de paiement d'échange",
                    options = {
                        bank = "Banque",
                        black_money = "Argent sale",
                        money = "Espèces",
                    },
                },
                darknetExchangeSellPrice = {
                    description = "Montant versé sur le compte de paiement pour une pièce.",
                    label = "Prix de vente par pièce",
                },
                darknetFaceToFaceDistance = {
                    description = "Distance maximale entre les deux joueurs ou avec le point NPC configuré.",
                    label = "Distance de remise",
                },
                darknetKnownScammerReports = {
                    description = "Nombre de signalements de transactions uniques requis pour le badge d'escroc connu.",
                    label = "Signalements pour avertissement d'escroquerie",
                },
                darknetListingExpiryHours = {
                    description = "Les offres actives expirent automatiquement après ce nombre d'heures.",
                    label = "Durée de l'offre (heures)",
                },
                darknetMaximumListingQuantity = {
                    description = "Limite supérieure de quantité pour une offre.",
                    label = "Quantité maximale de marchandises",
                },
                darknetMaximumListings = {
                    description = "Maximum d'offres par alias actif.",
                    label = "Maximum d'offres actives",
                },
                darknetMaximumMessageLength = {
                    description = "Nombre maximum de caractères par message de chat crypté.",
                    label = "Longueur maximale du message",
                },
                darknetMaximumUnitPrice = {
                    description = "Prix crypto maximum pour une unité.",
                    label = "Prix unitaire maximum",
                },
                darknetMeetingLocations = {
                    description = "Lieux assignés aléatoirement pour les échanges en face à face avec les PNJ. Configurez au moins deux lieux.",
                    itemLabel = "Lieu de rendez-vous",
                    label = "Lieux de rendez-vous",
                },
                darknetNpcBuyerAliases = {
                    description = "Noms fictifs assignés aléatoirement aux nouvelles demandes d'achat NPC. Configurez au moins deux alias uniques.",
                    label = "Alias des acheteurs NPC",
                },
                darknetNpcMaximumBuyListings = {
                    description = "Limite supérieure utilisée lors du choix aléatoire du nombre de demandes d'achat NPC actives.",
                    label = "Maximum de demandes d'achat NPC",
                },
                darknetNpcMaximumSellListings = {
                    description = "Limite supérieure utilisée pour choisir aléatoirement le nombre d'offres de vente NPC actives.",
                    label = "Nombre maximum d'offres de vente NPC",
                },
                darknetNpcMinimumBuyListings = {
                    description = "Lorsque le marché NPC est réapprovisionné, au moins ce nombre de demandes d'achat sélectionnées aléatoirement reste actif.",
                    label = "Nombre minimum de demandes d'achat NPC",
                },
                darknetNpcMinimumSellListings = {
                    description = "Lorsque le marché PNJ est réapprovisionné, au moins ce nombre d'offres de vente sélectionnées aléatoirement restent actives.",
                    label = "Offres de vente PNJ minimales",
                },
                darknetNpcSellerAliases = {
                    description = "Noms fictifs attribués aléatoirement aux nouvelles offres de vente NPC. Configurez au moins deux alias uniques.",
                    label = "Alias des vendeurs NPC",
                },
                darknetNpcTraders = {
                    description = "Configure les offres synthétiques, la méthode de livraison, la réputation et la probabilité d'escroquerie.",
                    label = "Acheteurs et vendeurs NPC",
                },
                darknetPoliceGroups = {
                    description = "Clés de groupe pouvant publier des offres d'appât et consulter les enquêtes.",
                    label = "Groupes de métiers de police autorisés",
                },
                darknetRenewalHours = {
                    description = "Nombre d'heures ajoutées lorsqu'un propriétaire renouvelle une offre.",
                    label = "Durée de renouvellement (heures)",
                },
                darknetScamChance = {
                    description = "Chance minimale qu'un échange NPC prenne le paiement ou les biens sans livrer la contrepartie. Une chance spécifique au commerçant plus élevée s'applique toujours.",
                    label = "Chance globale d'arnaque NPC (%)",
                },
                darknetStarterBalance = {
                    description = "Crypto attribuée uniquement lorsqu'un joueur ouvre le marché pour la première fois.",
                    label = "Solde de départ du nouveau portefeuille",
                },
                darknetTabletOrder = {
                    description = "Contrôle la position du Darknet Market sur la tablette.",
                    label = "Ordre de l'application tablette",
                },
                darknetVerifiedMinimumRating = {
                    description = "Évaluation moyenne minimale pour un vendeur vérifié.",
                    label = "Évaluation requise pour la vérification",
                },
                darknetVerifiedMinimumSales = {
                    description = "Nombre de ventes réussies requis avant qu'un vendeur puisse être vérifié.",
                    label = "Ventes requises pour la vérification",
                },
                drugAdvancedBusinessNetworkPaymentAccount = {
                    description = "Compte utilisé lorsque la source de paiement est réglée sur le compte joueur. Les paiements de l'organisation utilisent toujours le compte du Menu Boss.",
                    label = "Compte de paiement du joueur",
                    options = {
                        bank = "Banque",
                        black_money = "Argent sale",
                        money = "Espèces",
                    },
                    requiresWarning = "Utilisé uniquement avec la source de paiement du compte joueur.",
                },
                drugAdvancedBusinessNetworkPaymentSource = {
                    description = "Utilise soit le solde du joueur effectuant l'achat, soit le compte du Menu Boss de l'organisation.",
                    label = "Source de paiement",
                    options = {
                        player = "Compte joueur",
                        society = "Compte de l'organisation",
                    },
                },
                drugCamperLockKey = {
                    description = "Définit la touche par défaut pour verrouiller et déverrouiller les campings possédés ou partagés par la faction. Les joueurs peuvent la modifier dans leurs touches FiveM.",
                    label = "Touche par défaut du verrou du camping",
                    options = {
                        L = "L",
                        U = "U",
                        K = "K",
                        J = "J",
                        G = "G",
                        H = "H",
                        X = "X",
                        Y = "Y",
                        F6 = "F6",
                        F7 = "F7",
                    },
                },
                drugCollectorInventoryMetadata = {
                    description = "Ajoute par défaut les données de qualité et de lot aux résultats de collecte. Désactivez ceci pour que les matières premières s'empilent normalement.",
                    label = "Métadonnées d'objet de collecte",
                },
                drugLabAssaultAlertDuration = {
                    description = "Nombre de secondes pendant lesquelles le rayon d'alerte reste visible sur la carte pour les défenseurs.",
                    label = "Durée de l'alerte des défenseurs",
                },
                drugLabAssaultAlertRadius = {
                    description = "Rayon de la zone d'attaque affiché à la faction défensive sur la carte.",
                    label = "Rayon d'alerte des défenseurs",
                },
                drugLabAssaultBreachRadius = {
                    description = "Rayon dans lequel un attaquant doit rester pendant l'ouverture de l'entrée.",
                    label = "Rayon de maintien lors de l'effraction",
                },
                drugLabAssaultCaptureDuration = {
                    description = "Nombre de secondes pendant lesquelles les attaquants doivent tenir l'entrée sans opposition pour prendre le contrôle du laboratoire ou du camping.",
                    label = "Durée de la prise de contrôle",
                },
                drugLabAssaultCaptureRadius = {
                    description = "Zone d'entrée utilisée pour compter les attaquants et les défenseurs en lutte.",
                    label = "Rayon de capture",
                },
                drugLabAssaultElectronicDuration = {
                    description = "Nombre de secondes nécessaires pour pirater le système d'entrée.",
                    label = "Durée du piratage électronique",
                },
                drugLabAssaultEnabled = {
                    description = "Permet aux factions de forcer et de prendre le contrôle des laboratoires rivaux et des campements partagés entre factions.",
                    label = "Activer les prises de contrôle de laboratoires et de campements",
                },
                drugLabAssaultExplosiveDuration = {
                    description = "Secondes requises pour forcer l'entrée avec une charge explosive.",
                    label = "Durée de la brèche explosive",
                },
                drugLabAssaultInteractionDistance = {
                    description = "Distance maximale par rapport à l'entrée du laboratoire ou du camping lors du déclenchement d'une attaque.",
                    label = "Distance d'interaction à l'entrée",
                },
                drugLabAssaultMechanicalDuration = {
                    description = "Nombre de secondes nécessaires pour percer la serrure d'entrée.",
                    label = "Durée du forçage mécanique",
                },
                drugLabAssaultMinimumDefenders = {
                    description = "Nombre de membres de la faction défensive en ligne requis avant qu'une attaque puisse commencer.",
                    label = "Nombre minimum de défenseurs",
                },
                drugLabAssaultRequireDuty = {
                    description = "Ne compte que les membres de la faction défensive qui sont actuellement en service.",
                    label = "Compter uniquement les défenseurs en service",
                },
                drugProcessingInventoryMetadata = {
                    description = "Ajoute par défaut les données de qualité et de lot aux produits de transformation. Les recettes individuelles peuvent outrepasser ce paramètre.",
                    label = "Métadonnées des objets de transformation",
                },
                graffitiItemName = {
                    description = "Objet d'inventaire requis pour commencer à taguer lorsque l'exigence d'objet est activée. L'objet doit être présent dans l'inventaire actif.",
                    label = "Objet de graffiti requis",
                },
                heistCooldownMinutes = {
                    description = "Bloque le même braquage après la fin et le nettoyage d'un run avec des interactions réelles. La valeur 0 désactive le délai de récupération. Une fenêtre de démarrage non utilisée ne le déclenche pas.",
                    label = "Délai de récupération du braquage (minutes)",
                },
                heistCraftingMode = {
                    optionDescriptions = {
                        simple = "Barre de progression de cinq secondes. Les ingrédients requis sont consommés en cas de réussite.",
                        medium = "Sélectionne les ingrédients dans l’ordre indiqué et réussis un test de timing par ingrédient.",
                        advanced = "Assemblage complet pour les recettes avec un profil d’appareil ; sinon, deux tests de timing précis par ingrédient.",
                    },
                    description = "Simple : barre de progression de cinq secondes. Moyen : sélection d'ingrédients et vérifications de timing. Maximum : assemblage complet du dispositif ; les recettes sans profil de dispositif utilisent deux vérifications de timing précises par ingrédient.",
                    label = "Complexité de l'artisanat",
                    options = {
                        advanced = "Complexité maximale",
                        medium = "Complexité moyenne",
                        simple = "Simple",
                    },
                },
                heistInactivityTimeoutMinutes = {
                    description = "Après la première interaction, chaque nouvelle action de braquage réinitialise ce minuteur. L'expiration termine le run et supprime ses objets du monde. S'applique aux nouveaux runs.",
                    label = "Limite d'inactivité du braquage (minutes)",
                },
                heistStartTimeoutMinutes = {
                    description = "Temps après avoir appuyé sur Start pour interagir à la cible. Sans interaction, le run est réinitialisé et peut être redémarré. S'applique aux nouveaux runs.",
                    label = "Minutes avant la première interaction de braquage",
                },
                moneywashAccount = {
                    options = {
                        bank = "Banque",
                        black_money = "Argent sale",
                        money = "Espèces",
                    },
                },
                moneywashDirtyAccount = {
                    description = "Compte duquel l'argent sale du joueur est retiré lorsqu'un cycle de blanchiment commence.",
                    label = "Compte de dépôt",
                },
                moneywashDrawDistance = {
                    description = "Distance maximale en mètres à laquelle les entrées d'entreprises et les magasins sont affichés.",
                    label = "Distance d'affichage",
                },
                moneywashEnabled = {
                    description = "Rend les entreprises de blanchiment d'argent appartenant à l'organisation disponibles.",
                    label = "Activer le blanchiment d'argent",
                },
                moneywashFeePercent = {
                    description = "Pourcentage déduit de chaque lot avant le paiement à l'organisation.",
                    label = "Frais de service (%)",
                },
                moneywashInteractionDistance = {
                    description = "Distance maximale en mètres pour utiliser les entrées d'entreprises et les magasins.",
                    label = "Distance d'interaction",
                },
                npcPoliceAccuracy = {
                    description = "Précision des officiers NPC de 0 à 100.",
                    label = "Précision au tir",
                },
                npcPoliceArmour = {
                    description = "Valeur de blindage de chaque officier PNJ de 0 à 100.",
                    label = "Gilet pare-balles",
                },
                npcPoliceAtms = {
                    description = "Envoie des renforts de police NPC lorsqu'une alarme de braquage d'ATM est déclenchée.",
                    label = "Renfort policier lors des braquages d'ATM",
                },
                npcPoliceDurationSeconds = {
                    description = "Temps maximum pendant lequel les officiers PNJ restent déployés après leur apparition (30–900 secondes).",
                    label = "Durée du déploiement (secondes)",
                },
                npcPoliceEnabled = {
                    description = "Envoie des officiers NPC armés lorsqu'une alarme de braquage est déclenchée. Désactivé par défaut.",
                    label = "Activer le soutien policier NPC",
                },
                npcPoliceHeists = {
                    description = "Envoie un soutien de police NPC lorsqu'une alarme de braquage est déclenchée.",
                    label = "Soutien pendant les braquages",
                },
                npcPoliceOfficerCount = {
                    description = "Nombre d'officiers NPC armés déployés par alerte de braquage (1–8).",
                    label = "Officiers par intervention",
                },
                npcPoliceResponseDelaySeconds = {
                    description = "Temps entre l'alarme de braquage et l'arrivée des officiers NPC (0–300 secondes).",
                    label = "Délai de réponse (secondes)",
                },
                npcPoliceShops = {
                    description = "Envoie un soutien de police NPC lorsqu'une alarme de braquage de magasin est déclenchée.",
                    label = "Soutien lors des braquages de magasins",
                },
                npcPoliceSpawnDistance = {
                    description = "Distance cible par rapport au lieu du vol à laquelle les officiers NPC apparaissent (15–150 mètres).",
                    label = "Distance d'apparition (mètres)",
                },
                npcPoliceWeapon = {
                    description = "Arme équipée par chaque officier NPC intervenant. Par défaut, un pistolet.",
                    label = "Arme de service",
                    options = {
                        WEAPON_CARBINERIFLE = "Carabine",
                        WEAPON_PISTOL = "Pistolet",
                        WEAPON_PUMPSHOTGUN = "Fusil à pompe",
                    },
                },
                openHeistCreator = {
                    buttonLabel = "Ouvrir le créateur de braquage",
                    description = "Ouvrez le Heist Creator et fermez le Job Configurator.",
                    label = "Créateur de braquage",
                    unsavedTooltip = "Enregistrez les modifications d'abord",
                },
                pickpocketAggressionChance = {
                    description = "Chance indépendante que le PNJ attaque après une tentative échouée, annulée ou expirée.",
                    label = "Chance de contre-attaque (%)",
                },
                pickpocketAlertChance = {
                    description = "Chance indépendante que le NPC signale une tentative échouée, annulée ou expirée.",
                    label = "Chance d'appel d'urgence (%)",
                },
                pickpocketDifficulty = {
                    description = "Contrôle la vitesse du curseur, la rapidité de rétrécissement de la cible, la longueur de la séquence et les erreurs tolérées.",
                    label = "Difficulté",
                    options = {
                        easy = "Facile",
                        expert = "Expert",
                        hard = "Difficile",
                        normal = "Normale",
                    },
                },
                pickpocketDispatchAlways = {
                    description = "Signaler une fois chaque tentative de vol à la tire commencée, même réussie, quelle que soit la probabilité d’appel d’urgence.",
                    label = "Toujours envoyer une alerte",
                },
                pickpocketDispatchDurationSeconds = {
                    description = "Secondes pendant lesquelles le signalement reste pertinent pour les récepteurs du dispatch.",
                    label = "Durée de la patrouille",
                },
                pickpocketDispatchJobs = {
                    description = "Noms d'emplois séparés par des virgules qui reçoivent les appels d'urgence.",
                    label = "Emplois de la patrouille",
                },
                pickpocketDispatchPriority = {
                    description = "Priorité transmise telle quelle à l'intégration de la patrouille.",
                    label = "Priorité de la patrouille",
                },
                pickpocketDispatchRadius = {
                    description = "Rayon d'alerte approximatif envoyé à l'intégration de la patrouille.",
                    label = "Rayon de la patrouille",
                },
                pickpocketEmptyChance = {
                    description = "Chance que le NPC ne porte aucun butin sélectionnable.",
                    label = "Chance de poches vides (%)",
                },
                pickpocketEnabled = {
                    description = "Permet aux joueurs de tenter de voler les poches des PNJ ambients connectés éligibles.",
                    label = "Activer le vol d'objets sur les PNJ",
                },
                pickpocketFleeChance = {
                    description = "Chance indépendante que le PNJ s'enfuye après une tentative échouée, annulée ou expirée.",
                    label = "Chance de fuite du PNJ (%)",
                },
                pickpocketInteractionDistance = {
                    description = "Portée client maximale ; le serveur valide avec une petite marge de synchronisation.",
                    label = "Distance d'interaction",
                },
                pickpocketItems = {
                    description = "Chaque ligne contrôle sa chance d'apparition. Quatre décimales permettent de régler 0.0001 pour cent.",
                    itemLabel = "Chance de l'objet",
                    label = "Butin de l'objet",
                },
                pickpocketItemsEnabled = {
                    description = "Incorpère également les objets configurés dans le contenu visible des poches.",
                    label = "Activer le vol d'objets",
                },
                pickpocketMaximumLootChoices = {
                    description = "Nombre maximum d'emplacements d'espèces ou d'objets générés par le serveur affichés pour un PNJ.",
                    label = "Butin visible maximum",
                },
                pickpocketMinigame = {
                    description = "Choisissez un défi ou alternez aléatoirement entre les trois.",
                    label = "Mini-jeu",
                    options = {
                        pulse = "Impulsion de pression",
                        random = "Rotation aléatoire",
                        sequence = "Séquence de direction",
                        timing = "Barre de timing",
                    },
                },
                pickpocketMoneyMaximum = {
                    description = "Montant d'espèces visible le plus élevé ; maintenu automatiquement au niveau ou au-dessus du minimum.",
                    label = "Espèces maximum",
                },
                pickpocketMoneyMinimum = {
                    description = "Montant minimal généré par le serveur pour un emplacement d'espèces visible.",
                    label = "Espèces minimum",
                },
                pickpocketRequestCooldownSeconds = {
                    description = "Nombre minimum de secondes entre deux requêtes de début d'un même joueur.",
                    label = "Délai de récupération de la requête",
                },
                pickpocketRequireCrimeJob = {
                    description = "Activé : ajoute l'action uniquement aux jobs du système de crime enregistrés. Désactivé : supprime l'action intégrée au menu radial et nécessite l'export serveur.",
                    label = "Utiliser le menu radial du job Crime",
                },
                pickpocketRequiredHits = {
                    description = "Valeur de base pour chaque mini-jeu. L'argent liquide précieux l'augmente par paliers ; les objets extrêmement rares nécessitent au moins huit coups.",
                    label = "Nombre de coups minimum",
                },
                pickpocketSessionTimeoutSeconds = {
                    description = "Nombre de secondes avant qu'un défi de serveur inachevé n'expire.",
                    label = "Délai d'expiration de la session",
                },
                pickpocketTargetCooldownMinutes = {
                    description = "Verrouillage après une tentative annulée ou échouée ; les PNJ vidés avec succès restent indisponibles.",
                    label = "Délai de récupération PNJ",
                },
                pvpAdminAce = {
                    description = "Objet ACE accordant l'accès à la gestion globale des événements PvP.",
                    label = "ACE Administrateur",
                },
                pvpArenaReturnSeconds = {
                    description = "Temps de retour par défaut pour les nouveaux événements. Les leaders d'événement peuvent le modifier via la tablette.",
                    label = "Temps de retour à l'arène",
                },
                pvpArenaWarningPosition = {
                    description = "Définit l'endroit où apparaît l'avertissement de retour à l'arène.",
                    label = "Position de l'avertissement d'arène",
                    options = {
                        bottom_center = "En bas au centre",
                        bottom_left = "En bas à gauche",
                        bottom_right = "En bas à droite",
                        middle_center = "Centre de l'écran",
                        middle_left = "Milieu à gauche",
                        middle_right = "Milieu à droite",
                        top_center = "En haut au centre",
                        top_left = "En haut à gauche",
                        top_right = "En haut à droite",
                    },
                },
                pvpArenas = {
                    description = "Crée des zones de combat circulaires avec un point d'observation et au moins deux points d'apparition pour les équipes.",
                    itemLabel = "Arène",
                    label = "Arènes PvP",
                },
                pvpCountdownPosition = {
                    description = "Contrôle l'endroit où apparaît le compte à rebours de début de match.",
                    label = "Position du compte à rebours",
                    options = {
                        bottom_center = "En bas au centre",
                        bottom_left = "En bas à gauche",
                        bottom_right = "En bas à droite",
                        middle_center = "Centre de l'écran",
                        middle_left = "Milieu à gauche",
                        middle_right = "Milieu à droite",
                        top_center = "En haut au centre",
                        top_left = "En haut à gauche",
                        top_right = "En haut à droite",
                    },
                },
                pvpDefaultMode = {
                    description = "Mode de jeu présélectionné pour les nouveaux événements.",
                    label = "Mode de jeu par défaut",
                    options = {
                        free_for_all = "Chacun pour soi",
                        last_man_standing = "Dernier survivant",
                        team_deathmatch = "Match à mort par équipe",
                    },
                },
                pvpDefaultScoreLimit = {
                    description = "Nombre de kills requis par défaut pour gagner en Team Deathmatch ou Free For All.",
                    label = "Cible de kill par défaut",
                },
                pvpEventsEnabled = {
                    description = "Rend l'application tablette PvP de faction et l'exécution des événements disponibles.",
                    label = "Activer les événements PvP de faction",
                },
                pvpKillfeedPosition = {
                    description = "Définit l'endroit où les éliminations récentes sont affichées.",
                    label = "Position du killfeed",
                    options = {
                        bottom_center = "En bas au centre",
                        bottom_left = "En bas à gauche",
                        bottom_right = "En bas à droite",
                        middle_center = "Centre de l'écran",
                        middle_left = "Milieu à gauche",
                        middle_right = "Milieu à droite",
                        top_center = "En haut au centre",
                        top_left = "En haut à gauche",
                        top_right = "En haut à droite",
                    },
                },
                pvpLeaderPermission = {
                    description = "Permission de job requise pour créer, enregistrer, démarrer et gérer les événements de faction.",
                    label = "Permission de chef de faction",
                },
                pvpMatchDurationMinutes = {
                    description = "Durée par défaut en minutes pour les nouveaux événements. Zéro désactive la limite de temps.",
                    label = "Durée du match",
                },
                pvpMaxHistory = {
                    description = "Nombre maximum d'événements terminés ou annulés renvoyés sur la tablette.",
                    label = "Historique des événements visible",
                },
                pvpMaxRewards = {
                    description = "Nombre maximum de récompenses combinées (objet, arme, véhicule ou argent) par événement.",
                    label = "Maximum de récompenses supplémentaires",
                },
                pvpMoneyPermission = {
                    description = "Permission de job requise pour les frais d'entrée et les prix.",
                    label = "Permission financière de faction",
                },
                pvpRequestCooldownMs = {
                    description = "Nombre minimum de millisecondes entre deux requêtes PvP mutantes d'un même joueur.",
                    label = "Délai de récupération de l'action",
                },
                pvpRespawnDelaySeconds = {
                    description = "Secondes avant qu'un joueur ne réapparaisse ou ne soit déplacé vers la zone d'observation après sa mort.",
                    label = "Délai de réapparition",
                },
                pvpSchedulePollSeconds = {
                    description = "Nombre de secondes entre les vérifications des modèles récurrents et des démarrages automatiques.",
                    label = "Intervalle de vérification du planning",
                },
                pvpScoreboardPosition = {
                    description = "Contrôle l'endroit où le tableau des scores compact apparaît pendant les matchs de faction.",
                    label = "Position du tableau des scores",
                    options = {
                        bottom_center = "En bas au centre",
                        bottom_left = "En bas à gauche",
                        bottom_right = "En bas à droite",
                        middle_center = "Centre de l'écran",
                        middle_left = "Milieu à gauche",
                        middle_right = "Milieu à droite",
                        top_center = "En haut au centre",
                        top_left = "En haut à gauche",
                        top_right = "En haut à droite",
                    },
                },
                pvpSoloTestingEnabled = {
                    description = "Permet aux administrateurs PvP de s'enregistrer et de démarrer manuellement avec un membre de faction. À désactiver sur les serveurs de production.",
                    label = "Activer le test solo administrateur",
                },
                pvpStartCountdownSeconds = {
                    description = "Compte à rebours par défaut pour les nouveaux événements. Les leaders d'événement peuvent le modifier sur la tablette.",
                    label = "Lancer le compte à rebours",
                },
                pvpTabletOrder = {
                    description = "Contrôle l'endroit où l'application PvP de faction apparaît sur la tablette.",
                    label = "Ordre de l'application tablette",
                },
                shopActiveTimeoutMinutes = {
                    description = "Minutes avant qu'un braquage abandonné n'échoue.",
                    label = "Délai d'expiration d'activité",
                },
                shopConsumeDrill = {
                    description = "Consommer la perceuse après une ouverture réussie.",
                    label = "Consommer la perceuse",
                },
                shopConsumeHackItem = {
                    description = "Consommer l'objet de piratage après avoir ouvert le coffre-fort avec succès.",
                    label = "Consommer l'objet de piratage",
                },
                shopCooldownMinutes = {
                    description = "Minutes de temps de jeu avant la réinitialisation du magasin.",
                    label = "Temps de recharge du magasin",
                },
                shopDispatchAlways = {
                    description = "Signaler une fois chaque braquage de magasin dès son début, même lors d’une intimidation continue et dans les magasins sans vendeur obligatoire.",
                    label = "Toujours envoyer une alerte",
                },
                shopDispatchDurationSeconds = {
                    description = "Nombre de secondes pendant lesquelles l'alerte reste pertinente.",
                    label = "Durée de la patrouille",
                },
                shopDispatchJobs = {
                    description = "Emplois des destinataires d'alerte séparés par des virgules.",
                    label = "Emplois de la patrouille",
                },
                shopDispatchPriority = {
                    description = "Priorité transmise au dispatch",
                    label = "Priorité de la patrouille",
                },
                shopDispatchRadius = {
                    description = "Rayon approximatif d'alerte de la police.",
                    label = "Rayon de la patrouille",
                },
                shopDrillDurationSeconds = {
                    description = "Nombre de secondes nécessaires pour percer le coffre-fort.",
                    label = "Durée du perçage du coffre-fort",
                },
                shopDrillItem = {
                    description = "Identifiant de l’objet d’inventaire requis pour percer les coffres de magasin. Réglage indépendant de la perceuse des distributeurs.",
                    label = "Objet de la perceuse",
                },
                shopDrillItemAmount = {
                    description = "Nombre d'objets de type perceuse requis.",
                    label = "Quantité de perceuse requise",
                },
                shopEnabled = {
                    description = "Active les braquages dans les magasins avec personnel configurés.",
                    label = "Activer les braquages de magasins",
                },
                shopHackItem = {
                    description = "Objet requis pour le mini-jeu de piratage du coffre-fort. Activez la méthode d'ouverture séparément pour chaque magasin.",
                    label = "Objet de piratage",
                },
                shopHackItemAmount = {
                    description = "Quantité requise de l'objet de piratage.",
                    label = "Quantité d'objet de piratage",
                },
                shopIntimidationSeconds = {
                    description = "Nombre de secondes pendant lesquelles le vendeur doit rester sous la menace d'une arme.",
                    label = "Durée d'intimidation",
                },
                shopLocations = {
                    description = "Un employé, une caisse et un coffre-fort facultatif par magasin.",
                    itemLabel = "Magasin",
                    label = "Emplacements des magasins",
                },
                shopMinimumPolice = {
                    description = "Nombre de membres de la police en service requis pour commencer.",
                    label = "Minimum de police",
                },
                shopPoliceGroup = {
                    description = "Groupe de job comptabilisé pour l'exigence de police.",
                    label = "Groupe de job de police",
                },
                shopRegisterDurationSeconds = {
                    description = "Secondes requises pour vider une caisse.",
                    label = "Durée du loot de la caisse",
                },
                shopRegisterRewardMaximum = {
                    description = "Plus haut paiement de la caisse.",
                    label = "Récompense maximale de la caisse",
                },
                shopRegisterRewardMinimum = {
                    description = "Le paiement minimal du tiroir.",
                    label = "Récompense minimale du tiroir",
                },
                shopRegisterRewardName = {
                    description = "Nom d'objet ou de compte optionnel.",
                    label = "Nom de la récompense de la caisse",
                },
                shopRegisterRewardSort = {
                    description = "Choisissez entre les espèces et l'objet black_money.",
                    label = "Type de paiement de la caisse",
                },
                shopRegisters = {
                    description = "Positions de caisse assignées par ID de magasin.",
                    itemLabel = "Caisse",
                    label = "Caisses enregistreuses",
                },
                shopSafeLootDurationSeconds = {
                    description = "Secondes requises pour prendre l'argent après avoir saisi un code de coffre-fort valide.",
                    label = "Durée du pillage du coffre-fort",
                },
                shopSafeRewardMaximum = {
                    description = "Plus gros paiement du coffre-fort.",
                    label = "Récompense maximale du coffre-fort",
                },
                shopSafeRewardMinimum = {
                    description = "Paiement minimal du coffre-fort.",
                    label = "Récompense minimale du coffre-fort",
                },
                shopSafeRewardName = {
                    description = "Nom d'objet ou de compte optionnel.",
                    label = "Nom de la récompense du coffre-fort",
                },
                shopSafeRewardSort = {
                    description = "Choisissez entre les espèces et l'objet black_money.",
                    label = "Type de paiement du coffre-fort",
                },
                shopThreatGraceSeconds = {
                    description = "Interruption autorisée avant l'alarme.",
                    label = "Marge de tolérance de visée",
                },
                territoryDrugSalesEnabled = {
                    description = "Les ventes de rue réussies aux PNJ accordent de l'influence au gang du vendeur dans le territoire de rue actuel.",
                    label = "Les ventes aux PNJ accordent de l'influence territoriale",
                },
                atmLocationMode = {
                    label = "Mode d'emplacement des distributeurs",
                    description = "Détecte automatiquement les objets pris en charge dans le monde ou utilise uniquement les emplacements configurés manuellement.",
                    options = {
                        automatic = "Automatique",
                        manual = "Manuel",
                    },
                },
                atmPoliceRequirementEnabled = {
                    label = "Exiger des policiers en service",
                    description = "Exige le nombre configuré de policiers en service avant de pouvoir braquer un distributeur.",
                },
                openDrugCreator = {
                    label = "Éditeur de drogues",
                    description = "Ouvre l'éditeur de drogues Sky Crime et ferme le configurateur de métier.",
                    buttonLabel = "Ouvrir l'éditeur de drogues",
                    unsavedTooltip = "Enregistrer d'abord",
                },
                drugCreatorRuntimeDensity = {
                    label = "Densité du panneau d'activité",
                    description = "Détermine la compacité du panneau de fonctionnement dans l'éditeur de drogues.",
                    options = {
                        comfortable = "Confortable",
                        compact = "Compacte",
                    },
                },
                drugCreatorListDensity = {
                    label = "Densité de la liste",
                    description = "Détermine la compacité de la liste des entrées dans l'éditeur.",
                    options = {
                        comfortable = "Confortable",
                        compact = "Compacte",
                    },
                },
                drugCreatorShowEmptyRuntimeLists = {
                    label = "Afficher les listes d'activité vides",
                    description = "Affiche les sections du panneau d'activité même sans entrées.",
                },
                drugCreatorHideDisabledEntries = {
                    label = "Masquer les entrées désactivées",
                    description = "Masque les entrées de modules désactivées dans la liste de l'éditeur de drogues.",
                },
                drugCreatorAutoGenerateId = {
                    label = "Générer les ID automatiquement",
                    description = "Génère les identifiants à partir des noms lors de la création d'entrées dans l'éditeur de drogues.",
                },
                drugCreatorOpenEditorOnModuleChange = {
                    label = "Ouvrir l'éditeur au changement de module",
                    description = "Ouvre automatiquement l'éditeur lors du changement de module actif.",
                },
                drugCreatorSmartDuplicateSuffix = {
                    label = "Suffixe automatique des copies",
                    description = "Ajoute un suffixe généré automatiquement lors de la duplication d'entrées dans l'éditeur de drogues.",
                },
                drugCreatorAutoSelectRuntimeTargets = {
                    label = "Présélectionner les cibles en jeu",
                    description = "Présélectionne automatiquement les laboratoires et les lots disponibles.",
                },
                drugCreatorAttentionOnOpen = {
                    label = "Afficher les problèmes à l'ouverture",
                    description = "Ouvre le panneau d'activité en se concentrant sur les entrées nécessitant une attention.",
                },
                drugActivityHudPosition = {
                    label = "Position du HUD d'activité",
                    description = "Faites glisser le HUD de placement et de récolte à l'emplacement souhaité à l'écran.",
                },
                drugInteractionHudPosition = {
                    label = "Position du HUD d'interaction",
                    description = "Faites glisser le HUD d'interaction des plantes, laboratoires et camping-cars à l'emplacement souhaité.",
                },
                drugPlantStatusHudPosition = {
                    label = "Position du HUD d'état de plante",
                    description = "Faites glisser le HUD détaillé de la plante à l'emplacement souhaité à l'écran.",
                },
                drugSystemEnabled = {
                    label = "Système de drogues",
                    description = "Active : production de drogues, données de l'éditeur et interfaces de jeu pour ce métier criminel.",
                },
                drugCreatorAccess = {
                    label = "Accès à l'éditeur de drogues",
                    description = "Détermine qui peut ouvrir l'éditeur avancé de drogues.",
                    options = {
                        permission = "Avec autorisation uniquement",
                        job_management = "Gestion du métier",
                        owner_only = "Propriétaire uniquement",
                    },
                },
                drugRuntimeEnabled = {
                    label = "Interfaces d'activité",
                    description = "Autorise les joueurs à utiliser en jeu les actions des laboratoires, plantes, traitements et marchés.",
                },
                drugRuntimePlayerCreateLabs = {
                    label = "Création de laboratoires par les joueurs",
                    description = "Autorise les joueurs ayant accès au système à créer des laboratoires à partir des modèles de l'éditeur, sans être administrateurs.",
                },
                drugRuntimeOutdoorPlanting = {
                    label = "Culture en extérieur",
                    description = "Autorise les cultures extérieures appartenant aux joueurs hors des laboratoires configurés.",
                },
                drugRuntimePublicOutdoorHarvest = {
                    label = "Récolte extérieure par d'autres joueurs",
                    description = "Autorise les autres joueurs à récolter les plantes extérieures qu'ils n'ont pas plantées.",
                },
                drugRuntimeChargeLabPurchase = {
                    label = "Facturer l'achat du laboratoire",
                    description = "Facture aux joueurs le prix d'achat configuré lors de la création d'un laboratoire.",
                },
                drugRuntimeStrictInventory = {
                    label = "Vérifier strictement l'inventaire",
                    description = "Les actions ne continuent que si les opérations configurées sur les objets, outils et fonds réussissent.",
                },
                drugRuntimeSalePayouts = {
                    label = "Vente / Versements",
                    description = "Rémunère les joueurs lorsque des lots ou des routes sont vendus via le système de marché.",
                },
                drugRuntimeSalePayoutAccount = {
                    label = "Paiement / Compte",
                    description = "Compte utilisé pour les paiements des ventes de drogues, par exemple black_money.",
                },
                drugRuntimeDispatchEnabled = {
                    label = "Expédition / Alertes",
                    description = "Transmet les événements liés aux risques de drogue à la centrale et aux métiers de police configurés.",
                },
                drugRuntimeNotifyPoliceJobs = {
                    label = "Police / Notifications",
                    description = "Avertit les métiers de police configurés lorsqu'un événement de risque lié aux drogues déclenche une alerte.",
                },
                drugBatchPrefix = {
                    label = "Lot / Préfixe",
                    description = "Préfixe des identifiants des nouveaux lots de drogues.",
                },
                drugTestingKitAccuracy = {
                    label = "Kit de test / Précision",
                    description = "Écart autorisé des valeurs cachées avec un kit de test basique.",
                },
                drugDecayIntervalMinutes = {
                    label = "Déclin / Intervalle",
                    description = "Intervalle en minutes pour contrôles de dégradation de fraîcheur et de réduction de contamination.",
                },
                drugDefaultPackaging = {
                    label = "Valeur par défaut / Emballage",
                    description = "Emballage des lots bruts ou transformés créés sans type d'emballage explicite.",
                    options = {
                        loose = "Vrac",
                        baggy = "Sachet",
                        jar = "Bocal",
                        vacuum = "Sac sous vide",
                        brick = "Emballage de bloc",
                        premium_seal = "Scellage supérieur",
                    },
                },
                drugQualityWeightQuality = {
                    label = "Qualité / Poids",
                    description = "Influence sur la qualité finale : Qualité de base.",
                },
                drugQualityWeightPurity = {
                    label = "Pureté / Poids",
                    description = "Influence sur la qualité finale : Pureté.",
                },
                drugQualityWeightFreshness = {
                    label = "Fraîcheur / Poids",
                    description = "Influence sur la qualité finale : Fraîcheur.",
                },
                drugQualityWeightPotency = {
                    label = "Puissance / Poids",
                    description = "Influence sur la qualité finale : Puissance.",
                },
                drugQualityWeightStability = {
                    label = "Stabilité / Poids",
                    description = "Influence sur la qualité finale : Stabilité.",
                },
                drugQualityWeightContamination = {
                    label = "Contamination / Pénalité",
                    description = "Pénalité appliquée à la qualité des produits contaminés.",
                },
                drugTierGoodMin = {
                    label = "Bon / Niveau / Minimum",
                    description = "Score minimum pour le niveau de qualité Bon.",
                },
                drugTierPremiumMin = {
                    label = "Premium / Niveau / Minimum",
                    description = "Score minimum pour le niveau de qualité Premium.",
                },
                drugTierTopShelfMin = {
                    label = "Qualité exceptionnelle / Niveau / Minimum",
                    description = "Score minimum pour le niveau de qualité Qualité exceptionnelle.",
                },
                drugTierLabGradeMin = {
                    label = "Qualité laboratoire / Niveau / Minimum",
                    description = "Score minimum pour le niveau de qualité Qualité laboratoire.",
                },
                drugBaggyDecayMultiplier = {
                    label = "Sachet / Déclin",
                    description = "Multiplicateur pour perte de fraîcheur / Sachets.",
                },
                drugJarDecayMultiplier = {
                    label = "Bocal / Déclin",
                    description = "Multiplicateur pour perte de fraîcheur / Bocaux.",
                },
                drugVacuumDecayMultiplier = {
                    label = "Vide / Déclin",
                    description = "Multiplicateur pour perte de fraîcheur / Sacs sous vide.",
                },
                drugPremiumSealPriceMultiplier = {
                    label = "Scellage supérieur / Prix",
                    description = "Multiplicateur pour Premium / Produit scellé / Prix.",
                },
                drugGrowingEnabled = {
                    label = "Culture / Activé",
                    description = "Active : croissance des plantes et récolte.",
                },
                drugEnvironmentSurveyEnabled = {
                    label = "Vérification du lieu de plantation",
                    description = "Si cette option est activée, les plantes placées librement attendent une vérification automatique du lieu par un administrateur. Désactivez-la pour permettre la croissance sans autorisation administrative.",
                },
                drugGrowthTickMinutes = {
                    label = "Croissance / Cycle de mise à jour / Minutes",
                    description = "Intervalle en minutes pour mises à jour de la croissance des plantes.",
                },
                drugBaseGrowthPerTick = {
                    label = "Valeur de base / Croissance / Par cycle de mise à jour",
                    description = "Croissance de base avant les modificateurs de variété, d'équipement et de soin.",
                },
                drugWildPlantRespawnMinutes = {
                    label = "Plante sauvage / Réapparition",
                    description = "Délai en minutes avant : Plante sauvage / Réapparition.",
                },
                drugWildPlantHighlightEnabled = {
                    label = "Mettre en évidence les plantes sauvages",
                    description = "Affiche le contour des plantes sauvages générées quand un joueur entre dans le rayon de surbrillance.",
                },
                drugWildPlantHighlightDistance = {
                    label = "Rayon de surbrillance des plantes sauvages",
                    description = "Distance en mètres autour de chaque plante sauvage générée à laquelle son contour devient visible.",
                },
                drugDefaultPlantWater = {
                    label = "Valeur par défaut / Eau",
                    description = "Valeur initiale à la création d'une plante : Eau.",
                },
                drugDefaultPlantFertilizer = {
                    label = "Valeur par défaut / Engrais",
                    description = "Valeur initiale à la création d'une plante : Engrais.",
                },
                drugDefaultPlantHealth = {
                    label = "Valeur par défaut / Santé",
                    description = "Valeur initiale à la création d'une plante : Santé.",
                },
                drugDefaultPlantMutationChance = {
                    label = "Valeur par défaut / Chance de mutation",
                    description = "Probabilité de mutation de base si la variété ne définit pas de valeur spécifique.",
                },
                drugHarvestPerfectStart = {
                    label = "Début de la récolte optimale",
                    description = "Pourcentage de croissance pour la période de récolte optimale : Début.",
                },
                drugHarvestPerfectEnd = {
                    label = "Fin de la récolte optimale",
                    description = "Pourcentage de croissance pour la période de récolte optimale : Fin.",
                },
                drugLabsEnabled = {
                    label = "Laboratoires / Activé",
                    description = "Active : laboratoires et camping-cars en jeu.",
                },
                drugMaxLaboratoriesPerCharacter = {
                    label = "Laboratoires par personnage",
                    description = "Nombre maximal de laboratoires fixes achetés ou loués par propriétaire. 0 signifie illimité ; les camping-cars et les accès partagés ne comptent pas.",
                },
                drugMaxLaboratoriesPerFaction = {
                    label = "Laboratoires par faction",
                    description = "Nombre maximal de laboratoires fixes achetés ou loués par propriétaire. 0 signifie illimité ; les camping-cars et les accès partagés ne comptent pas.",
                },
                drugDefaultRentDays = {
                    label = "Valeur par défaut / Jours de location",
                    description = "Valeur par défaut pour Labo / Loyer / Durée.",
                },
                drugCamperHotVehicleMinutes = {
                    label = "Camping-car volé / Minutes",
                    description = "Durée pendant laquelle les camping-cars volés présentent un risque accru.",
                },
                drugLabRentWarningHours = {
                    label = "Loyer / Alerte / Heures",
                    description = "Nombre d'heures avant l'expiration de la location du laboratoire où un avertissement apparaît.",
                },
                drugLabRentExpiredHeatGain = {
                    label = "Location expirée / Pression policière",
                    description = "Suspicion ajoutée à l'expiration de la location du laboratoire.",
                },
                drugCamperMoveCooldownMinutes = {
                    label = "Camping-car / Déplacer / Temps de recharge",
                    description = "Délai en minutes avant : Camping-car / Labo / Nouveau déplacement.",
                },
                drugLabUpgradeCostMultiplier = {
                    label = "Amélioration / Coût / Multiplicateur",
                    description = "Multiplicateur pour Labo / Niveau / Amélioration / Prix.",
                },
                drugCamperBaseSlots = {
                    label = "Camping-car / Emplacements",
                    description = "Valeur par défaut pour laboratoires mobiles / emplacements d'équipement.",
                },
                drugCamperBaseStorage = {
                    label = "Camping-car / Stockage",
                    description = "Valeur par défaut pour laboratoires mobiles / Capacité de stockage.",
                },
                drugCamperBasePower = {
                    label = "Camping-car / Énergie",
                    description = "Valeur par défaut pour laboratoires mobiles / Alimentation intégrée.",
                },
                drugBasementBaseSlots = {
                    label = "Sous-sol / Emplacements",
                    description = "Valeur par défaut pour laboratoires en sous-sol / emplacements d'équipement.",
                },
                drugBasementBaseStorage = {
                    label = "Sous-sol / Stockage",
                    description = "Valeur par défaut pour laboratoires en sous-sol / Capacité de stockage.",
                },
                drugWarehouseBasePower = {
                    label = "Entrepôt / Énergie",
                    description = "Valeur par défaut pour laboratoires d'entrepôt / Alimentation intégrée.",
                },
                drugPowerEnabled = {
                    label = "Énergie / Système",
                    description = "Active : production électrique, consommation et contrôles de surcharge du laboratoire.",
                },
                drugOverloadGraceSeconds = {
                    label = "Surcharge / Délai de grâce",
                    description = "Délai en secondes avant qu'une surcharge électrique devienne dangereuse.",
                },
                drugHeatPerKilowatt = {
                    label = "Pression policière / Par kilowatt",
                    description = "Suspicion du laboratoire générée par sa consommation électrique.",
                },
                drugGeneratorT1Watts = {
                    label = "Générateur T1 / Watts",
                    description = "Puissance des générateurs de niveau T1 en watts.",
                },
                drugGeneratorT2Watts = {
                    label = "Générateur T2 / Watts",
                    description = "Puissance des générateurs de niveau T2 en watts.",
                },
                drugGeneratorT3Watts = {
                    label = "Générateur T3 / Watts",
                    description = "Puissance des générateurs de niveau T3 en watts.",
                },
                drugEquipmentConditionWearMultiplier = {
                    label = "Usure / Multiplicateur",
                    description = "Multiplicateur global pour Usure de l'équipement / Traitement.",
                },
                drugWorkersEnabled = {
                    label = "Employés / Activé",
                    description = "Active : chimistes, cultivateurs, emballeurs et agents de sécurité dans les laboratoires de drogues.",
                },
                drugMaxWorkersPerLab = {
                    label = "Maximum / Employés / Labo",
                    description = "Nombre maximal d'employés par laboratoire.",
                },
                drugWorkerFatiguePerProcessStep = {
                    label = "Fatigue de transformation",
                    description = "Fatigue ajoutée pour Employés après cette tâche : Étape de transformation.",
                },
                drugWorkerFatiguePerGrowAction = {
                    label = "Culture / Fatigue",
                    description = "Fatigue ajoutée pour Cultivateurs après cette tâche : Récolte ou culture.",
                },
                drugWorkerRecoveryPerTick = {
                    label = "Travailleur / Récupération",
                    description = "Récupération de Fatigue à chaque étape : Mise à jour de croissance.",
                },
                drugMarketEnabled = {
                    label = "Marché / Activé",
                    description = "Active : acheteurs, dealers et ventes de lots.",
                },
                drugMarketBasePriceFallback = {
                    label = "Valeur de remplacement / Prix de base",
                    description = "Prix de base des drogues sans prix spécifique configuré.",
                },
                drugMarketStreetMultiplier = {
                    label = "Rue / Multiplicateur",
                    description = "Multiplicateur global pour Prix / Vente de rue.",
                },
                drugMarketWholesaleMultiplier = {
                    label = "Vente en gros / Multiplicateur",
                    description = "Multiplicateur global pour Prix / Vente en gros / Transactions.",
                },
                drugMarketPremiumMultiplier = {
                    label = "Premium / Multiplicateur",
                    description = "Multiplicateur global pour Prix / Premium / Acheteurs.",
                },
                drugMarketHeatPerSale = {
                    label = "Pression policière / Vente",
                    description = "Pression policière de base ajoutée au laboratoire lors de la vente d'un lot.",
                },
                drugDistributionTickMinutes = {
                    label = "Distribution / Cycle de mise à jour",
                    description = "Intervalle en minutes pour mises à jour de la distribution des dealers.",
                },
                drugDistributionIntervalMinutes = {
                    label = "Distribution / Intervalle",
                    description = "Valeur par défaut pour Dealer / Délai avant vente / Minutes.",
                },
                drugDistributionMaxPerDealer = {
                    label = "Maximum / Dealer / Commandes",
                    description = "Valeur par défaut pour Dealer / nombre maximal de commandes de distribution actives.",
                },
                drugThreatsEnabled = {
                    label = "Menaces / Activé",
                    description = "Active : baisse de suspicion, descentes et sabotages dans les laboratoires.",
                },
                drugThreatTickMinutes = {
                    label = "Menace / Cycle de mise à jour",
                    description = "Intervalle en minutes pour baisse de suspicion et contrôles de descente et de sabotage.",
                },
                drugRaidHeatThreshold = {
                    label = "Seuil de suspicion des descentes",
                    description = "Pression policière requise au laboratoire avant de pouvoir déclencher : Raids.",
                },
                drugSabotageHeatThreshold = {
                    label = "Seuil de suspicion du sabotage",
                    description = "Pression policière requise au laboratoire avant de pouvoir déclencher : Sabotage.",
                },
                drugThreatHeatDecay = {
                    label = "Pression policière / Déclin",
                    description = "Réduit la suspicion du laboratoire de cette valeur à chaque mise à jour des menaces.",
                },
                drugRaidChanceAtThreshold = {
                    label = "Probabilité de descente",
                    description = "Probabilité de base pour Raid lorsque le seuil de pression policière associé est atteint.",
                },
                drugSabotageChanceAtThreshold = {
                    label = "Sabotage / Chance",
                    description = "Probabilité de base pour Sabotage lorsque le seuil de pression policière associé est atteint.",
                },
                drugConsumptionEnabled = {
                    label = "Consommation activée",
                    description = "Active : effets des drogues et suivi de la tolérance et de la dépendance.",
                },
                drugDoseConsumesBatch = {
                    label = "Consommer le lot à l'utilisation",
                    description = "Retire un lot consommé du stock actif.",
                },
                drugToleranceDecayMinutes = {
                    label = "Tolérance / Déclin",
                    description = "Intervalle en minutes pour mises à jour de la baisse de tolérance.",
                },
                drugAddictionDecayMinutes = {
                    label = "Addiction / Déclin",
                    description = "Intervalle en minutes pour mises à jour de la baisse de dépendance.",
                },
                drugPotencyEffectMultiplier = {
                    label = "Puissance / Multiplicateur",
                    description = "Détermine à quel point la puissance augmente l'intensité des effets.",
                },
                drugOverdosePotencyThreshold = {
                    label = "Surdose / Seuil",
                    description = "Charge de puissance requise avant qu'une overdose puisse être tirée au sort.",
                },
                drugBaseAddictionGain = {
                    label = "Valeur de base / Addiction / gain",
                    description = "Augmentation de base de la dépendance par dose.",
                },
                drugProcessingEnabled = {
                    label = "Traitement / Activé",
                    description = "Active : tâches de transformation, emballage et kits de test.",
                },
                drugBatchMetadataItemKey = {
                    label = "Lot / Métadonnées / Clé",
                    description = "Clé de métadonnées d'inventaire utilisée par les intégrations pour les données de lot.",
                },
                drugDefaultProcessDuration = {
                    label = "Durée de transformation par défaut",
                    description = "Valeur par défaut pour Traitement / Durée / secondes / Sans valeur propre à la recette.",
                },
                drugDefaultFailureRisk = {
                    label = "Valeur par défaut / Risque d'échec",
                    description = "Valeur par défaut pour Traitement / Risque d'échec / Sans valeur propre à la recette.",
                },
                drugPackagingDuration = {
                    label = "Durée d'emballage",
                    description = "Valeur par défaut pour Emballage / Durée / secondes.",
                },
                drugPowerTickSeconds = {
                    label = "Énergie / Cycle de mise à jour / secondes",
                    description = "Intervalle en secondes pour mise à jour de la consommation des générateurs et des signatures électriques.",
                },
                drugPowerSignatureHeatPerHour = {
                    label = "Signature électrique / Pression policière / Heure",
                    description = "Suspicion générée par heure par la signature électrique du laboratoire.",
                },
                drugPowerOverloadHeatPerHour = {
                    label = "Surcharge / Pression policière / Heure",
                    description = "Pression policière supplémentaire par heure lorsque le laboratoire est surchargé.",
                },
                drugPowerIdleHeatDecayPerHour = {
                    label = "Inactif / Pression policière / Déclin / Heure",
                    description = "Baisse de suspicion par heure lorsque le laboratoire n'a aucune signature électrique active.",
                },
                drugPowerModeManualMaxLoadPercent = {
                    label = "Manuel / Maximum / Charge",
                    description = "Valeur pour le mode énergétique Manuel : Maximum / Charge.",
                },
                drugPowerModeManualHeatMultiplier = {
                    label = "Manuel / Pression policière / Multiplicateur",
                    description = "Valeur pour le mode énergétique Manuel : Pression policière / Multiplicateur.",
                },
                drugPowerModeManualNoiseMultiplier = {
                    label = "Manuel / Bruit / Multiplicateur",
                    description = "Valeur pour le mode énergétique Manuel : Bruit / Multiplicateur.",
                },
                drugPowerModeBalancedMaxLoadPercent = {
                    label = "Équilibré / Maximum / Charge",
                    description = "Valeur pour le mode énergétique Équilibré : Maximum / Charge.",
                },
                drugPowerModeBalancedHeatMultiplier = {
                    label = "Équilibré / Pression policière / Multiplicateur",
                    description = "Valeur pour le mode énergétique Équilibré : Pression policière / Multiplicateur.",
                },
                drugPowerModeBalancedNoiseMultiplier = {
                    label = "Équilibré / Bruit / Multiplicateur",
                    description = "Valeur pour le mode énergétique Équilibré : Bruit / Multiplicateur.",
                },
                drugPowerModeStealthMaxLoadPercent = {
                    label = "Discret / Maximum / Charge",
                    description = "Valeur pour le mode énergétique Discret : Maximum / Charge.",
                },
                drugPowerModeStealthHeatMultiplier = {
                    label = "Discret / Pression policière / Multiplicateur",
                    description = "Valeur pour le mode énergétique Discret : Pression policière / Multiplicateur.",
                },
                drugPowerModeStealthNoiseMultiplier = {
                    label = "Discret / Bruit / Multiplicateur",
                    description = "Valeur pour le mode énergétique Discret : Bruit / Multiplicateur.",
                },
                drugPowerPrioritySmellControl = {
                    label = "Contrôle des odeurs / Priorité",
                    description = "Priorité de délestage automatique : Contrôle des odeurs / Équipement.",
                },
                drugPowerPriorityAirflow = {
                    label = "Ventilation / Priorité",
                    description = "Priorité de délestage automatique : Ventilation / Équipement.",
                },
                drugPowerPrioritySecurity = {
                    label = "Sécurité / Priorité",
                    description = "Priorité de délestage automatique : Équipement de sécurité.",
                },
                drugPowerPriorityGrowing = {
                    label = "Culture / Priorité",
                    description = "Priorité de délestage automatique : Culture / Équipement.",
                },
                drugPowerPriorityLight = {
                    label = "Éclairage / Priorité",
                    description = "Priorité de délestage automatique : Éclairage / Équipement.",
                },
                drugPowerPriorityTesting = {
                    label = "Analyse / Priorité",
                    description = "Priorité de délestage automatique : Analyse / Équipement.",
                },
                drugPowerPriorityPackaging = {
                    label = "Emballage / Priorité",
                    description = "Priorité de délestage automatique : Emballage / Équipement.",
                },
                drugPowerPriorityChemistry = {
                    label = "Chimie / Priorité",
                    description = "Priorité de délestage automatique : Chimie / Équipement.",
                },
                drugPowerPriorityHeating = {
                    label = "Chauffage / Priorité",
                    description = "Priorité de délestage automatique : Chauffage / Équipement.",
                },
                drugPowerPriorityPressing = {
                    label = "Pressage / Priorité",
                    description = "Priorité de délestage automatique : Pressage / Équipement.",
                },
                drugPowerPriorityGeneral = {
                    label = "Général / Priorité",
                    description = "Priorité de délestage automatique : Équipement général.",
                },
                drugAdvancedPerformanceInactiveControlIntervalMs = {
                    label = "Performances / Inactif / Contrôles / Intervalle / ms",
                    description = "Paramètre de fonctionnement pour Performances / Inactif / Contrôles / Intervalle / ms.",
                },
                drugAdvancedPerformanceInteractionIdleScanIntervalMs = {
                    label = "Performances / Interaction / Inactif / Intervalle d'analyse / ms",
                    description = "Paramètre de fonctionnement pour Performances / Interaction / Inactif / Intervalle d'analyse / ms.",
                },
                drugAdvancedPerformanceInteractionPromptIntervalMs = {
                    label = "Performances / Interaction / Invite d'interaction / Intervalle / ms",
                    description = "Paramètre de fonctionnement pour Performances / Interaction / Invite d'interaction / Intervalle / ms.",
                },
                drugAdvancedPerformanceInteractionScanIntervalMs = {
                    label = "Performances / Interaction / Intervalle d'analyse / ms",
                    description = "Paramètre de fonctionnement pour Performances / Interaction / Intervalle d'analyse / ms.",
                },
                drugAdvancedPerformanceMinimumScanIntervalMs = {
                    label = "Performances / Minimum / Intervalle d'analyse / ms",
                    description = "Paramètre de fonctionnement pour Performances / Minimum / Intervalle d'analyse / ms.",
                },
                drugAdvancedPerformanceStreetPedActivationDistance = {
                    label = "Performances / Rue / PNJ / Activation / Distance",
                    description = "Paramètre de fonctionnement pour Performances / Rue / PNJ / Activation / Distance.",
                },
                drugAdvancedPerformanceStreetPedIdleScanIntervalMs = {
                    label = "Performances / Rue / PNJ / Inactif / Intervalle d'analyse / ms",
                    description = "Paramètre de fonctionnement pour Performances / Rue / PNJ / Inactif / Intervalle d'analyse / ms.",
                },
                drugAdvancedPerformanceStreetPedScanIntervalMs = {
                    label = "Performances / Rue / PNJ / Intervalle d'analyse / ms",
                    description = "Paramètre de fonctionnement pour Performances / Rue / PNJ / Intervalle d'analyse / ms.",
                },
                drugAdvancedPerformanceWorldCachePadding = {
                    label = "Performances / Monde / Cache / Marge supplémentaire",
                    description = "Paramètre de fonctionnement pour Performances / Monde / Cache / Marge supplémentaire.",
                },
                drugAdvancedPerformanceWorldCacheRefreshIntervalMs = {
                    label = "Performances / Monde / Cache / Actualisation / Intervalle / ms",
                    description = "Paramètre de fonctionnement pour Performances / Monde / Cache / Actualisation / Intervalle / ms.",
                },
                drugAdvancedPerformanceWorldIdleIntervalMs = {
                    label = "Performances / Monde / Inactif / Intervalle / ms",
                    description = "Paramètre de fonctionnement pour Performances / Monde / Inactif / Intervalle / ms.",
                },
                drugAdvancedDynamicMarketActionCooldownSeconds = {
                    label = "Marché Dynamique / Délai de récupération de l'action / secondes",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Délai de récupération de l'action / secondes.",
                },
                drugAdvancedDynamicMarketActionHistoryLimit = {
                    label = "Marché Dynamique / Action / Limite de l'historique",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Action / Limite de l'historique.",
                },
                drugAdvancedDynamicMarketAmountSaturationWeight = {
                    label = "Marché Dynamique / Quantité / Saturation / Poids",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Quantité / Saturation / Poids.",
                },
                drugAdvancedDynamicMarketBaseIntelAccuracy = {
                    label = "Marché Dynamique / Valeur de base / Précision du renseignement",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Valeur de base / Précision du renseignement.",
                },
                drugAdvancedDynamicMarketDefaultAverageQuality = {
                    label = "Marché Dynamique / Valeur par défaut / Moyenne / Qualité",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Valeur par défaut / Moyenne / Qualité.",
                },
                drugAdvancedDynamicMarketDefaultResourceElasticity = {
                    label = "Marché Dynamique / Valeur par défaut / Ressource / Élasticité",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Valeur par défaut / Ressource / Élasticité.",
                },
                drugAdvancedDynamicMarketDemandCenter = {
                    label = "Marché Dynamique / Demande / Valeur centrale",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Demande / Valeur centrale.",
                },
                drugAdvancedDynamicMarketDemandPriceImpact = {
                    label = "Marché Dynamique / Demande / Prix / Impact",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Demande / Prix / Impact.",
                },
                drugAdvancedDynamicMarketDirectionThreshold = {
                    label = "Marché Dynamique / Direction / Seuil",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Direction / Seuil.",
                },
                drugAdvancedDynamicMarketEnabled = {
                    label = "Marché Dynamique / Activé",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Activé.",
                },
                drugAdvancedDynamicMarketEventChance = {
                    label = "Marché Dynamique / Événement / Chance",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événement / Chance.",
                },
                drugAdvancedDynamicMarketEventDurationMinutes = {
                    label = "Marché Dynamique / Événement / Durée / Minutes",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événement / Durée / Minutes.",
                },
                drugAdvancedDynamicMarketEventMinimumDurationMinutes = {
                    label = "Marché Dynamique / Événement / Minimum / Durée / Minutes",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événement / Minimum / Durée / Minutes.",
                },
                drugAdvancedDynamicMarketEventStrengthMaximum = {
                    label = "Marché Dynamique / Événement / Intensité / Maximum",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événement / Intensité / Maximum.",
                },
                drugAdvancedDynamicMarketEventStrengthMinimum = {
                    label = "Marché Dynamique / Événement / Intensité / Minimum",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événement / Intensité / Minimum.",
                },
                drugAdvancedDynamicMarketEventsCrackdownDemand = {
                    label = "Marché Dynamique / Événements / Opération policière / Demande",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Opération policière / Demande.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPolice = {
                    label = "Marché Dynamique / Événements / Opération policière / Police",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Opération policière / Police.",
                },
                drugAdvancedDynamicMarketEventsCrackdownPrice = {
                    label = "Marché Dynamique / Événements / Opération policière / Prix",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Opération policière / Prix.",
                },
                drugAdvancedDynamicMarketEventsFestivalDemand = {
                    label = "Marché Dynamique / Événements / Festival / Demande",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Festival / Demande.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem1 = {
                    label = "Marché Dynamique / Événements / Festival / Effets / 1",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Festival / Effets / 1.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem2 = {
                    label = "Marché Dynamique / Événements / Festival / Effets / 2",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Festival / Effets / 2.",
                },
                drugAdvancedDynamicMarketEventsFestivalEffectsItem3 = {
                    label = "Marché Dynamique / Événements / Festival / Effets / 3",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Festival / Effets / 3.",
                },
                drugAdvancedDynamicMarketEventsFestivalPrice = {
                    label = "Marché Dynamique / Événements / Festival / Prix",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Festival / Prix.",
                },
                drugAdvancedDynamicMarketEventsFestivalProfilesItem1 = {
                    label = "Marché Dynamique / Événements / Festival / Profils / 1",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Festival / Profils / 1.",
                },
                drugAdvancedDynamicMarketEventsGangconflictDemand = {
                    label = "Marché Dynamique / Événements / Conflit de gangs / Demande",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Conflit de gangs / Demande.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPolice = {
                    label = "Marché Dynamique / Événements / Conflit de gangs / Police",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Conflit de gangs / Police.",
                },
                drugAdvancedDynamicMarketEventsGangconflictPrice = {
                    label = "Marché Dynamique / Événements / Conflit de gangs / Prix",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Conflit de gangs / Prix.",
                },
                drugAdvancedDynamicMarketEventsGangconflictProfilesItem1 = {
                    label = "Marché Dynamique / Événements / Conflit de gangs / Profils / 1",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Conflit de gangs / Profils / 1.",
                },
                drugAdvancedDynamicMarketEventsLabbustDemand = {
                    label = "Marché Dynamique / Événements / Descente au laboratoire / Demande",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Descente au laboratoire / Demande.",
                },
                drugAdvancedDynamicMarketEventsLabbustPolice = {
                    label = "Marché Dynamique / Événements / Descente au laboratoire / Police",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Descente au laboratoire / Police.",
                },
                drugAdvancedDynamicMarketEventsLabbustPrice = {
                    label = "Marché Dynamique / Événements / Descente au laboratoire / Prix",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Descente au laboratoire / Prix.",
                },
                drugAdvancedDynamicMarketEventsLabbustSupply = {
                    label = "Marché Dynamique / Événements / Descente au laboratoire / Approvisionnement",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Descente au laboratoire / Approvisionnement.",
                },
                drugAdvancedDynamicMarketEventsPartyDemand = {
                    label = "Marché Dynamique / Événements / Fête / Demande",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Fête / Demande.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem1 = {
                    label = "Marché Dynamique / Événements / Fête / Effets / 1",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Fête / Effets / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem2 = {
                    label = "Marché Dynamique / Événements / Fête / Effets / 2",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Fête / Effets / 2.",
                },
                drugAdvancedDynamicMarketEventsPartyEffectsItem3 = {
                    label = "Marché Dynamique / Événements / Fête / Effets / 3",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Fête / Effets / 3.",
                },
                drugAdvancedDynamicMarketEventsPartyPrice = {
                    label = "Marché Dynamique / Événements / Fête / Prix",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Fête / Prix.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem1 = {
                    label = "Marché Dynamique / Événements / Fête / Profils / 1",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Fête / Profils / 1.",
                },
                drugAdvancedDynamicMarketEventsPartyProfilesItem2 = {
                    label = "Marché Dynamique / Événements / Fête / Profils / 2",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Fête / Profils / 2.",
                },
                drugAdvancedDynamicMarketEventsShortageDemand = {
                    label = "Marché Dynamique / Événements / Pénurie / Demande",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Pénurie / Demande.",
                },
                drugAdvancedDynamicMarketEventsShortagePrice = {
                    label = "Marché Dynamique / Événements / Pénurie / Prix",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Pénurie / Prix.",
                },
                drugAdvancedDynamicMarketEventsShortageSupply = {
                    label = "Marché Dynamique / Événements / Pénurie / Approvisionnement",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Événements / Pénurie / Approvisionnement.",
                },
                drugAdvancedDynamicMarketExactIntelReputation = {
                    label = "Marché Dynamique / Renseignements précis / Réputation",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements précis / Réputation.",
                },
                drugAdvancedDynamicMarketExactIntelTrust = {
                    label = "Marché Dynamique / Renseignements précis / Confiance",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements précis / Confiance.",
                },
                drugAdvancedDynamicMarketGlobalZoneLabel = {
                    label = "Marché Dynamique / Global / Zone / Libellé",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Global / Zone / Libellé.",
                },
                drugAdvancedDynamicMarketHistoryLimit = {
                    label = "Marché Dynamique / Limite de l'historique",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Limite de l'historique.",
                },
                drugAdvancedDynamicMarketInitialDemand = {
                    label = "Marché Dynamique / Valeur initiale / Demande",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Valeur initiale / Demande.",
                },
                drugAdvancedDynamicMarketInitialPriceMultiplier = {
                    label = "Marché Dynamique / Valeur initiale / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Valeur initiale / Multiplicateur de prix.",
                },
                drugAdvancedDynamicMarketIntelDemandError = {
                    label = "Marché Dynamique / Renseignements / Demande / Erreur",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Demande / Erreur.",
                },
                drugAdvancedDynamicMarketIntelMaximumAccuracy = {
                    label = "Marché Dynamique / Renseignements / Maximum / Précision",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Maximum / Précision.",
                },
                drugAdvancedDynamicMarketIntelMinimumAccuracy = {
                    label = "Marché Dynamique / Renseignements / Minimum / Précision",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Minimum / Précision.",
                },
                drugAdvancedDynamicMarketIntelPoliceError = {
                    label = "Marché Dynamique / Renseignements / Police / Erreur",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Police / Erreur.",
                },
                drugAdvancedDynamicMarketIntelPriceError = {
                    label = "Marché Dynamique / Renseignements / Prix / Erreur",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Prix / Erreur.",
                },
                drugAdvancedDynamicMarketIntelPriceMaximum = {
                    label = "Marché Dynamique / Renseignements / Prix / Maximum",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Prix / Maximum.",
                },
                drugAdvancedDynamicMarketIntelPriceMinimum = {
                    label = "Marché Dynamique / Renseignements / Prix / Minimum",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Prix / Minimum.",
                },
                drugAdvancedDynamicMarketIntelReputationWeight = {
                    label = "Marché Dynamique / Renseignements / Réputation / Poids",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Réputation / Poids.",
                },
                drugAdvancedDynamicMarketIntelResourcePriceError = {
                    label = "Marché Dynamique / Renseignements / Ressource / Prix / Erreur",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Ressource / Prix / Erreur.",
                },
                drugAdvancedDynamicMarketIntelSaturationError = {
                    label = "Marché Dynamique / Renseignements / Saturation / Erreur",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Saturation / Erreur.",
                },
                drugAdvancedDynamicMarketIntelSeedBucketSeconds = {
                    label = "Marché Dynamique / Fenêtre de graine des renseignements / secondes",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Fenêtre de graine des renseignements / secondes.",
                },
                drugAdvancedDynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Marché Dynamique / Renseignements / Statut / Précision / Seuil",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Statut / Précision / Seuil.",
                },
                drugAdvancedDynamicMarketIntelStatusErrorThreshold = {
                    label = "Marché Dynamique / Renseignements / Statut / Erreur / Seuil",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Statut / Erreur / Seuil.",
                },
                drugAdvancedDynamicMarketIntelSupplyError = {
                    label = "Marché Dynamique / Renseignements / Approvisionnement / Erreur",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Approvisionnement / Erreur.",
                },
                drugAdvancedDynamicMarketIntelTrustWeight = {
                    label = "Marché Dynamique / Renseignements / Confiance / Poids",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Renseignements / Confiance / Poids.",
                },
                drugAdvancedDynamicMarketManipulationCooldownMinutes = {
                    label = "Marché Dynamique / Manipulation / Minutes de délai",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Manipulation / Minutes de délai.",
                },
                drugAdvancedDynamicMarketManipulationDemandShift = {
                    label = "Marché Dynamique / Manipulation / Demande / Variation",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Manipulation / Demande / Variation.",
                },
                drugAdvancedDynamicMarketManipulationDurationMinutes = {
                    label = "Marché Dynamique / Manipulation / Durée / Minutes",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Manipulation / Durée / Minutes.",
                },
                drugAdvancedDynamicMarketManipulationHeat = {
                    label = "Marché Dynamique / Manipulation / Pression policière",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Manipulation / Pression policière.",
                },
                drugAdvancedDynamicMarketManipulationMinimumBatchAmount = {
                    label = "Marché Dynamique / Manipulation / Minimum / Lot / Quantité",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Manipulation / Minimum / Lot / Quantité.",
                },
                drugAdvancedDynamicMarketManipulationPaymentAccount = {
                    label = "Marché Dynamique / Manipulation / Compte de paiement",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Manipulation / Compte de paiement.",
                },
                drugAdvancedDynamicMarketManipulationPrice = {
                    label = "Marché Dynamique / Manipulation / Prix",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Manipulation / Prix.",
                },
                drugAdvancedDynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Marché Dynamique / Manipulation / Zone / Pression policière / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Manipulation / Zone / Pression policière / Multiplicateur.",
                },
                drugAdvancedDynamicMarketMaximumIntelAgeMinutes = {
                    label = "Marché Dynamique / Maximum / Âge du renseignement / Minutes",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Maximum / Âge du renseignement / Minutes.",
                },
                drugAdvancedDynamicMarketMaximumPriceMultiplier = {
                    label = "Marché Dynamique / Maximum / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Maximum / Multiplicateur de prix.",
                },
                drugAdvancedDynamicMarketMinimumIntelAgeMinutes = {
                    label = "Marché Dynamique / Minimum / Âge du renseignement / Minutes",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Minimum / Âge du renseignement / Minutes.",
                },
                drugAdvancedDynamicMarketMinimumMetricWindowMinutes = {
                    label = "Marché Dynamique / Minimum / Mesure / Fenêtre temporelle / Minutes",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Minimum / Mesure / Fenêtre temporelle / Minutes.",
                },
                drugAdvancedDynamicMarketMinimumPriceMultiplier = {
                    label = "Marché Dynamique / Prix minimum / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Prix minimum / Multiplicateur.",
                },
                drugAdvancedDynamicMarketMinimumUpdateMinutes = {
                    label = "Marché Dynamique / Minimum / Mise à jour / Minutes",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Minimum / Mise à jour / Minutes.",
                },
                drugAdvancedDynamicMarketPoliceDemandWeight = {
                    label = "Marché Dynamique / Police / Demande / Poids",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Police / Demande / Poids.",
                },
                drugAdvancedDynamicMarketPolicePriceImpact = {
                    label = "Marché Dynamique / Police / Prix / Impact",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Police / Prix / Impact.",
                },
                drugAdvancedDynamicMarketPoorQualityDemandPenalty = {
                    label = "Marché Dynamique / Mauvaise qualité / Demande / Pénalité",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Mauvaise qualité / Demande / Pénalité.",
                },
                drugAdvancedDynamicMarketPoorQualityThreshold = {
                    label = "Marché Dynamique / Mauvaise qualité / Seuil",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Mauvaise qualité / Seuil.",
                },
                drugAdvancedDynamicMarketPremiumQualityDemandBonus = {
                    label = "Marché Dynamique / Qualité supérieure / Bonus de demande",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Qualité supérieure / Bonus de demande.",
                },
                drugAdvancedDynamicMarketPremiumQualityThreshold = {
                    label = "Marché Dynamique / Qualité supérieure / Seuil",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Qualité supérieure / Seuil.",
                },
                drugAdvancedDynamicMarketProductionSupplyWeight = {
                    label = "Marché Dynamique / Production / Approvisionnement / Poids",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Production / Approvisionnement / Poids.",
                },
                drugAdvancedDynamicMarketProductionWindowMinutes = {
                    label = "Marché Dynamique / Production / Fenêtre temporelle / Minutes",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Production / Fenêtre temporelle / Minutes.",
                },
                drugAdvancedDynamicMarketQualityCenter = {
                    label = "Marché Dynamique / Qualité / Valeur centrale",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Qualité / Valeur centrale.",
                },
                drugAdvancedDynamicMarketQualityConfidenceImpact = {
                    label = "Marché Dynamique / Qualité / Confiance / Impact",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Qualité / Confiance / Impact.",
                },
                drugAdvancedDynamicMarketQualityRange = {
                    label = "Marché Dynamique / Qualité / Plage de valeurs",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Qualité / Plage de valeurs.",
                },
                drugAdvancedDynamicMarketRarityBonusMaximum = {
                    label = "Marché Dynamique / Rareté / Prime / Maximum",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Rareté / Prime / Maximum.",
                },
                drugAdvancedDynamicMarketRegionalGlobalWeight = {
                    label = "Marché Dynamique / Régional / Global / Poids",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Régional / Global / Poids.",
                },
                drugAdvancedDynamicMarketRegionalLocalWeight = {
                    label = "Marché Dynamique / Régional / Local / Poids",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Régional / Local / Poids.",
                },
                drugAdvancedDynamicMarketResourceAliasesDrugpackaging = {
                    label = "Marché Dynamique / Ressource / Alias / Drogue / Emballage",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressource / Alias / Drogue / Emballage.",
                },
                drugAdvancedDynamicMarketResourceAliasesFuelcan = {
                    label = "Marché Dynamique / Ressource / Alias / Bidon de carburant",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressource / Alias / Bidon de carburant.",
                },
                drugAdvancedDynamicMarketResourceAliasesMachineoil = {
                    label = "Marché Dynamique / Ressource / Alias / Huile pour machine",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressource / Alias / Huile pour machine.",
                },
                drugAdvancedDynamicMarketResourceAliasesPlantnutrients = {
                    label = "Marché Dynamique / Ressource / Alias / Nutriments pour plantes",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressource / Alias / Nutriments pour plantes.",
                },
                drugAdvancedDynamicMarketResourceAliasesRepairkit = {
                    label = "Marché Dynamique / Ressource / Alias / Kit de réparation",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressource / Alias / Kit de réparation.",
                },
                drugAdvancedDynamicMarketResourceDirectionFallThreshold = {
                    label = "Marché Dynamique / Ressource / Direction / Baisse / Seuil",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressource / Direction / Baisse / Seuil.",
                },
                drugAdvancedDynamicMarketResourceDirectionRiseThreshold = {
                    label = "Marché Dynamique / Ressource / Direction / Hausse / Seuil",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressource / Direction / Hausse / Seuil.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterBasePrice = {
                    label = "Marché Dynamique / Ressources / Filtre à charbon / Prix de base",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Filtre à charbon / Prix de base.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterElasticity = {
                    label = "Marché Dynamique / Ressources / Filtre à charbon / Élasticité",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Filtre à charbon / Élasticité.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLabel = {
                    label = "Marché Dynamique / Ressources / Filtre à charbon / Libellé",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Filtre à charbon / Libellé.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem1 = {
                    label = "Marché Dynamique / Ressources / Filtre à charbon / Drogues liées / 1",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Filtre à charbon / Drogues liées / 1.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem2 = {
                    label = "Marché Dynamique / Ressources / Filtre à charbon / Drogues liées / 2",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Filtre à charbon / Drogues liées / 2.",
                },
                drugAdvancedDynamicMarketResourcesCarbonfilterLinkedDrugsItem3 = {
                    label = "Marché Dynamique / Ressources / Filtre à charbon / Drogues liées / 3",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Filtre à charbon / Drogues liées / 3.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorBasePrice = {
                    label = "Marché Dynamique / Ressources / Précurseur chimique / Prix de base",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Précurseur chimique / Prix de base.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorElasticity = {
                    label = "Marché Dynamique / Ressources / Précurseur chimique / Élasticité",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Précurseur chimique / Élasticité.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLabel = {
                    label = "Marché Dynamique / Ressources / Précurseur chimique / Libellé",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Précurseur chimique / Libellé.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem1 = {
                    label = "Marché Dynamique / Ressources / Précurseur chimique / Drogues liées / 1",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Précurseur chimique / Drogues liées / 1.",
                },
                drugAdvancedDynamicMarketResourcesChemicalprecursorLinkedDrugsItem2 = {
                    label = "Marché Dynamique / Ressources / Précurseur chimique / Drogues liées / 2",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Précurseur chimique / Drogues liées / 2.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsBasePrice = {
                    label = "Marché Dynamique / Ressources / Pièces d'équipement / Prix de base",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Pièces d'équipement / Prix de base.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsElasticity = {
                    label = "Marché Dynamique / Ressources / Pièces d'équipement / Élasticité",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Pièces d'équipement / Élasticité.",
                },
                drugAdvancedDynamicMarketResourcesEquipmentpartsLabel = {
                    label = "Marché Dynamique / Ressources / Pièces d'équipement / Libellé",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Pièces d'équipement / Libellé.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerBasePrice = {
                    label = "Marché Dynamique / Ressources / Engrais / Prix de base",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Engrais / Prix de base.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerElasticity = {
                    label = "Marché Dynamique / Ressources / Engrais / Élasticité",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Engrais / Élasticité.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLabel = {
                    label = "Marché Dynamique / Ressources / Engrais / Libellé",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Engrais / Libellé.",
                },
                drugAdvancedDynamicMarketResourcesFertilizerLinkedDrugsItem1 = {
                    label = "Marché Dynamique / Ressources / Engrais / Drogues liées / 1",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Engrais / Drogues liées / 1.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelBasePrice = {
                    label = "Marché Dynamique / Ressources / Carburant de laboratoire / Prix de base",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Carburant de laboratoire / Prix de base.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelElasticity = {
                    label = "Marché Dynamique / Ressources / Carburant de laboratoire / Élasticité",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Carburant de laboratoire / Élasticité.",
                },
                drugAdvancedDynamicMarketResourcesLaboratoryfuelLabel = {
                    label = "Marché Dynamique / Ressources / Carburant de laboratoire / Libellé",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Carburant de laboratoire / Libellé.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagBasePrice = {
                    label = "Marché Dynamique / Ressources / Sachet d'emballage / Prix de base",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Sachet d'emballage / Prix de base.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagElasticity = {
                    label = "Marché Dynamique / Ressources / Sachet d'emballage / Élasticité",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Sachet d'emballage / Élasticité.",
                },
                drugAdvancedDynamicMarketResourcesPackagingbagLabel = {
                    label = "Marché Dynamique / Ressources / Sachet d'emballage / Libellé",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Sachet d'emballage / Libellé.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotBasePrice = {
                    label = "Marché Dynamique / Ressources / Pot de plantation / Prix de base",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Pot de plantation / Prix de base.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotElasticity = {
                    label = "Marché Dynamique / Ressources / Pot de plantation / Élasticité",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Pot de plantation / Élasticité.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLabel = {
                    label = "Marché Dynamique / Ressources / Pot de plantation / Libellé",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Pot de plantation / Libellé.",
                },
                drugAdvancedDynamicMarketResourcesPlantpotLinkedDrugsItem1 = {
                    label = "Marché Dynamique / Ressources / Pot de plantation / Drogues liées / 1",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Pot de plantation / Drogues liées / 1.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedBasePrice = {
                    label = "Marché Dynamique / Ressources / Graine de cannabis / Prix de base",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Graine de cannabis / Prix de base.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedElasticity = {
                    label = "Marché Dynamique / Ressources / Graine de cannabis / Élasticité",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Graine de cannabis / Élasticité.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLabel = {
                    label = "Marché Dynamique / Ressources / Graine de cannabis / Libellé",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Graine de cannabis / Libellé.",
                },
                drugAdvancedDynamicMarketResourcesWeedseedLinkedDrugsItem1 = {
                    label = "Marché Dynamique / Ressources / Graine de cannabis / Drogues liées / 1",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ressources / Graine de cannabis / Drogues liées / 1.",
                },
                drugAdvancedDynamicMarketSalesWindowMinutes = {
                    label = "Marché Dynamique / Ventes / Fenêtre temporelle / Minutes",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Ventes / Fenêtre temporelle / Minutes.",
                },
                drugAdvancedDynamicMarketSaturationDemandWeight = {
                    label = "Marché Dynamique / Saturation / Demande / Poids",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Saturation / Demande / Poids.",
                },
                drugAdvancedDynamicMarketSaturationPriceImpact = {
                    label = "Marché Dynamique / Saturation / Prix / Impact",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Saturation / Prix / Impact.",
                },
                drugAdvancedDynamicMarketScarcityDemandWeight = {
                    label = "Marché Dynamique / Pénurie / Demande / Poids",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Pénurie / Demande / Poids.",
                },
                drugAdvancedDynamicMarketScarcityPriceImpact = {
                    label = "Marché Dynamique / Pénurie / Prix / Impact",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Pénurie / Prix / Impact.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsDecember = {
                    label = "Marché Dynamique / Saison / Fin / Mois / Décembre",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Saison / Fin / Mois / Décembre.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSpring = {
                    label = "Marché Dynamique / Saison / Fin / Mois / Printemps",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Saison / Fin / Mois / Printemps.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsSummer = {
                    label = "Marché Dynamique / Saison / Fin / Mois / Été",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Saison / Fin / Mois / Été.",
                },
                drugAdvancedDynamicMarketSeasonEndMonthsWinter = {
                    label = "Marché Dynamique / Saison / Fin / Mois / Hiver",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Saison / Fin / Mois / Hiver.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersAutumn = {
                    label = "Marché Dynamique / Saison / Multiplicateurs / Automne",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Saison / Multiplicateurs / Automne.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSpring = {
                    label = "Marché Dynamique / Saison / Multiplicateurs / Printemps",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Saison / Multiplicateurs / Printemps.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersSummer = {
                    label = "Marché Dynamique / Saison / Multiplicateurs / Été",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Saison / Multiplicateurs / Été.",
                },
                drugAdvancedDynamicMarketSeasonMultipliersWinter = {
                    label = "Marché Dynamique / Saison / Multiplicateurs / Hiver",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Saison / Multiplicateurs / Hiver.",
                },
                drugAdvancedDynamicMarketShortageRumorThreshold = {
                    label = "Marché Dynamique / Pénurie / Rumeur / Seuil",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Pénurie / Rumeur / Seuil.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHighDemand = {
                    label = "Marché Dynamique / Statut / Seuils / Forte demande",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Statut / Seuils / Forte demande.",
                },
                drugAdvancedDynamicMarketStatusThresholdsHot = {
                    label = "Marché Dynamique / Statut / Seuils / Recherché",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Statut / Seuils / Recherché.",
                },
                drugAdvancedDynamicMarketStatusThresholdsLowDemand = {
                    label = "Marché Dynamique / Statut / Seuils / Faible demande",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Statut / Seuils / Faible demande.",
                },
                drugAdvancedDynamicMarketStatusThresholdsSaturated = {
                    label = "Marché Dynamique / Statut / Seuils / Saturé",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Statut / Seuils / Saturé.",
                },
                drugAdvancedDynamicMarketTargetSupply = {
                    label = "Marché Dynamique / Cible / Approvisionnement",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Cible / Approvisionnement.",
                },
                drugAdvancedDynamicMarketTrendChance = {
                    label = "Marché Dynamique / Tendance / Chance",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Tendance / Chance.",
                },
                drugAdvancedDynamicMarketTrendDurationMinutes = {
                    label = "Marché Dynamique / Tendance / Durée / Minutes",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Tendance / Durée / Minutes.",
                },
                drugAdvancedDynamicMarketTrendMaximumStrength = {
                    label = "Marché Dynamique / Tendance / Maximum / Intensité",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Tendance / Maximum / Intensité.",
                },
                drugAdvancedDynamicMarketTrendMinimumStrength = {
                    label = "Marché Dynamique / Tendance / Minimum / Intensité",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Tendance / Minimum / Intensité.",
                },
                drugAdvancedDynamicMarketUpdateMinutes = {
                    label = "Marché Dynamique / Mise à jour / Minutes",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Mise à jour / Minutes.",
                },
                drugAdvancedDynamicMarketVolatilityMaximum = {
                    label = "Marché Dynamique / Volatilité / Maximum",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Volatilité / Maximum.",
                },
                drugAdvancedDynamicMarketVolatilityMinimum = {
                    label = "Marché Dynamique / Volatilité / Minimum",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Volatilité / Minimum.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersCold = {
                    label = "Marché Dynamique / Météo / Multiplicateurs / Froid",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Météo / Multiplicateurs / Froid.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersHeatwave = {
                    label = "Marché Dynamique / Météo / Multiplicateurs / Canicule",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Météo / Multiplicateurs / Canicule.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersNormal = {
                    label = "Marché Dynamique / Météo / Multiplicateurs / Normale",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Météo / Multiplicateurs / Normale.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersRain = {
                    label = "Marché Dynamique / Météo / Multiplicateurs / Pluie",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Météo / Multiplicateurs / Pluie.",
                },
                drugAdvancedDynamicMarketWeatherMultipliersStorm = {
                    label = "Marché Dynamique / Météo / Multiplicateurs / Tempête",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Météo / Multiplicateurs / Tempête.",
                },
                drugAdvancedDynamicMarketWeatherState = {
                    label = "Marché Dynamique / Météo / État",
                    description = "Paramètre de fonctionnement pour Marché Dynamique / Météo / État.",
                },
                drugAdvancedHeatActionCooldownSeconds = {
                    label = "Suspicion et risque / Délai de récupération de l'action / secondes",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Délai de récupération de l'action / secondes.",
                },
                drugAdvancedHeatActivityRiskWeightsAmount = {
                    label = "Suspicion et risque / Activité / Risque / Pondérations / Quantité",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Activité / Risque / Pondérations / Quantité.",
                },
                drugAdvancedHeatActivityRiskWeightsDurationMinutes = {
                    label = "Suspicion et risque / Activité / Risque / Pondérations / Durée / Minutes",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Activité / Risque / Pondérations / Durée / Minutes.",
                },
                drugAdvancedHeatActivityRiskWeightsPolicePressure = {
                    label = "Suspicion et risque / Activité / Risque / Pondérations / Pression policière",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Activité / Risque / Pondérations / Pression policière.",
                },
                drugAdvancedHeatActivityRiskWeightsReputation = {
                    label = "Suspicion et risque / Activité / Risque / Pondérations / Réputation",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Activité / Risque / Pondérations / Réputation.",
                },
                drugAdvancedHeatActivityRiskWeightsSecurity = {
                    label = "Suspicion et risque / Activité / Risque / Pondérations / Sécurité",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Activité / Risque / Pondérations / Sécurité.",
                },
                drugAdvancedHeatAggressiveHeatMultiplier = {
                    label = "Suspicion et risque / Mode agressif / Pression policière / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Mode agressif / Pression policière / Multiplicateur.",
                },
                drugAdvancedHeatBurnerBurnThreshold = {
                    label = "Suspicion et risque / Téléphone jetable / Compromission / Seuil",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Téléphone jetable / Compromission / Seuil.",
                },
                drugAdvancedHeatBurnerHeatPerWholesale = {
                    label = "Suspicion et risque / Téléphone jetable / Pression policière / Par vente en gros",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Téléphone jetable / Pression policière / Par vente en gros.",
                },
                drugAdvancedHeatBurnerPhoneItem = {
                    label = "Suspicion et risque / Téléphone jetable / Objet",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Téléphone jetable / Objet.",
                },
                drugAdvancedHeatCamperOperationalHeatMultiplier = {
                    label = "Suspicion et risque / Camping-car en activité / Pression policière / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Camping-car en activité / Pression policière / Multiplicateur.",
                },
                drugAdvancedHeatCamperOperationalHeatThreshold = {
                    label = "Suspicion et risque / Camping-car en activité / Pression policière / Seuil",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Camping-car en activité / Pression policière / Seuil.",
                },
                drugAdvancedHeatCamperParkedHeat = {
                    label = "Suspicion et risque / Camping-car stationné / Pression policière",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Camping-car stationné / Pression policière.",
                },
                drugAdvancedHeatContaminatedHeatMultiplier = {
                    label = "Suspicion et risque / Contamination / Pression policière / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Contamination / Pression policière / Multiplicateur.",
                },
                drugAdvancedHeatContaminatedThreshold = {
                    label = "Suspicion et risque / Contamination / Seuil",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Contamination / Seuil.",
                },
                drugAdvancedHeatCultivationFreePlants = {
                    label = "Suspicion et risque / Culture / Plantes sans risque supplémentaire",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Culture / Plantes sans risque supplémentaire.",
                },
                drugAdvancedHeatCultivationHeatPerPlant = {
                    label = "Suspicion et risque / Culture / Pression policière / Par plante",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Culture / Pression policière / Par plante.",
                },
                drugAdvancedHeatDealerHiddenMinutes = {
                    label = "Suspicion et risque / Dealer / caché / Minutes",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Dealer / caché / Minutes.",
                },
                drugAdvancedHeatDecayPerTickBatch = {
                    label = "Suspicion et risque / Déclin / Par cycle de mise à jour / Lot",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Déclin / Par cycle de mise à jour / Lot.",
                },
                drugAdvancedHeatDecayPerTickCamper = {
                    label = "Suspicion et risque / Déclin / Par cycle de mise à jour / Camping-car",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Déclin / Par cycle de mise à jour / Camping-car.",
                },
                drugAdvancedHeatDecayPerTickDealer = {
                    label = "Suspicion et risque / Déclin / Par cycle de mise à jour / Dealer",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Déclin / Par cycle de mise à jour / Dealer.",
                },
                drugAdvancedHeatDecayPerTickFaction = {
                    label = "Suspicion et risque / Déclin / Par cycle de mise à jour / Faction",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Déclin / Par cycle de mise à jour / Faction.",
                },
                drugAdvancedHeatDecayPerTickHub = {
                    label = "Suspicion et risque / Déclin / Par cycle de mise à jour / Centre de distribution",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Déclin / Par cycle de mise à jour / Centre de distribution.",
                },
                drugAdvancedHeatDecayPerTickLab = {
                    label = "Suspicion et risque / Déclin / Par cycle de mise à jour / Labo",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Déclin / Par cycle de mise à jour / Labo.",
                },
                drugAdvancedHeatDecayPerTickPlayer = {
                    label = "Suspicion et risque / Déclin / Par cycle de mise à jour / Joueur",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Déclin / Par cycle de mise à jour / Joueur.",
                },
                drugAdvancedHeatDecayPerTickRoute = {
                    label = "Suspicion et risque / Déclin / Par cycle de mise à jour / Itinéraire",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Déclin / Par cycle de mise à jour / Itinéraire.",
                },
                drugAdvancedHeatDecayPerTickZone = {
                    label = "Suspicion et risque / Déclin / Par cycle de mise à jour / Zone",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Déclin / Par cycle de mise à jour / Zone.",
                },
                drugAdvancedHeatEnabled = {
                    label = "Suspicion et risque / Activé",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Activé.",
                },
                drugAdvancedHeatEnforcementHeatCritical = {
                    label = "Suspicion et risque / Présence policière / Pression policière / Critique",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Présence policière / Pression policière / Critique.",
                },
                drugAdvancedHeatEnforcementHeatHigh = {
                    label = "Suspicion et risque / Présence policière / Pression policière / Élevé",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Présence policière / Pression policière / Élevé.",
                },
                drugAdvancedHeatEnforcementHeatLow = {
                    label = "Suspicion et risque / Présence policière / Pression policière / Faible",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Présence policière / Pression policière / Faible.",
                },
                drugAdvancedHeatEnforcementHeatMedium = {
                    label = "Suspicion et risque / Présence policière / Pression policière / Moyen",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Présence policière / Pression policière / Moyen.",
                },
                drugAdvancedHeatEnforcementMultipliersBatch = {
                    label = "Suspicion et risque / Présence policière / Multiplicateurs / Lot",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Présence policière / Multiplicateurs / Lot.",
                },
                drugAdvancedHeatEnforcementMultipliersFaction = {
                    label = "Suspicion et risque / Présence policière / Multiplicateurs / Faction",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Présence policière / Multiplicateurs / Faction.",
                },
                drugAdvancedHeatEnforcementMultipliersZone = {
                    label = "Suspicion et risque / Présence policière / Multiplicateurs / Zone",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Présence policière / Multiplicateurs / Zone.",
                },
                drugAdvancedHeatEntityTypesBatch = {
                    label = "Suspicion et risque / Entité / Types / Lot",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Entité / Types / Lot.",
                },
                drugAdvancedHeatEntityTypesCamper = {
                    label = "Suspicion et risque / Entité / Types / Camping-car",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Entité / Types / Camping-car.",
                },
                drugAdvancedHeatEntityTypesDealer = {
                    label = "Suspicion et risque / Entité / Types / Dealer",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Entité / Types / Dealer.",
                },
                drugAdvancedHeatEntityTypesFaction = {
                    label = "Suspicion et risque / Entité / Types / Faction",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Entité / Types / Faction.",
                },
                drugAdvancedHeatEntityTypesHub = {
                    label = "Suspicion et risque / Entité / Types / Centre de distribution",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Entité / Types / Centre de distribution.",
                },
                drugAdvancedHeatEntityTypesLab = {
                    label = "Suspicion et risque / Entité / Types / Labo",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Entité / Types / Labo.",
                },
                drugAdvancedHeatEntityTypesPlayer = {
                    label = "Suspicion et risque / Entité / Types / Joueur",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Entité / Types / Joueur.",
                },
                drugAdvancedHeatEntityTypesRoute = {
                    label = "Suspicion et risque / Entité / Types / Itinéraire",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Entité / Types / Itinéraire.",
                },
                drugAdvancedHeatEntityTypesZone = {
                    label = "Suspicion et risque / Entité / Types / Zone",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Entité / Types / Zone.",
                },
                drugAdvancedHeatEventCooldownMinutes = {
                    label = "Suspicion et risque / Événement / Minutes de délai",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Événement / Minutes de délai.",
                },
                drugAdvancedHeatEventHistoryLimit = {
                    label = "Suspicion et risque / Événement / Limite de l'historique",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Événement / Limite de l'historique.",
                },
                drugAdvancedHeatLabHeatSyncThreshold = {
                    label = "Suspicion et risque / Labo / Pression policière / Synchronisation / Seuil",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Labo / Pression policière / Synchronisation / Seuil.",
                },
                drugAdvancedHeatLayLowCooldownMinutes = {
                    label = "Suspicion et risque / Se faire discret / Minutes de délai",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Se faire discret / Minutes de délai.",
                },
                drugAdvancedHeatLayLowIdleMinutes = {
                    label = "Suspicion et risque / Se faire discret / Inactif / Minutes",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Se faire discret / Inactif / Minutes.",
                },
                drugAdvancedHeatLayLowReduction = {
                    label = "Suspicion et risque / Se faire discret / Réduction",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Se faire discret / Réduction.",
                },
                drugAdvancedHeatLockdownMinutes = {
                    label = "Suspicion et risque / Confinement / Minutes",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Confinement / Minutes.",
                },
                drugAdvancedHeatMinimumDurationMinutes = {
                    label = "Suspicion et risque / Minimum / Durée / Minutes",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Minimum / Durée / Minutes.",
                },
                drugAdvancedHeatMinimumEventCooldownSeconds = {
                    label = "Suspicion et risque / Minimum / Événement / Temps de recharge (secondes)",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Minimum / Événement / Temps de recharge (secondes).",
                },
                drugAdvancedHeatMinimumIdleSeconds = {
                    label = "Suspicion et risque / Minimum / Inactif / secondes",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Minimum / Inactif / secondes.",
                },
                drugAdvancedHeatProcessingHeatMultiplier = {
                    label = "Suspicion et risque / Traitement / Pression policière / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Traitement / Pression policière / Multiplicateur.",
                },
                drugAdvancedHeatRiskWeightsBatch = {
                    label = "Suspicion et risque / Risque / Pondérations / Lot",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Risque / Pondérations / Lot.",
                },
                drugAdvancedHeatRiskWeightsCamper = {
                    label = "Suspicion et risque / Risque / Pondérations / Camping-car",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Risque / Pondérations / Camping-car.",
                },
                drugAdvancedHeatRiskWeightsDealer = {
                    label = "Suspicion et risque / Risque / Pondérations / Dealer",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Risque / Pondérations / Dealer.",
                },
                drugAdvancedHeatRiskWeightsFaction = {
                    label = "Suspicion et risque / Risque / Pondérations / Faction",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Risque / Pondérations / Faction.",
                },
                drugAdvancedHeatRiskWeightsHub = {
                    label = "Suspicion et risque / Risque / Pondérations / Centre de distribution",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Risque / Pondérations / Centre de distribution.",
                },
                drugAdvancedHeatRiskWeightsLab = {
                    label = "Suspicion et risque / Risque / Pondérations / Labo",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Risque / Pondérations / Labo.",
                },
                drugAdvancedHeatRiskWeightsPlayer = {
                    label = "Suspicion et risque / Risque / Pondérations / Joueur",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Risque / Pondérations / Joueur.",
                },
                drugAdvancedHeatRiskWeightsRoute = {
                    label = "Suspicion et risque / Risque / Pondérations / Itinéraire",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Risque / Pondérations / Itinéraire.",
                },
                drugAdvancedHeatRiskWeightsZone = {
                    label = "Suspicion et risque / Risque / Pondérations / Zone",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Risque / Pondérations / Zone.",
                },
                drugAdvancedHeatRotateBurnerReduction = {
                    label = "Suspicion et risque / Changer de téléphone jetable / Réduction",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Changer de téléphone jetable / Réduction.",
                },
                drugAdvancedHeatRouteControlMinutes = {
                    label = "Suspicion et risque / Itinéraire / Contrôles / Minutes",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Itinéraire / Contrôles / Minutes.",
                },
                drugAdvancedHeatSaleHeatBatch = {
                    label = "Suspicion et risque / Vente / Pression policière / Lot",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Vente / Pression policière / Lot.",
                },
                drugAdvancedHeatSaleHeatCamper = {
                    label = "Suspicion et risque / Vente / Pression policière / Camping-car",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Vente / Pression policière / Camping-car.",
                },
                drugAdvancedHeatSaleHeatDealer = {
                    label = "Suspicion et risque / Vente / Pression policière / Dealer",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Vente / Pression policière / Dealer.",
                },
                drugAdvancedHeatSaleHeatFaction = {
                    label = "Suspicion et risque / Vente / Pression policière / Faction",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Vente / Pression policière / Faction.",
                },
                drugAdvancedHeatSaleHeatHub = {
                    label = "Suspicion et risque / Vente / Pression policière / Centre de distribution",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Vente / Pression policière / Centre de distribution.",
                },
                drugAdvancedHeatSaleHeatLab = {
                    label = "Suspicion et risque / Vente / Pression policière / Labo",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Vente / Pression policière / Labo.",
                },
                drugAdvancedHeatSaleHeatPlayer = {
                    label = "Suspicion et risque / Vente / Pression policière / Joueur",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Vente / Pression policière / Joueur.",
                },
                drugAdvancedHeatSaleHeatRoute = {
                    label = "Suspicion et risque / Vente / Pression policière / Itinéraire",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Vente / Pression policière / Itinéraire.",
                },
                drugAdvancedHeatSaleHeatZone = {
                    label = "Suspicion et risque / Vente / Pression policière / Zone",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Vente / Pression policière / Zone.",
                },
                drugAdvancedHeatThresholdsCritical = {
                    label = "Suspicion et risque / Seuils / Critique",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Seuils / Critique.",
                },
                drugAdvancedHeatThresholdsHigh = {
                    label = "Suspicion et risque / Seuils / Élevé",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Seuils / Élevé.",
                },
                drugAdvancedHeatThresholdsLockdown = {
                    label = "Suspicion et risque / Seuils / Confinement",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Seuils / Confinement.",
                },
                drugAdvancedHeatThresholdsLow = {
                    label = "Suspicion et risque / Seuils / Faible",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Seuils / Faible.",
                },
                drugAdvancedHeatThresholdsMedium = {
                    label = "Suspicion et risque / Seuils / Moyen",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Seuils / Moyen.",
                },
                drugAdvancedHeatTickMinutes = {
                    label = "Suspicion et risque / Cycle de mise à jour / Minutes",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Cycle de mise à jour / Minutes.",
                },
                drugAdvancedHeatWholesaleHeatMultiplier = {
                    label = "Suspicion et risque / Vente en gros / Pression policière / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Vente en gros / Pression policière / Multiplicateur.",
                },
                drugAdvancedHeatWorkerLeakAlertRadius = {
                    label = "Suspicion et risque / Travailleur / Fuite d'informations / Rayon d'alerte",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Rayon d'alerte.",
                },
                drugAdvancedHeatWorkerLeakBaseChance = {
                    label = "Suspicion et risque / Travailleur / Fuite d'informations / Valeur de base / Chance",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Valeur de base / Chance.",
                },
                drugAdvancedHeatWorkerLeakFactionMultiplier = {
                    label = "Suspicion et risque / Travailleur / Fuite d'informations / Faction / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Faction / Multiplicateur.",
                },
                drugAdvancedHeatWorkerLeakHighSeverityThreshold = {
                    label = "Suspicion et risque / Travailleur / Fuite d'informations / Élevé / Gravité / Seuil",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Élevé / Gravité / Seuil.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Suspicion et risque / Travailleur / Fuite d'informations / Loyauté / Chance / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Loyauté / Chance / Multiplicateur.",
                },
                drugAdvancedHeatWorkerLeakLoyaltyThreshold = {
                    label = "Suspicion et risque / Travailleur / Fuite d'informations / Loyauté / Seuil",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Loyauté / Seuil.",
                },
                drugAdvancedHeatWorkerLeakMaximumChance = {
                    label = "Suspicion et risque / Travailleur / Fuite d'informations / Maximum / Chance",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Maximum / Chance.",
                },
                drugAdvancedHeatWorkerLeakMinimumCooldownSeconds = {
                    label = "Suspicion et risque / Travailleur / Fuite d'informations / Minimum / Temps de recharge (secondes)",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Minimum / Temps de recharge (secondes).",
                },
                drugAdvancedHeatWorkerLeakRouteMultiplier = {
                    label = "Suspicion et risque / Travailleur / Fuite d'informations / Itinéraire / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Itinéraire / Multiplicateur.",
                },
                drugAdvancedHeatWorkerLeakStrengthMaximum = {
                    label = "Suspicion et risque / Travailleur / Fuite d'informations / Intensité / Maximum",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Intensité / Maximum.",
                },
                drugAdvancedHeatWorkerLeakStrengthMinimum = {
                    label = "Suspicion et risque / Travailleur / Fuite d'informations / Intensité / Minimum",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Intensité / Minimum.",
                },
                drugAdvancedHeatWorkerLeakStrengthMultiplier = {
                    label = "Suspicion et risque / Travailleur / Fuite d'informations / Intensité / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Intensité / Multiplicateur.",
                },
                drugAdvancedHeatWorkerLeakStressChanceMultiplier = {
                    label = "Suspicion et risque / Travailleur / Fuite d'informations / Stress / Chance / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Stress / Chance / Multiplicateur.",
                },
                drugAdvancedHeatWorkerLeakStressThreshold = {
                    label = "Suspicion et risque / Travailleur / Fuite d'informations / Stress / Seuil",
                    description = "Paramètre de fonctionnement pour Suspicion et risque / Travailleur / Fuite d'informations / Stress / Seuil.",
                },
                drugAdvancedContactNetworkActionCooldownSeconds = {
                    label = "Réseau de contacts / Délai de récupération de l'action / secondes",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Délai de récupération de l'action / secondes.",
                },
                drugAdvancedContactNetworkActiveHotspotCount = {
                    label = "Réseau de contacts / Nombre de points chauds actifs",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Nombre de points chauds actifs.",
                },
                drugAdvancedContactNetworkBurnerHintTrust = {
                    label = "Réseau de contacts / Indice burner / Confiance",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Indice burner / Confiance.",
                },
                drugAdvancedContactNetworkBurnerOfferMaximumMultiplier = {
                    label = "Réseau de contacts / Téléphone jetable / Offre / Maximum / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Téléphone jetable / Offre / Maximum / Multiplicateur.",
                },
                drugAdvancedContactNetworkBurnerOfferMinimumMultiplier = {
                    label = "Réseau de contacts / Téléphone jetable / Offre / Minimum / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Téléphone jetable / Offre / Minimum / Multiplicateur.",
                },
                drugAdvancedContactNetworkBuyerCooldownMinutes = {
                    label = "Réseau de contacts / Acheteur / Minutes de délai",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Acheteur / Minutes de délai.",
                },
                drugAdvancedContactNetworkBuyerDeliveryDistance = {
                    label = "Réseau de contacts / Acheteur / Distance de livraison",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Acheteur / Distance de livraison.",
                },
                drugAdvancedContactNetworkBuyerPremiumSuccessScore = {
                    label = "Réseau de contacts / Acheteur / Premium / Succès / Score",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Acheteur / Premium / Succès / Score.",
                },
                drugAdvancedContactNetworkBuyerPremiumTrustGain = {
                    label = "Réseau de contacts / Acheteur / Premium / Confiance / gain",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Acheteur / Premium / Confiance / gain.",
                },
                drugAdvancedContactNetworkBuyerRequestHeatRiskWeight = {
                    label = "Réseau de contacts / Acheteur / Demande / Recherche & Risque / Poids",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Acheteur / Demande / Recherche & Risque / Poids.",
                },
                drugAdvancedContactNetworkBuyerStandardTrustGain = {
                    label = "Réseau de contacts / Acheteur / Norme / Confiance / gain",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Acheteur / Norme / Confiance / gain.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMax = {
                    label = "Réseau de contacts / Délai d'activation du contact / secondes / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Délai d'activation du contact / secondes / Maximum.",
                },
                drugAdvancedContactNetworkContactActiveDelaySecondsMin = {
                    label = "Réseau de contacts / Délai d'activation du contact / secondes / Minimum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Délai d'activation du contact / secondes / Minimum.",
                },
                drugAdvancedContactNetworkContactDemandRangeMax = {
                    label = "Réseau de contacts / Contact / Demande / Plage de valeurs / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Contact / Demande / Plage de valeurs / Maximum.",
                },
                drugAdvancedContactNetworkContactDemandRangeMin = {
                    label = "Réseau de contacts / Contact / Demande / Plage de valeurs / Minimum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Contact / Demande / Plage de valeurs / Minimum.",
                },
                drugAdvancedContactNetworkContactLossTrust = {
                    label = "Réseau de contacts / Contact / Perte / Confiance",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Contact / Perte / Confiance.",
                },
                drugAdvancedContactNetworkDarknetExactIntelMinutes = {
                    label = "Réseau de contacts / Darknet / Renseignements précis / Minutes",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Darknet / Renseignements précis / Minutes.",
                },
                drugAdvancedContactNetworkDarknetHotspotIntelPrice = {
                    label = "Réseau de contacts / Darknet / Point sensible / Renseignements / Prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Darknet / Point sensible / Renseignements / Prix.",
                },
                drugAdvancedContactNetworkDarknetIntelPrice = {
                    label = "Réseau de contacts / Darknet / Renseignements / Prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Darknet / Renseignements / Prix.",
                },
                drugAdvancedContactNetworkDealerBasePrice = {
                    label = "Réseau de contacts / Dealer / Prix de base",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Prix de base.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMax = {
                    label = "Réseau de contacts / Dealer / Recrutement / capacité / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Recrutement / capacité / Maximum.",
                },
                drugAdvancedContactNetworkDealerHireCapacityMin = {
                    label = "Réseau de contacts / Dealer / Recrutement / capacité / Minimum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Recrutement / capacité / Minimum.",
                },
                drugAdvancedContactNetworkDealerHireRiskMax = {
                    label = "Réseau de contacts / Dealer / Recrutement / Risque / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Recrutement / Risque / Maximum.",
                },
                drugAdvancedContactNetworkDealerHireRiskMin = {
                    label = "Réseau de contacts / Dealer / Recrutement / Risque / Minimum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Recrutement / Risque / Minimum.",
                },
                drugAdvancedContactNetworkDealerHireSkillMax = {
                    label = "Réseau de contacts / Dealer / Recrutement / Compétence / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Recrutement / Compétence / Maximum.",
                },
                drugAdvancedContactNetworkDealerHireSkillMin = {
                    label = "Réseau de contacts / Dealer / Recrutement / Compétence / Minimum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Recrutement / Compétence / Minimum.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Id = {
                    label = "Réseau de contacts / Offres du concessionnaire / 1 / ID",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 1 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Item = {
                    label = "Réseau de contacts / Offres du concessionnaire / 1 / Objet",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 1 / Objet.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Label = {
                    label = "Réseau de contacts / Offres du concessionnaire / 1 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 1 / Libellé.",
                },
                drugAdvancedContactNetworkDealerOffersItem1MinTrust = {
                    label = "Réseau de contacts / Offres du concessionnaire / 1 / Confiance minimum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 1 / Confiance minimum.",
                },
                drugAdvancedContactNetworkDealerOffersItem1Price = {
                    label = "Réseau de contacts / Offres du concessionnaire / 1 / Prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 1 / Prix.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Id = {
                    label = "Réseau de contacts / Offres du concessionnaire / 2 / ID",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 2 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Item = {
                    label = "Réseau de contacts / Offres du concessionnaire / 2 / Objet",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 2 / Objet.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Label = {
                    label = "Réseau de contacts / Offres du concessionnaire / 2 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 2 / Libellé.",
                },
                drugAdvancedContactNetworkDealerOffersItem2MinTrust = {
                    label = "Réseau de contacts / Offres du concessionnaire / 2 / Confiance minimum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 2 / Confiance minimum.",
                },
                drugAdvancedContactNetworkDealerOffersItem2Price = {
                    label = "Réseau de contacts / Offres du concessionnaire / 2 / Prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 2 / Prix.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Id = {
                    label = "Réseau de contacts / Offres du concessionnaire / 3 / ID",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 3 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Item = {
                    label = "Réseau de contacts / Offres du concessionnaire / 3 / Objet",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 3 / Objet.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Label = {
                    label = "Réseau de contacts / Offres du concessionnaire / 3 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 3 / Libellé.",
                },
                drugAdvancedContactNetworkDealerOffersItem3MinTrust = {
                    label = "Réseau de contacts / Offres du concessionnaire / 3 / Confiance minimum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 3 / Confiance minimum.",
                },
                drugAdvancedContactNetworkDealerOffersItem3Price = {
                    label = "Réseau de contacts / Offres du concessionnaire / 3 / Prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 3 / Prix.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Id = {
                    label = "Réseau de contacts / Offres du concessionnaire / 4 / ID",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 4 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Item = {
                    label = "Réseau de contacts / Offres du concessionnaire / 4 / Objet",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 4 / Objet.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Label = {
                    label = "Réseau de contacts / Offres du concessionnaire / 4 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 4 / Libellé.",
                },
                drugAdvancedContactNetworkDealerOffersItem4MinTrust = {
                    label = "Réseau de contacts / Offres du concessionnaire / 4 / Confiance minimum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 4 / Confiance minimum.",
                },
                drugAdvancedContactNetworkDealerOffersItem4Price = {
                    label = "Réseau de contacts / Offres du concessionnaire / 4 / Prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 4 / Prix.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Id = {
                    label = "Réseau de contacts / Offres du concessionnaire / 5 / ID",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 5 / ID.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Item = {
                    label = "Réseau de contacts / Offres du concessionnaire / 5 / Objet",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 5 / Objet.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Label = {
                    label = "Réseau de contacts / Offres du concessionnaire / 5 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 5 / Libellé.",
                },
                drugAdvancedContactNetworkDealerOffersItem5MinTrust = {
                    label = "Réseau de contacts / Offres du concessionnaire / 5 / Confiance minimum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 5 / Confiance minimum.",
                },
                drugAdvancedContactNetworkDealerOffersItem5Price = {
                    label = "Réseau de contacts / Offres du concessionnaire / 5 / Prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Offres du concessionnaire / 5 / Prix.",
                },
                drugAdvancedContactNetworkDealerProtectionHours = {
                    label = "Réseau de contacts / Dealer / Protection / Heures",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Protection / Heures.",
                },
                drugAdvancedContactNetworkDealerProtectionPrice = {
                    label = "Réseau de contacts / Dealer / Protection / Prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Protection / Prix.",
                },
                drugAdvancedContactNetworkDealerSaleMax = {
                    label = "Réseau de contacts / Dealer / Vente / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Vente / Maximum.",
                },
                drugAdvancedContactNetworkDealerSaleMin = {
                    label = "Réseau de contacts / Dealer / Vente / Minimum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Vente / Minimum.",
                },
                drugAdvancedContactNetworkDealerSimulationAggressivePriceMultiplier = {
                    label = "Réseau de contacts / Dealer / Simulation / Mode agressif / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Mode agressif / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkDealerSimulationBaseQualityPriceFactor = {
                    label = "Réseau de contacts / Dealer / Simulation / Qualité de base / Facteur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Qualité de base / Facteur de prix.",
                },
                drugAdvancedContactNetworkDealerSimulationBulkPriceMultiplier = {
                    label = "Réseau de contacts / Dealer / Simulation / En gros / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / En gros / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkDealerSimulationCheapPriceMultiplier = {
                    label = "Réseau de contacts / Dealer / Simulation / Ventes à bas prix / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Ventes à bas prix / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkDealerSimulationDefaultQuality = {
                    label = "Réseau de contacts / Dealer / Simulation / Valeur par défaut / Qualité",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Valeur par défaut / Qualité.",
                },
                drugAdvancedContactNetworkDealerSimulationDisloyalThreshold = {
                    label = "Réseau de contacts / Dealer / Simulation / Seuil de déloyauté",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Seuil de déloyauté.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerLevel = {
                    label = "Réseau de contacts / Dealer / Simulation / Expérience / Par niveau",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Expérience / Par niveau.",
                },
                drugAdvancedContactNetworkDealerSimulationExperiencePerUnit = {
                    label = "Réseau de contacts / Dealer / Simulation / Expérience / Par unité",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Expérience / Par unité.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentLoyaltyLoss = {
                    label = "Réseau de contacts / Dealer / Simulation / Incident / Loyauté / Perte",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Incident / Loyauté / Perte.",
                },
                drugAdvancedContactNetworkDealerSimulationIncidentRollMaximum = {
                    label = "Réseau de contacts / Dealer / Simulation / Incident / Tirage aléatoire / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Incident / Tirage aléatoire / Maximum.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelPriceBonus = {
                    label = "Réseau de contacts / Dealer / Simulation / Niveau / Prix / Prime",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Niveau / Prix / Prime.",
                },
                drugAdvancedContactNetworkDealerSimulationLevelSaleDivisor = {
                    label = "Réseau de contacts / Dealer / Simulation / Niveau / Vente / Diviseur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Niveau / Vente / Diviseur.",
                },
                drugAdvancedContactNetworkDealerSimulationLoyaltyRiskWeight = {
                    label = "Réseau de contacts / Dealer / Simulation / Loyauté / Risque / Poids",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Loyauté / Risque / Poids.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumIncidentChance = {
                    label = "Réseau de contacts / Dealer / Simulation / Maximum / Incident / Chance",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Maximum / Incident / Chance.",
                },
                drugAdvancedContactNetworkDealerSimulationMaximumLevel = {
                    label = "Réseau de contacts / Dealer / Simulation / Maximum / Niveau",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Maximum / Niveau.",
                },
                drugAdvancedContactNetworkDealerSimulationPremiumPriceMultiplier = {
                    label = "Réseau de contacts / Dealer / Simulation / Premium / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Premium / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkDealerSimulationProfileRiskWeight = {
                    label = "Réseau de contacts / Dealer / Simulation / Profil / Risque / Poids",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Profil / Risque / Poids.",
                },
                drugAdvancedContactNetworkDealerSimulationProtectionRiskReduction = {
                    label = "Réseau de contacts / Dealer / Simulation / Protection / Risque / Réduction",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Protection / Risque / Réduction.",
                },
                drugAdvancedContactNetworkDealerSimulationQualityPriceDivisor = {
                    label = "Réseau de contacts / Dealer / Simulation / Qualité / Prix / Diviseur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Qualité / Prix / Diviseur.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryBaseChance = {
                    label = "Réseau de contacts / Dealer / Simulation / Récupération / Valeur de base / Chance",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Récupération / Valeur de base / Chance.",
                },
                drugAdvancedContactNetworkDealerSimulationRecoveryLoyaltyWeight = {
                    label = "Réseau de contacts / Dealer / Simulation / Récupération / Loyauté / Poids",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Récupération / Loyauté / Poids.",
                },
                drugAdvancedContactNetworkDealerSimulationRobbedStockLoss = {
                    label = "Réseau de contacts / Dealer / Simulation / Perte de stock par vol",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Perte de stock par vol.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillRiskReduction = {
                    label = "Réseau de contacts / Dealer / Simulation / Compétence / Risque / Réduction",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Compétence / Risque / Réduction.",
                },
                drugAdvancedContactNetworkDealerSimulationSkillSaleDivisor = {
                    label = "Réseau de contacts / Dealer / Simulation / Compétence / Vente / Diviseur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Compétence / Vente / Diviseur.",
                },
                drugAdvancedContactNetworkDealerSimulationStableLoyaltyThreshold = {
                    label = "Réseau de contacts / Dealer / Simulation / Seuil de loyauté stable",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Seuil de loyauté stable.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryPriceMultiplier = {
                    label = "Réseau de contacts / Dealer / Simulation / Territoire / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Territoire / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkDealerSimulationTerritoryRiskReduction = {
                    label = "Réseau de contacts / Dealer / Simulation / Territoire / Risque / Réduction",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Simulation / Territoire / Risque / Réduction.",
                },
                drugAdvancedContactNetworkDealerTickMinutes = {
                    label = "Réseau de contacts / Dealer / Cycle de mise à jour / Minutes",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Cycle de mise à jour / Minutes.",
                },
                drugAdvancedContactNetworkDealerWage = {
                    label = "Réseau de contacts / Dealer / Salaire",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Salaire.",
                },
                drugAdvancedContactNetworkDealerWageDecay = {
                    label = "Réseau de contacts / Dealer / Salaire / Déclin",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Salaire / Déclin.",
                },
                drugAdvancedContactNetworkDealerWageLoyaltyGain = {
                    label = "Réseau de contacts / Dealer / Salaire / Loyauté / gain",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Salaire / Loyauté / gain.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem1 = {
                    label = "Réseau de contacts / Dealer / Faiblesses / 1",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Faiblesses / 1.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem2 = {
                    label = "Réseau de contacts / Dealer / Faiblesses / 2",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Faiblesses / 2.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem3 = {
                    label = "Réseau de contacts / Dealer / Faiblesses / 3",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Faiblesses / 3.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem4 = {
                    label = "Réseau de contacts / Dealer / Faiblesses / 4",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Faiblesses / 4.",
                },
                drugAdvancedContactNetworkDealerWeaknessesItem5 = {
                    label = "Réseau de contacts / Dealer / Faiblesses / 5",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer / Faiblesses / 5.",
                },
                drugAdvancedContactNetworkDefaultContactDemand = {
                    label = "Réseau de contacts / Valeur par défaut / Contact / Demande",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Valeur par défaut / Contact / Demande.",
                },
                drugAdvancedContactNetworkDefaultContactRisk = {
                    label = "Réseau de contacts / Valeur par défaut / Contact / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Valeur par défaut / Contact / Risque.",
                },
                drugAdvancedContactNetworkDefaultDealerCapacity = {
                    label = "Réseau de contacts / Dealer par défaut / capacité",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer par défaut / capacité.",
                },
                drugAdvancedContactNetworkDefaultDealerRisk = {
                    label = "Réseau de contacts / Dealer par défaut / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer par défaut / Risque.",
                },
                drugAdvancedContactNetworkDefaultDealerSkill = {
                    label = "Réseau de contacts / Dealer par défaut / Compétence",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Dealer par défaut / Compétence.",
                },
                drugAdvancedContactNetworkDefaultHotspotRadius = {
                    label = "Réseau de contacts / Valeur par défaut / Point sensible / Rayon",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Valeur par défaut / Point sensible / Rayon.",
                },
                drugAdvancedContactNetworkDemandResetMinutes = {
                    label = "Réseau de contacts / Réinitialisation de la demande (minutes)",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Réinitialisation de la demande (minutes).",
                },
                drugAdvancedContactNetworkEnabled = {
                    label = "Réseau de contacts / Activé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Activé.",
                },
                drugAdvancedContactNetworkExactLocationTrust = {
                    label = "Réseau de contacts / Emplacement exact / Confiance",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement exact / Confiance.",
                },
                drugAdvancedContactNetworkFactionDiscoveryReputation = {
                    label = "Réseau de contacts / Faction / Découverte / Réputation",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Faction / Découverte / Réputation.",
                },
                drugAdvancedContactNetworkFactionHintTrust = {
                    label = "Réseau de contacts / Faction / Indice / Confiance",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Faction / Indice / Confiance.",
                },
                drugAdvancedContactNetworkFailedDeliveryCooldownMinutes = {
                    label = "Réseau de contacts / Livraison échouée / Minutes de délai",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Livraison échouée / Minutes de délai.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerCount = {
                    label = "Réseau de contacts / Fausse transaction / Rencontre / Attaquant / Nombre",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Fausse transaction / Rencontre / Attaquant / Nombre.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem1 = {
                    label = "Réseau de contacts / Fausse transaction / Rencontre / Attaquant / Modèles / 1",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Fausse transaction / Rencontre / Attaquant / Modèles / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem2 = {
                    label = "Réseau de contacts / Fausse transaction / Rencontre / Attaquant / Modèles / 2",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Fausse transaction / Rencontre / Attaquant / Modèles / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterAttackerModelsItem3 = {
                    label = "Réseau de contacts / Fausse transaction / Rencontre / Attaquant / Modèles / 3",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Fausse transaction / Rencontre / Attaquant / Modèles / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterDurationSeconds = {
                    label = "Réseau de contacts / Fausse transaction / Rencontre / Durée (secondes)",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Fausse transaction / Rencontre / Durée (secondes).",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem1 = {
                    label = "Réseau de contacts / Fausse transaction / Rencontre / Police / Modèles / 1",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Fausse transaction / Rencontre / Police / Modèles / 1.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem2 = {
                    label = "Réseau de contacts / Fausse transaction / Rencontre / Police / Modèles / 2",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Fausse transaction / Rencontre / Police / Modèles / 2.",
                },
                drugAdvancedContactNetworkFakeDealEncounterPoliceModelsItem3 = {
                    label = "Réseau de contacts / Fausse transaction / Rencontre / Police / Modèles / 3",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Fausse transaction / Rencontre / Police / Modèles / 3.",
                },
                drugAdvancedContactNetworkFakeDealEncounterSpawnRadius = {
                    label = "Réseau de contacts / Fausse transaction / Rencontre / Rayon de spawn",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Fausse transaction / Rencontre / Rayon de spawn.",
                },
                drugAdvancedContactNetworkFallbackPreferredDrug = {
                    label = "Réseau de contacts / Valeur de remplacement / Drogue préférée",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Valeur de remplacement / Drogue préférée.",
                },
                drugAdvancedContactNetworkFallbackProductLabel = {
                    label = "Réseau de contacts / Valeur de remplacement / Nom du produit",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Valeur de remplacement / Nom du produit.",
                },
                drugAdvancedContactNetworkGuideBookItem = {
                    label = "Réseau de contacts / Guide / Livre / Objet",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Guide / Livre / Objet.",
                },
                drugAdvancedContactNetworkGuideBookTrust = {
                    label = "Réseau de contacts / Guide / Livre / Confiance",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Guide / Livre / Confiance.",
                },
                drugAdvancedContactNetworkHireDealerPrice = {
                    label = "Réseau de contacts / Embaucher un dealer / Prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Embaucher un dealer / Prix.",
                },
                drugAdvancedContactNetworkHistoryLimit = {
                    label = "Réseau de contacts / Limite de l'historique",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Limite de l'historique.",
                },
                drugAdvancedContactNetworkHotspotIntelMinutes = {
                    label = "Réseau de contacts / Point sensible / Renseignements / Minutes",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Point sensible / Renseignements / Minutes.",
                },
                drugAdvancedContactNetworkHotspotRotationMinutes = {
                    label = "Réseau de contacts / Point sensible / Rotation / Minutes",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Point sensible / Rotation / Minutes.",
                },
                drugAdvancedContactNetworkListingDurationMinutes = {
                    label = "Réseau de contacts / Annonce / Durée / Minutes",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Annonce / Durée / Minutes.",
                },
                drugAdvancedContactNetworkMaxOwnedDealers = {
                    label = "Réseau de contacts / Maximum / Possédées / Revendeurs",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Maximum / Possédées / Revendeurs.",
                },
                drugAdvancedContactNetworkMinimumBuyerDeliveryDistance = {
                    label = "Réseau de contacts / Minimum / Acheteur / Distance de livraison",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Acheteur / Distance de livraison.",
                },
                drugAdvancedContactNetworkMinimumContactRotationMinutes = {
                    label = "Réseau de contacts / Minimum / Rotation des contacts (minutes)",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Rotation des contacts (minutes).",
                },
                drugAdvancedContactNetworkMinimumDemandResetMinutes = {
                    label = "Réseau de contacts / Minimum / Réinitialisation de la demande (minutes)",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Réinitialisation de la demande (minutes).",
                },
                drugAdvancedContactNetworkMinimumHeatMultiplier = {
                    label = "Réseau de contacts / Minimum / Pression policière / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Pression policière / Multiplicateur.",
                },
                drugAdvancedContactNetworkMinimumHotspotIntelMinutes = {
                    label = "Réseau de contacts / Minimum / Point sensible / Renseignements / Minutes",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Point sensible / Renseignements / Minutes.",
                },
                drugAdvancedContactNetworkMinimumHotspotRadius = {
                    label = "Réseau de contacts / Minimum / Point sensible / Rayon",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Point sensible / Rayon.",
                },
                drugAdvancedContactNetworkMinimumHotspotRotationMinutes = {
                    label = "Réseau de contacts / Minimum / Point sensible / Rotation / Minutes",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Point sensible / Rotation / Minutes.",
                },
                drugAdvancedContactNetworkMinimumListingDurationMinutes = {
                    label = "Réseau de contacts / Minimum / Annonce / Durée / Minutes",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Annonce / Durée / Minutes.",
                },
                drugAdvancedContactNetworkMinimumRewardMultiplier = {
                    label = "Réseau de contacts / Récompense minimale / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Récompense minimale / Multiplicateur.",
                },
                drugAdvancedContactNetworkMinimumRobberyMultiplier = {
                    label = "Réseau de contacts / Minimum / Braquage / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Braquage / Multiplicateur.",
                },
                drugAdvancedContactNetworkMinimumSpotPriceMultiplier = {
                    label = "Réseau de contacts / Minimum / Emplacement / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Minimum / Emplacement / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkOtherDrugPriceMultiplier = {
                    label = "Réseau de contacts / Autre / Drogue / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Autre / Drogue / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkPaymentAccount = {
                    label = "Réseau de contacts / Compte de paiement",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Compte de paiement.",
                },
                drugAdvancedContactNetworkPostDeliveryDemandResetSeconds = {
                    label = "Réseau de contacts / Après livraison / Demande / Reset / secondes",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Après livraison / Demande / Reset / secondes.",
                },
                drugAdvancedContactNetworkPreferredDrugPriceMultiplier = {
                    label = "Réseau de contacts / Drogue préférée / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Drogue préférée / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkRegionLocationTrust = {
                    label = "Réseau de contacts / Région / Lieu / Confiance",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Région / Lieu / Confiance.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMax = {
                    label = "Réseau de contacts / Demande / Quantités / En gros / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Demande / Quantités / En gros / Maximum.",
                },
                drugAdvancedContactNetworkRequestAmountsBulkMin = {
                    label = "Réseau de contacts / Demande / Quantités / En gros / Minimum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Demande / Quantités / En gros / Minimum.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMax = {
                    label = "Réseau de contacts / Demande / Quantités / Premium / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Demande / Quantités / Premium / Maximum.",
                },
                drugAdvancedContactNetworkRequestAmountsPremiumMin = {
                    label = "Réseau de contacts / Demande / Quantités / Premium / Minimum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Demande / Quantités / Premium / Minimum.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMax = {
                    label = "Réseau de contacts / Demande / Quantités / Norme / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Demande / Quantités / Norme / Maximum.",
                },
                drugAdvancedContactNetworkRequestAmountsStandardMin = {
                    label = "Réseau de contacts / Demande / Quantités / Norme / Minimum",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Demande / Quantités / Norme / Minimum.",
                },
                drugAdvancedContactNetworkRotationMinutes = {
                    label = "Réseau de contacts / Rotation / Minutes",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rotation / Minutes.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 1 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 1 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 1 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 1 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 1 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 1 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 1 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 1 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 1 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 1 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 1 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 1 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 1 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 1 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem1Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 1 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 1 / Risque.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 2 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 2 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 2 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 2 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 2 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 2 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 2 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 2 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 2 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 2 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 2 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 2 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 2 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 2 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem2Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 2 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 2 / Risque.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 3 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 3 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 3 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 3 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 3 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 3 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 3 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 3 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 3 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 3 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 3 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 3 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 3 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 3 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsCornerdealerItem3Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 3 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer de rue / 3 / Risque.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 1 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 1 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 1 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 1 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 1 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 1 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 1 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 1 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 1 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 1 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 1 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 1 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 1 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 1 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem1Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 1 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 1 / Risque.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 2 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 2 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 2 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 2 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 2 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 2 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 2 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 2 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 2 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 2 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 2 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 2 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 2 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 2 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem2Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 2 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 2 / Risque.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 3 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 3 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 3 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 3 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 3 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 3 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 3 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 3 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 3 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 3 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 3 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 3 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 3 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 3 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultbuyerItem3Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 3 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Acheteur par défaut / 3 / Risque.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 1 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 1 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 1 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 1 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 1 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 1 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 1 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 1 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 1 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 1 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 1 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 1 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 1 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 1 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem1Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 1 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 1 / Risque.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 2 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 2 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 2 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 2 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 2 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 2 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 2 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 2 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 2 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 2 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 2 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 2 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 2 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 2 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem2Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 2 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 2 / Risque.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 3 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 3 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 3 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 3 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 3 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 3 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 3 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 3 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 3 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 3 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 3 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 3 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 3 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 3 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsDefaultdealerItem3Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 3 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer par défaut / 3 / Risque.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 1 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 1 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 1 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 1 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 1 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 1 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 1 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 1 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 1 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 1 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 1 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 1 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 1 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 1 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem1Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 1 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 1 / Risque.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 2 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 2 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 2 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 2 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 2 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 2 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 2 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 2 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 2 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 2 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 2 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 2 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 2 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 2 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem2Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 2 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 2 / Risque.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 3 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 3 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 3 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 3 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 3 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 3 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 3 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 3 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 3 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 3 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 3 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 3 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 3 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 3 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsNetworkdealerItem3Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 3 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Dealer du réseau / 3 / Risque.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 1 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 1 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 1 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 1 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 1 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 1 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 1 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 1 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 1 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 1 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 1 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 1 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 1 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 1 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem1Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 1 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 1 / Risque.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 2 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 2 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 2 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 2 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 2 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 2 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 2 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 2 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 2 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 2 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 2 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 2 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 2 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 2 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem2Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 2 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 2 / Risque.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 3 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 3 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 3 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 3 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 3 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 3 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 3 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 3 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 3 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 3 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 3 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 3 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 3 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 3 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsPremiumbrokerItem3Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 3 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Courtier haut de gamme / 3 / Risque.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 1 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 1 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 1 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 1 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 1 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 1 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 1 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 1 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 1 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 1 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 1 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 1 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 1 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 1 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem1Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 1 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 1 / Risque.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 2 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 2 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 2 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 2 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 2 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 2 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 2 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 2 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 2 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 2 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 2 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 2 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 2 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 2 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem2Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 2 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 2 / Risque.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsX = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 3 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 3 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsY = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 3 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 3 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsZ = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 3 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 3 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3CoordsW = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 3 / Coordonnées / W",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 3 / Coordonnées / W.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Label = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 3 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 3 / Libellé.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3PriceMultiplier = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 3 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 3 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Region = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 3 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 3 / Région.",
                },
                drugAdvancedContactNetworkSpotPoolsWholesalecontactItem3Risk = {
                    label = "Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 3 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Emplacement / Réserves de sélection / Contact de gros / 3 / Risque.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1AcceptBonus = {
                    label = "Réseau de contacts / Rue / Points sensibles / 1 / Bonus d'acceptation",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 1 / Bonus d'acceptation.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Archetype = {
                    label = "Réseau de contacts / Rue / Points sensibles / 1 / Archétype",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 1 / Archétype.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsX = {
                    label = "Réseau de contacts / Rue / Points sensibles / 1 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 1 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsY = {
                    label = "Réseau de contacts / Rue / Points sensibles / 1 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 1 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1CoordsZ = {
                    label = "Réseau de contacts / Rue / Points sensibles / 1 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 1 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1DemandBonus = {
                    label = "Réseau de contacts / Rue / Points sensibles / 1 / Bonus de demande",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 1 / Bonus de demande.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1HeatMultiplier = {
                    label = "Réseau de contacts / Rue / Points sensibles / 1 / Pression policière / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 1 / Pression policière / Multiplicateur.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Id = {
                    label = "Réseau de contacts / Rue / Points sensibles / 1 / ID",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 1 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Label = {
                    label = "Réseau de contacts / Rue / Points sensibles / 1 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 1 / Libellé.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem1 = {
                    label = "Réseau de contacts / Rue / Points sensibles / 1 / Drogues préférées / 1",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 1 / Drogues préférées / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem2 = {
                    label = "Réseau de contacts / Rue / Points sensibles / 1 / Drogues préférées / 2",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 1 / Drogues préférées / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem3 = {
                    label = "Réseau de contacts / Rue / Points sensibles / 1 / Drogues préférées / 3",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 1 / Drogues préférées / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PreferredDrugsItem4 = {
                    label = "Réseau de contacts / Rue / Points sensibles / 1 / Drogues préférées / 4",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 1 / Drogues préférées / 4.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1PriceMultiplier = {
                    label = "Réseau de contacts / Rue / Points sensibles / 1 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 1 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Radius = {
                    label = "Réseau de contacts / Rue / Points sensibles / 1 / Rayon",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 1 / Rayon.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1Region = {
                    label = "Réseau de contacts / Rue / Points sensibles / 1 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 1 / Région.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem1RobberyMultiplier = {
                    label = "Réseau de contacts / Rue / Points sensibles / 1 / Braquage / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 1 / Braquage / Multiplicateur.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2AcceptBonus = {
                    label = "Réseau de contacts / Rue / Points sensibles / 2 / Bonus d'acceptation",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 2 / Bonus d'acceptation.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Archetype = {
                    label = "Réseau de contacts / Rue / Points sensibles / 2 / Archétype",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 2 / Archétype.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsX = {
                    label = "Réseau de contacts / Rue / Points sensibles / 2 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 2 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsY = {
                    label = "Réseau de contacts / Rue / Points sensibles / 2 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 2 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2CoordsZ = {
                    label = "Réseau de contacts / Rue / Points sensibles / 2 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 2 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2DemandBonus = {
                    label = "Réseau de contacts / Rue / Points sensibles / 2 / Bonus de demande",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 2 / Bonus de demande.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2HeatMultiplier = {
                    label = "Réseau de contacts / Rue / Points sensibles / 2 / Pression policière / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 2 / Pression policière / Multiplicateur.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Id = {
                    label = "Réseau de contacts / Rue / Points sensibles / 2 / ID",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 2 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Label = {
                    label = "Réseau de contacts / Rue / Points sensibles / 2 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 2 / Libellé.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2MinimumQuality = {
                    label = "Réseau de contacts / Rue / Points sensibles / 2 / Qualité minimale",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 2 / Qualité minimale.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem1 = {
                    label = "Réseau de contacts / Rue / Points sensibles / 2 / Drogues préférées / 1",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 2 / Drogues préférées / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PreferredDrugsItem2 = {
                    label = "Réseau de contacts / Rue / Points sensibles / 2 / Drogues préférées / 2",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 2 / Drogues préférées / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2PriceMultiplier = {
                    label = "Réseau de contacts / Rue / Points sensibles / 2 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 2 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Radius = {
                    label = "Réseau de contacts / Rue / Points sensibles / 2 / Rayon",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 2 / Rayon.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2Region = {
                    label = "Réseau de contacts / Rue / Points sensibles / 2 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 2 / Région.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem2RobberyMultiplier = {
                    label = "Réseau de contacts / Rue / Points sensibles / 2 / Braquage / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 2 / Braquage / Multiplicateur.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3AcceptBonus = {
                    label = "Réseau de contacts / Rue / Points sensibles / 3 / Bonus d'acceptation",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 3 / Bonus d'acceptation.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Archetype = {
                    label = "Réseau de contacts / Rue / Points sensibles / 3 / Archétype",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 3 / Archétype.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsX = {
                    label = "Réseau de contacts / Rue / Points sensibles / 3 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 3 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsY = {
                    label = "Réseau de contacts / Rue / Points sensibles / 3 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 3 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3CoordsZ = {
                    label = "Réseau de contacts / Rue / Points sensibles / 3 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 3 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3DemandBonus = {
                    label = "Réseau de contacts / Rue / Points sensibles / 3 / Bonus de demande",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 3 / Bonus de demande.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3HeatMultiplier = {
                    label = "Réseau de contacts / Rue / Points sensibles / 3 / Pression policière / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 3 / Pression policière / Multiplicateur.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Id = {
                    label = "Réseau de contacts / Rue / Points sensibles / 3 / ID",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 3 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Label = {
                    label = "Réseau de contacts / Rue / Points sensibles / 3 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 3 / Libellé.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem1 = {
                    label = "Réseau de contacts / Rue / Points sensibles / 3 / Drogues préférées / 1",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 3 / Drogues préférées / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem2 = {
                    label = "Réseau de contacts / Rue / Points sensibles / 3 / Drogues préférées / 2",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 3 / Drogues préférées / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PreferredDrugsItem3 = {
                    label = "Réseau de contacts / Rue / Points sensibles / 3 / Drogues préférées / 3",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 3 / Drogues préférées / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3PriceMultiplier = {
                    label = "Réseau de contacts / Rue / Points sensibles / 3 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 3 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Radius = {
                    label = "Réseau de contacts / Rue / Points sensibles / 3 / Rayon",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 3 / Rayon.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3Region = {
                    label = "Réseau de contacts / Rue / Points sensibles / 3 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 3 / Région.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem3RobberyMultiplier = {
                    label = "Réseau de contacts / Rue / Points sensibles / 3 / Braquage / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 3 / Braquage / Multiplicateur.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4AcceptBonus = {
                    label = "Réseau de contacts / Rue / Points sensibles / 4 / Bonus d'acceptation",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 4 / Bonus d'acceptation.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Archetype = {
                    label = "Réseau de contacts / Rue / Points sensibles / 4 / Archétype",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 4 / Archétype.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsX = {
                    label = "Réseau de contacts / Rue / Points sensibles / 4 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 4 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsY = {
                    label = "Réseau de contacts / Rue / Points sensibles / 4 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 4 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4CoordsZ = {
                    label = "Réseau de contacts / Rue / Points sensibles / 4 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 4 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4DemandBonus = {
                    label = "Réseau de contacts / Rue / Points sensibles / 4 / Bonus de demande",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 4 / Bonus de demande.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4HeatMultiplier = {
                    label = "Réseau de contacts / Rue / Points sensibles / 4 / Pression policière / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 4 / Pression policière / Multiplicateur.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Id = {
                    label = "Réseau de contacts / Rue / Points sensibles / 4 / ID",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 4 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Label = {
                    label = "Réseau de contacts / Rue / Points sensibles / 4 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 4 / Libellé.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem1 = {
                    label = "Réseau de contacts / Rue / Points sensibles / 4 / Drogues préférées / 1",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 4 / Drogues préférées / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem2 = {
                    label = "Réseau de contacts / Rue / Points sensibles / 4 / Drogues préférées / 2",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 4 / Drogues préférées / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PreferredDrugsItem3 = {
                    label = "Réseau de contacts / Rue / Points sensibles / 4 / Drogues préférées / 3",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 4 / Drogues préférées / 3.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4PriceMultiplier = {
                    label = "Réseau de contacts / Rue / Points sensibles / 4 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 4 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Radius = {
                    label = "Réseau de contacts / Rue / Points sensibles / 4 / Rayon",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 4 / Rayon.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4Region = {
                    label = "Réseau de contacts / Rue / Points sensibles / 4 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 4 / Région.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem4RobberyMultiplier = {
                    label = "Réseau de contacts / Rue / Points sensibles / 4 / Braquage / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 4 / Braquage / Multiplicateur.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5AcceptBonus = {
                    label = "Réseau de contacts / Rue / Points sensibles / 5 / Bonus d'acceptation",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 5 / Bonus d'acceptation.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Archetype = {
                    label = "Réseau de contacts / Rue / Points sensibles / 5 / Archétype",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 5 / Archétype.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsX = {
                    label = "Réseau de contacts / Rue / Points sensibles / 5 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 5 / Coordonnées / X.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsY = {
                    label = "Réseau de contacts / Rue / Points sensibles / 5 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 5 / Coordonnées / Y.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5CoordsZ = {
                    label = "Réseau de contacts / Rue / Points sensibles / 5 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 5 / Coordonnées / Z.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5DemandBonus = {
                    label = "Réseau de contacts / Rue / Points sensibles / 5 / Bonus de demande",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 5 / Bonus de demande.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5HeatMultiplier = {
                    label = "Réseau de contacts / Rue / Points sensibles / 5 / Pression policière / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 5 / Pression policière / Multiplicateur.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Id = {
                    label = "Réseau de contacts / Rue / Points sensibles / 5 / ID",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 5 / ID.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Label = {
                    label = "Réseau de contacts / Rue / Points sensibles / 5 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 5 / Libellé.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem1 = {
                    label = "Réseau de contacts / Rue / Points sensibles / 5 / Drogues préférées / 1",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 5 / Drogues préférées / 1.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PreferredDrugsItem2 = {
                    label = "Réseau de contacts / Rue / Points sensibles / 5 / Drogues préférées / 2",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 5 / Drogues préférées / 2.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5PriceMultiplier = {
                    label = "Réseau de contacts / Rue / Points sensibles / 5 / Multiplicateur de prix",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 5 / Multiplicateur de prix.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Radius = {
                    label = "Réseau de contacts / Rue / Points sensibles / 5 / Rayon",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 5 / Rayon.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5Region = {
                    label = "Réseau de contacts / Rue / Points sensibles / 5 / Région",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 5 / Région.",
                },
                drugAdvancedContactNetworkStreetHotspotsItem5RobberyMultiplier = {
                    label = "Réseau de contacts / Rue / Points sensibles / 5 / Braquage / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Rue / Points sensibles / 5 / Braquage / Multiplicateur.",
                },
                drugAdvancedContactNetworkTrustLevelsKnown = {
                    label = "Réseau de contacts / Confiance / Niveaux / Connu",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Confiance / Niveaux / Connu.",
                },
                drugAdvancedContactNetworkTrustLevelsReliable = {
                    label = "Réseau de contacts / Confiance / Niveaux / Fiable",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Confiance / Niveaux / Fiable.",
                },
                drugAdvancedContactNetworkTrustLevelsTrusted = {
                    label = "Réseau de contacts / Confiance / Niveaux / Digne de confiance",
                    description = "Paramètre de fonctionnement pour Réseau de contacts / Confiance / Niveaux / Digne de confiance.",
                },
                drugAdvancedBusinessNetworkActionCooldownSeconds = {
                    label = "Réseau d'entreprises / Délai de récupération de l'action / secondes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Délai de récupération de l'action / secondes.",
                },
                drugAdvancedBusinessNetworkBalanceBaseUnitPrice = {
                    label = "Réseau d'entreprises / Solde / Valeur de base / Prix unitaire",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Solde / Valeur de base / Prix unitaire.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerDealer = {
                    label = "Réseau d'entreprises / Solde / Chaleur du réseau / Par dealer",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Solde / Chaleur du réseau / Par dealer.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerHub = {
                    label = "Réseau d'entreprises / Solde / Chaleur du réseau / Par centre de distribution",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Solde / Chaleur du réseau / Par centre de distribution.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerRoute = {
                    label = "Réseau d'entreprises / Solde / Chaleur du réseau / Par route",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Solde / Chaleur du réseau / Par route.",
                },
                drugAdvancedBusinessNetworkBalanceNetworkHeatPerStaff = {
                    label = "Réseau d'entreprises / Solde / Chaleur du réseau / Par employé",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Solde / Chaleur du réseau / Par employé.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityGain = {
                    label = "Réseau d'entreprises / Solde / Fiabilité / gain",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Solde / Fiabilité / gain.",
                },
                drugAdvancedBusinessNetworkBalanceReliabilityLoss = {
                    label = "Réseau d'entreprises / Solde / Fiabilité / Perte",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Solde / Fiabilité / Perte.",
                },
                drugAdvancedBusinessNetworkBalanceRouteHeatDecay = {
                    label = "Réseau d'entreprises / Solde / Itinéraire / Pression policière / Déclin",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Solde / Itinéraire / Pression policière / Déclin.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / gang / Quantité / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / gang / Quantité / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangAmountItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / gang / Quantité / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / gang / Quantité / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangMinRank = {
                    label = "Réseau d'entreprises / Contrats / Catégories / gang / Minimum / Grade",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / gang / Minimum / Grade.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / gang / Qualité / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / gang / Qualité / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangQualityItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / gang / Qualité / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / gang / Qualité / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / gang / Récompense / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / gang / Récompense / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRewardItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / gang / Récompense / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / gang / Récompense / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / gang / Risque / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / gang / Risque / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesGangRiskItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / gang / Risque / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / gang / Risque / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Quantité / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Quantité / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkAmountItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Quantité / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Quantité / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkMinRank = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Minimum / Grade",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Minimum / Grade.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Qualité / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Qualité / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkQualityItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Qualité / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Qualité / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Récompense / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Récompense / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRewardItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Récompense / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Récompense / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Risque / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Risque / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesNpcnetworkRiskItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Risque / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Réseau NPC / Risque / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Organisation / Quantité / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Organisation / Quantité / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationAmountItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Organisation / Quantité / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Organisation / Quantité / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationMinRank = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Organisation / Minimum / Grade",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Organisation / Minimum / Grade.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Organisation / Qualité / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Organisation / Qualité / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationQualityItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Organisation / Qualité / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Organisation / Qualité / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Organisation / Récompense / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Organisation / Récompense / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRewardItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Organisation / Récompense / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Organisation / Récompense / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Organisation / Risque / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Organisation / Risque / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesOrganizationRiskItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Organisation / Risque / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Organisation / Risque / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Premium / Quantité / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Premium / Quantité / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumAmountItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Premium / Quantité / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Premium / Quantité / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumMinRank = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Premium / Minimum / Grade",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Premium / Minimum / Grade.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Premium / Qualité / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Premium / Qualité / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumQualityItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Premium / Qualité / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Premium / Qualité / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Premium / Récompense / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Premium / Récompense / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRewardItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Premium / Récompense / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Premium / Récompense / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Premium / Risque / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Premium / Risque / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPremiumRiskItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Premium / Risque / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Premium / Risque / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Revendeur / Quantité / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Revendeur / Quantité / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherAmountItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Revendeur / Quantité / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Revendeur / Quantité / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherMinRank = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Revendeur / Minimum / Grade",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Revendeur / Minimum / Grade.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Revendeur / Qualité / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Revendeur / Qualité / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherQualityItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Revendeur / Qualité / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Revendeur / Qualité / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Revendeur / Récompense / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Revendeur / Récompense / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRewardItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Revendeur / Récompense / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Revendeur / Récompense / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Revendeur / Risque / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Revendeur / Risque / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesPusherRiskItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Revendeur / Risque / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Revendeur / Risque / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Spécial / Quantité / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Spécial / Quantité / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialAmountItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Spécial / Quantité / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Spécial / Quantité / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialMinRank = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Spécial / Minimum / Grade",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Spécial / Minimum / Grade.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Spécial / Qualité / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Spécial / Qualité / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialQualityItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Spécial / Qualité / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Spécial / Qualité / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Spécial / Récompense / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Spécial / Récompense / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRewardItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Spécial / Récompense / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Spécial / Récompense / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Spécial / Risque / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Spécial / Risque / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesSpecialRiskItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Spécial / Risque / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Spécial / Risque / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Vente en gros / Quantité / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Vente en gros / Quantité / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleAmountItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Vente en gros / Quantité / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Vente en gros / Quantité / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleMinRank = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Vente en gros / Minimum / Grade",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Vente en gros / Minimum / Grade.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Vente en gros / Qualité / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Vente en gros / Qualité / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleQualityItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Vente en gros / Qualité / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Vente en gros / Qualité / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Vente en gros / Récompense / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Vente en gros / Récompense / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRewardItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Vente en gros / Récompense / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Vente en gros / Récompense / 2.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem1 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Vente en gros / Risque / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Vente en gros / Risque / 1.",
                },
                drugAdvancedBusinessNetworkContractsCategoriesWholesaleRiskItem2 = {
                    label = "Réseau d'entreprises / Contrats / Catégories / Vente en gros / Risque / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Catégories / Vente en gros / Risque / 2.",
                },
                drugAdvancedBusinessNetworkContractsDeliveryDistance = {
                    label = "Réseau d'entreprises / Contrats / Distance de livraison",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Distance de livraison.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMax = {
                    label = "Réseau d'entreprises / Contrats / Durée / Minutes / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Durée / Minutes / Maximum.",
                },
                drugAdvancedBusinessNetworkContractsDurationMinutesMin = {
                    label = "Réseau d'entreprises / Contrats / Durée / Minutes / Minimum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Durée / Minutes / Minimum.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsX = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 1 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 1 / Coordonnées / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsY = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 1 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 1 / Coordonnées / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1CoordsZ = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 1 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 1 / Coordonnées / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Id = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 1 / ID",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 1 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Label = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 1 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 1 / Libellé.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Region = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 1 / Région",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 1 / Région.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1RewardMultiplier = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 1 / Récompense / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 1 / Récompense / Multiplicateur.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem1Risk = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 1 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 1 / Risque.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsX = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 2 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 2 / Coordonnées / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsY = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 2 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 2 / Coordonnées / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2CoordsZ = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 2 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 2 / Coordonnées / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Id = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 2 / ID",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 2 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Label = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 2 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 2 / Libellé.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Region = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 2 / Région",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 2 / Région.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2RewardMultiplier = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 2 / Récompense / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 2 / Récompense / Multiplicateur.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem2Risk = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 2 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 2 / Risque.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsX = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 3 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 3 / Coordonnées / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsY = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 3 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 3 / Coordonnées / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3CoordsZ = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 3 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 3 / Coordonnées / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Id = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 3 / ID",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 3 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Label = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 3 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 3 / Libellé.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Region = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 3 / Région",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 3 / Région.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3RewardMultiplier = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 3 / Récompense / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 3 / Récompense / Multiplicateur.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem3Risk = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 3 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 3 / Risque.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsX = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 4 / Coordonnées / X",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 4 / Coordonnées / X.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsY = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 4 / Coordonnées / Y",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 4 / Coordonnées / Y.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4CoordsZ = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 4 / Coordonnées / Z",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 4 / Coordonnées / Z.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Id = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 4 / ID",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 4 / ID.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Label = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 4 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 4 / Libellé.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Region = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 4 / Région",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 4 / Région.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4RewardMultiplier = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 4 / Récompense / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 4 / Récompense / Multiplicateur.",
                },
                drugAdvancedBusinessNetworkContractsMeetingPointsItem4Risk = {
                    label = "Réseau d'entreprises / Contrats / Rencontre / Points / 4 / Risque",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Rencontre / Points / 4 / Risque.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem1 = {
                    label = "Réseau d'entreprises / Contrats / Négociation / Avance / Options / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Négociation / Avance / Options / 1.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem2 = {
                    label = "Réseau d'entreprises / Contrats / Négociation / Avance / Options / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Négociation / Avance / Options / 2.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAdvanceOptionsItem3 = {
                    label = "Réseau d'entreprises / Contrats / Négociation / Avance / Options / 3",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Négociation / Avance / Options / 3.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationAmountFlexPercent = {
                    label = "Réseau d'entreprises / Contrats / Négociation / Quantité / Marge de négociation / Pourcentage",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Négociation / Quantité / Marge de négociation / Pourcentage.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationBaseAcceptance = {
                    label = "Réseau d'entreprises / Contrats / Négociation / Valeur de base / Acceptation",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Négociation / Valeur de base / Acceptation.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationDeadlineFlexPercent = {
                    label = "Réseau d'entreprises / Contrats / Négociation / Échéance / Marge de négociation / Pourcentage",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Négociation / Échéance / Marge de négociation / Pourcentage.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationMaxRounds = {
                    label = "Réseau d'entreprises / Contrats / Négociation / Maximum / Manches",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Négociation / Maximum / Manches.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationQualityFlex = {
                    label = "Réseau d'entreprises / Contrats / Négociation / Qualité / Marge de négociation",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Négociation / Qualité / Marge de négociation.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRejectionCooldownMinutes = {
                    label = "Réseau d'entreprises / Contrats / Négociation / Refus / Minutes de délai",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Négociation / Refus / Minutes de délai.",
                },
                drugAdvancedBusinessNetworkContractsNegotiationRoundPressure = {
                    label = "Réseau d'entreprises / Contrats / Négociation / Round / Pression",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Négociation / Round / Pression.",
                },
                drugAdvancedBusinessNetworkContractsOfferCount = {
                    label = "Réseau d'entreprises / Contrats / Offre / Nombre",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Offre / Nombre.",
                },
                drugAdvancedBusinessNetworkContractsRefreshMinutes = {
                    label = "Réseau d'entreprises / Contrats / Actualisation / Minutes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Contrats / Actualisation / Minutes.",
                },
                drugAdvancedBusinessNetworkDefaultBusinessName = {
                    label = "Réseau d'entreprises / Valeur par défaut / Nom de l'entreprise",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Valeur par défaut / Nom de l'entreprise.",
                },
                drugAdvancedBusinessNetworkDefaultRankId = {
                    label = "Réseau d'entreprises / Valeur par défaut / Grade / ID",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Valeur par défaut / Grade / ID.",
                },
                drugAdvancedBusinessNetworkDefaultStaffStyle = {
                    label = "Réseau d'entreprises / Valeur par défaut / Personnel / Style de travail",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Valeur par défaut / Personnel / Style de travail.",
                },
                drugAdvancedBusinessNetworkDefaultTransport = {
                    label = "Réseau d'entreprises / Valeur par défaut / Transports",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Valeur par défaut / Transports.",
                },
                drugAdvancedBusinessNetworkEnabled = {
                    label = "Réseau d'entreprises / Activé",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Activé.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterCapacity = {
                    label = "Réseau d'entreprises / Centres de distribution / Centre de distribution / capacité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Centres de distribution / Centre de distribution / capacité.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterPurchasePrice = {
                    label = "Réseau d'entreprises / Centres de distribution / Centre de distribution / Prix d'achat",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Centres de distribution / Centre de distribution / Prix d'achat.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterSecurity = {
                    label = "Réseau d'entreprises / Centres de distribution / Centre de distribution / Sécurité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Centres de distribution / Centre de distribution / Sécurité.",
                },
                drugAdvancedBusinessNetworkHubsDistributioncenterUpkeep = {
                    label = "Réseau d'entreprises / Centres de distribution / Centre de distribution / Entretien",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Centres de distribution / Centre de distribution / Entretien.",
                },
                drugAdvancedBusinessNetworkHubsStashCapacity = {
                    label = "Réseau d'entreprises / Centres de distribution / Cachette / capacité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Centres de distribution / Cachette / capacité.",
                },
                drugAdvancedBusinessNetworkHubsStashPurchasePrice = {
                    label = "Réseau d'entreprises / Centres de distribution / Cachette / Prix d'achat",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Centres de distribution / Cachette / Prix d'achat.",
                },
                drugAdvancedBusinessNetworkHubsStashSecurity = {
                    label = "Réseau d'entreprises / Centres de distribution / Cachette / Sécurité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Centres de distribution / Cachette / Sécurité.",
                },
                drugAdvancedBusinessNetworkHubsStashUpkeep = {
                    label = "Réseau d'entreprises / Centres de distribution / Cachette / Entretien",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Centres de distribution / Cachette / Entretien.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseCapacity = {
                    label = "Réseau d'entreprises / Centres de distribution / Entrepôt / capacité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Centres de distribution / Entrepôt / capacité.",
                },
                drugAdvancedBusinessNetworkHubsWarehousePurchasePrice = {
                    label = "Réseau d'entreprises / Centres de distribution / Entrepôt / Prix d'achat",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Centres de distribution / Entrepôt / Prix d'achat.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseSecurity = {
                    label = "Réseau d'entreprises / Centres de distribution / Entrepôt / Sécurité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Centres de distribution / Entrepôt / Sécurité.",
                },
                drugAdvancedBusinessNetworkHubsWarehouseUpkeep = {
                    label = "Réseau d'entreprises / Centres de distribution / Entrepôt / Entretien",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Centres de distribution / Entrepôt / Entretien.",
                },
                drugAdvancedBusinessNetworkLimitsActiveContracts = {
                    label = "Réseau d'entreprises / Limites / Contrats actifs",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Limites / Contrats actifs.",
                },
                drugAdvancedBusinessNetworkLimitsHubs = {
                    label = "Réseau d'entreprises / Limites / Centres de distribution",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Limites / Centres de distribution.",
                },
                drugAdvancedBusinessNetworkLimitsLedgerRows = {
                    label = "Réseau d'entreprises / Limites / Registre comptable / Lignes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Limites / Registre comptable / Lignes.",
                },
                drugAdvancedBusinessNetworkLimitsRoutes = {
                    label = "Réseau d'entreprises / Limites / Routes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Limites / Routes.",
                },
                drugAdvancedBusinessNetworkLimitsStaff = {
                    label = "Réseau d'entreprises / Limites / Personnel",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Limites / Personnel.",
                },
                drugAdvancedBusinessNetworkPayoutAccount = {
                    label = "Réseau d'entreprises / Paiement / Compte",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Paiement / Compte.",
                },
                drugAdvancedBusinessNetworkRanksItem1Contracts = {
                    label = "Réseau d'entreprises / Rangs / 1 / Contrats",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 1 / Contrats.",
                },
                drugAdvancedBusinessNetworkRanksItem1Dealers = {
                    label = "Réseau d'entreprises / Rangs / 1 / Revendeurs",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 1 / Revendeurs.",
                },
                drugAdvancedBusinessNetworkRanksItem1Hubs = {
                    label = "Réseau d'entreprises / Rangs / 1 / Centres de distribution",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 1 / Centres de distribution.",
                },
                drugAdvancedBusinessNetworkRanksItem1Id = {
                    label = "Réseau d'entreprises / Rangs / 1 / ID",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 1 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem1Label = {
                    label = "Réseau d'entreprises / Rangs / 1 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 1 / Libellé.",
                },
                drugAdvancedBusinessNetworkRanksItem1Routes = {
                    label = "Réseau d'entreprises / Rangs / 1 / Routes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 1 / Routes.",
                },
                drugAdvancedBusinessNetworkRanksItem1Score = {
                    label = "Réseau d'entreprises / Rangs / 1 / Score",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 1 / Score.",
                },
                drugAdvancedBusinessNetworkRanksItem1Staff = {
                    label = "Réseau d'entreprises / Rangs / 1 / Personnel",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 1 / Personnel.",
                },
                drugAdvancedBusinessNetworkRanksItem2Contracts = {
                    label = "Réseau d'entreprises / Rangs / 2 / Contrats",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 2 / Contrats.",
                },
                drugAdvancedBusinessNetworkRanksItem2Dealers = {
                    label = "Réseau d'entreprises / Rangs / 2 / Revendeurs",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 2 / Revendeurs.",
                },
                drugAdvancedBusinessNetworkRanksItem2Hubs = {
                    label = "Réseau d'entreprises / Rangs / 2 / Centres de distribution",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 2 / Centres de distribution.",
                },
                drugAdvancedBusinessNetworkRanksItem2Id = {
                    label = "Réseau d'entreprises / Rangs / 2 / ID",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 2 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem2Label = {
                    label = "Réseau d'entreprises / Rangs / 2 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 2 / Libellé.",
                },
                drugAdvancedBusinessNetworkRanksItem2Routes = {
                    label = "Réseau d'entreprises / Rangs / 2 / Routes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 2 / Routes.",
                },
                drugAdvancedBusinessNetworkRanksItem2Score = {
                    label = "Réseau d'entreprises / Rangs / 2 / Score",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 2 / Score.",
                },
                drugAdvancedBusinessNetworkRanksItem2Staff = {
                    label = "Réseau d'entreprises / Rangs / 2 / Personnel",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 2 / Personnel.",
                },
                drugAdvancedBusinessNetworkRanksItem3Contracts = {
                    label = "Réseau d'entreprises / Rangs / 3 / Contrats",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 3 / Contrats.",
                },
                drugAdvancedBusinessNetworkRanksItem3Dealers = {
                    label = "Réseau d'entreprises / Rangs / 3 / Revendeurs",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 3 / Revendeurs.",
                },
                drugAdvancedBusinessNetworkRanksItem3Hubs = {
                    label = "Réseau d'entreprises / Rangs / 3 / Centres de distribution",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 3 / Centres de distribution.",
                },
                drugAdvancedBusinessNetworkRanksItem3Id = {
                    label = "Réseau d'entreprises / Rangs / 3 / ID",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 3 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem3Label = {
                    label = "Réseau d'entreprises / Rangs / 3 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 3 / Libellé.",
                },
                drugAdvancedBusinessNetworkRanksItem3Routes = {
                    label = "Réseau d'entreprises / Rangs / 3 / Routes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 3 / Routes.",
                },
                drugAdvancedBusinessNetworkRanksItem3Score = {
                    label = "Réseau d'entreprises / Rangs / 3 / Score",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 3 / Score.",
                },
                drugAdvancedBusinessNetworkRanksItem3Staff = {
                    label = "Réseau d'entreprises / Rangs / 3 / Personnel",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 3 / Personnel.",
                },
                drugAdvancedBusinessNetworkRanksItem4Contracts = {
                    label = "Réseau d'entreprises / Rangs / 4 / Contrats",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 4 / Contrats.",
                },
                drugAdvancedBusinessNetworkRanksItem4Dealers = {
                    label = "Réseau d'entreprises / Rangs / 4 / Revendeurs",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 4 / Revendeurs.",
                },
                drugAdvancedBusinessNetworkRanksItem4Hubs = {
                    label = "Réseau d'entreprises / Rangs / 4 / Centres de distribution",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 4 / Centres de distribution.",
                },
                drugAdvancedBusinessNetworkRanksItem4Id = {
                    label = "Réseau d'entreprises / Rangs / 4 / ID",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 4 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem4Label = {
                    label = "Réseau d'entreprises / Rangs / 4 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 4 / Libellé.",
                },
                drugAdvancedBusinessNetworkRanksItem4Routes = {
                    label = "Réseau d'entreprises / Rangs / 4 / Routes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 4 / Routes.",
                },
                drugAdvancedBusinessNetworkRanksItem4Score = {
                    label = "Réseau d'entreprises / Rangs / 4 / Score",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 4 / Score.",
                },
                drugAdvancedBusinessNetworkRanksItem4Staff = {
                    label = "Réseau d'entreprises / Rangs / 4 / Personnel",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 4 / Personnel.",
                },
                drugAdvancedBusinessNetworkRanksItem5Contracts = {
                    label = "Réseau d'entreprises / Rangs / 5 / Contrats",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 5 / Contrats.",
                },
                drugAdvancedBusinessNetworkRanksItem5Dealers = {
                    label = "Réseau d'entreprises / Rangs / 5 / Revendeurs",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 5 / Revendeurs.",
                },
                drugAdvancedBusinessNetworkRanksItem5Hubs = {
                    label = "Réseau d'entreprises / Rangs / 5 / Centres de distribution",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 5 / Centres de distribution.",
                },
                drugAdvancedBusinessNetworkRanksItem5Id = {
                    label = "Réseau d'entreprises / Rangs / 5 / ID",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 5 / ID.",
                },
                drugAdvancedBusinessNetworkRanksItem5Label = {
                    label = "Réseau d'entreprises / Rangs / 5 / Libellé",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 5 / Libellé.",
                },
                drugAdvancedBusinessNetworkRanksItem5Routes = {
                    label = "Réseau d'entreprises / Rangs / 5 / Routes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 5 / Routes.",
                },
                drugAdvancedBusinessNetworkRanksItem5Score = {
                    label = "Réseau d'entreprises / Rangs / 5 / Score",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 5 / Score.",
                },
                drugAdvancedBusinessNetworkRanksItem5Staff = {
                    label = "Réseau d'entreprises / Rangs / 5 / Personnel",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Rangs / 5 / Personnel.",
                },
                drugAdvancedBusinessNetworkReportDays = {
                    label = "Réseau d'entreprises / Période du rapport / jours",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Période du rapport / jours.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesBuyer = {
                    label = "Réseau d'entreprises / Itinéraire / Point d'arrivée / Types / Acheteur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Itinéraire / Point d'arrivée / Types / Acheteur.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesContract = {
                    label = "Réseau d'entreprises / Itinéraire / Point d'arrivée / Types / Contrat",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Itinéraire / Point d'arrivée / Types / Contrat.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesDealer = {
                    label = "Réseau d'entreprises / Itinéraire / Point d'arrivée / Types / Dealer",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Itinéraire / Point d'arrivée / Types / Dealer.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesGang = {
                    label = "Réseau d'entreprises / Itinéraire / Point d'arrivée / Types / gang",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Itinéraire / Point d'arrivée / Types / gang.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesHub = {
                    label = "Réseau d'entreprises / Itinéraire / Point d'arrivée / Types / Centre de distribution",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Itinéraire / Point d'arrivée / Types / Centre de distribution.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesLab = {
                    label = "Réseau d'entreprises / Itinéraire / Point d'arrivée / Types / Labo",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Itinéraire / Point d'arrivée / Types / Labo.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesOrganization = {
                    label = "Réseau d'entreprises / Itinéraire / Point d'arrivée / Types / Organisation",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Itinéraire / Point d'arrivée / Types / Organisation.",
                },
                drugAdvancedBusinessNetworkRouteEndpointTypesPusher = {
                    label = "Réseau d'entreprises / Itinéraire / Point d'arrivée / Types / Revendeur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Itinéraire / Point d'arrivée / Types / Revendeur.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMax = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Contrat / Fréquence / Minutes / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Contrat / Fréquence / Minutes / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCadenceMinutesMin = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Contrat / Fréquence / Minutes / Minimum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Contrat / Fréquence / Minutes / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractCooldownMinimumMinutes = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Contrat / Temps de recharge / Minimum / Minutes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Contrat / Temps de recharge / Minimum / Minutes.",
                },
                drugAdvancedBusinessNetworkRuntimeContractFailureReliabilityLoss = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Contrat / Échec / Fiabilité / Perte",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Contrat / Échec / Fiabilité / Perte.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumCadenceMinutes = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Contrat / Minimum / Fréquence / Minutes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Contrat / Minimum / Fréquence / Minutes.",
                },
                drugAdvancedBusinessNetworkRuntimeContractMinimumMeetingMultiplier = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Contrat / Minimum / Rencontre / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Contrat / Minimum / Rencontre / Multiplicateur.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyGrowth = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Pénalité de contrat / Croissance",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Pénalité de contrat / Croissance.",
                },
                drugAdvancedBusinessNetworkRuntimeContractPenaltyMultiplier = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Pénalité de contrat / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Pénalité de contrat / Multiplicateur.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityFailureCooldownMinutes = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Contrat / Qualité / Échec / Minutes de délai",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Contrat / Qualité / Échec / Minutes de délai.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceBase = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Contrat / Qualité / Prix / Valeur de base",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Contrat / Qualité / Prix / Valeur de base.",
                },
                drugAdvancedBusinessNetworkRuntimeContractQualityPriceDivisor = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Contrat / Qualité / Prix / Diviseur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Contrat / Qualité / Prix / Diviseur.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossBase = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Contrat / Fiabilité / Perte / Valeur de base",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Contrat / Fiabilité / Perte / Valeur de base.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossMaximum = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Contrat / Fiabilité / Perte / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Contrat / Fiabilité / Perte / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReliabilityLossQualityWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Contrat / Fiabilité / Perte / Qualité / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Contrat / Fiabilité / Perte / Qualité / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeContractReputationQualityWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Contrat / Réputation / Qualité / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Contrat / Réputation / Qualité / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsCategory = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Contrat / Risque / Pondérations / Catégorie",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Contrat / Risque / Pondérations / Catégorie.",
                },
                drugAdvancedBusinessNetworkRuntimeContractRiskWeightsMeeting = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Contrat / Risque / Pondérations / Rencontre",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Contrat / Risque / Pondérations / Rencontre.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubCapacity = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Valeur par défaut / Centre de distribution / capacité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Valeur par défaut / Centre de distribution / capacité.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultHubSecurity = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Valeur par défaut / Centre de distribution / Sécurité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Valeur par défaut / Centre de distribution / Sécurité.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultMeetingRisk = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Valeur par défaut / Rencontre / Risque",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Valeur par défaut / Rencontre / Risque.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultQuality = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Valeur par défaut / Qualité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Valeur par défaut / Qualité.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteCapacity = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Valeur par défaut / Capacité de la route",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Valeur par défaut / Capacité de la route.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteIntervalMinutes = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Valeur par défaut / Itinéraire / Intervalle / Minutes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Valeur par défaut / Itinéraire / Intervalle / Minutes.",
                },
                drugAdvancedBusinessNetworkRuntimeDefaultRouteRisk = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Valeur par défaut / Itinéraire / Risque",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Valeur par défaut / Itinéraire / Risque.",
                },
                drugAdvancedBusinessNetworkRuntimeHubHeatDecay = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Pression policière / Déclin",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Pression policière / Déclin.",
                },
                drugAdvancedBusinessNetworkRuntimeHubLoadHeat = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Charge / Pression policière",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Charge / Pression policière.",
                },
                drugAdvancedBusinessNetworkRuntimeHubRaidRecoveryMinutes = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Raid / Récupération / Minutes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Raid / Récupération / Minutes.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostBase = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Sécurité / Coût / Valeur de base",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Sécurité / Coût / Valeur de base.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityCostPerLevel = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Sécurité / Coût / Par niveau",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Sécurité / Coût / Par niveau.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityMaximum = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Sécurité / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Sécurité / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeHubSecurityUpgrade = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Sécurité / Amélioration",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Sécurité / Amélioration.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidHeat = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Impayé / Pression policière",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Impayé / Pression policière.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUnpaidSecurityLoss = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Impayé / Sécurité / Perte",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Impayé / Sécurité / Perte.",
                },
                drugAdvancedBusinessNetworkRuntimeHubUpkeepIntervalHours = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Entretien / Intervalle / Heures",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Centre de distribution / Entretien / Intervalle / Heures.",
                },
                drugAdvancedBusinessNetworkRuntimeInitialReliability = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Valeur initiale / Fiabilité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Valeur initiale / Fiabilité.",
                },
                drugAdvancedBusinessNetworkRuntimeMaximumBusinessNameLength = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Maximum / Nom de l'entreprise / Longueur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Maximum / Nom de l'entreprise / Longueur.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumContractDeliveryMinutes = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Minimum / Contrat / Livraison / Minutes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Minimum / Contrat / Livraison / Minutes.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumDeliveryDistance = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Minimum / Distance de livraison",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Minimum / Distance de livraison.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumLedgerRows = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Minimum / Registre comptable / Lignes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Minimum / Registre comptable / Lignes.",
                },
                drugAdvancedBusinessNetworkRuntimeMinimumRouteIntervalMinutes = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Minimum / Itinéraire / Intervalle / Minutes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Minimum / Itinéraire / Intervalle / Minutes.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvanceCostWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Avance / Coût / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Avance / Coût / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAdvancePriceWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Avance / Prix / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Avance / Prix / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountCostWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Quantité / Coût / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Quantité / Coût / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountFlexMaximum = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Quantité / Marge de négociation / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Quantité / Marge de négociation / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationAmountRiskWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Quantité / Risque / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Quantité / Risque / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationCounterOfferWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Contre-offre / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Contre-offre / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationDeadlineFlexMaximum = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Échéance / Marge de négociation / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Échéance / Marge de négociation / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMaximumAcceptance = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Maximum / Acceptation",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Maximum / Acceptation.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationMinimumAcceptance = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Minimum / Acceptation",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Minimum / Acceptation.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityBenefitWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Qualité / Bénéfice / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Qualité / Bénéfice / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityCostWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Qualité / Coût / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Qualité / Coût / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityFlexMaximum = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Qualité / Marge de négociation / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Qualité / Marge de négociation / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationQualityRewardWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Qualité / Récompense / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Qualité / Récompense / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReliabilityWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Fiabilité / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Fiabilité / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationReputationWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Réputation / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Réputation / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMax = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Récompense demandée / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Récompense demandée / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRequestedRewardMin = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Récompense demandée / Minimum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Récompense demandée / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardCostWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Récompense / Coût / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Récompense / Coût / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMax = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Récompense / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Récompense / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationRewardMin = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Récompense / Minimum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Récompense / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBase = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Urgence / Valeur de base",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Urgence / Valeur de base.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyBenefitWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Urgence / Bénéfice / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Urgence / Bénéfice / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyRiskWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Urgence / Risque / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Urgence / Risque / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeNegotiationUrgencyWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Négociation / Urgence / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Négociation / Urgence / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeOtherFailureHeat = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Autre / Échec / Pression policière",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Autre / Échec / Pression policière.",
                },
                drugAdvancedBusinessNetworkRuntimePersonalHeatWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Pression personnelle / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Pression personnelle / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimePoliceFailureHeat = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Police / Échec / Pression policière",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Police / Échec / Pression policière.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBaseUnits = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Revendeur / Valeur de base / unités",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Revendeur / Valeur de base / unités.",
                },
                drugAdvancedBusinessNetworkRuntimePusherBulkMultiplier = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Revendeur / En gros / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Revendeur / En gros / Multiplicateur.",
                },
                drugAdvancedBusinessNetworkRuntimePusherCheapMultiplier = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Revendeur / Ventes à bas prix / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Revendeur / Ventes à bas prix / Multiplicateur.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerLevel = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Revendeur / Expérience / Par niveau",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Revendeur / Expérience / Par niveau.",
                },
                drugAdvancedBusinessNetworkRuntimePusherExperiencePerUnit = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Revendeur / Expérience / Par unité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Revendeur / Expérience / Par unité.",
                },
                drugAdvancedBusinessNetworkRuntimePusherHubHeatPerUnit = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Revendeur / Centre de distribution / Pression policière / Par unité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Revendeur / Centre de distribution / Pression policière / Par unité.",
                },
                drugAdvancedBusinessNetworkRuntimePusherPremiumMultiplier = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Revendeur / Premium / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Revendeur / Premium / Multiplicateur.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillDivisor = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Revendeur / Compétence / Diviseur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Revendeur / Compétence / Diviseur.",
                },
                drugAdvancedBusinessNetworkRuntimePusherSkillGain = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Revendeur / Compétence / gain",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Revendeur / Compétence / gain.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationBaseSeconds = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Durée / Valeur de base / secondes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Durée / Valeur de base / secondes.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteDurationPerUnitSeconds = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Durée / Par unité / secondes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Durée / Par unité / secondes.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem1 = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Échec / Causes / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Échec / Causes / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem2 = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Échec / Causes / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Échec / Causes / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem3 = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Échec / Causes / 3",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Échec / Causes / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureCausesItem4 = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Échec / Causes / 4",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Échec / Causes / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteFailureValueMultiplier = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Échec / Valeur / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Échec / Valeur / Multiplicateur.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatAmountDivisor = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Pression policière / Quantité / Diviseur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Pression policière / Quantité / Diviseur.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostBase = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Réduction de la pression de recherche / Coût / Valeur de base",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Réduction de la pression de recherche / Coût / Valeur de base.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteHeatReductionCostPerHeat = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Réduction de la pression de recherche / Coût / Par point de suspicion",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Réduction de la pression de recherche / Coût / Par point de suspicion.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMaximum = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Risque / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Risque / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskMinimum = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Risque / Minimum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Risque / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsHeat = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Risque / Pondérations / Pression policière",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Risque / Pondérations / Pression policière.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsLoyalty = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Risque / Pondérations / Loyauté",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Risque / Pondérations / Loyauté.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsRunnerRisk = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Risque / Pondérations / Coursier / Risque",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Risque / Pondérations / Coursier / Risque.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRiskWeightsSkill = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Risque / Pondérations / Compétence",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Risque / Pondérations / Compétence.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationHeatReduction = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Rotation de route / Réduction de la pression de recherche",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Rotation de route / Réduction de la pression de recherche.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteRotationRiskReduction = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Rotation de route / Risque / Réduction",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Rotation de route / Risque / Réduction.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityBase = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Vente / Base de qualité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Vente / Base de qualité.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleQualityDivisor = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Vente / Qualité / Diviseur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Vente / Qualité / Diviseur.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteSaleRiskDivisor = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Vente / Risque / Diviseur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Vente / Risque / Diviseur.",
                },
                drugAdvancedBusinessNetworkRuntimeRouteStartHeat = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Début / Pression policière",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Itinéraire / Début / Pression policière.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerLevel = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Coursier / Expérience / Par niveau",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Coursier / Expérience / Par niveau.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerExperiencePerUnit = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Coursier / Expérience / Par unité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Coursier / Expérience / Par unité.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureLoyaltyLoss = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Coursier / Échec / Loyauté / Perte",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Coursier / Échec / Loyauté / Perte.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerFailureRiskGain = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Coursier / Risque d'échec / gain",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Coursier / Risque d'échec / gain.",
                },
                drugAdvancedBusinessNetworkRuntimeRunnerSkillGain = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Coursier / Compétence / gain",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Coursier / Compétence / gain.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsHeat = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Score / Pondérations / Pression policière",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Score / Pondérations / Pression policière.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReliability = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Score / Pondérations / Fiabilité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Score / Pondérations / Fiabilité.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsReputation = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Score / Pondérations / Réputation",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Score / Pondérations / Réputation.",
                },
                drugAdvancedBusinessNetworkRuntimeScoreWeightsStructure = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Score / Pondérations / Structure",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Score / Pondérations / Structure.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffCapacityBaseMultiplier = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / capacité / Valeur de base / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / capacité / Valeur de base / Multiplicateur.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMax = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Recrutement / Loyauté / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Recrutement / Loyauté / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireLoyaltyMin = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Recrutement / Loyauté / Minimum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Recrutement / Loyauté / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMax = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Recrutement / Risque / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Recrutement / Risque / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireRiskMin = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Recrutement / Risque / Minimum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Recrutement / Risque / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMax = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Recrutement / Compétence / Maximum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Recrutement / Compétence / Maximum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffHireSkillMin = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Recrutement / Compétence / Minimum",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Recrutement / Compétence / Minimum.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentLoyaltyWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Incident / Loyauté / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Incident / Loyauté / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentMaximumChance = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Incident / Maximum / Chance",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Incident / Maximum / Chance.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem1 = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Incident / Résultats / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Incident / Résultats / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem2 = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Incident / Résultats / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Incident / Résultats / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem3 = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Incident / Résultats / 3",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Incident / Résultats / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentOutcomesItem4 = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Incident / Résultats / 4",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Incident / Résultats / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffIncidentRiskWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Incident / Risque / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Incident / Risque / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffLoyaltyDecay = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Loyauté / Déclin",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Loyauté / Déclin.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffMaximumLevel = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Maximum / Niveau",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Maximum / Niveau.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffPoachedLoyaltyLoss = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Perte de loyauté par débauchage",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Perte de loyauté par débauchage.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionCostBase = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Protection / Coût / Valeur de base",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Protection / Coût / Valeur de base.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionHours = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Protection / Heures",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Protection / Heures.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionIncidentReduction = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Protection / Incident / Réduction",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Protection / Incident / Réduction.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffProtectionRiskCost = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Protection / Risque / Coût",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Protection / Risque / Coût.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryBaseChance = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Récupération / Valeur de base / Chance",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Récupération / Valeur de base / Chance.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffRecoveryLoyaltyWeight = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Récupération / Loyauté / Poids",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Récupération / Loyauté / Poids.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageBaseMultiplier = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Salaire / Valeur de base / Multiplicateur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Salaire / Valeur de base / Multiplicateur.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageLoyaltyGain = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Salaire / Loyauté / gain",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Salaire / Loyauté / gain.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWageSkillDivisor = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Salaire / Compétence / Diviseur",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Salaire / Compétence / Diviseur.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem1 = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Faiblesses / 1",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Faiblesses / 1.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem2 = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Faiblesses / 2",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Faiblesses / 2.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem3 = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Faiblesses / 3",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Faiblesses / 3.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem4 = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Faiblesses / 4",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Faiblesses / 4.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem5 = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Faiblesses / 5",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Faiblesses / 5.",
                },
                drugAdvancedBusinessNetworkRuntimeStaffWeaknessesItem6 = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Personnel / Faiblesses / 6",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Personnel / Faiblesses / 6.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsContracts = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Structure / Pondérations / Contrats",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Structure / Pondérations / Contrats.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsDealers = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Structure / Pondérations / Revendeurs",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Structure / Pondérations / Revendeurs.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsHubs = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Structure / Pondérations / Centres de distribution",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Structure / Pondérations / Centres de distribution.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsRoutes = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Structure / Pondérations / Routes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Structure / Pondérations / Routes.",
                },
                drugAdvancedBusinessNetworkRuntimeStructureWeightsStaff = {
                    label = "Réseau d'entreprises / Fonctionnement en jeu / Structure / Pondérations / Personnel",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Fonctionnement en jeu / Structure / Pondérations / Personnel.",
                },
                drugAdvancedBusinessNetworkSocietyPermission = {
                    label = "Réseau d'entreprises / Organisation / Autorisation",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Organisation / Autorisation.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseCapacity = {
                    label = "Réseau d'entreprises / Personnel / Revendeur / Valeur de base / capacité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Personnel / Revendeur / Valeur de base / capacité.",
                },
                drugAdvancedBusinessNetworkStaffPusherBaseWage = {
                    label = "Réseau d'entreprises / Personnel / Revendeur / Valeur de base / Salaire",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Personnel / Revendeur / Valeur de base / Salaire.",
                },
                drugAdvancedBusinessNetworkStaffPusherCommission = {
                    label = "Réseau d'entreprises / Personnel / Revendeur / Commission",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Personnel / Revendeur / Commission.",
                },
                drugAdvancedBusinessNetworkStaffPusherHirePrice = {
                    label = "Réseau d'entreprises / Personnel / Revendeur / Recrutement / Prix",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Personnel / Revendeur / Recrutement / Prix.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseCapacity = {
                    label = "Réseau d'entreprises / Personnel / Coursier / Valeur de base / capacité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Personnel / Coursier / Valeur de base / capacité.",
                },
                drugAdvancedBusinessNetworkStaffRunnerBaseWage = {
                    label = "Réseau d'entreprises / Personnel / Coursier / Valeur de base / Salaire",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Personnel / Coursier / Valeur de base / Salaire.",
                },
                drugAdvancedBusinessNetworkStaffRunnerCommission = {
                    label = "Réseau d'entreprises / Personnel / Coursier / Commission",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Personnel / Coursier / Commission.",
                },
                drugAdvancedBusinessNetworkStaffRunnerHirePrice = {
                    label = "Réseau d'entreprises / Personnel / Coursier / Recrutement / Prix",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Personnel / Coursier / Recrutement / Prix.",
                },
                drugAdvancedBusinessNetworkTickMinutes = {
                    label = "Réseau d'entreprises / Cycle de mise à jour / Minutes",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Cycle de mise à jour / Minutes.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCapacity = {
                    label = "Réseau d'entreprises / Transports / Avion / capacité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Avion / capacité.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftCost = {
                    label = "Réseau d'entreprises / Transports / Avion / Coût",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Avion / Coût.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftDurationMultiplier = {
                    label = "Réseau d'entreprises / Transports / Avion / Multiplicateur de durée",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Avion / Multiplicateur de durée.",
                },
                drugAdvancedBusinessNetworkTransportsAircraftRisk = {
                    label = "Réseau d'entreprises / Transports / Avion / Risque",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Avion / Risque.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCapacity = {
                    label = "Réseau d'entreprises / Transports / Bateau / capacité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Bateau / capacité.",
                },
                drugAdvancedBusinessNetworkTransportsBoatCost = {
                    label = "Réseau d'entreprises / Transports / Bateau / Coût",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Bateau / Coût.",
                },
                drugAdvancedBusinessNetworkTransportsBoatDurationMultiplier = {
                    label = "Réseau d'entreprises / Transports / Bateau / Multiplicateur de durée",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Bateau / Multiplicateur de durée.",
                },
                drugAdvancedBusinessNetworkTransportsBoatRisk = {
                    label = "Réseau d'entreprises / Transports / Bateau / Risque",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Bateau / Risque.",
                },
                drugAdvancedBusinessNetworkTransportsCarCapacity = {
                    label = "Réseau d'entreprises / Transports / Voiture / capacité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Voiture / capacité.",
                },
                drugAdvancedBusinessNetworkTransportsCarCost = {
                    label = "Réseau d'entreprises / Transports / Voiture / Coût",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Voiture / Coût.",
                },
                drugAdvancedBusinessNetworkTransportsCarDurationMultiplier = {
                    label = "Réseau d'entreprises / Transports / Voiture / Multiplicateur de durée",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Voiture / Multiplicateur de durée.",
                },
                drugAdvancedBusinessNetworkTransportsCarRisk = {
                    label = "Réseau d'entreprises / Transports / Voiture / Risque",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Voiture / Risque.",
                },
                drugAdvancedBusinessNetworkTransportsFootCapacity = {
                    label = "Réseau d'entreprises / Transports / À pied / capacité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / À pied / capacité.",
                },
                drugAdvancedBusinessNetworkTransportsFootCost = {
                    label = "Réseau d'entreprises / Transports / À pied / Coût",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / À pied / Coût.",
                },
                drugAdvancedBusinessNetworkTransportsFootDurationMultiplier = {
                    label = "Réseau d'entreprises / Transports / À pied / Multiplicateur de durée",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / À pied / Multiplicateur de durée.",
                },
                drugAdvancedBusinessNetworkTransportsFootRisk = {
                    label = "Réseau d'entreprises / Transports / À pied / Risque",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / À pied / Risque.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCapacity = {
                    label = "Réseau d'entreprises / Transports / Camion / capacité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Camion / capacité.",
                },
                drugAdvancedBusinessNetworkTransportsTruckCost = {
                    label = "Réseau d'entreprises / Transports / Camion / Coût",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Camion / Coût.",
                },
                drugAdvancedBusinessNetworkTransportsTruckDurationMultiplier = {
                    label = "Réseau d'entreprises / Transports / Camion / Multiplicateur de durée",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Camion / Multiplicateur de durée.",
                },
                drugAdvancedBusinessNetworkTransportsTruckRisk = {
                    label = "Réseau d'entreprises / Transports / Camion / Risque",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Camion / Risque.",
                },
                drugAdvancedBusinessNetworkTransportsVanCapacity = {
                    label = "Réseau d'entreprises / Transports / Fourgonnette / capacité",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Fourgonnette / capacité.",
                },
                drugAdvancedBusinessNetworkTransportsVanCost = {
                    label = "Réseau d'entreprises / Transports / Fourgonnette / Coût",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Fourgonnette / Coût.",
                },
                drugAdvancedBusinessNetworkTransportsVanDurationMultiplier = {
                    label = "Réseau d'entreprises / Transports / Fourgonnette / Multiplicateur de durée",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Fourgonnette / Multiplicateur de durée.",
                },
                drugAdvancedBusinessNetworkTransportsVanRisk = {
                    label = "Réseau d'entreprises / Transports / Fourgonnette / Risque",
                    description = "Paramètre de fonctionnement pour Réseau d'entreprises / Transports / Fourgonnette / Risque.",
                },
                interrogationDispatchAdapter = {
                    options = {
                        sky_jobs_base = "Sky Jobs Base",
                        generic = "Intégration générique",
                        custom = "Intégration personnalisée",
                        none = "Désactivé",
                    },
                },
                reputationRules = {
                    label = "Règles de réputation",
                    description = "Configurez des règles nommées pour les actions et leurs cibles facultatives. Seules les règles activées attribuent des points.",
                },
            },
            territoryMap = {
                addPoint = "Ajouter un point",
                clear = "Effacer",
                create = "Créer",
                custom = "Territoires personnalisés",
                deletePoint = "Supprimer un point",
                eyebrow = "Éditeur de territoire",
                minimum = "Minimum 3",
                pointCount = "Points {count}",
                presets = "Districts prédéfinis",
                shown = "Affiché sur la carte",
                street = "Rue",
                supply = "Approvisionnement",
                territories = "Territoires",
                type = "Type de territoire",
                undo = "Annuler",
            },
            shopPositionTools = {
                currentPosition = "Utiliser la position actuelle",
                selectEntity = "Sélectionner l'entité",
                selectEntityHint = "Visez le laser sur une caisse ou un coffre-fort. Entrée : utiliser la position et l'orientation de l'objet encadré. Retour arrière : annuler.",
            },
            drugSettingSubsections = {
                cultivationLevels = "Niveaux de culture",
                general = "Général",
                runtime = "Accès aux actions en jeu",
                quality = "Qualité",
                packaging = "Emballage",
                growing = "Culture",
                labs = "Laboratoires et camping-cars",
                power = "Alimentation et équipement",
                workers = "Employés",
                market = "Marché et distribution",
                threats = "Descentes et sabotage",
                pvpTakeovers = "Prises de laboratoires",
                consumption = "Consommation",
                processing = "Traitement",
                performance = "Performances",
                dynamicMarket = "Marché Dynamique",
                heat = "Suspicion et risque",
                contacts = "Réseau de contacts",
                business = "Réseau d'entreprises",
            },
            drugSettingGroups = {
                cultivationGeneral = { label = "Général" },
                cultivationCurve = { label = "Courbe de niveaux" },
                cultivationExperience = { label = "Récompenses XP" },
                cultivationUnlocks = { label = "Déblocages de niveau" },
                creator = {
                    label = "Ouvrir l'éditeur",
                },
                creatorSettings = {
                    label = "Paramètres de l'éditeur",
                },
                interfaceHud = {
                    label = "Positions de l'interface",
                },
                drugsGeneral = {
                    label = "Général",
                },
                runtimeAccess = {
                    label = "Accès et propriété",
                },
                runtimePayouts = {
                    label = "Versements",
                },
                runtimeDispatch = {
                    label = "Centrale et police",
                },
                qualityWeights = {
                    label = "Qualité / Pondérations",
                },
                qualityTiers = {
                    label = "Qualité / Niveaux de qualité",
                },
                packagingGeneral = {
                    label = "Général",
                },
                growingGeneral = {
                    label = "Général",
                },
                plantDefaults = {
                    label = "Plante / Valeurs par défaut",
                },
                harvestWindow = {
                    label = "Récolte / Fenêtre temporelle",
                },
                labsGeneral = {
                    label = "Général",
                },
                labRent = {
                    label = "Location et cycle de vie",
                },
                camperDefaults = {
                    label = "Camping-car",
                },
                labUpgrades = {
                    label = "Améliorations",
                },
                labDefaults = {
                    label = "Labo / Valeurs par défaut",
                },
                powerGeneral = {
                    label = "Général",
                },
                generators = {
                    label = "Générateurs",
                },
                equipmentWear = {
                    label = "Équipement",
                },
                workersGeneral = {
                    label = "Général",
                },
                marketGeneral = {
                    label = "Général",
                },
                marketPrices = {
                    label = "Prix",
                },
                distribution = {
                    label = "Distribution",
                },
                threatsGeneral = {
                    label = "Général",
                },
                threatHeat = {
                    label = "Pression policière",
                },
                threatChances = {
                    label = "Probabilités",
                },
                pvpTakeoverRules = {
                    label = "Règles de prise de contrôle",
                },
                pvpTakeoverZones = {
                    label = "Zones & Délais",
                },
                pvpTakeoverMethods = {
                    label = "Méthodes d'effraction",
                },
                consumptionGeneral = {
                    label = "Général",
                },
                consumerDecay = {
                    label = "Réduction de la tolérance et de la dépendance",
                },
                consumerEffects = {
                    label = "Effets et risques",
                },
                processingFlow = {
                    label = "Processus de transformation",
                },
                processingGeneral = {
                    label = "Général",
                },
                powerRuntime = {
                    label = "Fonctionnement en jeu",
                },
                powerHeat = {
                    label = "Suspicion et signature électrique",
                },
                powerModes = {
                    label = "Gestion / Modes",
                },
                powerPriorities = {
                    label = "Charge / Priorités",
                },
                performanceInactiveControlIntervalMs = {
                    label = "Inactif / Contrôles / Intervalle / ms",
                },
                performanceInteractionIdleScanIntervalMs = {
                    label = "Interaction / Inactif / Intervalle d'analyse / ms",
                },
                performanceInteractionPromptIntervalMs = {
                    label = "Interaction / Invite d'interaction / Intervalle / ms",
                },
                performanceInteractionScanIntervalMs = {
                    label = "Interaction / Intervalle d'analyse / ms",
                },
                performanceMinimumScanIntervalMs = {
                    label = "Minimum / Intervalle d'analyse / ms",
                },
                performanceStreetPedActivationDistance = {
                    label = "Rue / PNJ / Activation / Distance",
                },
                performanceStreetPedIdleScanIntervalMs = {
                    label = "Rue / PNJ / Inactif / Intervalle d'analyse / ms",
                },
                performanceStreetPedScanIntervalMs = {
                    label = "Rue / PNJ / Intervalle d'analyse / ms",
                },
                performanceWorldCachePadding = {
                    label = "Monde / Cache / Marge supplémentaire",
                },
                performanceWorldCacheRefreshIntervalMs = {
                    label = "Monde / Cache / Actualisation / Intervalle / ms",
                },
                performanceWorldIdleIntervalMs = {
                    label = "Monde / Inactif / Intervalle / ms",
                },
                dynamicMarketActionCooldownSeconds = {
                    label = "Délai de récupération de l'action / secondes",
                },
                dynamicMarketActionHistoryLimit = {
                    label = "Action / Limite de l'historique",
                },
                dynamicMarketAmountSaturationWeight = {
                    label = "Quantité / Saturation / Poids",
                },
                dynamicMarketBaseIntelAccuracy = {
                    label = "Valeur de base / Précision du renseignement",
                },
                dynamicMarketDefaultAverageQuality = {
                    label = "Valeur par défaut / Moyenne / Qualité",
                },
                dynamicMarketDefaultResourceElasticity = {
                    label = "Valeur par défaut / Ressource / Élasticité",
                },
                dynamicMarketDemandCenter = {
                    label = "Demande / Valeur centrale",
                },
                dynamicMarketDemandPriceImpact = {
                    label = "Demande / Prix / Impact",
                },
                dynamicMarketDirectionThreshold = {
                    label = "Direction / Seuil",
                },
                dynamicMarketEnabled = {
                    label = "Activé",
                },
                dynamicMarketEventChance = {
                    label = "Événement / Chance",
                },
                dynamicMarketEventDurationMinutes = {
                    label = "Événement / Durée / Minutes",
                },
                dynamicMarketEventMinimumDurationMinutes = {
                    label = "Événement / Minimum / Durée / Minutes",
                },
                dynamicMarketEventStrengthMaximum = {
                    label = "Événement / Intensité / Maximum",
                },
                dynamicMarketEventStrengthMinimum = {
                    label = "Événement / Intensité / Minimum",
                },
                dynamicMarketEvents = {
                    label = "Événements",
                },
                dynamicMarketExactIntelReputation = {
                    label = "Renseignements précis / Réputation",
                },
                dynamicMarketExactIntelTrust = {
                    label = "Renseignements précis / Confiance",
                },
                dynamicMarketGlobalZoneLabel = {
                    label = "Global / Zone / Libellé",
                },
                dynamicMarketHistoryLimit = {
                    label = "Limite de l'historique",
                },
                dynamicMarketInitialDemand = {
                    label = "Valeur initiale / Demande",
                },
                dynamicMarketInitialPriceMultiplier = {
                    label = "Valeur initiale / Multiplicateur de prix",
                },
                dynamicMarketIntelDemandError = {
                    label = "Renseignements / Demande / Erreur",
                },
                dynamicMarketIntelMaximumAccuracy = {
                    label = "Renseignements / Maximum / Précision",
                },
                dynamicMarketIntelMinimumAccuracy = {
                    label = "Renseignements / Minimum / Précision",
                },
                dynamicMarketIntelPoliceError = {
                    label = "Renseignements / Police / Erreur",
                },
                dynamicMarketIntelPriceError = {
                    label = "Renseignements / Prix / Erreur",
                },
                dynamicMarketIntelPriceMaximum = {
                    label = "Renseignements / Prix / Maximum",
                },
                dynamicMarketIntelPriceMinimum = {
                    label = "Renseignements / Prix / Minimum",
                },
                dynamicMarketIntelReputationWeight = {
                    label = "Renseignements / Réputation / Poids",
                },
                dynamicMarketIntelResourcePriceError = {
                    label = "Renseignements / Ressource / Prix / Erreur",
                },
                dynamicMarketIntelSaturationError = {
                    label = "Renseignements / Saturation / Erreur",
                },
                dynamicMarketIntelSeedBucketSeconds = {
                    label = "Fenêtre de graine des renseignements / secondes",
                },
                dynamicMarketIntelStatusAccuracyThreshold = {
                    label = "Renseignements / Statut / Précision / Seuil",
                },
                dynamicMarketIntelStatusErrorThreshold = {
                    label = "Renseignements / Statut / Erreur / Seuil",
                },
                dynamicMarketIntelSupplyError = {
                    label = "Renseignements / Approvisionnement / Erreur",
                },
                dynamicMarketIntelTrustWeight = {
                    label = "Renseignements / Confiance / Poids",
                },
                dynamicMarketManipulationCooldownMinutes = {
                    label = "Manipulation / Minutes de délai",
                },
                dynamicMarketManipulationDemandShift = {
                    label = "Manipulation / Demande / Variation",
                },
                dynamicMarketManipulationDurationMinutes = {
                    label = "Manipulation / Durée / Minutes",
                },
                dynamicMarketManipulationHeat = {
                    label = "Manipulation / Pression policière",
                },
                dynamicMarketManipulationMinimumBatchAmount = {
                    label = "Manipulation / Minimum / Lot / Quantité",
                },
                dynamicMarketManipulationPaymentAccount = {
                    label = "Manipulation / Compte de paiement",
                },
                dynamicMarketManipulationPrice = {
                    label = "Manipulation / Prix",
                },
                dynamicMarketManipulationZoneHeatMultiplier = {
                    label = "Manipulation / Zone / Pression policière / Multiplicateur",
                },
                dynamicMarketMaximumIntelAgeMinutes = {
                    label = "Maximum / Âge du renseignement / Minutes",
                },
                dynamicMarketMaximumPriceMultiplier = {
                    label = "Maximum / Multiplicateur de prix",
                },
                dynamicMarketMinimumIntelAgeMinutes = {
                    label = "Minimum / Âge du renseignement / Minutes",
                },
                dynamicMarketMinimumMetricWindowMinutes = {
                    label = "Minimum / Mesure / Fenêtre temporelle / Minutes",
                },
                dynamicMarketMinimumPriceMultiplier = {
                    label = "Prix minimum / Multiplicateur",
                },
                dynamicMarketMinimumUpdateMinutes = {
                    label = "Minimum / Mise à jour / Minutes",
                },
                dynamicMarketPoliceDemandWeight = {
                    label = "Police / Demande / Poids",
                },
                dynamicMarketPolicePriceImpact = {
                    label = "Police / Prix / Impact",
                },
                dynamicMarketPoorQualityDemandPenalty = {
                    label = "Mauvaise qualité / Demande / Pénalité",
                },
                dynamicMarketPoorQualityThreshold = {
                    label = "Mauvaise qualité / Seuil",
                },
                dynamicMarketPremiumQualityDemandBonus = {
                    label = "Qualité supérieure / Bonus de demande",
                },
                dynamicMarketPremiumQualityThreshold = {
                    label = "Qualité supérieure / Seuil",
                },
                dynamicMarketProductionSupplyWeight = {
                    label = "Production / Approvisionnement / Poids",
                },
                dynamicMarketProductionWindowMinutes = {
                    label = "Production / Fenêtre temporelle / Minutes",
                },
                dynamicMarketQualityCenter = {
                    label = "Qualité / Valeur centrale",
                },
                dynamicMarketQualityConfidenceImpact = {
                    label = "Qualité / Confiance / Impact",
                },
                dynamicMarketQualityRange = {
                    label = "Qualité / Plage de valeurs",
                },
                dynamicMarketRarityBonusMaximum = {
                    label = "Rareté / Prime / Maximum",
                },
                dynamicMarketRegionalGlobalWeight = {
                    label = "Régional / Global / Poids",
                },
                dynamicMarketRegionalLocalWeight = {
                    label = "Régional / Local / Poids",
                },
                dynamicMarketResourceAliases = {
                    label = "Ressource / Alias",
                },
                dynamicMarketResourceDirectionFallThreshold = {
                    label = "Ressource / Direction / Baisse / Seuil",
                },
                dynamicMarketResourceDirectionRiseThreshold = {
                    label = "Ressource / Direction / Hausse / Seuil",
                },
                dynamicMarketResources = {
                    label = "Ressources",
                },
                dynamicMarketSalesWindowMinutes = {
                    label = "Ventes / Fenêtre temporelle / Minutes",
                },
                dynamicMarketSaturationDemandWeight = {
                    label = "Saturation / Demande / Poids",
                },
                dynamicMarketSaturationPriceImpact = {
                    label = "Saturation / Prix / Impact",
                },
                dynamicMarketScarcityDemandWeight = {
                    label = "Pénurie / Demande / Poids",
                },
                dynamicMarketScarcityPriceImpact = {
                    label = "Pénurie / Prix / Impact",
                },
                dynamicMarketSeasonEndMonths = {
                    label = "Saison / Fin / Mois",
                },
                dynamicMarketSeasonMultipliers = {
                    label = "Saison / Multiplicateurs",
                },
                dynamicMarketShortageRumorThreshold = {
                    label = "Pénurie / Rumeur / Seuil",
                },
                dynamicMarketStatusThresholds = {
                    label = "Statut / Seuils",
                },
                dynamicMarketTargetSupply = {
                    label = "Cible / Approvisionnement",
                },
                dynamicMarketTrendChance = {
                    label = "Tendance / Chance",
                },
                dynamicMarketTrendDurationMinutes = {
                    label = "Tendance / Durée / Minutes",
                },
                dynamicMarketTrendMaximumStrength = {
                    label = "Tendance / Maximum / Intensité",
                },
                dynamicMarketTrendMinimumStrength = {
                    label = "Tendance / Minimum / Intensité",
                },
                dynamicMarketUpdateMinutes = {
                    label = "Mise à jour / Minutes",
                },
                dynamicMarketVolatilityMaximum = {
                    label = "Volatilité / Maximum",
                },
                dynamicMarketVolatilityMinimum = {
                    label = "Volatilité / Minimum",
                },
                dynamicMarketWeatherMultipliers = {
                    label = "Météo / Multiplicateurs",
                },
                dynamicMarketWeatherState = {
                    label = "Météo / État",
                },
                heatActionCooldownSeconds = {
                    label = "Délai de récupération de l'action / secondes",
                },
                heatActivityRiskWeights = {
                    label = "Activité / Risque / Pondérations",
                },
                heatAggressiveHeatMultiplier = {
                    label = "Mode agressif / Pression policière / Multiplicateur",
                },
                heatBurnerBurnThreshold = {
                    label = "Téléphone jetable / Compromission / Seuil",
                },
                heatBurnerHeatPerWholesale = {
                    label = "Téléphone jetable / Pression policière / Par vente en gros",
                },
                heatBurnerPhoneItem = {
                    label = "Téléphone jetable / Objet",
                },
                heatCamperOperationalHeatMultiplier = {
                    label = "Camping-car en activité / Pression policière / Multiplicateur",
                },
                heatCamperOperationalHeatThreshold = {
                    label = "Camping-car en activité / Pression policière / Seuil",
                },
                heatCamperParkedHeat = {
                    label = "Camping-car stationné / Pression policière",
                },
                heatContaminatedHeatMultiplier = {
                    label = "Contamination / Pression policière / Multiplicateur",
                },
                heatContaminatedThreshold = {
                    label = "Contamination / Seuil",
                },
                heatCultivationFreePlants = {
                    label = "Culture / Plantes sans risque supplémentaire",
                },
                heatCultivationHeatPerPlant = {
                    label = "Culture / Pression policière / Par plante",
                },
                heatDealerHiddenMinutes = {
                    label = "Dealer / caché / Minutes",
                },
                heatDecayPerTick = {
                    label = "Déclin / Par cycle de mise à jour",
                },
                heatEnabled = {
                    label = "Activé",
                },
                heatEnforcementHeat = {
                    label = "Présence policière / Pression policière",
                },
                heatEnforcementMultipliers = {
                    label = "Présence policière / Multiplicateurs",
                },
                heatEntityTypes = {
                    label = "Entité / Types",
                },
                heatEventCooldownMinutes = {
                    label = "Événement / Minutes de délai",
                },
                heatEventHistoryLimit = {
                    label = "Événement / Limite de l'historique",
                },
                heatLabHeatSyncThreshold = {
                    label = "Labo / Pression policière / Synchronisation / Seuil",
                },
                heatLayLowCooldownMinutes = {
                    label = "Se faire discret / Minutes de délai",
                },
                heatLayLowIdleMinutes = {
                    label = "Se faire discret / Inactif / Minutes",
                },
                heatLayLowReduction = {
                    label = "Se faire discret / Réduction",
                },
                heatLockdownMinutes = {
                    label = "Confinement / Minutes",
                },
                heatMinimumDurationMinutes = {
                    label = "Minimum / Durée / Minutes",
                },
                heatMinimumEventCooldownSeconds = {
                    label = "Minimum / Événement / Temps de recharge (secondes)",
                },
                heatMinimumIdleSeconds = {
                    label = "Minimum / Inactif / secondes",
                },
                heatProcessingHeatMultiplier = {
                    label = "Traitement / Pression policière / Multiplicateur",
                },
                heatRiskWeights = {
                    label = "Risque / Pondérations",
                },
                heatRotateBurnerReduction = {
                    label = "Changer de téléphone jetable / Réduction",
                },
                heatRouteControlMinutes = {
                    label = "Itinéraire / Contrôles / Minutes",
                },
                heatSaleHeat = {
                    label = "Vente / Pression policière",
                },
                heatThresholds = {
                    label = "Seuils",
                },
                heatTickMinutes = {
                    label = "Cycle de mise à jour / Minutes",
                },
                heatWholesaleHeatMultiplier = {
                    label = "Vente en gros / Pression policière / Multiplicateur",
                },
                heatWorkerLeakAlertRadius = {
                    label = "Travailleur / Fuite d'informations / Rayon d'alerte",
                },
                heatWorkerLeakBaseChance = {
                    label = "Travailleur / Fuite d'informations / Valeur de base / Chance",
                },
                heatWorkerLeakFactionMultiplier = {
                    label = "Travailleur / Fuite d'informations / Faction / Multiplicateur",
                },
                heatWorkerLeakHighSeverityThreshold = {
                    label = "Travailleur / Fuite d'informations / Élevé / Gravité / Seuil",
                },
                heatWorkerLeakLoyaltyChanceMultiplier = {
                    label = "Travailleur / Fuite d'informations / Loyauté / Chance / Multiplicateur",
                },
                heatWorkerLeakLoyaltyThreshold = {
                    label = "Travailleur / Fuite d'informations / Loyauté / Seuil",
                },
                heatWorkerLeakMaximumChance = {
                    label = "Travailleur / Fuite d'informations / Maximum / Chance",
                },
                heatWorkerLeakMinimumCooldownSeconds = {
                    label = "Travailleur / Fuite d'informations / Minimum / Temps de recharge (secondes)",
                },
                heatWorkerLeakRouteMultiplier = {
                    label = "Travailleur / Fuite d'informations / Itinéraire / Multiplicateur",
                },
                heatWorkerLeakStrengthMaximum = {
                    label = "Travailleur / Fuite d'informations / Intensité / Maximum",
                },
                heatWorkerLeakStrengthMinimum = {
                    label = "Travailleur / Fuite d'informations / Intensité / Minimum",
                },
                heatWorkerLeakStrengthMultiplier = {
                    label = "Travailleur / Fuite d'informations / Intensité / Multiplicateur",
                },
                heatWorkerLeakStressChanceMultiplier = {
                    label = "Travailleur / Fuite d'informations / Stress / Chance / Multiplicateur",
                },
                heatWorkerLeakStressThreshold = {
                    label = "Travailleur / Fuite d'informations / Stress / Seuil",
                },
                contactsActionCooldownSeconds = {
                    label = "Délai de récupération de l'action / secondes",
                },
                contactsActiveHotspotCount = {
                    label = "Nombre de points chauds actifs",
                },
                contactsBurnerHintTrust = {
                    label = "Indice burner / Confiance",
                },
                contactsBurnerOfferMaximumMultiplier = {
                    label = "Téléphone jetable / Offre / Maximum / Multiplicateur",
                },
                contactsBurnerOfferMinimumMultiplier = {
                    label = "Téléphone jetable / Offre / Minimum / Multiplicateur",
                },
                contactsBuyerCooldownMinutes = {
                    label = "Acheteur / Minutes de délai",
                },
                contactsBuyerDeliveryDistance = {
                    label = "Acheteur / Distance de livraison",
                },
                contactsBuyerPremiumSuccessScore = {
                    label = "Acheteur / Premium / Succès / Score",
                },
                contactsBuyerPremiumTrustGain = {
                    label = "Acheteur / Premium / Confiance / gain",
                },
                contactsBuyerRequestHeatRiskWeight = {
                    label = "Acheteur / Demande / Recherche & Risque / Poids",
                },
                contactsBuyerStandardTrustGain = {
                    label = "Acheteur / Norme / Confiance / gain",
                },
                contactsContactActiveDelaySeconds = {
                    label = "Délai d'activation du contact / secondes",
                },
                contactsContactDemandRange = {
                    label = "Contact / Demande / Plage de valeurs",
                },
                contactsContactLossTrust = {
                    label = "Contact / Perte / Confiance",
                },
                contactsDarknetExactIntelMinutes = {
                    label = "Darknet / Renseignements précis / Minutes",
                },
                contactsDarknetHotspotIntelPrice = {
                    label = "Darknet / Point sensible / Renseignements / Prix",
                },
                contactsDarknetIntelPrice = {
                    label = "Darknet / Renseignements / Prix",
                },
                contactsDealerBasePrice = {
                    label = "Dealer / Prix de base",
                },
                contactsDealerHireCapacity = {
                    label = "Dealer / Recrutement / capacité",
                },
                contactsDealerHireRisk = {
                    label = "Dealer / Recrutement / Risque",
                },
                contactsDealerHireSkill = {
                    label = "Dealer / Recrutement / Compétence",
                },
                contactsDealerOffers = {
                    label = "Offres du concessionnaire",
                },
                contactsDealerProtectionHours = {
                    label = "Dealer / Protection / Heures",
                },
                contactsDealerProtectionPrice = {
                    label = "Dealer / Protection / Prix",
                },
                contactsDealerSaleMax = {
                    label = "Dealer / Vente / Maximum",
                },
                contactsDealerSaleMin = {
                    label = "Dealer / Vente / Minimum",
                },
                contactsDealerSimulation = {
                    label = "Dealer / Simulation",
                },
                contactsDealerTickMinutes = {
                    label = "Dealer / Cycle de mise à jour / Minutes",
                },
                contactsDealerWage = {
                    label = "Dealer / Salaire",
                },
                contactsDealerWageDecay = {
                    label = "Dealer / Salaire / Déclin",
                },
                contactsDealerWageLoyaltyGain = {
                    label = "Dealer / Salaire / Loyauté / gain",
                },
                contactsDealerWeaknesses = {
                    label = "Dealer / Faiblesses",
                },
                contactsDefaultContactDemand = {
                    label = "Valeur par défaut / Contact / Demande",
                },
                contactsDefaultContactRisk = {
                    label = "Valeur par défaut / Contact / Risque",
                },
                contactsDefaultDealerCapacity = {
                    label = "Dealer par défaut / capacité",
                },
                contactsDefaultDealerRisk = {
                    label = "Dealer par défaut / Risque",
                },
                contactsDefaultDealerSkill = {
                    label = "Dealer par défaut / Compétence",
                },
                contactsDefaultHotspotRadius = {
                    label = "Valeur par défaut / Point sensible / Rayon",
                },
                contactsDemandResetMinutes = {
                    label = "Réinitialisation de la demande (minutes)",
                },
                contactsEnabled = {
                    label = "Activé",
                },
                contactsExactLocationTrust = {
                    label = "Emplacement exact / Confiance",
                },
                contactsFactionDiscoveryReputation = {
                    label = "Faction / Découverte / Réputation",
                },
                contactsFactionHintTrust = {
                    label = "Faction / Indice / Confiance",
                },
                contactsFailedDeliveryCooldownMinutes = {
                    label = "Livraison échouée / Minutes de délai",
                },
                contactsFakeDealEncounter = {
                    label = "Fausse transaction / Rencontre",
                },
                contactsFallbackPreferredDrug = {
                    label = "Valeur de remplacement / Drogue préférée",
                },
                contactsFallbackProductLabel = {
                    label = "Valeur de remplacement / Nom du produit",
                },
                contactsGuideBookItem = {
                    label = "Guide / Livre / Objet",
                },
                contactsGuideBookTrust = {
                    label = "Guide / Livre / Confiance",
                },
                contactsHireDealerPrice = {
                    label = "Embaucher un dealer / Prix",
                },
                contactsHistoryLimit = {
                    label = "Limite de l'historique",
                },
                contactsHotspotIntelMinutes = {
                    label = "Point sensible / Renseignements / Minutes",
                },
                contactsHotspotRotationMinutes = {
                    label = "Point sensible / Rotation / Minutes",
                },
                contactsListingDurationMinutes = {
                    label = "Annonce / Durée / Minutes",
                },
                contactsMaxOwnedDealers = {
                    label = "Maximum / Possédées / Revendeurs",
                },
                contactsMinimumBuyerDeliveryDistance = {
                    label = "Minimum / Acheteur / Distance de livraison",
                },
                contactsMinimumContactRotationMinutes = {
                    label = "Minimum / Rotation des contacts (minutes)",
                },
                contactsMinimumDemandResetMinutes = {
                    label = "Minimum / Réinitialisation de la demande (minutes)",
                },
                contactsMinimumHeatMultiplier = {
                    label = "Minimum / Pression policière / Multiplicateur",
                },
                contactsMinimumHotspotIntelMinutes = {
                    label = "Minimum / Point sensible / Renseignements / Minutes",
                },
                contactsMinimumHotspotRadius = {
                    label = "Minimum / Point sensible / Rayon",
                },
                contactsMinimumHotspotRotationMinutes = {
                    label = "Minimum / Point sensible / Rotation / Minutes",
                },
                contactsMinimumListingDurationMinutes = {
                    label = "Minimum / Annonce / Durée / Minutes",
                },
                contactsMinimumRewardMultiplier = {
                    label = "Récompense minimale / Multiplicateur",
                },
                contactsMinimumRobberyMultiplier = {
                    label = "Minimum / Braquage / Multiplicateur",
                },
                contactsMinimumSpotPriceMultiplier = {
                    label = "Minimum / Emplacement / Multiplicateur de prix",
                },
                contactsOtherDrugPriceMultiplier = {
                    label = "Autre / Drogue / Multiplicateur de prix",
                },
                contactsPaymentAccount = {
                    label = "Compte de paiement",
                },
                contactsPostDeliveryDemandResetSeconds = {
                    label = "Après livraison / Demande / Reset / secondes",
                },
                contactsPreferredDrugPriceMultiplier = {
                    label = "Drogue préférée / Multiplicateur de prix",
                },
                contactsRegionLocationTrust = {
                    label = "Région / Lieu / Confiance",
                },
                contactsRequestAmounts = {
                    label = "Demande / Quantités",
                },
                contactsRotationMinutes = {
                    label = "Rotation / Minutes",
                },
                contactsSpotPools = {
                    label = "Emplacement / Réserves de sélection",
                },
                contactsStreetHotspots = {
                    label = "Rue / Points sensibles",
                },
                contactsTrustLevels = {
                    label = "Confiance / Niveaux",
                },
                businessActionCooldownSeconds = {
                    label = "Délai de récupération de l'action / secondes",
                },
                businessBalance = {
                    label = "Solde",
                },
                businessContracts = {
                    label = "Contrats",
                },
                businessDefaultBusinessName = {
                    label = "Valeur par défaut / Nom de l'entreprise",
                },
                businessDefaultRankId = {
                    label = "Valeur par défaut / Grade / ID",
                },
                businessDefaultStaffStyle = {
                    label = "Valeur par défaut / Personnel / Style de travail",
                },
                businessDefaultTransport = {
                    label = "Valeur par défaut / Transports",
                },
                businessEnabled = {
                    label = "Activé",
                },
                businessHubs = {
                    label = "Centres de distribution",
                },
                businessLimits = {
                    label = "Limites",
                },
                businessPayments = {
                    label = "Paiements",
                },
                businessPayoutAccount = {
                    label = "Paiement / Compte",
                },
                businessRanks = {
                    label = "Rangs",
                },
                businessReportDays = {
                    label = "Période du rapport / jours",
                },
                businessRouteEndpointTypes = {
                    label = "Itinéraire / Point d'arrivée / Types",
                },
                businessRuntime = {
                    label = "Fonctionnement en jeu",
                },
                businessSocietyPermission = {
                    label = "Organisation / Autorisation",
                },
                businessStaff = {
                    label = "Personnel",
                },
                businessTickMinutes = {
                    label = "Cycle de mise à jour / Minutes",
                },
                businessTransports = {
                    label = "Transports",
                },
            },
            territorySettings = {
                section = "Territoires",
                zonesGroup = "Zones de territoire",
                sourceLabel = "Source de la zone",
                sourceDescription = "Utilisez les districts prédéfinis protégés ou définissez vos propres polygones de territoire.",
                sourcePreset = "Districts prédéfinis",
                sourceCustom = "Territoires personnalisés",
                editLabel = "Éditeur de territoire",
                editDescription = "Modifiez les districts utilisés par la source de zone sélectionnée.",
                editButton = "Modifier les territoires",
                presetSection = "Districts prédéfinis",
                presetEntry = "District prédéfini",
                customSection = "Territoires personnalisés",
                customEntry = "Territoire personnalisé",
                typeLabel = "Type de territoire",
                streetType = "Rue",
                supplyType = "Approvisionnement",
                enabledLabel = "Affiché sur la carte",
                enabledDescription = "Les districts prédéfinis désactivés sont retirés de la carte et ne peuvent pas être revendiqués.",
                zoneLabel = "Limite du territoire",
                zoneDescription = "Placez au moins trois points successivement le long de la limite du territoire.",
                ownershipGroup = "Propriété",
                decayGroup = "Déclin",
                presenceGroup = "Présence",
                activityGroup = "Score d'activité",
                ownershipBenefitsGroup = "Avantages de propriété",
                ownershipThresholdLabel = "Seuil de propriété",
                ownershipThresholdDescription = "Pourcentage de contrôle qu'un gang doit dépasser pour posséder officiellement un territoire.",
                activityFloorLabel = "Seuil d'activité fixe",
                activityFloorDescription = "Points d'influence requis lorsque les seuils basés sur la taille sont désactivés.",
                floorByZoneSizeLabel = "Échelle du seuil par taille de zone",
                floorByZoneSizeDescription = "Calcule le seuil d'activité de chaque territoire à partir de la surface de son polygone au lieu d'utiliser le seuil fixe.",
                floorPointsPerSizeUnitLabel = "Points de seuil par km²",
                floorPointsPerSizeUnitDescription = "Points de seuil d'activité requis pour chaque kilomètre carré de la surface du territoire.",
                fixedFloorRequirement = "Désactivez les seuils basés sur la taille pour modifier le seuil d'activité fixe.",
                sizeFloorRequirement = "Activez les seuils basés sur la taille pour modifier les points par kilomètre carré.",
                dailyDecayLabel = "Déclin quotidien de l'influence",
                dailyDecayDescription = "Pourcentage d'influence retiré toutes les 24 heures.",
                presenceIntervalLabel = "Intervalle de présence",
                presenceIntervalDescription = "Minutes entre les récompenses automatiques de présence en territoire.",
                presencePointsLabel = "Points de présence par membre",
                presencePointsDescription = "Points de présence attribués à chaque membre de gang éligible par intervalle.",
                drugSalesEnabledLabel = "Les ventes aux PNJ accordent de l'influence territoriale",
                drugSalesEnabledDescription = "Les ventes de rue réussies aux PNJ accordent de l'influence au gang du vendeur dans le territoire de rue actuel.",
                drugSalePointsLabel = "Points par drogue vendue",
                drugSalePointsDescription = "Points d'influence attribués pour chaque unité de drogue signalée comme vendue.",
                drugSalesRequirement = "Activez l'influence des ventes aux PNJ pour configurer ses points.",
                graffitiPointsLabel = "Points de graffiti par 24 heures",
                graffitiPointsDescription = "Points de présence attribués lorsqu'un graffiti a existé pendant un total de 24 heures signalées.",
                streetSellingPriceBonusLabel = "Bonus de prix de vente de rue",
                streetSellingPriceBonusDescription = "Pourcentage ajouté aux prix de vente de drogue pour le propriétaire officiel d'un territoire de rue.",
                supplyProductionSpeedBonusLabel = "Bonus de vitesse de production d'approvisionnement",
                supplyProductionSpeedBonusDescription = "Pourcentage ajouté à la vitesse de production de drogue pour le propriétaire officiel d'un territoire d'approvisionnement.",
                pruneToleranceLabel = "Tolérance d'élagage de l'influence",
                pruneToleranceDescription = "L'influence effective en dessous de cette valeur est traitée comme étant nulle.",
            },
            graffitiSettings = {
                section = "Graffiti",
                generalGroup = "Général",
                streamingGroup = "Rendu",
                moderationGroup = "Modération",
                graffitiEnabledLabel = "Activer les graffitis",
                graffitiEnabledDescription = "Permet aux joueurs de taguer et de voir les graffitis.",
                graffitiRequireItemLabel = "Nécessite une bombe de peinture",
                graffitiRequireItemDescription = "Les joueurs ont besoin d'une bombe de peinture pour taguer. Sinon, la commande /graffiti est utilisée.",
                graffitiChargesPerCanLabel = "Charges par bombe",
                graffitiChargesPerCanDescription = "Nombre de graffitis qu'une seule bombe de peinture peut créer.",
                graffitiCooldownSecondsLabel = "Délai de peinture",
                graffitiCooldownSecondsDescription = "Secondes que le joueur doit attendre entre deux sprays.",
                graffitiMaxPerPlayerLabel = "Max. graffitis par joueur",
                graffitiMaxPerPlayerDescription = "Nombre maximum de graffitis actifs qu'un joueur peut posséder. 0 signifie illimité.",
                graffitiMaxDistanceLabel = "Distance de pulvérisation max.",
                graffitiMaxDistanceDescription = "Distance maximale à laquelle un mur peut se trouver pour pouvoir encore le taguer, en mètres.",
                graffitiSprayDurationLabel = "Durée de pulvérisation",
                graffitiSprayDurationDescription = "Durée de l'animation de pulvérisation, en millisecondes.",
                graffitiExpiryDaysLabel = "Temps d'expiration",
                graffitiExpiryDaysDescription = "Nombre de jours avant qu'un graffiti ne disparaisse automatiquement. 0 signifie jamais.",
                graffitiTerritoryHoursLabel = "Heures de territoire par spray",
                graffitiTerritoryHoursDescription = "Heures de présence territoriale qu'un nouveau graffiti accorde à son gang.",
                graffitiStreamRadiusLabel = "Rayon de streaming",
                graffitiStreamRadiusDescription = "Distance en mètres à laquelle les graffitis deviennent visibles pour les joueurs.",
                graffitiPoolSizeLabel = "Taille du pool de decals",
                graffitiPoolSizeDescription = "Nombre de graffitis rendus simultanément. Les valeurs élevées impactent les performances.",
                graffitiReportsEnabledLabel = "Activer les signalements",
                graffitiReportsEnabledDescription = "Permet aux joueurs de signaler les graffitis offensants.",
                graffitiAutoHideThresholdLabel = "Seuil de masquage automatique",
                graffitiAutoHideThresholdDescription = "Nombre de signalements nécessaires pour masquer automatiquement un graffiti. 0 désactive cette option.",
            },
            darknetSettings = {
                section = "Marché du darknet",
                availabilityGroup = "Disponibilité",
                economyGroup = "Cryptomonnaie",
                listingsGroup = "Offres et expiration",
                chatGroup = "Chat privé",
                identityGroup = "Alias et réputation",
                deliveryGroup = "Remises et dead drops",
                policeGroup = "Accès police",
                npcGroup = "Commerçants NPC",
                enabledLabel = "Activer le Darknet Market",
                enabledDescription = "Rend l'application tablette du marché noir et son exécution disponibles.",
                tabletOrderLabel = "Ordre de l'application tablette",
                tabletOrderDescription = "Contrôle la position du Darknet Market sur la tablette.",
                currencyCodeLabel = "Code de la devise",
                currencyCodeDescription = "Libellé court affiché pour le grand livre interne de cryptomonnaie.",
                starterBalanceLabel = "Solde de départ du nouveau portefeuille",
                starterBalanceDescription = "Crypto attribuée uniquement lorsqu'un joueur ouvre le marché pour la première fois.",
                exchangeEnabledLabel = "Activer l'échange de pièces",
                exchangeEnabledDescription = "Permet aux utilisateurs authentifiés de BlackBay d'acheter et de vendre des pièces sur leur page de compte.",
                exchangeAccountLabel = "Compte de paiement d'échange",
                exchangeAccountDescription = "Compte de la plateforme utilisé pour les achats de pièces et les paiements de vente.",
                exchangeBuyPriceLabel = "Prix d'achat par pièce",
                exchangeBuyPriceDescription = "Montant prélevé sur le compte de paiement pour une pièce.",
                exchangeSellPriceLabel = "Prix de vente par pièce",
                exchangeSellPriceDescription = "Montant versé sur le compte de paiement pour une pièce.",
                exchangeMinimumLabel = "Minimum de pièces par échange",
                exchangeMinimumDescription = "Plus petite quantité de pièces entières acceptée lors d'un échange.",
                exchangeMaximumLabel = "Maximum de pièces par échange",
                exchangeMaximumDescription = "Plus grande quantité de pièces entières acceptée lors d'un échange.",
                accountMoney = "Espèces",
                accountBank = "Banque",
                accountBlackMoney = "Argent sale",
                scamChanceLabel = "Chance globale d'arnaque NPC (%)",
                scamChanceDescription = "Chance minimale qu'un échange NPC prenne le paiement ou les biens sans livrer la contrepartie. Une chance spécifique au commerçant plus élevée s'applique toujours.",
                listingExpiryLabel = "Durée de l'offre (heures)",
                listingExpiryDescription = "Les offres actives expirent automatiquement après ce nombre d'heures.",
                renewalHoursLabel = "Durée de renouvellement (heures)",
                renewalHoursDescription = "Nombre d'heures ajoutées lorsqu'un propriétaire renouvelle une offre.",
                maximumListingsLabel = "Maximum d'offres actives",
                maximumListingsDescription = "Maximum d'offres par alias actif.",
                maximumQuantityLabel = "Quantité maximale de marchandises",
                maximumQuantityDescription = "Limite supérieure de quantité pour une offre.",
                maximumPriceLabel = "Prix unitaire maximum",
                maximumPriceDescription = "Prix crypto maximum pour une unité.",
                maximumMessageLengthLabel = "Longueur maximale du message",
                maximumMessageLengthDescription = "Nombre maximum de caractères par message de chat crypté.",
                aliasCooldownLabel = "Délai entre les changements d'alias (heures)",
                aliasCooldownDescription = "Âge minimum d'une identité avant qu'elle ne puisse être retirée à nouveau.",
                verifiedSalesLabel = "Ventes requises pour la vérification",
                verifiedSalesDescription = "Nombre de ventes réussies requis avant qu'un vendeur puisse être vérifié.",
                verifiedRatingLabel = "Évaluation requise pour la vérification",
                verifiedRatingDescription = "Évaluation moyenne minimale pour un vendeur vérifié.",
                scammerReportsLabel = "Signalements pour avertissement d'escroquerie",
                scammerReportsDescription = "Nombre de signalements de transactions uniques requis pour le badge d'escroc connu.",
                meetingDistanceLabel = "Distance de remise",
                meetingDistanceDescription = "Distance maximale entre les deux joueurs ou avec le point NPC configuré.",
                dropModelLabel = "Modèle de caisse de dead-drop",
                dropModelDescription = "Modèle d'objet GTA généré localement pour les dead-drops disponibles.",
                dropStreamLabel = "Distance de streaming du dead-drop",
                dropStreamDescription = "Distance à laquelle les caisses et les contacts de rencontre NPC sont chargés.",
                dropInteractionLabel = "Distance d'interaction du dead-drop",
                dropInteractionDescription = "Distance requise pour fouiller et récupérer une caisse.",
                dropLifetimeLabel = "Durée de vie du dead-drop (heures)",
                dropLifetimeDescription = "Temps avant qu'une caisse non réclamée n'expire.",
                dropPollLabel = "Intervalle de rafraîchissement du monde (ms)",
                dropPollDescription = "Intervalle utilisé pour rafraîchir les caisses et les rencontres NPC à proximité.",
                policeGroupsLabel = "Groupes de métiers de police autorisés",
                policeGroupsDescription = "Clés de groupe du configurateur de métier pouvant publier des offres d'appât et consulter les enquêtes.",
                policeGroupEntry = "Groupe de police",
                groupKeyLabel = "Clé de groupe",
                npcTradersLabel = "Acheteurs et vendeurs NPC",
                npcTradersDescription = "Configure les offres synthétiques persistantes, la méthode de livraison, la réputation et la probabilité d'escroquerie.",
                npcTraderEntry = "Commerçant NPC",
                npcIdLabel = "ID",
                npcAliasLabel = "Alias",
                npcSideLabel = "Côté du marché",
                sideSell = "Vend aux joueurs",
                sideBuy = "Achète aux joueurs",
                npcTitleLabel = "Titre de l'offre",
                npcDescriptionLabel = "Descriptif",
                npcItemNameLabel = "Nom de l'objet d'inventaire",
                npcItemLabelLabel = "Libellé de la marchandise",
                npcQuantityLabel = "Quantité",
                npcPriceLabel = "Prix unitaire",
                npcDeliveryLabel = "Méthode de livraison",
                deliveryBoth = "Rencontre et dead drop",
                deliveryMeeting = "En face à face uniquement",
                deliveryDrop = "Dead drop uniquement",
                npcScamChanceLabel = "Chance d'escroquerie du marchand (%)",
                npcPedModelLabel = "Modèle de ped NPC",
                npcRatingLabel = "Évaluation affichée",
                npcRatingCountLabel = "Nombre d'évaluations affichées",
                npcTradesLabel = "Transactions réussies affichées",
                npcVerifiedLabel = "Marchand vérifié",
                npcScammerLabel = "Arnaqueur connu",
                npcEnabledLabel = "Activé",
            },
            interrogationSettings = {
                section = "Interrogatoire",
                generalGroup = "Général",
                consentGroup = "Protection des joueurs",
                objectGroup = "Objets",
                grabGroup = "Saisie",
                sessionGroup = "Séance",
                dispatchGroup = "Alertes de police",
                loggingGroup = "Journalisation",
                securityGroup = "Sécurité",
                presentationGroup = "Présentation",
                enabledLabel = "Activer l'interrogatoire",
                enabledDescription = "Permet aux joueurs d'attacher les autres à des chaises d'interrogatoire et d'utiliser des outils sur eux.",
                consentRequiredLabel = "Exiger le consentement",
                consentRequiredDescription = "Seuls les joueurs ayant donné leur consentement peuvent devenir victimes. Le consentement n'est plus accordé automatiquement, cela nécessite donc le réglage ci-dessous.",
                consentDefaultLabel = "Consentement par défaut",
                consentDefaultDescription = "Les nouveaux personnages commencent avec le consentement accordé au lieu de refusé.",
                globalIntensityLabel = "Intensité des effets",
                globalIntensityDescription = "Ajuste les effets d'écran, les particules et le son. 0 les désactive complètement.",
                maxPerPlayerLabel = "Objets par joueur",
                maxPerPlayerDescription = "Nombre de chaises et de chariots qu'un joueur peut placer. 0 signifie illimité.",
                maxGlobalLabel = "Objets sur tout le serveur",
                maxGlobalDescription = "Nombre total d'objets placés simultanément. 0 signifie illimité.",
                placementDistanceLabel = "Distance de placement",
                placementDistanceDescription = "Distance maximale à laquelle un objet peut être placé par rapport au joueur, en mètres.",
                interactDistanceLabel = "Distance d'interaction",
                interactDistanceDescription = "Distance minimale à laquelle un joueur doit se trouver pour utiliser une chaise ou un chariot, en mètres.",
                inactivityMinutesLabel = "Suppression automatique après",
                inactivityMinutesDescription = "Minutes d'inactivité avant qu'un objet placé ne disparaisse. 0 le conserve indéfiniment.",
                persistObjectsLabel = "Conserver les objets après redémarrage",
                persistObjectsDescription = "Les objets placés sont restaurés depuis la base de données lors du redémarrage du serveur.",
                grabEnabledLabel = "Activer la saisie",
                grabEnabledDescription = "Permet aux joueurs de maîtriser et de transporter un autre joueur.",
                grabItemLabel = "Objet requis",
                grabItemDescription = "Objet dont l'attaquant a besoin pour saisir quelqu'un. Laissez vide pour n'en nécessiter aucun.",
                grabAngleLabel = "Angle d'approche",
                grabAngleDescription = "Angle latéral autorisé par rapport à l'arrière direct de l'attaquant, en degrés.",
                grabHealthBelowLabel = "Seuil de santé",
                grabHealthBelowDescription = "Une victime en dessous de ce seuil de santé peut être saisie sans être ligotée. 0 désactive cette option.",
                grabCooldownLabel = "Temps de recharge après échec",
                grabCooldownDescription = "Secondes avant qu'une tentative de saisie échouée ne puisse être renouvelée.",
                grabVehiclesLabel = "Véhicules autorisés",
                grabVehiclesDescription = "Modèles de véhicules dans lesquels une victime saisie peut être chargée.",
                carryEnabledLabel = "Autoriser le transport",
                carryEnabledDescription = "Permet à l'attaquant de porter la victime sur son épaule.",
                restrictVisionLabel = "Restreindre la vue de la victime",
                restrictVisionDescription = "Obscurcit l'écran de la victime pendant son transport.",
                escapeEnabledLabel = "Autoriser les tentatives d'évasion",
                escapeEnabledDescription = "Permet à une victime transportée de tenter de se libérer.",
                escapeSecondsLabel = "Durée de l'évasion",
                escapeSecondsDescription = "Nombre de secondes pendant lesquelles la victime doit maintenir la touche pour se libérer.",
                maxDurationLabel = "Durée maximale",
                maxDurationDescription = "Nombre de minutes après lesquelles une session se termine automatiquement.",
                warnMinutesLabel = "Avertissement avant la fin",
                warnMinutesDescription = "Nombre de minutes avant la limite à partir desquelles les deux parties sont averties.",
                idleMinutesLabel = "Libération en cas d'inactivité",
                idleMinutesDescription = "Nombre de minutes sans aucune interaction avant que la victime ne soit libérée.",
                selfReleaseMinutesLabel = "Libération automatique après",
                selfReleaseMinutesDescription = "Nombre de minutes sans interaction de l'attaquant avant que la victime ne puisse se libérer elle-même.",
                graceSecondsLabel = "Délai après déconnexion",
                graceSecondsDescription = "Nombre de secondes pendant lesquelles la victime reste ligotée si l'attaquant quitte le serveur.",
                rescueEnabledLabel = "Autoriser les sauvetages",
                rescueEnabledDescription = "Permet aux joueurs non impliqués de libérer une victime ligotée.",
                rescueSecondsLabel = "Durée du sauvetage",
                rescueSecondsDescription = "Nombre de secondes nécessaires à un sauveteur pour libérer la victime.",
                rescueItemLabel = "Objet de sauvetage",
                rescueItemDescription = "Objet dont un sauveteur a besoin. Laissez vide pour n'en nécessiter aucun.",
                allowInventoryLabel = "La victime conserve son inventaire",
                allowInventoryDescription = "Une victime ligotée peut toujours ouvrir son inventaire.",
                dispatchEnabledLabel = "Activer les alertes de police",
                dispatchEnabledDescription = "Signale les enlèvements et les interrogatoires aux services d'urgence.",
                dispatchAdapterLabel = "Système d'alerte",
                dispatchAdapterDescription = "Système de répartition qui reçoit les rapports.",
                dispatchJobsLabel = "Métiers destinataires",
                dispatchJobsDescription = "Métiers qui reçoivent l'alerte.",
                dispatchGrabChanceLabel = "Chance de saisie",
                dispatchGrabChanceDescription = "Pourcentage de chance qu'une saisie soit signalée.",
                dispatchFixateChanceLabel = "Chance de ligotage",
                dispatchFixateChanceDescription = "Pourcentage de chance que le fait de ligoter quelqu'un sur une chaise soit signalé.",
                dispatchToolChanceLabel = "Chance d'utilisation d'outil",
                dispatchToolChanceDescription = "Pourcentage de chance que l'utilisation d'un outil soit signalée.",
                dispatchWitnessLabel = "Nécessite un témoin",
                dispatchWitnessDescription = "Ne signaler que si un autre joueur est assez proche pour s'en apercevoir.",
                dispatchWitnessRadiusLabel = "Rayon du témoin",
                dispatchWitnessRadiusDescription = "Distance minimale en mètres qu'un témoin doit respecter.",
                dispatchCooldownLabel = "Délai de l'alerte",
                dispatchCooldownDescription = "Secondes entre deux alertes provenant de la même session.",
                dispatchInaccuracyLabel = "Imprécision de position",
                dispatchInaccuracyDescription = "Nombre de mètres par lequel la position signalée est décalée aléatoirement. 0 indique l'endroit exact.",
                loggingEnabledLabel = "Activer les journaux",
                loggingEnabledDescription = "Enregistre les placements, les saisies, l'utilisation d'outils, les libérations et les actions d'admin.",
                logDatabaseLabel = "Journaliser dans la base de données",
                logDatabaseDescription = "Écrit également chaque entrée dans la table des journaux d'interrogatoire.",
                logRetentionLabel = "Conserver les journaux",
                logRetentionDescription = "Nombre de jours avant que les entrées de la base de données ne soient supprimées. 0 les conserve indéfiniment.",
                pingToleranceLabel = "Tolérance de distance",
                pingToleranceDescription = "Mètres ajoutés à chaque vérification de distance côté serveur pour compenser le lag.",
                violationThresholdLabel = "Seuil de violation",
                violationThresholdDescription = "Nombre de violations de sécurité dans la fenêtre de temps avant que la réaction ne se déclenche. 0 la désactive.",
                violationActionLabel = "Réaction aux violations",
                violationActionDescription = "Ce qui se passe lorsqu'un joueur dépasse le seuil de violation.",
                violationActionNone = "Ne rien faire",
                violationActionLog = "Journaliser uniquement",
                violationActionKick = "Expulser",
                violationActionCheating = "Signaler comme triche",
                particlesLabel = "Effets de particules",
                particlesDescription = "Affiche du sang, des étincelles et des flammes lors de l'utilisation d'outils.",
                soundLabel = "Effets sonores",
                soundDescription = "Joue les sons des outils pour tous les joueurs à proximité.",
                cameraWorkLabel = "Mouvements de caméra",
                cameraWorkDescription = "Déplace la caméra lors de la ligature de quelqu'un et pendant l'utilisation d'outils.",
                screenEffectsLabel = "Effets d'écran",
                screenEffectsDescription = "Secousses, flash, flou et filtres de couleur sur l'écran de la victime.",
                objectsSection = "Objets d'interrogatoire",
                objectsEntry = "Objet",
                objectsEditLabel = "Objets d'interrogatoire",
                objectsEditDescription = "Placer des chaises permanentes et des chariots d'outils sur la carte.",
                objectsEditButton = "Modifier les objets",
                objectsKindLabel = "Type d'objet",
                objectsKindChair = "Chaise",
                objectsKindCart = "Chariot d'outils",
                objectsModelLabel = "Modèle de l'objet",
                objectsPositionLabel = "Poste",
                blockedZonesSection = "Zones d'exclusion",
                blockedZonesEntry = "Zone",
                blockedZonesEditLabel = "Zones d'exclusion",
                blockedZonesEditDescription = "Zones où aucun objet d'interrogatoire ne peut être placé.",
                blockedZonesEditButton = "Modifier les zones",
                blockedZonesZoneLabel = "Contour de la zone",
                blockedZonesZoneDescription = "Faites glisser les coins pour définir la zone où le placement est refusé.",
                toolsSection = "Outils",
                toolsEntry = "Outil",
                toolsEditLabel = "Outils",
                toolsEditDescription = "Ajouter ou ajuster les outils pouvant être utilisés sur une victime.",
                toolsEditButton = "Modifier les outils",
                toolsItemLabel = "Objet requis",
                toolsConsumeLabel = "Consommer l'objet",
                toolsDamageLabel = "Dégâts par utilisation",
                toolsHealthFloorLabel = "Seuil de santé",
                toolsCooldownLabel = "Délai en secondes",
                toolsProgressLabel = "Progression par utilisation",
                sessionsSection = "Sessions en cours",
                sessionsEntry = "Séance",
                sessionsEditLabel = "Sessions en cours",
                sessionsEditDescription = "Voir qui est actuellement interrogé et mettre fin à la session si nécessaire.",
                sessionsEditButton = "Afficher les sessions",
                sessionsStateLabel = "État",
                sessionsProgressLabel = "Progression",
                orphansSection = "Objets orphelins",
                orphansEntry = "Objet",
                orphansEditLabel = "Objets orphelins",
                orphansEditDescription = "Supprimer les objets dont le propriétaire n'a pas été vu depuis longtemps.",
                orphansEditButton = "Nettoyer",
                sessionStates = {
                    binding = "Immobilisation en cours",
                    active = "Actif",
                    ending = "Fin en cours",
                },
            },
        },
    },
}
