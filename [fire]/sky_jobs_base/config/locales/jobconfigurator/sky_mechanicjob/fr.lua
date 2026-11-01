JobConfigLocales["sky_mechanicjob:fr"] = {
    Nui = {
        workshopConfig = {
            settingFields = {
                radialEnabled = "Facture dans le menu radial",
                allowTuningInvoices = "Facturer le tuning aux clients",
                customerRange = "Distance du client",
                allowAnalytics = "Analyse comptable",
                allowCancellation = "Annulation",
                allowCustomPrices = "Permettre des prix sur mesure",
                allowEstimates = "Autoriser les estimations",
                allowImmediatePayment = "Autoriser le paiement immédiat",
                allowManualItems = "Autoriser ses propres positions",
                allowPartialPayments = "Autoriser les paiements partiels",
                allowReminders = "Rappels",
                amount = "Montant",
                analyticsPeriodDays = "Période d'analyse",
                bone = "Os",
                category = "Catégorie",
                classId = "Classe ID",
                defaultDueDays = "Durée du paiement (jours)",
                depositPercent = "Pourcentage de dépôts",
                difficulty = "Difficulté",
                enabled = "Activé",
                estimateLifetimeHours = "Durée de vie estimée (heures)",
                flow = "Installer le flux",
                grade = "Catégorie",
                gradeRules = "Règles de classement",
                item = "Objet",
                key = "Clé",
                kilometersToZero = "Kilométrage à zéro",
                label = "Étiquette",
                laborFee = "Coût de la main-d'œuvre",
                laborMultiplier = "Multiplication de la main-d'œuvre",
                marginAdjustmentPercent = "Ajustement de marge",
                marginPercent = "Marge %",
                maxDiscountPercent = "Réduction maximale",
                maximumInvoiceAmount = "Facture maximale",
                maximumManualItems = "Positions personnelles maximales",
                maximumPrice = "Maximum",
                maximumReminders = "Rappels maximums",
                minimumInvoiceAmount = "Facture minimale",
                minimumPartialPayment = "Paiement partiel minimal",
                minimumPrice = "minimum",
                multiplier = "Multiplicateur",
                name = "Nom de l'article",
                partKey = "Clé de la partie",
                price = "Prix",
                priceType = "Type de prix",
                prop = "Accessoire",
                reason = "Raison",
                reminderFee = "Frais de rappel",
                reminderGraceDays = "Délai de grâce du rappel",
                removeAfterUse = "Consommer l'article",
                repair = "Réparation avec kit",
                repairItem = "Objet de réparation",
                rx = "Rotation X",
                ry = "Rotation Y",
                rz = "Tour Z",
                supplierSharePercent = "Fournisseur %",
                taxPercent = "Taxe sur les factures",
                transport = "Transports",
                x = "X",
                y = "Y",
                z = "Z",
                upgrade = "Amélioration",
                maximumDiscountPercent = "Remise maximale",
            },
            settingFieldDescriptions = {
                radialEnabled = "Ouvrir la facturation du garage depuis le menu radial.",
                allowTuningInvoices = "Facturer le panier de tuning au client le plus proche. Le montage est disponible après paiement intégral.",
                customerRange = "Distance maximale en mètres pour facturer les clients à proximité.",
                allowAnalytics = "Autoriser l'analyse de facturation à moins qu'une règle de grade ne l'emporte.",
                allowCustomPrices = "Permettre aux mécaniciens de modifier les prix de position de facture avant l'émission.",
                allowEstimates = "Autoriser les estimations que les clients doivent accepter avant le paiement.",
                allowImmediatePayment = "Permettre le paiement direct des factures de cette profession.",
                allowManualItems = "Permettre aux mécaniciens de créer des positions de facture arbitraires.",
                allowPartialPayments = "Autoriser les dépôts et les paiements multiples vers une facture.",
                analyticsPeriodDays = "Jours inclus dans l'analyse de facturation.",
                defaultDueDays = "Jours jusqu'à ce qu'une facture soit en retard.",
                depositPercent = "Pourcentage de dépôt requis après l'émission d'une facture ou l'acceptation d'une estimation.",
                enabled = "Permettre à cette profession d'utiliser la facturation mécanique.",
                estimateLifetimeHours = "Heures avant l'expiration d'une estimation sans réponse.",
                gradeRules = "Limites de facturation et actions disponibles pour chaque grade mécanicien.",
                maxDiscountPercent = "Le plus grand rabais qu'une facture puisse recevoir.",
                maximumInvoiceAmount = "Total global maximal avant les limites de grade.",
                maximumManualItems = "Positions arbitraires maximales par document.",
                maximumReminders = "Rappels maximums autorisés par facture.",
                minimumInvoiceAmount = "Total minimal pour les estimations et les factures.",
                minimumPartialPayment = "Paiement partiel le plus faible, à l'exclusion d'un solde ou d'un dépôt moindre.",
                reminderFee = "Frais ajoutés par chaque rappel valide.",
                reminderGraceDays = "Jours en retard avant que le premier rappel soit autorisé.",
                taxPercent = "Taxe ajoutée après remises.",
            },
            creatorSections = {
                mobileDyno = {
                    entryLabel = "Installation du banc mobile",
                    entryPluralLabel = "Installations du banc mobile",
                    label = "Installations du banc mobile",
                },
                workshops = {
                    entryLabel = "Atelier",
                    entryPluralLabel = "Ateliers",
                    label = "Ateliers",
                },
            },
            dispatchActions = {
                addChannel = "Ajouter un canal radio",
                addKeyword = "Ajouter un mot-clé",
                addPoi = "Ajouter un point d'intérêt",
                addReporter = "Ajouter un requérant",
                addStatus = "Ajouter un état FMS",
                addVehicle = "Ajouter une unité virtuelle",
                addVehicleType = "Ajouter un type d'unité",
                currentLocation = "Utiliser l'emplacement actuel",
            },
            dispatchFieldDescriptions = {
                crewCapacity = "Nombre maximal de personnes pouvant armer l'unité. Utilisez 0 pour un équipage illimité.",
                joinLocked = "Empêche d'autres personnes de rejoindre l'unité après son armement.",
                minimumCrew = "Nombre minimal de personnes dans les unités retenues pour ce plan de réponse.",
                poiId = "Identifiant technique stable que les profils de centrale conservent même après le renommage du lieu.",
                readyStatusCode = "État FMS appliqué lorsque la ressource devient disponible au départ.",
                resourceType = "Classe la ressource opérationnelle pour les filtres et la coordination de la centrale.",
                respondingStatusCode = "État FMS appliqué lorsque la ressource répond à une intervention.",
                shortLabel = "Libellé court facultatif affiché sur les six mémoires de canaux radio.",
                stationId = "Associe l'unité à une caserne configurée dans le profil de la centrale.",
                unitId = "Identifiant technique stable qui conserve l'unité même si son indicatif change.",
                autoAlarm = "Attribue immédiatement les unités disponibles correspondantes lorsqu'un incident est créé.",
                available = "Les unités dans ce statut peuvent être suggérées et affectées à un nouvel incident.",
                averageResponseSpeedKmh = "Calcule l'estimation d'arrivée affichée à partir d'une distance en ligne droite.",
                callsign = "Indicatif radio unique affiché lorsque les joueurs équipent cette unité virtuelle.",
                centerEnabled = "Permet aux membres autorisés en service d'affecter du personnel à un centre de répartition.",
                channelId = "ID de canal radio pour PMA Voice, SaltyChat et YACA. Les identifiants numériques tels que 2 500 restent inchangés ; PMA Voice mappe les identifiants de texte à un numéro stable.",
                channelLabel = "Nom du canal lisible affiché aux répartiteurs et aux unités.",
                defaultChannel = "Les répartiteurs rejoignent ce canal lorsqu'ils commencent leur quart de travail. Les unités rejoignent manuellement depuis l'onglet Radio. Sélectionnez Aucun pour utiliser la valeur par défaut du groupe de tâches.",
                emergencyAppEnabled = "Rend cette tâche sélectionnable en tant que service public dans l'application Téléphone d'urgence.",
                enabled = "Rend cette tâche disponible pour l'application Dispatch et les incidents inter-tâches.",
                icon = "Sélectionnez l'icône affichée pour cette catégorie d'unité dans l'application Dispatch.",
                incidentAssessmentEnabled = "Affiche les questions médicales et d'évaluation des dangers dans l'enregistrement complet des incidents.",
                jobs = "Noms de tâches supplémentaires qui reçoivent des incidents à l'aide de ce mot clé.",
                noUnitFallback = "Sans centre ni unité dotée de personnel, envoie une notification Sky à tous les membres en service.",
                radius = "Distance maximale en mètres à laquelle l'annonce de la station peut être entendue.",
                requirements = "Demande de réponse sous forme de paires TYPE:COUNT, par exemple PATROL:2,CRIME:1.",
                statusCode = "État FMS numérique affiché sur la radio portative.",
                statusLabel = "Signification de cet état FMS pour les répartiteurs et les unités.",
                vehicleType = "Doit correspondre à un code de type de véhicule configuré dans la sous-section précédente.",
                vehicleTypeCode = "Code d'unité court utilisé dans les exigences d'intervention, par exemple PATROL, CRIME, EMS ou RESCUE.",
                vehicleTypeLabel = "Nom lisible de cette catégorie d'unité.",
            },
            dispatchFields = {
                crewCapacity = "Capacité de l'équipage",
                joinLocked = "Verrouiller l'accès à l'équipage",
                minimumCrew = "Équipage minimum",
                poiId = "ID stable du point d'intérêt",
                readyStatusCode = "Code d'état disponible",
                resourceType = "Type de ressource",
                respondingStatusCode = "Code d'état en intervention",
                shortLabel = "Libellé de mémoire radio",
                stationId = "ID de la caserne",
                unitId = "ID stable de l'unité",
                address = "Adresse",
                autoAlarm = "Alarme automatique",
                available = "Disponible pour l'expédition\nIcône",
                averageResponseSpeedKmh = "Vitesse de réponse estimée (km/h)",
                callsign = "Indicatif",
                category = "Catégorie",
                centerEnabled = "Activer le centre de répartition",
                channelId = "ID de chaîne",
                code = "Code",
                defaultChannel = "Canal radio par défaut",
                emergencyAppEnabled = "Afficher dans l'application d'urgence",
                enabled = "Activer l'envoi",
                icon = "Icône",
                incidentAssessmentEnabled = "Activer l'évaluation d'urgence",
                jobs = "Tâches cibles (séparées par des virgules)",
                keywordCode = "Code de mot clé",
                label = "Étiquette",
                name = "Nom",
                noUnitFallback = "Avertir le personnel de service sans unités",
                noneChannel = "Aucun / groupe par défaut",
                note = "Remarque",
                phone = "Téléphone",
                radius = "Rayon d'annonce",
                requirements = "Unités requises (par exemple PATROL:2,CRIME:1)",
                type = "Type",
                vehicleType = "Type d'unité de réponse",
            },
            dispatchNavigation = {
                summary = {
                    reporters = "Requérants connus",
                    channels = "Canaux radio",
                    plans = "Plans d'intervention",
                    statuses = "États FMS disponibles",
                    units = "Unités virtuelles",
                },
                active = "Centre de régulation actif",
                description = "Configurez la prise d'appels d'urgence, la radio, les unités, les plans d'intervention, les lieux et les données des requérants pour ce métier.",
                inactive = "Centre de régulation désactivé",
                steps = {
                    accessText = "Activez la régulation et décidez si ce métier peut armer un centre de régulation.",
                    accessTitle = "Accès et prise d'appels",
                    fleetText = "Configurez les canaux, les codes d'état FMS, les types de véhicules et les indicatifs.",
                    fleetTitle = "Radio et parc de véhicules",
                    responseText = "Terminez avec les mots-clés, les moyens requis et les points d'intérêt.",
                    responseTitle = "Plans d'intervention",
                },
                title = "Centre de régulation",
                warnings = {
                    channels = "Aucun canal radio propre n'existe ; le canal de secours du groupe de métiers sera utilisé.",
                    defaultChannel = "Le canal par défaut sélectionné n'existe plus.",
                    disabled = "La régulation est désactivée pour ce métier.",
                    statuses = "Au moins un état FMS doit être disponible pour pouvoir alerter les unités.",
                },
            },
            extensionDescriptions = {
                dispatchReporters = "Gère les noms, numéros de rappel et notes de régulation propres à ce métier.",
                dispatchChannels = "Définit les canaux radio auxquels les unités et les centres de répartition dotés de personnel peuvent se joindre.",
                dispatchKeywords = "Définit les mots-clés d'incident, le nombre de véhicules requis, les tâches participantes et les alarmes automatiques en option.",
                dispatchPois = "Stocke les stations et les emplacements communs pour les formulaires d'incident et les annonces de station basées sur la position.",
                dispatchStatusCodes = "Configure les étiquettes d'état FMS et les statuts considérés comme disponibles pour les nouveaux incidents.",
                dispatchVehicleTypes = "Définit les catégories d'unités utilisées par les plans d'intervention, telles que Patrol, Crime Unit, EMS ou Rescue.",
                dispatchVehicles = "Définit des véhicules de répartition virtuels qui peuvent être dotés de n'importe où sans nécessiter de véhicule généré.",
            },
            diagnosticsSettings = {
                enabledLabel = "Activer le diagnostic des véhicules",
                enabledDescription = "Autorise ce métier à ouvrir le diagnostic des véhicules et à y réparer des pièces.",
            },
            extensions = {
                diagnosticsSettings = {
                    label = "Diagnostic des véhicules",
                    description = "Configurez l’accès de ce métier au diagnostic des véhicules.",
                },
                dispatchReporters = "Requérants connus",
                invalidSelection = "Sélection invalide : {value}",
                billingPrices = {
                    description = "Configurez les prix des factures pour les entrées d'historique d'entretien et de réparation. La clé d'action est jumelée avec action_key, action_type, ou l'étiquette de travail.",
                    label = "Motifs de facturation",
                },
                billingSettings = {
                    description = "Configurez le comportement de facturation mécanique pour cette profession.",
                    label = "Facturation",
                },
                dispatchChannels = "Canaux radio",
                dispatchKeywords = "Mots-clés et plans d'intervention",
                dispatchPois = "Points d'intérêt de la répartition",
                dispatchSettings = {
                    description = "Configurez l'accès à la répartition, l'accueil des urgences et le canal radio par défaut.",
                    label = "Paramètres de répartition",
                },
                dispatchStatusCodes = "Codes de statut",
                dispatchVehicleTypes = "Types de véhicules de répartition",
                dispatchVehicles = "Flotte de répartition",
                emptyDescription = "Utilisez le bouton Ajouter ci-dessus pour créer la première entrée.",
                emptyTitle = "Rien de configuré pour l'instant",
                partsDeliveryShop = "Boutique de livraison de pieces",
                trainingSettings = {
                    description = "Configurez l'accès à la formation, l'inscription, les approbations et la planification des cours pour cet emploi.",
                    label = "Paramètres d'entraînement",
                },
                tuningCostProfile = {
                    description = "Configurez les couts de performance, d apparence, de roues et d options speciales pour ce job.",
                    label = "Prix de tuning",
                },
            },
            features = {
                tuningFreeCamera = {
                    label = "Caméra libre dans le menu de tuning",
                    description = "Permet de masquer le curseur avec Espace pour déplacer librement la caméra. Échap ferme toujours le menu.",
                },
                tuningCamera = {
                    description = "Oriente automatiquement la caméra vers la pièce sélectionnée. Une fois désactivée, la caméra de jeu normale reste active.",
                    label = "Caméra de tuning automatique",
                },
                jgMileage = {
                    description = "Utiliser JG Vehicle Mileage lorsque sa ressource est démarrée. Sinon, utiliser le kilométrage Sky. JG HUD se configure séparément.",
                    label = "JG Mileage",
                },
                jgHud = {
                    description = "Afficher le kilométrage sélectionné dans JG HUD. Fonctionne sans JG Vehicle Mileage ; installer l’adaptateur HUD selon le README.",
                    label = "JG HUD",
                },
                handlingEditor = {
                    description = "Active l’éditeur administrateur et ses règles automatiques par plaque et modèle. Après désactivation, ressortez les véhicules concernés du garage pour réinitialiser les valeurs déjà appliquées.",
                    label = "Éditeur de conduite",
                },
                kuv = {
                    description = "Démarrer le contrôle technique",
                    label = "Contrôle technique du véhicule",
                },
                mobileDyno = {
                    description = "Active le banc mobile, les écrans de contrôle et de résultats, le contrôleur des ventilateurs et la tablette.",
                    label = "Banc mobile",
                },
                vehicleRegistration = {
                    description = "Immatriculer / transférer",
                    label = "Immatriculation",
                },
                antiLag = {
                    description = "Activer l'installation anti-lag et les effets d'échappement.",
                    label = "Lutte contre le lag",
                },
                brakeOverheating = {
                    description = "Activer la chaleur des freins, les disques brillants, les étincelles critiques et l'évanouissement des freins.",
                    label = "Surchauffe des freins",
                },
                carryItems = {
                    description = "Obliger le transport des pieces livrees dans l atelier.",
                    label = "Manutention physique des pieces",
                },
                customHandling = {
                    description = "Activer le groupe motopropulseur personnalisé et le réglage de la manipulation.",
                    label = "Manipulation personnalisée",
                },
                electronicTuning = {
                    description = "Activez ECU persistante, options d'éclairage et d'aide au conducteur.",
                    label = "Tuning électronique",
                },
                instantTuning = {
                    description = "Permettre l'accordage direct à des emplacements publics configurés.",
                    label = "Tuning instantané",
                },
                mileageHud = {
                    description = "Afficher le kilometrage du vehicule pendant la conduite.",
                    label = "HUD kilometrage",
                },
                nitro = {
                    description = "Activez l'installation de nitro et l'utilisation d'un boost de véhicule.",
                    label = "Nitro",
                },
                partsDelivery = {
                    description = "Activer les commandes de pieces d atelier et les zones de livraison.",
                    label = "Livraison de pieces",
                },
                selfServiceOrderNotifications = {
                    description = "Informer les employés en service lorsqu'un ordre d'accord en libre-service est créé.",
                    label = "Notifications de commande en libre-service",
                },
                stance = {
                    description = "Afficher les réglages de Stance dans tous les menus de réglage et activer l'élément Stance Kit.",
                    label = "Posture",
                },
                stanceWheelSize = {
                    description = "Afficher, enregistrer et appliquer les réglages de la taille de la roue dans Stance.",
                    label = "Taille de la roue de stance",
                },
                stanceWheelWidth = {
                    description = "Afficher, enregistrer et appliquer des réglages de largeur de roue dans Stance.",
                    label = "Largeur de la roue de stance",
                },
                subscriptions = {
                    description = "Activer les terminaux d'abonnement à l'atelier, la gestion et les rabais clients.",
                    label = "Abonnements aux ateliers",
                },
                twoStep = {
                    description = "Activer la commande de lancement en deux étapes et les effets d'échappement.",
                    label = "Deux étapes",
                },
                vehicleMaintenanceNotifications = {
                    description = "Prévenez les propriétaires lorsque leur véhicule atteint le seuil d'entretien configuré.",
                    label = "Notifications d'entretien des véhicules",
                },
                wheelDamage = {
                    description = "Activer les degats realistes des roues et les reparations.",
                    label = "Degats des roues",
                },
                workshopLift = {
                    description = "Activer les points de pont elevateur utilisables dans les ateliers.",
                    label = "Pont elevateur",
                },
            },
            locationDescriptions = {
                vehicle_registry = "Placez le point dans la zone de contrôle de l’atelier. Le véhicule doit respecter la distance de contrôle configurée pour le contrôle technique et l’immatriculation.",
            },
            locationTypes = {
                mobile_dyno_monitor = {
                    description = "Position de l'écran de résultats.",
                    label = "Écran de résultats",
                },
                mobile_dyno_station = {
                    description = "Position de la station de banc mobile.",
                    label = "Station de banc mobile",
                },
                vehicle_registry = "Point de contrôle et d’immatriculation",
            },
            messages = {
                dispatchEmergencyRequiresDispatch = "L’affichage dans l’application Urgences nécessite l’activation de la régulation. Activez la régulation ou désactivez l’affichage dans l’application Urgences dans les paramètres de régulation.",
                dispatchJobNotCovered = "Aucun centre de régulation actif ne couvre le métier « {job} ». Dans sky_jobs_base/config/config.lua, ajoutez « {job} » à coveredJobs dans le profil approprié de Config.Dispatch.centers, puis redémarrez sky_jobs_base. Réinitialiser les paramètres ne modifie pas cette affectation.",
                invalidDispatchChannels = "Les ID des canaux radio doivent être uniques et chaque canal doit avoir un libellé valide.",
                invalidDispatchDefaultChannel = "Le canal radio par défaut n’existe pas. Dans les paramètres de régulation, sélectionnez un canal existant ou « Aucun ».",
                invalidDispatchKeywords = "Les plans de réponse doivent avoir des codes uniques et des besoins TYPE:NOMBRE valides.",
                invalidDispatchPois = "Les ID, noms et coordonnées des points d'intérêt doivent être valides et uniques.",
                invalidDispatchRadioButtons = "Vérifiez les boutons de fonction de la radio : utilisez chaque bouton pris en charge une seule fois et sélectionnez son action dans la liste.",
                invalidDispatchRadioFmsKeys = "Vérifiez les touches FMS de la radio : utilisez chaque touche (0-9, * ou #) une seule fois et associez-lui un code de statut existant ou laissez-la sans affectation.",
                invalidDispatchReadyStatus = "Dans les paramètres de régulation, sélectionnez un code de disponibilité marqué comme disponible dans les codes de statut.",
                invalidDispatchReporters = "Les données des requérants connus dépassent le nombre d'entrées ou la longueur autorisés.",
                invalidDispatchRespondingStatus = "Dans les paramètres de régulation, sélectionnez un code de départ en intervention marqué comme indisponible dans les codes de statut.",
                invalidDispatchSettings = "Sélectionnez un état disponible existant, un état de départ indisponible et un canal par défaut valide.",
                invalidDispatchStatusCodes = "Les codes FMS doivent être uniques et au moins un état doit être disponible.",
                invalidDispatchVehicleTypes = "Les codes des types d'unités doivent être uniques et complets.",
                invalidDispatchVehicles = "Les ID et indicatifs d'unité doivent être uniques et toutes les références de type et de caserne doivent exister.",
            },
            settingGroups = {
                diagnostics = {
                    label = "Diagnostic",
                },
                keybinds = {
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                    label = "Raccourcis",
                },
                safety = {
                    label = "Validation et sécurité",
                },
                antiExploit = {
                    label = "Lutte contre l'exploitation",
                },
                coach = {
                    label = "Entraîneur de télémétrie",
                },
                cooldownMultipliers = {
                    label = "Multiplicateurs de refroidissement",
                },
                crashFalloff = {
                    label = "Atténuation des dégâts de collision",
                },
                criticalEngine = {
                    label = "Moteur brisé",
                },
                deformation = {
                    label = "Déformation",
                },
                fade = {
                    label = "Perte d’efficacité des freins",
                },
                features = {
                    label = "Fonctionnalités",
                },
                format = {
                    label = "Format",
                },
                frontalImpact = {
                    label = "Accident frontal sévère",
                },
                general = {
                    label = "Général",
                },
                heatMultipliers = {
                    label = "Multiplicateurs de chauffe",
                },
                illegalMarket = {
                    label = "Marché illégal",
                },
                integration = {
                    label = "Intégration",
                },
                items = {
                    label = "Objets",
                },
                lifetime = {
                    label = "Durée de vie",
                },
                limits = {
                    label = "Limites de stockage",
                },
                repairRestore = {
                    label = "Restaurer la réparation",
                },
                risk = {
                    label = "Risque",
                },
                rules = {
                    label = "Règles",
                },
                stages = {
                    label = "Paliers de surchauffe",
                },
                tyreRepair = {
                    label = "Réparation des pneumatiques",
                },
                visuals = {
                    label = "Effets visuels",
                },
            },
            settingSections = {
                electronicTuning = "Logiciel moteur ECU",
                handlingEditor = "Éditeur de tenue de route",
                mobileDyno = "Banc de puissance mobile",
                vehicleRegistry = "Documents du véhicule",
                advancedPricing = "Prix avancé",
                brakeOverheating = "Surchauffe des freins",
                carryItems = "Objets à porter",
                fakePlates = "Fausses plaques",
                firejobVehicleFires = "Incendie des véhicules",
                general = "Général",
                instantTuning = "Tuning instantané",
                maintenanceNotifications = "Notifications d'entretien",
                mileageHud = "HUD kilometrage",
                oilLeaks = "Fuites des fluides du véhicule",
                partsTheft = "Vol de pièces",
                subscriptions = "Abonnements",
                tuning = "Réglage",
                vehicleCare = "Prise en charge des véhicules",
                wear = "Usure",
                wheelDamage = "Degats des roues",
            },
            settingSubsectionGroups = {
                handlingAdditional = "Autres",
                handlingAir = "Dans l'air",
                handlingGeneral = "Général",
                handlingRoad = "Route",
                handlingWater = "Eau",
            },
            settingSubsections = {
                mechanicHotkeys = "Raccourcis",
                database = "Base de données",
                handlingEditorGeneral = "Paramètres de l’éditeur",
                handlingMaximumCBikeHandlingData = "Moto",
                handlingMaximumCBoatHandlingData = "Bateau",
                handlingMaximumCCarHandlingData = "Voiture",
                handlingMaximumCFlyingHandlingData = "Avion",
                handlingMaximumCHandlingData = "Base du véhicule",
                handlingMaximumCSeaPlaneHandlingData = "Hydravion",
                handlingMaximumCSpecialFlightHandlingData = "Vol spécial",
                handlingMaximumCSubmarineHandlingData = "Sous-marin",
                handlingMaximumCTrailerHandlingData = "Remorque",
                handlingMaximumCVehicleWeaponHandlingData = "Armes du véhicule",
                keybinds = "Raccourcis",
                operation = "Fonctionnement",
                placementRules = "Règles de placement",
                testFlow = "Déroulement du test",
                tuning = "Options de modification instantanée",
            },
            settings = {
                instantTuningRepairEnabled = {
                    label = "Réparation du véhicule",
                    description = "Proposer la réparation aux points de tuning instantané.",
                },
                instantTuningRepairPrice = {
                    label = "Prix de réparation",
                    description = "Prix fixe de réparation, sans multiplicateur de prix du tuning.",
                },
                instantTuningWashEnabled = {
                    label = "Lavage du véhicule",
                    description = "Proposer le lavage aux points de tuning instantané.",
                },
                instantTuningWashPrice = {
                    label = "Prix du lavage",
                    description = "Prix fixe du lavage, sans multiplicateur de prix du tuning.",
                },
                vehiclePriceSource = {
                    label = "Source des prix des véhicules",
                    description = "Automatique : SQL sur ESX ; catalogue de véhicules sur QBCore/Qbox. Base de données : table SQL configurée sur chaque framework.",
                    options = {
                        auto = "Automatique (framework)",
                        database = "Base de données",
                    },
                },
                vehiclePriceTable = {
                    label = "Table des prix des véhicules",
                    description = "Table contenant les prix d'achat, par exemple dealership_vehicles (JG).",
                },
                vehiclePriceModelColumn = {
                    label = "Colonne du nom de spawn",
                    description = "Colonne des noms de spawn, par exemple spawn_code (JG), et non du nom affiché.",
                },
                vehiclePricePriceColumn = {
                    label = "Colonne du prix",
                    description = "Colonne des prix d'achat numériques, par exemple price.",
                },
                vehiclePriceHashColumn = {
                    label = "Colonne du hash du modèle (facultative)",
                    description = "Colonne facultative de hash numériques, par exemple hashkey (JG). Laisser vide pour calculer les hash à partir des noms de spawn.",
                },
                handlingEditorFieldMaximum = {
                    description = "Valeur maximale stricte acceptée par l’éditeur pour ce champ de tenue de route.",
                },
                handlingEditorFocusKey = {
                    label = "Retour à l’éditeur handling",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                handlingEditorPayloadWarningBytes = {
                    description = "Nombre d’octets encodés au-delà duquel une requête, réponse ou capture de l’éditeur est signalée comme volumineuse.",
                    label = "Seuil de charge volumineuse",
                },
                handlingEditorPerformanceChecksEnabled = {
                    description = "Mesure les opérations de l’éditeur et avertit via Sky.Debug lorsque les limites configurées sont dépassées.",
                    label = "Contrôles de performances",
                },
                handlingEditorPerformanceSummaryIntervalMs = {
                    description = "Nombre de millisecondes entre les résumés de performances lorsque le journal détaillé est activé.",
                    label = "Intervalle des résumés",
                },
                handlingEditorPerformanceWarningMs = {
                    description = "Nombre de millisecondes au-delà duquel une opération de l’éditeur est signalée comme lente.",
                    label = "Seuil d’opération lente",
                },
                handlingEditorSliderMaximumDeviationPercent = {
                    description = "Pourcentage maximal dont un curseur numérique peut s’écarter au-dessus ou au-dessous de la base du véhicule lue. La saisie directe et l’import XML restent sans perte. Un maximum de champ différent de la valeur par défaut remplace la limite supérieure du curseur.",
                    label = "Écart maximal du curseur",
                },
                mechanicCatalyticConverterCATALYTICACTIONCONTROL = {
                    label = "Vol de catalyseur · Contrôle 38",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicCatalyticConverterCATALYTICCANCELCONTROL = {
                    label = "Vol de catalyseur · Contrôle 73",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicDynoControl172 = {
                    label = "Banc d’essai · Contrôle 172",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicDynoControl173 = {
                    label = "Banc d’essai · Contrôle 173",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicDynoControl174 = {
                    label = "Banc d’essai · Contrôle 174",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicDynoControl175 = {
                    label = "Banc d’essai · Contrôle 175",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicDynoControl177 = {
                    label = "Banc d’essai · Contrôle 177",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicDynoControl38 = {
                    label = "Banc d’essai · Contrôle 38",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicDynoControl45 = {
                    label = "Banc d’essai · Contrôle 45",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicDynoControl47 = {
                    label = "Banc d’essai · Contrôle 47",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicSprayPaintControl200 = {
                    label = "Peinture · Contrôle 200",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicSprayPaintControl202 = {
                    label = "Peinture · Contrôle 202",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicVehicleCareControl200 = {
                    label = "Entretien du véhicule · Contrôle 200",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicVehicleCareControl202 = {
                    label = "Entretien du véhicule · Contrôle 202",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicVehiclePushINPUTCONTEXT = {
                    label = "Poussée du véhicule · Contrôle 38",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicVehiclePushINPUTMOVEDOWN = {
                    label = "Poussée du véhicule · Contrôle 33",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicVehiclePushINPUTMOVELEFT = {
                    label = "Poussée du véhicule · Contrôle 34",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicVehiclePushINPUTMOVERIGHT = {
                    label = "Poussée du véhicule · Contrôle 35",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicVehiclePushINPUTMOVEUP = {
                    label = "Poussée du véhicule · Contrôle 32",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicVehiclePushINPUTSPRINT = {
                    label = "Poussée du véhicule · Contrôle 21",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicWheelChangeControl200 = {
                    label = "Changement de roue · Contrôle 200",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicWheelChangeControl202 = {
                    label = "Changement de roue · Contrôle 202",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicWheelChangeControl22 = {
                    label = "Changement de roue · Contrôle 22",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicWheelTheftWHEELTHEFTACTIONCONTROL = {
                    label = "Vol de roue · Contrôle 38",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mechanicWheelTheftWHEELTHEFTCANCELCONTROL = {
                    label = "Vol de roue · Contrôle 73",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                mobileDynoConsumeItem = {
                    description = "Retirer un objet après un placement réussi.",
                    label = "Consommer un objet",
                },
                mobileDynoCooldownMs = {
                    label = "Durée de refroidissement",
                },
                mobileDynoCountdownMs = {
                    label = "Compte à rebours",
                },
                mobileDynoDuiDistance = {
                    label = "Distance d'affichage du panneau",
                },
                mobileDynoFanInteractionDistance = {
                    label = "Distance du contrôleur des ventilateurs",
                    description = "Distance en mètres pour utiliser l'interrupteur physique entre les ventilateurs de refroidissement.",
                },
                mobileDynoFullLoadDurationMs = {
                    label = "Durée à pleine charge",
                    description = "Des millisecondes ont été dépensées à pleine charge soutenue dans des profils comportant une phase de pleine charge.",
                },
                mobileDynoHistoryLimit = {
                    label = "Limite de l'historique",
                },
                mobileDynoInteractionDistance = {
                    label = "Distance d'interaction",
                },
                mobileDynoItemUseEnabled = {
                    description = "Autoriser le placement du banc et du moniteur en utilisant des objets.",
                    label = "Placement par objet",
                },
                mobileDynoMaxActiveSessions = {
                    label = "Limite de sessions actives",
                },
                mobileDynoMaxVehicleDistance = {
                    label = "Distance de détection du véhicule",
                },
                mobileDynoMonitorItem = {
                    description = "Objet à utiliser pour placer un moniteur de résultats.",
                    label = "Objet du moniteur",
                },
                mobileDynoPersistItems = {
                    description = "Conserver les nouveaux placements après le redémarrage du serveur.",
                    label = "Enregistrer les placements",
                },
                mobileDynoPickupDistance = {
                    description = "Distance maximale en mètres pour ranger le matériel.",
                    label = "Distance de rangement",
                },
                mobileDynoPlacementMaxHeightSpread = {
                    label = "Écart de hauteur maximal",
                    description = "Variation maximale de hauteur au sol en mètres acceptée pour toutes les sondes dyno.",
                },
                mobileDynoPlacementMaxSlopeDegrees = {
                    label = "Pente maximale de placement",
                    description = "La pente maximale du sol en degrés est acceptée à travers l'empreinte dyno.",
                },
                mobileDynoRequireOnDuty = {
                    description = "Les mécaniciens doivent être en service pour placer et utiliser le banc.",
                    label = "Service obligatoire",
                },
                mobileDynoResultDuiDistance = {
                    label = "Distance de l'écran de résultats",
                    description = "Distance maximale en mètres à laquelle le moniteur de résultats séparé est rendu.",
                },
                mobileDynoReturnItem = {
                    description = "Restituer l’objet consommé lors du rangement du matériel.",
                    label = "Restituer un objet",
                },
                mobileDynoStationItem = {
                    description = "Objet à utiliser pour placer un banc de puissance.",
                    label = "Objet du banc",
                },
                mobileDynoTabletDistance = {
                    description = "Distance maximale du banc en mètres pour le contrôle par tablette et les tests actifs.",
                    label = "Portée de la tablette",
                },
                nitroActivationKey = {
                    label = "Maintenir le nitro",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                registryBikeChecks = {
                    description = "Points de contrôle moto",
                    label = "Points de contrôle moto",
                },
                registryCarChecks = {
                    description = "Points de contrôle automobile",
                    label = "Points de contrôle automobile",
                },
                registryDistance = {
                    description = "Distance de service (mètres)",
                    label = "Distance de service (mètres)",
                },
                registryKuvFee = {
                    description = "Frais Contrôle technique du véhicule",
                    label = "Frais Contrôle technique du véhicule",
                },
                registryKuvValidityDays = {
                    description = "Validité des nouveaux contrôles en temps réel. Par défaut : 30 jours. Les échéances existantes sont conservées.",
                    label = "Validité du contrôle (jours réels)",
                },
                registryKuvWarningDays = {
                    description = "Préavis (jours)",
                    label = "Préavis (jours)",
                },
                registryRegistrationFee = {
                    description = "Frais d'immatriculation",
                    label = "Frais d'immatriculation",
                },
                registryReinspectionFee = {
                    description = "Frais de contre-visite",
                    label = "Frais de contre-visite",
                },
                registryRequireKuv = {
                    description = "Exiger un Contrôle technique du véhicule valide pour immatriculer",
                    label = "Exiger un Contrôle technique du véhicule valide pour immatriculer",
                },
                registrySessionSeconds = {
                    description = "Délai de confirmation (secondes)",
                    label = "Délai de confirmation (secondes)",
                },
                registryTransferFee = {
                    description = "Frais de transfert",
                    label = "Frais de transfert",
                },
                registryVehicleTypes = {
                    description = "Types de véhicules autorisés",
                    label = "Types de véhicules autorisés",
                },
                tuningFocusKey = {
                    label = "Interaction souris du tuning",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                addRevenueToSociety = {
                    description = "Dépôt d'accord payé mandat de l'argent dans le compte de la société de profession d'accord.",
                    label = "Dépôt des recettes à la société",
                },
                advancedPricingAlwaysAvailableItemCategories = {
                    description = "Catégories d'atelier de livraison de pièces qui restent librement purchasables pendant que le prix avancé est activé.",
                    itemLabel = "Catégorie",
                    label = "Catégories toujours disponibles",
                },
                advancedPricingAlwaysAvailableItemsEnabled = {
                    description = "Conservez les articles de magasin configurés dans les catégories sélectionnées disponibles sans ordre de réglage et prix à travers le système de fournisseur dynamique.",
                    label = "Produits toujours disponibles en magasin",
                },
                advancedPricingAnalyticsPeriodDays = {
                    description = "Nombre de jours indiqués dans l'analyse des bénéfices de la tablette.",
                    label = "Période d'analyse",
                },
                advancedPricingCategoryRules = {
                    description = "Part des fournisseurs, la marge, la main-d'oeuvre et les limites de prix par catégorie de réglage.",
                    label = "Règles de catégorie",
                },
                advancedPricingDefaultMarginPercent = {
                    description = "Marge mécanique par défaut avant ajustements de classe et de grade.",
                    label = "Marge par défaut",
                },
                advancedPricingDifficultyRules = {
                    description = "Coût de la main-d'oeuvre supplémentaire pour chaque difficulté de réglage.",
                    label = "Règles de difficulté",
                },
                advancedPricingEnabled = {
                    description = "Recalculer les prix de réglage sur le serveur et, lorsque la livraison de pièces est activée, exiger que des pièces Dynasty soient achetées pour leur commande de réglage spécifique.",
                    label = "Activer les prix avancés",
                },
                advancedPricingInventoryBaseStock = {
                    description = "Stock virtuel normal pour chaque article fournisseur.",
                    label = "Stock de base",
                },
                advancedPricingInventoryDemandDecayPerDay = {
                    description = "Points de demande supprimés par jour écoulé.",
                    label = "Décroissance quotidienne de la demande",
                },
                advancedPricingInventoryDemandMarkupPerUnitPercent = {
                    description = "Marquage du fournisseur ajouté pour chaque point de demande.",
                    label = "Indice de la demande par unité",
                },
                advancedPricingInventoryEnabled = {
                    description = "Augmenter les prix des fournisseurs lorsque le stock virtuel est faible ou que la demande est élevée.",
                    label = "Stock de fournisseurs dynamiques",
                },
                advancedPricingInventoryLowStockMarkupPercent = {
                    description = "Marquage maximal du fournisseur causé par un stock faible.",
                    label = "Marquage à bas stocks",
                },
                advancedPricingInventoryLowStockThreshold = {
                    description = "Niveau de stock en dessous duquel commence la tarification de la rareté.",
                    label = "Seuil de stocks bas",
                },
                advancedPricingInventoryMaximumDemandMarkupPercent = {
                    description = "Limite supérieure pour le marquage de la demande.",
                    label = "Marquage de la demande maximale",
                },
                advancedPricingInventoryRestockPerDay = {
                    description = "Unités virtuelles reconstituées par jour écoulé.",
                    label = "Restockage quotidien",
                },
                advancedPricingMaximumDiscountPercent = {
                    description = "Plafond d'escompte global pour les factures de mécaniciens.",
                    label = "Réduction maximale",
                },
                advancedPricingMaximumMarginPercent = {
                    description = "Marge mécanique maximale autorisée.",
                    label = "Marge maximale",
                },
                advancedPricingMaximumRetailPrice = {
                    description = "Limite mondiale des prix supérieurs pour une partie de réglage.",
                    label = "Prix de détail maximal",
                },
                advancedPricingMechanicGradeRules = {
                    description = "Marquage, travail et limites de rabais par grade mécanicien.",
                    label = "Règles relatives aux grades mécaniques",
                },
                advancedPricingMinimumMarginPercent = {
                    description = "Marge mécanique la plus faible autorisée.",
                    label = "Marge minimale",
                },
                advancedPricingMinimumRetailPrice = {
                    description = "Limite des prix mondiaux plus bas pour une partie de réglage.",
                    label = "Prix minimal de détail",
                },
                advancedPricingPreviewCompactValue = {
                    description = "Valeur du véhicule utilisée pour l'exemple compact.",
                    label = "Valeur d'aperçu compacte",
                },
                advancedPricingPreviewCostPercent = {
                    description = "Exemple de pourcentage de coût de réglage utilisé par l'aperçu en direct.",
                    label = "Prévisualiser le taux de réglage",
                },
                advancedPricingPreviewSportsValue = {
                    description = "Valeur du véhicule utilisée pour l'exemple sportif.",
                    label = "Valeur de l'aperçu sportif",
                },
                advancedPricingPreviewSuperValue = {
                    description = "Valeur du véhicule utilisée pour l'exemple de supercar.",
                    label = "Valeur d'aperçu supérieure",
                },
                advancedPricingQuoteLifetimeMinutes = {
                    description = "Minutes avant qu'une offre de prix impayée soit recalculée.",
                    label = "Durée de vie des citations",
                },
                advancedPricingReturnRefundPercent = {
                    description = "Pourcentage remboursé pour une partie liée à l'achat.",
                    label = "Remboursement de retour",
                },
                advancedPricingRoundingStep = {
                    description = "Rond chaque ligne d'approvisionnement Dynasty à cette étape d'argent.",
                    label = "Étape d'arrondi du fournisseur",
                },
                advancedPricingSupplierSharePercent = {
                    description = "Pourcentage du prix de la pièce client facturé par Dynasty Auto Supply.",
                    label = "Part des fournisseurs",
                },
                advancedPricingTaxPercent = {
                    description = "Pourcentage de taxe stocké séparément dans la comptabilité des prix.",
                    label = "Taxe",
                },
                advancedPricingVehicleClassRules = {
                    description = "Marge et ajustements de la main-d'œuvre par classe de véhicules GTA.",
                    label = "Règles relatives à la classe du véhicule",
                },
                brakeOverheatingCooldownBrakeUpgradeMultipliers = {
                    label = "Multiplicateurs de refroidissement de la mise à niveau des freins",
                },
                brakeOverheatingCooldownClassMultipliers = {
                    label = "Multiplicateurs de refroidissement de la classe du véhicule",
                },
                brakeOverheatingCoolingDelayMs = {
                    description = "Retard en millisecondes après le freinage avant le début du refroidissement actif.",
                    label = "Délai de refroidissement",
                },
                brakeOverheatingCoolingPerSecond = {
                    description = "Chaleur enlevée par seconde pendant que le frein n'est pas utilisé.",
                    label = "Vitesse de refroidissement",
                },
                brakeOverheatingCriticalThreshold = {
                    description = "Niveau de chaleur à partir duquel les étincelles et l'évanouissement des freins peuvent commencer.",
                    label = "Seuil critique",
                },
                brakeOverheatingFadeChancePerSecond = {
                    description = "Chance de 0 à 1 pour une courte coupure de frein pendant le freinage à chaleur critique.",
                    label = "Fade chance par seconde",
                },
                brakeOverheatingFadeCooldownMs = {
                    label = "Refroidissement du fade",
                },
                brakeOverheatingFadeMaximumDurationMs = {
                    label = "Durée maximale de l'épreuve",
                },
                brakeOverheatingFadeMinimumDurationMs = {
                    label = "Durée minimale de la décoloration",
                },
                brakeOverheatingHeatBrakeUpgradeMultipliers = {
                    label = "Multiplicateurs de chaleur de mise à niveau des freins",
                },
                brakeOverheatingHeatClassMultipliers = {
                    label = "Multiplicateurs de chaleur par classe de véhicule",
                },
                brakeOverheatingHeatGainPerSecond = {
                    description = "La chaleur de base a augmenté par seconde pendant le freinage à la vitesse de référence.",
                    label = "Gain de chaleur",
                },
                brakeOverheatingHotThreshold = {
                    label = "Seuil à chaud",
                },
                brakeOverheatingMinimumSpeedKmh = {
                    description = "Vitesse minimale du véhicule en km/h avant que le freinage ne crée de la chaleur.",
                    label = "Vitesse minimale de freinage",
                },
                brakeOverheatingReferenceSpeedKmh = {
                    description = "Vitesse en km/h à laquelle le gain calorifique de base configuré est appliqué.",
                    label = "Régime de référence",
                },
                brakeOverheatingSparkMaximumIntervalMs = {
                    label = "Intervalle maximal d'étincelles",
                },
                brakeOverheatingSparkMinimumIntervalMs = {
                    label = "Intervalle minimal d ' étincelles",
                },
                brakeOverheatingVisualDistance = {
                    description = "Distance maximale en mètres pour le rendu de la lumière et de l'étincelle.",
                    label = "Distance visuelle",
                },
                brakeOverheatingWarmThreshold = {
                    label = "Seuil chaud",
                },
                carryItems = {
                    description = "Pièces livrées qui devraient devenir des accessoires portés physiquement.",
                    fields = {
                        transport = {
                            options = {
                                engine_lift = "Poignée du moteur",
                                forklift = "Chariot élévateur",
                                hand = "Main",
                            },
                        },
                    },
                    itemLabel = "Objet de transport",
                    label = "Charger les articles",
                },
                ecuEngineTorqueStage1 = {
                    description = "1,00 n'ajoute aucune puissance ; 1,10 augmente le couple de 10 %. S'applique aux véhicules équipés de ce niveau ECU.",
                    label = "Multiplicateur de couple du niveau 1",
                },
                ecuEngineTorqueStage2 = {
                    description = "1,00 n'ajoute aucune puissance ; 1,10 augmente le couple de 10 %. S'applique aux véhicules équipés de ce niveau ECU.",
                    label = "Multiplicateur de couple du niveau 2",
                },
                ecuEngineTorqueStage3 = {
                    description = "1,00 n'ajoute aucune puissance ; 1,10 augmente le couple de 10 %. S'applique aux véhicules équipés de ce niveau ECU.",
                    label = "Multiplicateur de couple du niveau 3",
                },
                ecuEngineTorqueStage4 = {
                    description = "1,00 n'ajoute aucune puissance ; 1,10 augmente le couple de 10 %. S'applique aux véhicules équipés de ce niveau ECU.",
                    label = "Multiplicateur de couple du niveau 4",
                },
                fakePlatesAudit = {
                    label = "Journal d'audit",
                },
                fakePlatesBlacklist = {
                    description = "Mots ou fragments bloqués qui ne peuvent pas apparaître dans de fausses plaques.",
                    label = "Liste noire",
                },
                fakePlatesBlankPlateItem = {
                    description = "Matériel d'artisanat/d'atelier utilisé pour les faux boucles d'économie de plaques.",
                    label = "Pièce de plaque blanche",
                },
                fakePlatesCooldownMinutes = {
                    label = "Minutes de délai",
                },
                fakePlatesCrashFalloffChance = {
                    label = "Risque de chute",
                },
                fakePlatesCrashFalloffEnabled = {
                    label = "Crash Falloff activé",
                },
                fakePlatesCrashFalloffMinSpeedKmh = {
                    label = "Vitesse minimale de choc",
                },
                fakePlatesEnabled = {
                    description = "Permettre aux joueurs d'utiliser de faux kits de plaques sur les véhicules.",
                    label = "Activer les fausses plaques",
                },
                fakePlatesExpireMinutes = {
                    description = "0 maintient les fausses plaques actives jusqu'à ce que la gestion de réinitialisation ou de redémarrage les supprime.",
                    label = "Expirer les minutes",
                },
                fakePlatesExpireOnRestart = {
                    label = "Expire au redémarrage",
                },
                fakePlatesIllegalMarketAccount = {
                    label = "Compte de paiement",
                },
                fakePlatesIllegalMarketEnabled = {
                    label = "Marché illégal",
                },
                fakePlatesIllegalMarketPrice = {
                    label = "Prix de marché illégaux",
                },
                fakePlatesIllegalMarketRiskMultiplier = {
                    label = "Multiplicateur de risque",
                },
                fakePlatesInstallDurationMs = {
                    label = "Installer la durée ms",
                },
                fakePlatesItem = {
                    description = "Un élément à usage unique qui démarre le flux d'installation de la fausse plaque.",
                    label = "Fausse pièce de kit de plaque",
                },
                fakePlatesMaxLength = {
                    label = "Longueur maximale",
                },
                fakePlatesMaxVehicleDistance = {
                    label = "Distance du véhicule",
                },
                fakePlatesMinLength = {
                    label = "Durée minimale",
                },
                fakePlatesPattern = {
                    description = "Modèle Lua utilisé pour valider le texte de la fausse plaque, par exemple ^[A-Z0-9]+$.",
                    label = "Modèle Lua",
                },
                fakePlatesPlateInstallDistance = {
                    label = "Distance de position de la plaque",
                },
                fakePlatesPreventDuplicateDisplayPlates = {
                    label = "Block duplicate active faux plaques",
                },
                fakePlatesPrinterItem = {
                    description = "Outil d'artisanat/d'atelier utilisé pour les boucles d'économie de faux plaques.",
                    label = "Pièce d'imprimante de plaques",
                },
                fakePlatesRequireEngineOff = {
                    label = "Le moteur doit être coupé",
                },
                fakePlatesRequireOwnerOrKeys = {
                    description = "Utiliser Config.Functions.CanApplyFakePlate avant de permettre l'installation.",
                    label = "Exiger le propriétaire ou les clés",
                },
                fakePlatesRequireStopped = {
                    label = "Le véhicule doit être arrêté",
                },
                fakePlatesResetOnGarageStore = {
                    description = "Réservé pour les intégrations de garage qui appellent l'événement de réinitialisation / exportation.",
                    label = "Réinitialisation dans le garage",
                },
                fakePlatesRiskCharacters = {
                    label = "Caractères Typo",
                },
                fakePlatesRiskEnabled = {
                    label = "Type de risque activé",
                },
                fakePlatesRiskTypoChance = {
                    label = "Probabilité de faute de frappe",
                },
                fallbackVehicleValue = {
                    description = "Valeur utilisée lorsqu'aucun prix du véhicule ne peut être résolu.",
                    label = "Valeur du véhicule",
                },
                firejobVehicleFiresCriticalChance = {
                    description = "Une chance de 0 à 1 après que le moteur reste critique.",
                    label = "Risque d ' incendie critique du moteur",
                },
                firejobVehicleFiresCriticalCooldownSeconds = {
                    description = "Des secondes avant qu'un autre moteur cassé ne déclenche.",
                    label = "Refroidissement critique du moteur",
                },
                firejobVehicleFiresCriticalDelayMs = {
                    description = "Retardez en millisecondes avant qu'un moteur cassé ne s'enflamme.",
                    label = "Délai critique du moteur ms",
                },
                firejobVehicleFiresCriticalEnabled = {
                    description = "Autoriser les moteurs gravement endommagés à déclencher un incendie de véhicule Firejob après un retard.",
                    label = "Moteurs à allumage commandé",
                },
                firejobVehicleFiresCriticalSmokeDensity = {
                    description = "Densité de fumée utilisée pour les demandes d'incendie de moteur cassé.",
                    label = "Densité critique de fumée du moteur",
                },
                firejobVehicleFiresEnabled = {
                    description = "Autoriser les systèmes de dommages à l'emploi de mécaniciens à demander des feux de véhicules à Firejob.",
                    label = "Activer les incendies de véhicules",
                },
                firejobVehicleFiresForwardMotionRatio = {
                    description = "Taux de déplacement vers l'avant requis de 0 à 1.",
                    label = "Rapport de mouvement vers l'avant",
                },
                firejobVehicleFiresImpactChance = {
                    description = "Il est possible, de 0 à 1, qu'un impact admissible déclenche un incendie.",
                    label = "Risque d ' incendie",
                },
                firejobVehicleFiresImpactCooldownSeconds = {
                    description = "Les secondes avant qu'un autre feu d'impact ne déclenche.",
                    label = "Refroidissement de l'incendie par impact",
                },
                firejobVehicleFiresImpactEnabled = {
                    description = "Autoriser de forts accidents frontaux à demander un incendie de véhicule Firejob.",
                    label = "Allumer après des accidents graves",
                },
                firejobVehicleFiresImpactSmokeDensity = {
                    description = "Densité de fumée utilisée pour les demandes d'incendie déclenchées par un accident.",
                    label = "Densité des fumées à impact",
                },
                firejobVehicleFiresIntegrationMode = {
                    description = "Automatique utilise la ressource Firejob configurée; Handicapé empêche Mechanicjob de créer des incendies.",
                    label = "Mode d'intégration",
                    options = {
                        automatic = "Automatique",
                        disabled = "Désactivé",
                    },
                },
                firejobVehicleFiresMinBodyHealthLoss = {
                    description = "Santé corporelle minimale perdue pendant l'impact.",
                    label = "Dommages corporels minimaux",
                },
                firejobVehicleFiresMinEngineHealthLoss = {
                    description = "La santé minimale du moteur a été perdue pendant l'impact.",
                    label = "Endommagement minimal du moteur",
                },
                firejobVehicleFiresMinFrontDeformation = {
                    description = "Utilisez 0 pour désactiver ce contrôle de déformation.",
                    label = "Déformation avant minimale",
                },
                firejobVehicleFiresMinImpactSpeedKmh = {
                    description = "Vitesse minimale avant impact en km/h.",
                    label = "Vitesse minimale d'impact",
                },
                firejobVehicleFiresMinSpeedDropKmh = {
                    description = "Perte de vitesse requise en km/h pendant l'impact.",
                    label = "Perte de vitesse minimale",
                },
                firejobVehicleFiresResource = {
                    description = "Ressources qui reçoivent les demandes d'incendie de véhicules.",
                    label = "Ressources en matière d ' emploi du feu",
                },
                firejobVehicleFiresServerEvent = {
                    description = "Événement serveur interne utilisé par le client mécanicien pour demander un incendie de véhicule Firejob.",
                    label = "Événement du serveur mécanique",
                },
                freeVehicles = {
                    description = "Modèles de géniteurs de véhicules qui reçoivent des ordres d'accord gratuits.",
                    itemLabel = "Modèle du véhicule",
                    label = "Véhicules à réglage libre",
                },
                handlingEditorBlockCriticalValidation = {
                    description = "Prévenir Appliquer pendant qu'un conflit de manipulation critique existe.",
                    label = "Bloquer les constatations critiques",
                },
                handlingEditorCoachMinimumBrakeDeceleration = {
                    description = "La décélération maximale attendue en m/s2 pour un essai de freinage complet.",
                    label = "décélération minimale du frein",
                },
                handlingEditorCoachMinimumSamples = {
                    description = "Échantillons mesurés requis avant que Telemetry Coach n'évalue un parcours.",
                    label = "Échantillons minimaux",
                },
                handlingEditorCoachWheelSlipWarningKmh = {
                    description = "Vitesse mesurée de glissement des roues en km/h à laquelle une perte de traction est signalée.",
                    label = "Avertissement de glissement de roue",
                },
                handlingEditorDefaultTab = {
                    description = "Page sélectionnée chaque fois que l'éditeur de manipulation autonome s'ouvre.",
                    label = "Page de démarrage",
                    options = {
                        advanced = "Avancé",
                        export = "Exporter",
                        flags = "Drapeaux",
                        fleet = "Flotte",
                        inspector = "Calque",
                        profiles = "Profils",
                        simple = "Simple",
                        telemetry = "Télémétrie",
                    },
                },
                handlingEditorFieldDocumentationEnabled = {
                    description = "Fournir l'effet, la plage de référence, les symptômes, les domaines connexes et le soutien en direct pour chaque valeur de manipulation.",
                    label = "Documentation sur le terrain",
                },
                handlingEditorFlagSearchEnabled = {
                    description = "Rechercher et filtrer les noms de drapeau, les effets, les positions de bits et les masques hexadécimaux.",
                    label = "Recherche d'un drapeau",
                },
                handlingEditorFleetManagerEnabled = {
                    description = "Rechercher, inspecter, promouvoir et restaurer les règles de manipulation des modèles et des plaques.",
                    label = "Gestionnaire de flotte",
                },
                handlingEditorLayerInspectorEnabled = {
                    description = "Affichez la base du véhicule, le réglage personnalisé installé, la règle du modèle, la règle de la plaque et l'ébauche de l'éditeur courant pour chaque champ.",
                    label = "Inspecteur des couches",
                },
                handlingEditorMaxFleetResults = {
                    description = "Règles maximales de modèle et de plaque chargées dans Fleet Manager.",
                    label = "Limite de résultat de la flotte",
                },
                handlingEditorMaxProfileRevisions = {
                    description = "Nombre maximal de révisions retenues pour chaque profil.",
                    label = "Révisions du profil",
                },
                handlingEditorMaxWorkspacesPerAdmin = {
                    description = "Espaces de travail maximums nommés conservés pour chaque administrateur.",
                    label = "Espaces de travail personnels",
                },
                handlingEditorProfileVersioningEnabled = {
                    description = "Créer une révision vérifiable chaque fois qu'un profil partagé est mis à jour ou restauré.",
                    label = "Mise en forme du profil",
                },
                handlingEditorTelemetryCoachEnabled = {
                    description = "Créer des recommandations transparentes fondées sur des règles à partir de données mesurées d'essai routier.",
                    label = "Entraîneur de télémétrie",
                },
                handlingEditorValidatorEnabled = {
                    description = "Détecter les combinaisons dangereuses ou contradictoires avant d'appliquer la manipulation.",
                    label = "Gestion du validateur",
                },
                handlingEditorWorkspacesEnabled = {
                    description = "Permettre aux administrateurs de conserver les ébauches d'éditeurs privés nommés.",
                    label = "Espaces de travail personnels",
                },
                instantTuningAllowedJobs = {
                    description = "Liste d'autorisations globale optionnelle. Laisser vide pour permettre à tout le monde sauf si le mécanicien seul est activé.",
                    itemLabel = "Nom du métier",
                    label = "Métiers autorisés",
                },
                instantTuningBlipColor = {
                    description = "GTA blip couleur id.",
                    label = "Couleur du blip",
                },
                instantTuningBlipEnabled = {
                    description = "Afficher les blips de la carte pour les emplacements de réglage instantané.",
                    label = "Blip activé",
                },
                instantTuningBlipName = {
                    description = "Le nom du blip de carte.",
                    label = "Nom du blip",
                },
                instantTuningBlipSprite = {
                    description = "ID de l’icône du repère sur la carte GTA.",
                    label = "Sprite du blip",
                },
                instantTuningForceMarkerInteraction = {
                    description = "Utiliser l'interaction de type marqueur E même lorsque le support de la cible est activé.",
                    label = "Forcer l'interaction par marqueur",
                },
                instantTuningInteractionDistance = {
                    description = "Distance par défaut pour l'utilisation de points de réglage instantané.",
                    label = "Distance d'interaction",
                },
                instantTuningLabel = {
                    description = "Texte par défaut affiché aux points de réglage instantané.",
                    label = "Étiquette par défaut",
                },
                instantTuningLocations = {
                    description = "Points de réglage instantané. Utilisez la distance 0 pour hériter de la distance d'interaction par défaut.",
                    itemLabel = "Emplacements",
                    label = "Emplacements",
                },
                instantTuningMarkerEnabled = {
                    description = "Dessinez un marqueur mondial à l'emplacement des réglages instantanés.",
                    label = "Marqueur activé",
                },
                instantTuningMarkerType = {
                    description = "GTA type de marqueur utilisé pour les emplacements de réglage instantané.",
                    label = "Type de marqueur",
                },
                instantTuningMechanicOnly = {
                    description = "Restreindre tous les emplacements de réglage instantané aux professions mécaniques configurées.",
                    label = "Mécanicien seulement",
                },
                instantTuningPriceMultiplier = {
                    description = "Multiplieur appliqué aux prix de réglage instantané.",
                    label = "Multiplicateur de prix",
                },
                instantTuningProfile = {
                    description = "Configurer les options de réglage disponibles aux points de réglage instantané.",
                    label = "Options de réglage instantané",
                },
                maintenanceNotificationsCooldownMinutes = {
                    description = "Minimum minutes avant que le même véhicule puisse déclencher un autre rappel d'entretien.",
                    label = "Refroidissement de la notification",
                },
                maintenanceNotificationsEnabled = {
                    description = "Prévenez les propriétaires de véhicules lorsqu'une pièce d'usure atteint le seuil d'entretien.",
                    label = "Activé",
                },
                maintenanceNotificationsThreshold = {
                    description = "Pourcentage d'usure au-dessous duquel l'entretien est considéré comme dû.",
                    label = "Seuil d'échéance",
                },
                mileageHudDigits = {
                    description = "Nombre de chiffres indiqués au point milliaire HUD.",
                    label = "Chiffres",
                },
                mileageHudPosition = {
                    description = "Faites glisser l'aperçu du kilométrage HUD vers la position souhaitée de l'écran.",
                    label = "Poste",
                },
                oilLeaksCooldownSeconds = {
                    description = "Les secondes avant qu'une autre fuite d'impact ne se déclenche.",
                    label = "Refroidissement par impact",
                },
                oilLeaksEnabled = {
                    description = "Autoriser les véhicules à combustion endommagés à laisser du liquide derrière eux pendant la conduite.",
                    label = "Activer les fuites de liquide",
                },
                oilLeaksEngineOilChance = {
                    description = "Risque normal de fuite de 0 à 1.",
                    label = "Risque d'huile du moteur",
                },
                oilLeaksEngineOilCriticalChance = {
                    description = "Risque de fuite critique de 0 à 1.",
                    label = "Risque critique d'huile moteur",
                },
                oilLeaksEngineOilCriticalThreshold = {
                    description = "État de l'huile moteur à ou au-dessous duquel le risque critique est utilisé.",
                    label = "Seuil critique d'huile moteur",
                },
                oilLeaksEngineOilThreshold = {
                    description = "État de l'huile moteur à ou au-dessous duquel une fuite peut démarrer.",
                    label = "Seuil d'huile moteur",
                },
                oilLeaksForwardMotionRatio = {
                    description = "Taux de déplacement vers l'avant requis de 0 à 1.",
                    label = "Rapport de mouvement vers l'avant",
                },
                oilLeaksFrontalImpactEnabled = {
                    description = "Permettre aux chocs frontaux graves de déclencher une fuite temporaire de liquide moteur.",
                    label = "Fuites d ' impact frontal",
                },
                oilLeaksImpactChance = {
                    description = "De 0 à 1, il est probable qu'un impact admissible déclenche une fuite.",
                    label = "Risque de fuite d'impact",
                },
                oilLeaksImpactRadius = {
                    description = "Rayon du point initial du fluide créé par un impact.",
                    label = "Rayon de déversement d'impact",
                },
                oilLeaksIntervalSeconds = {
                    description = "Minimum de secondes entre les points de piste.",
                    label = "Intervalle de piste",
                },
                oilLeaksLeakDurationSeconds = {
                    description = "Deuxièmement, une fuite se poursuit après un impact admissible.",
                    label = "Durée de la fuite d ' impact",
                },
                oilLeaksMinBodyHealthLoss = {
                    description = "Santé corporelle minimale perdue pendant l'impact.",
                    label = "Dommages corporels minimaux",
                },
                oilLeaksMinDistance = {
                    description = "Distance minimale parcourue entre les points de piste.",
                    label = "Distance de la piste",
                },
                oilLeaksMinEngineHealthLoss = {
                    description = "La santé minimale du moteur a été perdue pendant l'impact.",
                    label = "Endommagement minimal du moteur",
                },
                oilLeaksMinFrontDeformation = {
                    description = "Déformation frontale requise. Utilisez 0 pour désactiver cette vérification.",
                    label = "Déformation avant minimale",
                },
                oilLeaksMinImpactSpeedKmh = {
                    description = "Vitesse minimale avant impact en km/h.",
                    label = "Vitesse minimale d'impact",
                },
                oilLeaksMinSpeedDropKmh = {
                    description = "Perte de vitesse requise en km/h pendant l'impact.",
                    label = "Perte de vitesse minimale",
                },
                oilLeaksMinSpeedKmh = {
                    description = "Vitesse minimale du véhicule en km/h avant qu'une fuite de liquide puisse créer un sentier.",
                    label = "Régime minimal",
                },
                oilLeaksRadius = {
                    description = "Rayon des points de circulation réguliers des véhicules.",
                    label = "Rayon de piste",
                },
                oilLeaksTransmissionFluidChance = {
                    description = "Risque normal de fuite de 0 à 1.",
                    label = "Potentiel du fluide de transmission",
                },
                oilLeaksTransmissionFluidCriticalChance = {
                    description = "Risque de fuite critique de 0 à 1.",
                    label = "Risque de transmission critique",
                },
                oilLeaksTransmissionFluidCriticalThreshold = {
                    description = "État du fluide de transmission à ou au-dessous duquel le risque critique est utilisé.",
                    label = "Seuil critique de transmission",
                },
                oilLeaksTransmissionFluidThreshold = {
                    description = "État du fluide de transmission à ou au-dessous duquel une fuite peut commencer.",
                    label = "Seuil du fluide de transmission",
                },
                orderInstallLiftBypassVehicleClasses = {
                    description = "Classes de véhicules qui peuvent effectuer des travaux de commande dépendant de l'ascenseur sans ascenseur d'atelier.",
                    itemLabel = "Ajouter une classe de véhicule",
                    label = "Classes de véhicules de contournement des ascenseurs",
                    options = {
                        ["0"] = "Compacts",
                        ["1"] = "Sedans",
                        ["10"] = "Industriel",
                        ["11"] = "Utilité",
                        ["12"] = "Voitures",
                        ["13"] = "Cycles",
                        ["14"] = "Bateaux",
                        ["15"] = "Helicoptères",
                        ["16"] = "Avions",
                        ["17"] = "Entretien",
                        ["18"] = "Urgence",
                        ["19"] = "Militaires",
                        ["2"] = "VUS",
                        ["20"] = "Commerce",
                        ["21"] = "Trains",
                        ["22"] = "Ouvrir la roue",
                        ["3"] = "Coupes",
                        ["4"] = "Muscle",
                        ["5"] = "Classiques de sport",
                        ["6"] = "Sports",
                        ["7"] = "Super",
                        ["8"] = "Motocycles",
                        ["9"] = "Tout-terrain",
                    },
                },
                orderInstallLiftBypassVehicleModels = {
                    description = "Modèles de géniteurs de véhicules qui peuvent terminer des travaux de commande dépendant de l'ascenseur sans ascenseur d'atelier.",
                    itemLabel = "Modèle du véhicule",
                    label = "Modèles de véhicules de contournement de levage",
                },
                orderInstallNonMinigameDurationMs = {
                    description = "Millisecondes utilisées pour l'installation d'étapes de commande qui n'exécutent pas un mini-jeu.",
                    label = "Durée d'installation simple",
                },
                orderInstallNonMinigameVehicleClasses = {
                    description = "Identificateurs de classe de véhicule qui utilisent toujours l'installation mécanique normale sans ascenseur spécialisé ou flux mini-jeux.",
                    label = "Classes de véhicules non-minigames",
                },
                orderInstallNonMinigameVehicleModels = {
                    description = "Modèles de géniteurs de véhicules qui utilisent toujours l'installation mécanique normale sans ascenseur spécialisé ou des flux mini-jeux.",
                    label = "Modèles de véhicules non-minigames",
                },
                partsDeliveryCompanyCard = {
                    description = "Permettre aux commandes de livraison de pièces d'utiliser les fonds de l'entreprise.",
                    label = "Paiement par carte d'entreprise",
                },
                partsDeliveryMode = {
                    description = "Conservez le flux de livraison physique standard ou ajoutez la livraison complète directement à l'inventaire du joueur collecteur.",
                    label = "Traitement de la livraison",
                    options = {
                        player_inventory = "Inventaire des joueurs",
                        standard = "Débit de livraison standard",
                    },
                },
                partsDeliveryOpenDurationMs = {
                    description = "Millisecondes nécessaires pour déballer une livraison de pièces prêtes.",
                    label = "Durée ouverte",
                },
                partsDeliveryOwnCard = {
                    description = "Permettre aux joueurs de payer des commandes de livraison de pièces avec leur propre argent.",
                    label = "Paiement par carte",
                },
                partsDeliveryTimeSeconds = {
                    description = "Secondes entre la commande de pièces et la livraison de se préparer.",
                    label = "Délai de livraison",
                },
                partsTheftCatalyticConverterItem = {
                    description = "Élément d'inventaire attribué lorsqu'un convertisseur catalytique est volé.",
                    label = "Élément de convertisseur catalytique",
                },
                partsTheftDealerAccount = {
                    description = "Compte utilisé pour les paiements de revendeur de pièces volées, comme l'argent ou la banque.",
                    label = "Compte de paiement des concessionnaires",
                },
                partsTheftDealerItems = {
                    description = "Articles volés le concessionnaire va acheter et leurs valeurs de paiement.",
                    itemLabel = "Produit du concessionnaire",
                    label = "Marchandises",
                },
                partsTheftDealerPayoutItem = {
                    description = "Article d'inventaire donné lorsque le type de paiement du concessionnaire est article. Le prix de vente est utilisé comme montant de l'article.",
                    label = "Produit de paiement du concessionnaire",
                },
                partsTheftDealerPayoutType = {
                    description = "Choisissez si le concessionnaire paie dans un compte-cadre ou donne un élément d'inventaire.",
                    label = "Type de paiement du concessionnaire",
                    options = {
                        account = "Compte",
                        item = "Objet",
                    },
                },
                partsTheftDealerSellDistance = {
                    description = "Distance maximale du concessionnaire pour vendre des pièces volées.",
                    label = "Distance de vente du concessionnaire",
                },
                partsTheftDispatchCooldownSeconds = {
                    description = "Les secondes avant la même partie du véhicule peuvent créer une autre expédition.",
                    label = "Délai du dispatch",
                },
                partsTheftDispatchEnabled = {
                    description = "Créer une dépêche de police lorsqu'une roue ou un convertisseur catalytique est volé.",
                    label = "Envoi de la police",
                },
                partsTheftDispatchJobs = {
                    description = "les noms de profession qui reçoivent des envois de pièces volées.",
                    itemLabel = "Nom du métier",
                    label = "Emplois de la patrouille",
                },
                partsTheftDispatchMessage = {
                    description = "Message affiché sur l'alerte d'expédition. Supporte {plate}, {part} et {type}.",
                    label = "Message d'expédition",
                },
                partsTheftDispatchTitle = {
                    description = "Titre figurant sur l'alerte d'expédition. Soutiens {plate}, {part}, {type}.",
                    label = "Titre de l'expédition",
                },
                partsTheftItem = {
                    description = "Article d'inventaire utilisé pour voler des roues et des convertisseurs catalytiques.",
                    label = "Élément de l'outil de vol",
                },
                partsTheftRemoveItemAfterUse = {
                    description = "Supprimer l'élément de l'outil de vol après une action de vol réussie.",
                    label = "Consommer l'outil de vol",
                },
                partsTheftStolenWheelItem = {
                    description = "Article d'inventaire attribué lorsque les roues sont volées.",
                    label = "Pièce de roue volée",
                },
                priceType = {
                    description = "Pourcentage calcule les coûts à partir du prix du véhicule. Fixe utilise des valeurs monétaires. La classe de véhicule utilise le tableau de prix de classe.",
                    label = "Type de prix",
                    options = {
                        class = "Classe de véhicule",
                        fixed = "Fixé",
                        percentage = "Pourcentage",
                    },
                },
                primaryColor = {
                    description = "Couleur par défaut pour le groupe de la profession de mécanicien et les nouvelles professions. Utilisez une valeur hexagonale telle que #EDC001.",
                    label = "Couleur primaire",
                },
                publicUsersSeePrices = {
                    description = "Lorsque cela est possible, les clients publics paient pendant la commande. Désactivez cette option pour créer des commandes impayées pour la facturation mécanique.",
                    label = "Charger les ordres publics de libre-service",
                },
                subscriptionsAllowJobSubscriptions = {
                    description = "Permettre aux patrons autorisés d'acheter un abonnement pour l'ensemble de leur profession en utilisant les fonds de l'entreprise.",
                    label = "Abonnements aux entreprises",
                },
                subscriptionsCurrency = {
                    description = "sky_base currency used to purchase subscriptions, for example bank.",
                    label = "Monnaie de paiement",
                },
                subscriptionsEnabled = {
                    description = "Activer les abonnements à l'atelier, les terminaux clients et les rabais d'abonnement.",
                    label = "Activé",
                },
                subscriptionsMaximumDurations = {
                    description = "Durée et prix maximums par modèle d'abonnement.",
                    label = "Durées maximales",
                },
                subscriptionsMaximumModels = {
                    description = "Modèles d'abonnement maximum qu'un atelier peut configurer dans la tablette.",
                    label = "Modèles maximums",
                },
                subscriptionsNpcEmoteClip = {
                    description = "Clip d'animation en boucle en option utilisé lorsque le scénario est vide.",
                    label = "NPC clip d'émote",
                },
                subscriptionsNpcEmoteDict = {
                    description = "Dictionnaire d'animation optionnel utilisé lorsque le scénario est vide.",
                    label = "NPC dictionnaire d'émote",
                },
                subscriptionsNpcPedModel = {
                    description = "Le modèle Ped a été créé aux terminaux d'abonnement, par exemple s_m_m_autoshop_01.",
                    label = "Modèle de PNJ par défaut",
                },
                subscriptionsNpcScenario = {
                    description = "Optionnel GTA scénario tel que WORLD_HUMAN_CLIPBOARD. Laisser vide pour utiliser l'animation d'émote.",
                    label = "Scénario NPC",
                },
                tuningBlockedPlates = {
                    description = "Les véhicules munis de l'une de ces plaques ne peuvent pas être ajustés, installés ou ont enlevé le réglage.",
                    itemLabel = "Plaque",
                    label = "Plaques d'accord bloquées",
                },
                tuningWorkshopDistance = {
                    description = "Distance maximale d'un point de réglage en libre-service pour les actions d'installation ou de suppression requises.",
                    label = "Distance requise pour l'atelier",
                },
                tuningWorkshopRequireForInstall = {
                    description = "Exiger que l'ordre de réglage s'installe pour démarrer et terminer près d'un point de réglage en libre-service.",
                    label = "Nécessite un atelier pour les installations",
                },
                tuningWorkshopRequireForRemoval = {
                    description = "Exiger des retraits de réglage pour commencer et terminer près d'un point de réglage en libre-service.",
                    label = "Besoin d'un atelier pour les enlèvements",
                },
                vehicleCareRepairDurationMs = {
                    description = "Réparer la durée de progression en millisecondes.",
                    label = "Durée de réparation",
                },
                vehicleCareRepairFixRealisticWheelDamage = {
                    description = "Réinitialisez également les dommages de roues réalistes lors de l'utilisation de l'action de réparation.",
                    label = "Fixer des dommages réalistes aux roues",
                },
                vehicleCareRepairItem = {
                    description = "Poste d'inventaire utilisé par l'action de réparation du véhicule.",
                    label = "Objet de réparation",
                },
                vehicleCareRepairMaxDistance = {
                    description = "Distance maximale par rapport au véhicule pendant la réparation.",
                    label = "Réparer la distance maximale",
                },
                vehicleCareRepairRemoveAfterUse = {
                    description = "Supprimer l'élément de réparation après utilisation.",
                    label = "Consommer l'élément de réparation",
                },
                vehicleCareRepairVehicleDamage = {
                    description = "Réparation normale GTA dommages au véhicule lors de l'utilisation de l'action de réparation.",
                    label = "Régler les dommages causés aux véhicules",
                },
                vehicleCareRepairWearParts = {
                    description = "Choisissez les pièces d'usure et de service que l'élément de réparation restaure. Désactiver les fluides ici si l'huile, le liquide de refroidissement, le fluide de frein ou le fluide de transmission doivent nécessiter le débit de réparation diagnostique.",
                    itemLabel = "Porter une partie",
                    label = "Kit de réparation pièces restaurées",
                },
                vehicleCareWashItem = {
                    description = "Élément d'inventaire utilisé pour laver un véhicule.",
                    label = "Laver l'article",
                },
                vehicleCareWashRemoveAfterUse = {
                    description = "Retirez l'élément de lavage après utilisation.",
                    label = "Produit de lavage consumé",
                },
                vehicleCareWaxCleanKilometers = {
                    description = "Distance un véhicule ciré reste propre.",
                    label = "Kilomètres propres à la cire",
                },
                vehicleCareWaxItem = {
                    description = "Élément d'inventaire utilisé pour cirer un véhicule.",
                    label = "Produit de cire",
                },
                vehicleCareWaxRemoveAfterUse = {
                    description = "Retirez l'article de cire après utilisation.",
                    label = "Produit de la cire de consume",
                },
                vehicleClassPricing = {
                    description = "Surpasser le type de prix et le multiplicateur de coût pour chaque classe de véhicule GTA.",
                    label = "Prix par classe de véhicule",
                },
                wearParts = {
                    description = "Les pièces d'usure du véhicule, leur distance de vie, l'article de réparation requis, la consommation d'article, et installer le débit.",
                    fields = {
                        flow = {
                            options = {
                                catalytic_converter = "Convertisseur catalytique",
                                fluid_refill = "Remplissage des fluides",
                                hood_install = "Installation du capot",
                                oil_change = "Changement de pétrole",
                                performance = "Performances",
                                underbody_neon = "Sous-corps / ascenseur",
                                wheel = "Roue",
                            },
                        },
                    },
                    itemLabel = "Porter une partie",
                    label = "Pièces d'usure",
                },
                wheelDamageDefaultMultiplier = {
                    description = "Multiplicateur d'endommagement des roues de base.",
                    label = "multiplicateur par défaut",
                },
                wheelDamageDeformationAngleThreshold = {
                    description = "Les points de la sonde de déformation des filtres ne renvoient pas à la carrosserie du véhicule.",
                    label = "Seuil d'angle des sondes",
                },
                wheelDamageDeformationDamageIncrement = {
                    description = "Une force supplémentaire a ajouté chaque itération de restauration.",
                    label = "Augmentation des dommages dus à la déformation",
                },
                wheelDamageDeformationEnabled = {
                    description = "Capturer et restaurer les bosselures du corps lors de la reconstruction de la géométrie de réparation des pneus.",
                    label = "Restaurer la déformation",
                },
                wheelDamageDeformationInitialDamage = {
                    description = "Force de départ utilisée lors de la restauration des bosselures.",
                    label = "Dommages à la déformation initiale",
                },
                wheelDamageDeformationMaxIterations = {
                    description = "Maximum SetVehicleDamage passes utilisés pour reconstruire les bosselures.",
                    label = "Déformation itérations",
                },
                wheelDamageDeformationThreshold = {
                    description = "Ampleur minimale de déformation détectée à stocker.",
                    label = "Seuil de déformation",
                },
                wheelDamageOffroadWheelsMultiplier = {
                    description = "Multiplicateur utilisé lorsque le véhicule a des roues hors route.",
                    label = "Multiplicateur de roue hors route",
                },
                wheelDamageRepairInstantDamageReapplyPasses = {
                    description = "Les dommages non-roues supplémentaires instantanés restaure passe après la géométrie de la roue est reconstruite.",
                    label = "Remise en cause des dommages",
                },
                wheelDamageRepairInstantWheelStateReapplyPasses = {
                    description = "Pass instantané supplémentaire pour les pneus qui manquent encore ou qui sont encore à plat après la réparation d'une roue.",
                    label = "Réapplication de l'état des roues",
                },
                wheelDamageRepairPreserveNonWheelDamage = {
                    description = "Garder la carrosserie, le moteur, les fenêtres, les portes, la saleté et les dommages visuels lorsque la réparation des pneus reconstruit la géométrie des roues.",
                    label = "Préserver les dommages causés aux véhicules",
                },
                wheelDamageRepairQuietWindowRemoval = {
                    description = "Restaurer les fenêtres cassées sans l'effet fort de casse lorsque c'est possible.",
                    label = "Fenêtres brisées silencieuses",
                },
                wheelDamageRepairSilentPoppedReapply = {
                    description = "Réappliquer les pneus à plat sans déclencher un nouveau bruit de pression ou d'effet.",
                    label = "Pneumatique plat silencieux à nouveau appliqué",
                },
                wheelDamageTyreRepairAttachDistance = {
                    description = "Distance maximale du pneumatique endommagé ou manquant pour l'action de montage.",
                    label = "Distance de fixation des pneumatiques",
                },
                wheelDamageTyreRepairCarJackRemoveDistance = {
                    description = "Distance maximale de la prise de voiture placée pour l'action de retrait.",
                    label = "jack de voiture supprimer la distance",
                },
                wheelDamageVehicleClassMultipliers = {
                    description = "Multiplicateurs de dommages par classe de véhicule GTA.",
                    itemLabel = "Classe de véhicule",
                    label = "Multiplicateurs de classe de véhicule",
                },
                vehicleCareRepairBlockForNonMechanicsWhenMechanicsOnDuty = {
                    label = "Bloquer les autres métiers si des mécaniciens sont en service",
                },
                allowsprint = {
                    label = "Autoriser le sprint avec les colis de livraison",
                },
            },
            tuningCategories = {
                bodywork = "Carrosserie",
                electronics = "ECU et électronique du véhicule",
                engineSounds = "Sons du moteur",
                handling = "Tenue de route",
                lights = "Éclairage",
                other = "Autres",
                paint = "Peinture",
                performance = "Performances",
                stance = "Posture",
                wheels = "Roues",
            },
            advancedPricingPreview = {
                compact = "Honda / Compact",
                customer = "Prix client",
                description = "Exemple de calcul cosmétique utilisant les règles actuelles.",
                labor = "Travail",
                live = "Aperçu en direct",
                margin = "Marge",
                sports = "Voiture de sport",
                super = "Supercar",
                supplier = "Fournisseur",
                title = "Aperçu du prix",
            },
            configs = {
                sky_mechanicjob = {
                    subtitle = "Configurez les jobs mecaniciens, boutiques, vehicules et emplacements d atelier.",
                    title = "Jobs mecaniciens",
                },
            },
            dispatchIconOptions = {
                crime = "Unité criminelle",
                emergency = "Unité d'urgence",
                ems = "Unité EMS",
                fire = "Unité de pompiers",
                heavy = "Unité lourde",
                k9 = "Unité K-9",
                medical = "Unité Médicale",
                patrol = "Patrouille",
                rescue = "Unité de sauvetage",
                service = "Unité de service",
                supervisor = "Superviseur",
                tactical = "Unité tactique",
            },
            fields = {
                quantity = "Quantité",
            },
            settingValues = {
                air_filter = "Filtre à air",
                brake_fluid = "Liquide de frein",
                brake_pads = "Plaquettes de frein",
                catalytic_converter = "Catalyseur",
                clutch = "Embrayage",
                coolant = "Liquide de refroidissement",
                engine_oil = "Huile moteur",
                inverter = "Onduleur de puissance",
                spark_plugs = "Bougies d’allumage",
                suspension = "Suspension",
                traction_battery = "Batterie de traction",
                transmission_fluid = "Liquide de transmission",
                tyres = "Pneus",
                vehicleClass_0 = "Compacts",
                vehicleClass_1 = "Sedans",
                vehicleClass_10 = "Industriel",
                vehicleClass_11 = "Utilité",
                vehicleClass_12 = "Voitures",
                vehicleClass_13 = "Cycles",
                vehicleClass_14 = "Bateaux",
                vehicleClass_15 = "Helicoptères",
                vehicleClass_16 = "Avions",
                vehicleClass_17 = "Entretien",
                vehicleClass_18 = "Urgence",
                vehicleClass_19 = "Militaires",
                vehicleClass_2 = "VUS",
                vehicleClass_20 = "Commerce",
                vehicleClass_21 = "Trains",
                vehicleClass_22 = "Ouvrir la roue",
                vehicleClass_3 = "Coupes",
                vehicleClass_4 = "Muscle",
                vehicleClass_5 = "Classiques de sport",
                vehicleClass_6 = "Sports",
                vehicleClass_7 = "Super",
                vehicleClass_8 = "Motocycles",
                vehicleClass_9 = "Tout-terrain",
            },
            trainingFieldDescriptions = {
                allowSelfEnrollment = "Permet aux employés de s'inscrire aux sessions de formation disponibles.",
                approvalRequired = "Maintient les auto-inscriptions en attente jusqu'à ce qu'un instructeur agréé les approuve.",
                defaultCapacity = "Nombre de sièges par défaut utilisés lors de la création d'une nouvelle session de formation.",
                enabled = "Rend l'application de formation disponible pour cette tâche.",
                requireOnDuty = "Nécessite que les employés soient en service avant d'ouvrir ou d'utiliser l'application de formation.",
                upcomingDays = "Nombre de jours futurs affichés dans le calendrier de l'application de formation.",
            },
            trainingFields = {
                allowSelfEnrollment = "Autoriser l'auto-inscription",
                approvalRequired = "Exiger l'approbation de l'inscription",
                defaultCapacity = "Capacité par défaut",
                enabled = "Activer la formation",
                requireOnDuty = "Exiger un devoir",
                upcomingDays = "Période à venir (jours)",
            },
            tuningOptions = {
                antilag_enabled = {
                    label = "antiLag",
                    values = {
                        [0] = "Désactivé",
                        [1] = "Standard GTA",
                        [2] = "Détonations route",
                        [3] = "Anti-Lag course",
                        [4] = "Anti-Lag rallye",
                    },
                },
                electronic_automatic_hazards = {
                    label = "Feux de détresse automatiques",
                    values = {
                        [0] = "Désactivé",
                        [1] = "Activé",
                    },
                },
                electronic_brake_lights = {
                    label = "Feux stop",
                    values = {
                        [0] = "Normale",
                        [1] = "Clignotement d’urgence",
                        [2] = "Désactivé",
                    },
                },
                electronic_engine_tune = {
                    label = "Logiciel moteur",
                    values = {
                        [0] = "D’origine",
                        [1] = "Étape 1",
                        [2] = "Étape 2",
                        [3] = "Étape 3",
                        [4] = "Étape 4",
                    },
                },
                electronic_headlight_brightness = {
                    label = "Luminosité des phares",
                    values = {
                        [0] = "25%",
                        [1] = "50%",
                        [2] = "75%",
                        [3] = "100%",
                        [4] = "125%",
                        [5] = "150%",
                    },
                },
                electronic_highbeams_on_horn = {
                    label = "Plein phares avec klaxon",
                    values = {
                        [0] = "Désactivé",
                        [1] = "Activé",
                    },
                },
                electronic_idle_rpm = {
                    label = "Régime de ralenti",
                    values = {
                        [0] = "D’origine",
                        [1] = "20%",
                        [2] = "30%",
                        [3] = "40%",
                        [4] = "50%",
                    },
                },
                electronic_interior_light = {
                    label = "Éclairage intérieur",
                    values = {
                        [0] = "Normale",
                        [1] = "Rouge",
                    },
                },
                electronic_mood_color = {
                    label = "Couleur de lumière d'humeur",
                    values = {
                        [0] = "Désactivé",
                        [1] = "Rouge",
                        [10] = "Citron vert",
                        [11] = "Turquoise",
                        [12] = "Indigo",
                        [13] = "Blanc",
                        [14] = "Blanc chaud",
                        [15] = "Blanc froid",
                        [16] = "Ambre",
                        [2] = "Bleu",
                        [3] = "Vert",
                        [4] = "Cyan",
                        [5] = "Magenta",
                        [6] = "Jaune",
                        [7] = "Orange",
                        [8] = "Violet",
                        [9] = "Rose",
                    },
                },
                electronic_mood_intensity = {
                    label = "Intensité d’ambiance",
                    values = {
                        [0] = "Faible",
                        [1] = "Normale",
                        [2] = "Fort",
                    },
                },
                electronic_radio_power = {
                    label = "Alimentation radio",
                    values = {
                        [0] = "Désactivé",
                        [1] = "Activé",
                    },
                },
                electronic_throttle_response = {
                    label = "Réponse de l’accélérateur",
                    values = {
                        [0] = "Plus d’adhérence",
                        [1] = "Agressif",
                    },
                },
                electronic_wheelie_tune = {
                    label = "Réglage wheelie",
                    values = {
                        [0] = "Désactivé",
                        [1] = "Doux",
                        [2] = "Intense",
                    },
                },
            },
            vehicleClassLabel = "Classe {id} ({name})",
        },
    },
}
