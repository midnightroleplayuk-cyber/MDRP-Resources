JobConfigLocales["sky_policejob:fr"] = {
    JobConfiguratorComingSoon = "Ce configurateur de job arrive bientôt.",
    JobConfiguratorNoPermission = "Vous n'avez pas la permission d'utiliser cette commande.",
    Nui = {
        workshopConfig = {
            configs = {
                sky_policejob = {
                    subtitle = "Configurer les commissariats, boutiques, props, véhicules, stations et paramètres des fonctionnalités principales.",
                    title = "Job Police",
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
                autoAlarm = "Attribue immédiatement les unités disponibles correspondantes lorsqu'un incident est créé.",
                available = "Les unités dans ce statut peuvent être suggérées et affectées à un nouvel incident.",
                averageResponseSpeedKmh = "Calcule l'estimation d'arrivée affichée à partir d'une distance en ligne droite.",
                callsign = "Indicatif radio unique affiché lorsque les joueurs équipent cette unité virtuelle.",
                centerEnabled = "Permet aux membres autorisés en service d'affecter du personnel à un centre de répartition.",
                channelId = "ID de canal radio pour PMA Voice, SaltyChat et YACA. Les identifiants numériques tels que 2 500 restent inchangés ; PMA Voice mappe les identifiants de texte à un numéro stable.",
                channelLabel = "Nom du canal lisible affiché aux répartiteurs et aux unités.",
                crewCapacity = "Nombre maximal de personnes pouvant armer l'unité. Utilisez 0 pour un équipage illimité.",
                defaultChannel = "Les répartiteurs rejoignent ce canal lorsqu'ils commencent leur quart de travail. Les unités rejoignent manuellement depuis l'onglet Radio. Sélectionnez Aucun pour utiliser la valeur par défaut du groupe de tâches.",
                emergencyAppEnabled = "Rend cette tâche sélectionnable en tant que service public dans l'application Téléphone d'urgence.",
                enabled = "Rend cette tâche disponible pour l'application Dispatch et les incidents inter-tâches.",
                icon = "Sélectionnez l'icône affichée pour cette catégorie d'unité dans l'application Dispatch.",
                incidentAssessmentEnabled = "Affiche les questions médicales et d'évaluation des dangers dans l'enregistrement complet des incidents.",
                jobs = "Noms de tâches supplémentaires qui reçoivent des incidents à l'aide de ce mot clé.",
                joinLocked = "Empêche d'autres personnes de rejoindre l'unité après son armement.",
                minimumCrew = "Nombre minimal de personnes dans les unités retenues pour ce plan de réponse.",
                noUnitFallback = "Sans centre ni unité dotée de personnel, envoie une notification Sky à tous les membres en service.",
                poiId = "Identifiant technique stable que les profils de centrale conservent même après le renommage du lieu.",
                radius = "Distance maximale en mètres à laquelle l'annonce de la station peut être entendue.",
                readyStatusCode = "État FMS appliqué lorsque la ressource devient disponible au départ.",
                requirements = "Demande de réponse sous forme de paires TYPE:COUNT, par exemple PATROL:2,CRIME:1.",
                resourceType = "Classe la ressource opérationnelle pour les filtres et la coordination de la centrale.",
                respondingStatusCode = "État FMS appliqué lorsque la ressource répond à une intervention.",
                shortLabel = "Libellé court facultatif affiché sur les six mémoires de canaux radio.",
                stationId = "Associe l'unité à une caserne configurée dans le profil de la centrale.",
                statusCode = "État FMS numérique affiché sur la radio portative.",
                statusLabel = "Signification de cet état FMS pour les répartiteurs et les unités.",
                unitId = "Identifiant technique stable qui conserve l'unité même si son indicatif change.",
                vehicleType = "Doit correspondre à un code de type de véhicule configuré dans la sous-section précédente.",
                vehicleTypeCode = "Code d'unité court utilisé dans les exigences d'intervention, par exemple PATROL, CRIME, EMS ou RESCUE.",
                vehicleTypeLabel = "Nom lisible de cette catégorie d'unité.",
            },
            dispatchFields = {
                address = "Adresse",
                autoAlarm = "Alarme automatique",
                available = "Disponible pour l'expédition\nIcône",
                averageResponseSpeedKmh = "Vitesse de réponse estimée (km/h)",
                callsign = "Indicatif",
                category = "Catégorie",
                centerEnabled = "Activer le centre de répartition",
                channelId = "ID de chaîne",
                code = "Code",
                crewCapacity = "Capacité de l'équipage",
                defaultChannel = "Canal radio par défaut",
                emergencyAppEnabled = "Afficher dans l'application d'urgence",
                enabled = "Activer l'envoi",
                icon = "Icône",
                incidentAssessmentEnabled = "Activer l'évaluation d'urgence",
                jobs = "Tâches cibles (séparées par des virgules)",
                joinLocked = "Verrouiller l'accès à l'équipage",
                keywordCode = "Code de mot clé",
                label = "Étiquette",
                minimumCrew = "Équipage minimum",
                name = "Nom",
                noUnitFallback = "Avertir le personnel de service sans unités",
                noneChannel = "Aucun / groupe par défaut",
                note = "Remarque",
                phone = "Téléphone",
                poiId = "ID stable du point d'intérêt",
                radius = "Rayon d'annonce",
                readyStatusCode = "Code d'état disponible",
                requirements = "Unités requises (par exemple PATROL:2,CRIME:1)",
                resourceType = "Type de ressource",
                respondingStatusCode = "Code d'état en intervention",
                shortLabel = "Libellé de mémoire radio",
                stationId = "ID de la caserne",
                type = "Type",
                unitId = "ID stable de l'unité",
                vehicleType = "Type d'unité de réponse",
                radioButton = "Bouton",
                radioButtonAction = "Bouton Action",
                radioButtonStatus = "FMS État",
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
            dispatchNavigation = {
                active = "Expédition active",
                description = "Configurer l'accueil d'urgence, la radio, les unités, les plans d'intervention, les emplacements et les données des journalistes pour cette tâche.",
                inactive = "Envoi désactivé",
                steps = {
                    accessText = "Activez la répartition et décidez si cette tâche peut occuper un centre de répartition.",
                    accessTitle = "Accès et prise d'urgence",
                    fleetText = "Configurez les canaux, les codes d'état FMS, les types de véhicules et les indicatifs d'appel.",
                    fleetTitle = "Radio et flotte",
                    responseText = "Terminez avec les mots-clés, les exigences de réponse et les POI.",
                    responseTitle = "Plans d'intervention",
                },
                summary = {
                    channels = "Chaînes radio",
                    plans = "Plans d'intervention",
                    reporters = "Requérants connus",
                    statuses = "FMS disponible",
                    units = "Unités virtuelles",
                },
                title = "Expédition",
                warnings = {
                    channels = "Aucune chaîne radio explicite n'existe ; le canal de secours du groupe de tâches sera utilisé.",
                    defaultChannel = "La chaîne par défaut sélectionnée n'existe plus.",
                    disabled = "La répartition est désactivée pour cette tâche.",
                    statuses = "Au moins un état FMS doit être disponible pour que les unités puissent déclencher une alarme.",
                },
            },
            extensionDescriptions = {
                dispatchChannels = "Définit les canaux radio auxquels les unités et les centres de répartition dotés de personnel peuvent se joindre.",
                dispatchKeywords = "Définit les mots-clés d'incident, le nombre de véhicules requis, les tâches participantes et les alarmes automatiques en option.",
                dispatchPois = "Stocke les stations et les emplacements communs pour les formulaires d'incident et les annonces de station basées sur la position.",
                dispatchReporters = "Gère les noms, numéros de rappel et notes de régulation propres à ce métier.",
                dispatchStatusCodes = "Configure les étiquettes d'état FMS et les statuts considérés comme disponibles pour les nouveaux incidents.",
                dispatchVehicleTypes = "Définit les catégories d'unités utilisées par les plans d'intervention, telles que Patrol, Crime Unit, EMS ou Rescue.",
                dispatchVehicles = "Définit des véhicules de répartition virtuels qui peuvent être dotés de n'importe où sans nécessiter de véhicule généré.",
                dispatchRadioButtons = "Définit l'action prédéfinie centrale pour chaque bouton de fonction physique.",
                dispatchRadioFmsKeys = "Attribuer l'état FMS aux touches de nombre physique. Le clavier effectue seulement FMS changements.",
            },
            extensions = {
                caseNumbering = {
                    label = "Numéros de dossier",
                    description = "Configure les numéros de dossier automatiques pour ce métier.",
                    fields = {
                        prefix = {
                            label = "Préfixe de dossier",
                            description = "Préfixe des nouveaux dossiers, par exemple LSPD ou LSCSD. Jusqu’à 16 caractères, convertis en majuscules ; vide utilise CASE. Les numéros existants et attribués manuellement sont conservés.",
                        },
                    },
                },
                dispatchReporters = "Requérants connus",
                invalidSelection = "Sélection invalide : {value}",
                trainingSettings = {
                    description = "Configurez l'accès à la formation, l'inscription, les approbations et la planification des cours pour cet emploi.",
                    label = "Paramètres d'entraînement",
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
                dispatchRadioButtons = "Boutons de fonction radio",
                dispatchRadioFmsKeys = "FMS Attribution des clés",
            },
            features = {
                billing = {
                    description = "Activer les flux de facturation policière.",
                    label = "Facturation",
                },
                devices = {
                    description = "Activer les dispositifs d'application de la loi déployables.",
                    label = "CCTV et radars de vitesse",
                },
                evidence = {
                    description = "Activer le stockage des preuves, les preuves de terrain et les flux du scanner.",
                    label = "Preuves",
                },
                impound = {
                    description = "Activer les flux de la fourrière.",
                    label = "Fourrière",
                },
                jail = {
                    description = "Activer l'assignation en prison et les activités des détenus.",
                    label = "Prison",
                },
                propPlacement = {
                    description = "Activer les props policiers configurables et les équipements de props des véhicules.",
                    label = "Placement de props",
                },
                radial = {
                    description = "Activer les actions radiales policières telles que la mise en fourrière et le sabot de roue.",
                    label = "Actions radiales",
                },
                restraints = {
                    description = "Activer les menottes, attaches zip, entraves de jambes et sacs de tête.",
                    label = "Contentions",
                },
                socialWork = {
                    description = "Activer l'assignation de travail social et les activités de tâches.",
                    label = "Travail social",
                },
                tablet = {
                    description = "Activer les applications de la tablette policière configurées par cette ressource.",
                    label = "Tablette policière",
                },
                tracking = {
                    description = "Activer les traceurs GPS et les bracelets électroniques.",
                    label = "Traçage",
                },
                vehicleRadar = {
                    description = "Activer le radar du véhicule de patrouille.",
                    label = "Radar véhicule",
                },
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
            settingFields = {
                gangMinimumGrade = "Rang minimum",
                gang = "Gang",
                component = "Composant",
                description = "Descriptif",
                fineAmount = "Montant de l'amende",
                itemName = "Nom de l'objet",
                length = "Longueur",
                max = "Max.",
                maxOverKmh = "Excès max",
                min = "Min.",
                minOverKmh = "Excès min",
                model = "Modèle de prop",
                propModel = "Modèle de prop",
                reason = "Raison",
                vehicleClass = "Classe",
            },
            settingGroups = {
                access = {
                    label = "Accès",
                },
                animation = {
                    label = "Animation",
                },
                ankleMonitor = {
                    label = "Bracelet électronique",
                },
                ankleMonitorAccess = {
                    label = "Accès au bracelet électronique",
                },
                ankleMonitorPlacement = {
                    label = "Pose du bracelet électronique",
                },
                ankleMonitorZone = {
                    label = "Zone du bracelet électronique",
                },
                ankleMonitorZoneVisual = {
                    label = "Visuels de la zone du bracelet électronique",
                },
                assignment = {
                    label = "Assignation",
                },
                blip = {
                    label = "Blip de la station",
                },
                carry = {
                    label = "Portage",
                },
                cctv = {
                    label = "CCTV",
                },
                cctvDurability = {
                    label = "Durabilité CCTV",
                },
                cctvMotionDetection = {
                    label = "Détection de mouvement",
                },
                cctvMotionDispatch = {
                    label = "Alerte de détection de mouvement",
                },
                cctvMotionTiming = {
                    label = "Temporisation de la détection",
                },
                cctvPlacement = {
                    label = "Placement CCTV",
                },
                cctvRepair = {
                    label = "Réparation CCTV",
                },
                cctvRepairAnimation = {
                    label = "Animation de réparation CCTV",
                },
                clamp = {
                    label = "Sabot de roue",
                },
                clampWeld = {
                    label = "Soudure du sabot",
                },
                cleanup = {
                    label = "Nettoyage",
                },
                collection = {
                    label = "Collecte",
                },
                controls = {
                    label = "Contrôles",
                },
                creator = {
                    label = "Créateur",
                },
                crimeSceneTape = {
                    label = "Ruban de scène de crime",
                },
                crimeSceneTapeAccess = {
                    label = "Accès au ruban",
                },
                crimeSceneTapeInventory = {
                    label = "Inventaire du ruban",
                },
                crimeSceneTapeLength = {
                    label = "Longueur du ruban",
                },
                crimeSceneTapePlacement = {
                    label = "Pose du ruban",
                },
                database = {
                    label = "Base de données",
                },
                delivery = {
                    label = "Livraison",
                },
                detection = {
                    label = "Détection",
                },
                dispatch = {
                    label = "Répartition",
                },
                display = {
                    label = "Affichage",
                },
                escape = {
                    label = "Évasion",
                },
                escort = {
                    label = "Escorte",
                },
                evidenceStorage = {
                    label = "Stockage des preuves",
                },
                fastLock = {
                    label = "Verrouillage rapide auto",
                },
                general = {
                    label = "Général",
                },
                gpsTracker = {
                    label = "Traceur GPS",
                },
                gpsTrackerAccess = {
                    label = "Accès au traceur GPS",
                },
                gpsTrackerPlacement = {
                    label = "Placement du traceur GPS",
                },
                gpsTrackerTiming = {
                    label = "Temporisation du traceur GPS",
                },
                gsr = {
                    label = "Résidus de tir",
                },
                handcuffs = {
                    label = "Menottes",
                },
                handsUp = {
                    label = "Mains en l'air",
                },
                header = {
                    label = "En-tête",
                },
                impound = {
                    label = "Fourrière",
                },
                imprisonment = {
                    label = "Emprisonnement",
                },
                jailCanteenGeneral = {
                    label = "Cantine de la prison",
                },
                jailCanteenPackage = {
                    label = "Colis de la cantine",
                },
                jailCarry = {
                    label = "Travail de portage",
                },
                jailCarryInspection = {
                    label = "Inspection du portage",
                },
                jailCleaning = {
                    label = "Travail de nettoyage",
                },
                jailCleaningIllegalFinds = {
                    label = "Découvertes illégales",
                },
                jailCleaningOutline = {
                    label = "Contour de nettoyage",
                },
                jailDoctor = {
                    label = "Médecin de la prison",
                },
                jailElectricalCodes = {
                    label = "Codes électriques",
                },
                jailElectricalGeneral = {
                    label = "Électricité de la prison",
                },
                jailElectricalPenalties = {
                    label = "Pénalités électriques",
                },
                jailElectricalRewards = {
                    label = "Récompenses électriques",
                },
                jailInmatesAlcoholic = {
                    label = "Détenu alcoolique",
                },
                jailInmatesCodeList = {
                    label = "Détenu informateur",
                },
                jailInmatesDrugDealer = {
                    label = "Détenu trafiquant de drogue",
                },
                jailInmatesWireCutter = {
                    label = "Détenu porteur d'outils",
                },
                jailJobs = {
                    label = "Travaux en prison",
                },
                jailOutfitFemale = {
                    label = "Tenue féminine",
                },
                jailOutfitMale = {
                    label = "Tenue masculine",
                },
                keybinds = {
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                    label = "Raccourcis",
                },
                keybindsHandcuff = {
                    label = "Raccourci menottage",
                },
                keybindsUnhandcuff = {
                    label = "Raccourci démenottage",
                },
                marker = {
                    label = "Marqueur",
                },
                markerColor = {
                    label = "Couleur du marqueur",
                },
                mugshotAnimation = {
                    label = "Animation de la photo",
                },
                mugshotBoard = {
                    label = "Panneau de la photo",
                },
                mugshotCameraCoords = {
                    label = "Position de la caméra",
                },
                mugshotCameraRotation = {
                    label = "Rotation de la caméra",
                },
                mugshotGeneral = {
                    label = "Photo d'identité judiciaire",
                },
                mugshotMetadata = {
                    label = "Métadonnées de la photo",
                },
                mugshotPosition = {
                    label = "Position de la photo",
                },
                mugshotTiming = {
                    label = "Temporisation de la photo",
                },
                officerDown = {
                    label = "Agent à terre",
                },
                outfit = {
                    label = "Tenue",
                },
                overlay = {
                    label = "Superposition de plaque",
                },
                payment = {
                    label = "Paiement",
                },
                paymentFlow = {
                    label = "Flux de paiement",
                },
                penalties = {
                    label = "Pénalités",
                },
                playerSearch = {
                    label = "Fouille de joueur",
                },
                playerSearchAnimation = {
                    label = "Animation de fouille",
                },
                props = {
                    label = "Objets props",
                },
                reasons = {
                    label = "Raisons",
                },
                release = {
                    label = "Restitution",
                },
                reports = {
                    label = "Rapports",
                },
                restore = {
                    label = "Restauration",
                },
                rules = {
                    label = "Règles",
                },
                scan = {
                    label = "Scanner",
                },
                scanner = {
                    label = "Scanner",
                },
                sentence = {
                    label = "Peine",
                },
                shotsFired = {
                    label = "Coups de feu tirés",
                },
                sound = {
                    label = "Son",
                },
                speedcam = {
                    label = "Radars de vitesse",
                },
                speedcamBilling = {
                    label = "Facturation du radar de vitesse",
                },
                speedcamDispatch = {
                    label = "Répartition du radar de vitesse",
                },
                speedcamDurability = {
                    label = "Durabilité du radar de vitesse",
                },
                speedcamPlacement = {
                    label = "Placement du radar de vitesse",
                },
                speedcamRepair = {
                    label = "Réparation du radar de vitesse",
                },
                speedcamRepairAnimation = {
                    label = "Animation de réparation du radar de vitesse",
                },
                speedcamTiming = {
                    label = "Temporisation du radar de vitesse",
                },
                speedcamVisual = {
                    label = "Visuels du radar de vitesse",
                },
                speedcams = {
                    label = "Radars de vitesse",
                },
                storage = {
                    label = "Stockage",
                },
                subscription = {
                    label = "Abonnement de l'application",
                },
                tackle = {
                    label = "Plaquage",
                },
                tasks = {
                    label = "Tâches",
                },
                theme = {
                    label = "Thème",
                },
                timing = {
                    label = "Temporisation",
                },
                vin = {
                    label = "Vérification du VIN",
                },
                warningUi = {
                    label = "Interface d'avertissement",
                },
                world = {
                    label = "Monde",
                },
                zipties = {
                    label = "Attaches zip",
                },
                ziptiesCutter = {
                    label = "Coupe-attaches zip",
                },
                speedcamAdvanced = {
                    label = "Caméra de vitesse avancée",
                },
            },
            settingSections = {
                radarGun = "Pistolet radar",
                billing = "Facturation",
                cctv = "CCTV",
                dispatch = "Répartition",
                equipment = "Équipement",
                evidence = "Preuves",
                fakePlates = "Fausses plaques",
                general = "Général",
                impound = "Fourrière",
                jail = "Prison",
                radar = "Radar véhicule",
                radial = "Actions radiales",
                restraints = "Contentions",
                socialWork = "Travail social",
                speedCamera = "Radar de vitesse",
                spikeStrips = "Herses",
                stations = "Gares",
                tablet = "Applications tablette",
                tracking = "Traçage",
            },
            settingSubsections = {
                app = "Application radar de vitesse",
                apps = "Applications",
                billing = "Facturation",
                canteen = "Cantine",
                dispatch = "Répartition",
                durability = "Durabilité",
                electrical = "Électricité",
                general = "Général",
                handcuffs = "Menottes et colliers de serrage",
                inmates = "Détenus",
                jobs = "Travaux en prison",
                keybinds = "Raccourcis",
                motionDetection = "Détection de mouvement",
                mugshot = "Photo d'identité",
                placement = "Placement",
                repair = "Réparation",
                timing = "Temporisation",
                visuals = "Visuels",
            },
            settings = {
                radarGunClearKey = { label = "Pistolet radar : Effacer la mesure" },
                radarGunToggleUiKey = { label = "Pistolet radar : Afficher/masquer" },
                radarGunNoTargetHoldMs = { label = "Durée de maintien de la cible (ms)" },
                radarGunMinimumReading = { label = "Vitesse minimale affichée" },
                radarGunSpeedSmoothing = { label = "Lissage de vitesse (0–1)" },
                radarGunBeamRadius = { label = "Rayon du faisceau (m)" },
                radarGunRefreshRateMs = { label = "Intervalle de mesure (ms)" },
                radarGunUseMph = { label = "Utiliser les MPH", description = "Affiche les mesures en miles par heure plutôt qu'en kilomètres par heure." },
                radarGunRange = { label = "Portée de mesure", description = "Distance maximale en mètres à laquelle le pistolet radar détecte les véhicules." },
                radarGunRequireOnDuty = { label = "Service requis", description = "Exige que les agents soient en service avant de mesurer les véhicules avec le pistolet radar." },
                radarGunAllowedJobs = { label = "Métiers ou groupes autorisés", description = "police inclut tous les métiers de police configurés ; les noms directs sont aussi acceptés. Une liste vide supprime les restrictions de métier.", itemLabel = "Métier ou groupe" },
                radarGunEnabled = { label = "Pistolet radar", description = "Active le pistolet radar portatif SKY SR-2." },
                speedCamProcessingMode = {
                    description = "Choisissez le prélèvement immédiat, le paiement dans le délai configuré ou un examen par un agent.",
                    label = "Mode de traitement",
                    options = {
                        instant = "Prélever immédiatement",
                        later = "Payer plus tard (par défaut)",
                        review = "Examen par un agent uniquement",
                    },
                },
                tabletRegistry = { label = "Registre", description = "Activer les registres RP personnalisés dans File Explorer. Les dossiers des citoyens et des véhicules restent accessibles séparément." },
                tabletFiles = { label = "Explorateur de fichiers", description = "Regroupe les dossiers de police dans l’explorateur de fichiers. Les documents du DOJ apparaissent uniquement lorsque le DOJ est actif." },
                ankleMonitorAnimDurationMs = {
                    description = "Millisecondes passées à appliquer un bracelet électronique.",
                    label = "Durée d'application",
                },
                ankleMonitorAnimScenario = {
                    description = "Scénario joué lors de l'application d'un bracelet électronique.",
                    label = "Scénario d'application",
                },
                ankleMonitorAttachBone = {
                    description = "Os du ped utilisé pour attacher le prop du bracelet électronique.",
                    label = "Os d'attache",
                },
                ankleMonitorConsumeOnPlace = {
                    description = "Retirer l'objet bracelet électronique après la pose.",
                    label = "Consommer le bracelet électronique",
                },
                ankleMonitorCutItem = {
                    description = "Objet d'inventaire utilisé pour retirer les bracelets électroniques.",
                    label = "Objet de coupe",
                },
                ankleMonitorEnabled = {
                    description = "Activer la pose du bracelet électronique.",
                    label = "Bracelet électronique",
                },
                ankleMonitorItem = {
                    description = "Objet d'inventaire utilisé pour poser des bracelets électroniques.",
                    label = "Objet bracelet électronique",
                },
                ankleMonitorMapUpdateIntervalMs = {
                    description = "Millisecondes entre les mises à jour de la carte du bracelet électronique.",
                    label = "Intervalle de mise à jour de la carte",
                },
                ankleMonitorPersistOnDisconnect = {
                    description = "Conserve les bracelets électroniques dans la base de données lorsque les joueurs surveillés se déconnectent afin de les restaurer après une reconnexion ou un redémarrage du serveur.",
                    label = "Conserver après déconnexion",
                },
                ankleMonitorPlaceDistance = {
                    description = "Distance maximale pour poser un bracelet électronique.",
                    label = "Distance de pose",
                },
                ankleMonitorPropModel = {
                    description = "Modèle de prop utilisé pour le visuel du bracelet électronique.",
                    label = "Modèle de prop",
                },
                ankleMonitorRequireOnDuty = {
                    description = "Exiger l'état de service avant d'utiliser des bracelets électroniques.",
                    label = "Bracelet nécessite le service",
                },
                ankleMonitorRequirePoliceJob = {
                    description = "Exiger que le joueur appartienne au groupe police avant d'utiliser des bracelets électroniques.",
                    label = "Bracelet nécessite le job policier",
                },
                ankleMonitorReturnOnRemove = {
                    description = "Restituer l'objet bracelet électronique lorsqu'il est retiré.",
                    label = "Restituer le bracelet au retrait",
                },
                ankleMonitorWarningSeconds = {
                    description = "Temps d'avertissement avant qu'une violation de zone du bracelet électronique ne soit envoyée en répartition.",
                    label = "Secondes d'avertissement de zone",
                },
                ankleMonitorZoneBeepIntervalMs = {
                    description = "Millisecondes entre les bips d'avertissement de zone du bracelet électronique.",
                    label = "Intervalle de bip de zone",
                },
                ankleMonitorZoneBeepSound = {
                    description = "Nom du son utilisé pour les avertissements de zone du bracelet électronique.",
                    label = "Son du bip",
                },
                ankleMonitorZoneBeepSoundSet = {
                    description = "Ensemble sonore utilisé pour les avertissements de zone du bracelet électronique.",
                    label = "Ensemble sonore du bip",
                },
                ankleMonitorZoneBlipAlpha = {
                    description = "Valeur d'opacité utilisée pour les blips de zone du bracelet électronique.",
                    label = "Opacité du blip",
                },
                ankleMonitorZoneBlipColorAllowed = {
                    description = "Couleur du blip utilisée lorsqu'une cible est à l'intérieur de la zone autorisée.",
                    label = "Couleur du blip autorisé",
                },
                ankleMonitorZoneBlipColorExcluded = {
                    description = "Couleur du blip utilisée lorsqu'une cible quitte la zone autorisée.",
                    label = "Couleur du blip exclu",
                },
                ankleMonitorZoneCheckIntervalMs = {
                    description = "Millisecondes entre les vérifications de zone du bracelet électronique.",
                    label = "Intervalle de vérification de zone",
                },
                ankleMonitorZoneDispatchCooldownSeconds = {
                    description = "Secondes avant qu'une autre répartition de zone du bracelet électronique puisse être envoyée.",
                    label = "Délai de répartition de zone",
                },
                ankleMonitorZoneEnabled = {
                    description = "Activer les vérifications de zone du bracelet électronique.",
                    label = "Zones du bracelet électronique",
                },
                ankleMonitorZoneLabelSprite = {
                    description = "Sprite de blip utilisé pour les marqueurs de zone du bracelet électronique.",
                    label = "Sprite de l'étiquette de zone",
                },
                ankleMonitorZoneOutlineRadius = {
                    description = "Rayon utilisé pour les contours de zone du bracelet électronique.",
                    label = "Rayon du contour",
                },
                ankleMonitorZoneOutlineStep = {
                    description = "Taille de pas utilisée pour les contours de zone du bracelet électronique.",
                    label = "Pas du contour",
                },
                billingAccount = {
                    description = "Compte de secours utilisé lorsqu'un job n'a pas de compte société configuré.",
                    label = "Compte société de secours",
                },
                billingCloseOnSuccess = {
                    description = "Fermer l'interface de facturation après l'émission d'une amende.",
                    label = "Fermer après succès",
                },
                billingCurrency = {
                    description = "Clé de devise utilisée pour la facturation. Laisser vide pour utiliser la devise par défaut.",
                    label = "Devise",
                },
                billingCustomReasons = {
                    description = "Autoriser des raisons de facturation personnalisées au lieu des seuls préréglages.",
                    label = "Raisons personnalisées",
                },
                billingDepositToSociety = {
                    description = "Déposer les revenus de facturation sur le compte société du job.",
                    label = "Dépôt vers la société",
                },
                billingMaxReasonLength = {
                    description = "Nombre maximum de caractères pour les raisons de facturation personnalisées.",
                    label = "Longueur de la raison",
                },
                billingMode = {
                    description = "Choisir si les amendes policières débitent instantanément, nécessitent la confirmation du citoyen, ou utilisent le système de facturation du framework.",
                    label = "Mode de facturation",
                    options = {
                        consent = "Payer ou refuser",
                        framework = "Facture du framework",
                        instant = "Débit instantané",
                    },
                },
                billingRange = {
                    description = "Distance maximale de la cible pour émettre des amendes policières.",
                    label = "Portée de facturation",
                },
                billingReasonPresets = {
                    description = "Raisons de facturation préréglées affichées dans l'interface de facturation.",
                    itemLabel = "Raison",
                    label = "Préréglages de raisons",
                },
                billingRefreshSeconds = {
                    description = "Intervalle de rafraîchissement de la cible pendant que l'interface de facturation est ouverte.",
                    label = "Secondes de rafraîchissement",
                },
                billingShowRecipientName = {
                    description = "Afficher le nom du citoyen sur les aperçus et reçus d'amende.",
                    label = "Afficher le nom du destinataire",
                },
                carryAllowCarrierInVehicle = {
                    description = "Autorise le porteur à entrer et conduire un véhicule sans déposer le joueur porté.",
                    label = "Autoriser le porteur en véhicule",
                },
                carryAllowConscious = {
                    description = "Autoriser le portage de cibles conscientes.",
                    label = "Porter des cibles conscientes",
                },
                carryAllowSprint = {
                    description = "Autoriser le sprint en portant un autre joueur.",
                    label = "Autoriser le sprint en portant",
                },
                carryEnabled = {
                    description = "Activer le portage de joueurs.",
                    label = "Portage",
                },
                carryMaxDistance = {
                    description = "Distance maximale pour commencer à porter un joueur.",
                    label = "Distance de portage",
                },
                carryRequireOnDuty = {
                    description = "Exiger l'état de service avant de commencer un portage.",
                    label = "Portage nécessite le service",
                },
                cctvDamageCooldownMs = {
                    description = "Millisecondes avant que des dégâts CCTV puissent à nouveau être appliqués.",
                    label = "Délai de dégâts",
                },
                cctvDamagePerHit = {
                    description = "Dégâts de durabilité appliqués aux caméras CCTV par coup.",
                    label = "Dégâts par coup",
                },
                cctvDefaultName = {
                    description = "Nom d'affichage par défaut pour les caméras CCTV déployées.",
                    label = "Nom par défaut CCTV",
                },
                cctvDefaultPitch = {
                    description = "Inclinaison de caméra par défaut pour le placement CCTV.",
                    label = "Inclinaison par défaut",
                },
                cctvDisassembleDistance = {
                    description = "Distance utilisée pour démonter les caméras CCTV.",
                    label = "Distance de démontage",
                },
                cctvEnabled = {
                    description = "Activer le placement et la diffusion des caméras CCTV.",
                    label = "Caméras CCTV",
                },
                cctvHealthDisplayDistance = {
                    description = "Distance à laquelle l'état de la CCTV est affiché.",
                    label = "Distance d'affichage de l'état",
                },
                cctvHealthDisplayDurationMs = {
                    description = "Millisecondes pendant lesquelles l'état de la CCTV reste visible.",
                    label = "Durée d'affichage de l'état",
                },
                cctvHealthTextOffset = {
                    description = "Décalage vertical utilisé pour le texte d'état de la CCTV.",
                    label = "Décalage du texte d'état",
                },
                cctvHeightStep = {
                    description = "Pas de hauteur utilisé lors du positionnement des caméras CCTV.",
                    label = "Pas de hauteur",
                },
                cctvItem = {
                    description = "Objet d'inventaire utilisé pour placer des caméras CCTV.",
                    label = "Objet CCTV",
                },
                cctvMaintenanceThreshold = {
                    description = "Seuil de durabilité où la maintenance CCTV est recommandée.",
                    label = "Seuil de maintenance",
                },
                cctvMaxDurability = {
                    description = "Durabilité maximale de la caméra CCTV.",
                    label = "Durabilité CCTV",
                },
                cctvMotionAlertCooldownSeconds = {
                    description = "Secondes avant qu'une caméra puisse créer un nouveau dispatch de mouvement.",
                    label = "Délai du dispatch",
                },
                cctvMotionCheckIntervalMs = {
                    description = "Millisecondes entre les analyses de mouvement côté client.",
                    label = "Intervalle d'analyse",
                },
                cctvMotionClientCooldownMs = {
                    description = "Millisecondes avant qu'un client puisse signaler à nouveau la même caméra.",
                    label = "Délai de signalement client",
                },
                cctvMotionDefaultCameraEnabled = {
                    description = "Active automatiquement les alertes de mouvement pour les nouvelles caméras CCTV.",
                    label = "Activer les nouvelles caméras par défaut",
                },
                cctvMotionDetectionEnabled = {
                    description = "Active les alertes de dispatch de détection de mouvement par caméra CCTV.",
                    label = "Alertes de mouvement",
                },
                cctvMotionDetectionRadius = {
                    description = "Distance maximale de détection des mouvements en mètres.",
                    label = "Rayon de détection",
                },
                cctvMotionFieldOfView = {
                    description = "Angle du cône de détection des mouvements en degrés.",
                    label = "Champ de vision",
                },
                cctvMotionJobs = {
                    description = "Noms de métiers ou groupes recevant les dispatches de mouvement CCTV.",
                    itemLabel = "Métier ou groupe",
                    label = "Métiers du dispatch",
                },
                cctvMotionMinimumSpeed = {
                    description = "Vitesse minimale d'une entité en mètres par seconde pour être considérée en mouvement.",
                    label = "Vitesse minimale de mouvement",
                },
                cctvMoveStep = {
                    description = "Pas de déplacement utilisé lors du positionnement des caméras CCTV.",
                    label = "Pas de déplacement",
                },
                cctvPropModel = {
                    description = "Modèle de prop utilisé pour les caméras CCTV déployées.",
                    label = "Modèle de prop CCTV",
                },
                cctvRepairAnimDict = {
                    description = "Dictionnaire d'animation utilisé lors de la réparation des caméras CCTV.",
                    label = "Dictionnaire d'animation de réparation",
                },
                cctvRepairAnimFlag = {
                    description = "Indicateur d'animation utilisé lors de la réparation des caméras CCTV.",
                    label = "Indicateur d'animation de réparation",
                },
                cctvRepairAnimName = {
                    description = "Nom de l'animation utilisée lors de la réparation des caméras CCTV.",
                    label = "Nom de l'animation de réparation",
                },
                cctvRepairCancelDelayMs = {
                    description = "Millisecondes avant que la réparation CCTV ne puisse être annulée.",
                    label = "Délai d'annulation de réparation",
                },
                cctvRepairDistance = {
                    description = "Distance utilisée pour réparer les caméras CCTV.",
                    label = "Distance de réparation",
                },
                cctvRepairItem = {
                    description = "Objet d'inventaire utilisé pour réparer les caméras CCTV.",
                    label = "Objet de réparation",
                },
                cctvRepairPerTick = {
                    description = "Durabilité restaurée par tic de réparation CCTV.",
                    label = "Réparation par tic",
                },
                cctvRepairTickMs = {
                    description = "Millisecondes entre les tics de réparation CCTV.",
                    label = "Intervalle de réparation",
                },
                cctvRotateStep = {
                    description = "Pas de rotation utilisé lors du positionnement des caméras CCTV.",
                    label = "Pas de rotation",
                },
                cctvStreamDistance = {
                    description = "Distance utilisée pour charger les caméras CCTV.",
                    label = "Distance de chargement",
                },
                cctvViewOffset = {
                    description = "Décalage de vue utilisé pour le rendu en direct de la caméra CCTV.",
                    label = "Décalage de vue",
                },
                crimeSceneTapeCollisionEnabled = {
                    description = "Crée une barrière de collision le long du ruban afin que les joueurs ne puissent pas le traverser.",
                    label = "Collision bloquante du ruban",
                },
                crimeSceneTapeConsumeItem = {
                    description = "Retirer un objet de ruban de l'inventaire après une pose réussie.",
                    label = "Consommer l'objet du ruban",
                },
                crimeSceneTapeDynamic = {
                    description = "Permettre au ruban de réagir à la physique et à la gravité au lieu de le figer sur place.",
                    label = "Physique dynamique",
                },
                crimeSceneTapeEnabled = {
                    description = "Autoriser la pose d'un ruban de scène de crime à partir d'un objet d'inventaire.",
                    label = "Ruban de scène de crime",
                },
                crimeSceneTapeEnforceRemovalAccess = {
                    description = "Seuls les métiers autorisés peuvent retirer le ruban et, si requis, leurs membres doivent être en service.",
                    label = "Restreindre le retrait",
                },
                crimeSceneTapeItem = {
                    description = "Nom de l'objet d'inventaire qui lance la pose du ruban de scène de crime.",
                    label = "Objet du ruban",
                },
                crimeSceneTapeJobs = {
                    description = "Noms des métiers autorisés à utiliser le ruban de scène de crime.",
                    itemLabel = "Métier",
                    label = "Métiers autorisés",
                },
                crimeSceneTapeLabel = {
                    description = "Nom affiché pour le ruban de scène de crime pendant sa pose.",
                    label = "Libellé du ruban",
                },
                crimeSceneTapeLengthStep = {
                    description = "Incrément en mètres auquel la longueur sélectionnée du ruban est arrondie.",
                    label = "Pas de longueur",
                },
                crimeSceneTapeMaxLength = {
                    description = "Distance maximale autorisée entre les deux poteaux du ruban, en mètres.",
                    label = "Longueur maximale du ruban",
                },
                crimeSceneTapeMaxPlacementDistance = {
                    description = "Distance maximale entre l’un des deux points d’extrémité et l’agent qui pose le ruban.",
                    label = "Distance maximale de pose",
                },
                crimeSceneTapeMinLength = {
                    description = "Distance minimale autorisée entre les deux poteaux du ruban, en mètres.",
                    label = "Longueur minimale du ruban",
                },
                crimeSceneTapeModel = {
                    description = "Nom du modèle de prop utilisé pour le ruban de scène de crime posé.",
                    label = "Modèle du ruban",
                },
                crimeSceneTapePostModel = {
                    description = "Modèle de prop utilisé pour les deux poteaux du ruban.",
                    label = "Modèle de poteau",
                },
                crimeSceneTapeRemoveDistance = {
                    description = "Distance maximale depuis laquelle le ruban de scène de crime posé peut être retiré.",
                    label = "Distance de retrait",
                },
                crimeSceneTapeRequireOnDuty = {
                    description = "Seuls les membres en service des métiers autorisés peuvent poser le ruban.",
                    label = "Service requis",
                },
                crimeSceneTapeReturnItemOnRemove = {
                    description = "Restituer l'objet consommé lorsque le ruban posé est retiré.",
                    label = "Restituer l'objet au retrait",
                },
                crimeSceneTapeSag = {
                    description = "Affaissement maximal du ruban vers le bas entre les poteaux, en mètres.",
                    label = "Affaissement du ruban",
                },
                crimeSceneTapeSections = {
                    description = "Modèles natifs de sections de ruban utilisés pour assembler la longueur sélectionnée.",
                    itemLabel = "Section de ruban",
                    label = "Sections de ruban",
                },
                crimeSceneTapeShowPosts = {
                    description = "Fait apparaître des poteaux de soutien visibles aux deux extrémités du ruban de scène de crime à longueur variable.",
                    label = "Afficher les poteaux du ruban",
                },
                crimeSceneTapeStreamDistance = {
                    description = "Distance dans laquelle le ruban de scène de crime posé est chargé.",
                    label = "Distance de chargement",
                },
                crimeSceneTapeTapeHeight = {
                    description = "Hauteur du ruban au-dessus des points au sol sélectionnés.",
                    label = "Hauteur du ruban",
                },
                crimeSceneTapeVariableLength = {
                    description = "Permet aux agents de définir un point de départ et un point d’arrivée afin de poser le ruban à une longueur réglable.",
                    label = "Longueur variable du ruban",
                },
                crimeSceneTapeZOffset = {
                    description = "Décalage vertical appliqué lors de la pose du modèle de ruban.",
                    label = "Décalage vertical",
                },
                cuffsAnimDict = {
                    description = "Dictionnaire d'animation utilisé pour les joueurs entravés.",
                    label = "Dictionnaire d'animation",
                },
                cuffsAnimFlag = {
                    description = "Indicateur d'animation utilisé pour les joueurs entravés.",
                    label = "Indicateur d'animation",
                },
                cuffsAnimName = {
                    description = "Nom de l'animation utilisée pour les joueurs entravés.",
                    label = "Nom de l'animation",
                },
                cuffsConsumeItem = {
                    description = "Retirer l'objet menottes lorsque les menottes sont appliquées.",
                    label = "Consommer les menottes",
                },
                cuffsEnabled = {
                    description = "Activer les actions de menottage.",
                    label = "Menottes",
                },
                cuffsEscapeEnabled = {
                    description = "Activer le mini-jeu d'évasion des menottes.",
                    label = "Évasion des menottes",
                },
                cuffsEscapeKeyPool = {
                    description = "Touches pouvant apparaître dans le mini-jeu d'évasion des menottes.",
                    itemLabel = "Touche",
                    label = "Réserve de touches d'évasion",
                },
                cuffsEscapeRounds = {
                    description = "Nombre de manches requises dans le mini-jeu d'évasion des menottes.",
                    label = "Manches d'évasion",
                },
                cuffsEscapeWindowMs = {
                    description = "Millisecondes autorisées par fenêtre de saisie d'évasion des menottes.",
                    label = "Fenêtre d'évasion",
                },
                cuffsHandsUpEnabled = {
                    description = "Activer l'état mains en l'air utilisé par les menottes et les attaches zip.",
                    label = "Mains en l'air",
                },
                cuffsHandsUpHoldSeconds = {
                    description = "Secondes pendant lesquelles la touche mains en l'air doit être maintenue avant l'activation.",
                    label = "Secondes de maintien mains en l'air",
                },
                cuffsHandsUpKey = {
                    description = "Touche du clavier utilisée pour lever les mains.",
                    label = "Touche mains en l'air",
                },
                cuffsItem = {
                    description = "Objet d'inventaire utilisé pour les actions de menottage.",
                    label = "Objet menottes",
                },
                cuffsMaxDistance = {
                    description = "Distance maximale de la cible pour les actions de menottage.",
                    label = "Distance de menottage",
                },
                cuffsRequireItem = {
                    description = "Exiger l'objet menottes configuré.",
                    label = "Menottes nécessitent l'objet",
                },
                cuffsRequireOnDuty = {
                    description = "Exiger l'état de service avant de menotter.",
                    label = "Menottes nécessitent le service",
                },
                cuffsReturnOnRemove = {
                    description = "Restituer l'objet menottes lorsque les menottes sont retirées.",
                    label = "Restituer les menottes",
                },
                dispatchOfficerDownEnabled = {
                    description = "Envoyer une alerte de répartition lorsqu'un agent en service est à terre.",
                    label = "Alertes agent à terre",
                },
                dispatchOfficerDownJobs = {
                    description = "Jobs devant recevoir les répartitions agent à terre.",
                    itemLabel = "Métier",
                    label = "Jobs agent à terre",
                },
                dispatchOfficerDownRequireDuty = {
                    description = "Ne notifier que les joueurs actuellement en service.",
                    label = "Agent à terre nécessite le service",
                },
                dispatchShotsFiredChance = {
                    description = "Probabilité de 0.0 à 1.0 qu'un tir détecté déclenche une alerte.",
                    label = "Probabilité d'alerte",
                },
                dispatchShotsFiredCooldownSeconds = {
                    description = "Secondes avant que le même joueur puisse déclencher une autre alerte de coups de feu.",
                    label = "Délai des coups de feu",
                },
                dispatchShotsFiredEnabled = {
                    description = "Activer les alertes de répartition de coups de feu tirés.",
                    label = "Alertes coups de feu",
                },
                dispatchShotsFiredIgnoredWeapons = {
                    description = "Armes ne devant pas déclencher d'alertes de coups de feu.",
                    itemLabel = "Arme",
                    label = "Armes ignorées",
                },
                dispatchShotsFiredJobs = {
                    description = "Jobs devant recevoir les répartitions de coups de feu.",
                    itemLabel = "Métier",
                    label = "Jobs coups de feu",
                },
                dispatchShotsFiredRequireDuty = {
                    description = "Ne notifier que les joueurs actuellement en service.",
                    label = "Coups de feu nécessitent le service",
                },
                dispatchShotsFiredSendDispatch = {
                    description = "Créer des entrées de répartition lorsque des coups de feu sont détectés.",
                    label = "Envoyer la répartition de coups de feu",
                },
                dispatchShotsFiredSuppressedChance = {
                    description = "Probabilité de 0.0 à 1.0 qu'un tir avec silencieux détecté déclenche une alerte.",
                    label = "Probabilité d'alerte avec silencieux",
                },
                escortEnabled = {
                    description = "Activer l'escorte de joueurs.",
                    label = "Escorte",
                },
                escortMaxDistance = {
                    description = "Distance maximale pour commencer à escorter un joueur.",
                    label = "Distance d'escorte",
                },
                escortRequireOnDuty = {
                    description = "Exiger l'état de service avant d'escorter des joueurs.",
                    label = "Escorte nécessite le service",
                },
                escortVehicleDistance = {
                    description = "Distance maximale pour placer un joueur escorté dans un véhicule.",
                    label = "Distance d'escorte véhicule",
                },
                evidenceBloodDamageThreshold = {
                    description = "Seuil de dégâts minimum avant qu'une preuve de sang ne soit créée.",
                    label = "Seuil de dégâts pour le sang",
                },
                evidenceCasingCreateCooldownMs = {
                    description = "Millisecondes avant qu'une autre douille puisse être créée.",
                    label = "Délai des douilles",
                },
                evidenceCasingMergeRadius = {
                    description = "Rayon utilisé pour fusionner les douilles proches.",
                    label = "Rayon de fusion des douilles",
                },
                evidenceCleanupIntervalMs = {
                    description = "Millisecondes entre les passes de nettoyage des preuves.",
                    label = "Intervalle de nettoyage",
                },
                evidenceCleanupTtlSeconds = {
                    description = "Secondes avant que les preuves de terrain n'expirent automatiquement.",
                    label = "Durée de vie avant nettoyage",
                },
                evidenceCleanerAllowEveryone = {
                    label = "Nettoyant pour tous",
                    description = "Autoriser tout le monde à effacer les traces avec du peroxyde d’hydrogène. Désactiver pour utiliser les listes de métiers et de gangs.",
                },
                evidenceCleanerJobs = {
                    label = "Métiers du nettoyant",
                    description = "Noms internes autorisés sans accès public. Un métier ou un gang correspondant autorise l’accès ; les listes vides le refusent.",
                    itemLabel = "Métier",
                },
                evidenceCleanerGangs = {
                    label = "Gangs du nettoyant",
                    description = "Noms internes autorisés sans accès public. Un métier ou un gang correspondant autorise l’accès ; les listes vides le refusent.",
                    itemLabel = "Gang",
                },
                evidenceCollectDistance = {
                    description = "Distance utilisée pour collecter les preuves de terrain.",
                    label = "Distance de collecte",
                },
                evidenceDiscoverDistance = {
                    description = "Distance utilisée pour découvrir les marqueurs de preuves à proximité.",
                    label = "Distance de découverte",
                },
                evidenceFieldEnabled = {
                    description = "Activer la création et la collecte de preuves sur le terrain.",
                    label = "Preuve de terrain",
                },
                evidenceFieldFlashlightWeapon = {
                    description = "Arme utilisée pour inspecter et révéler les preuves sur le terrain.",
                    label = "Arme lampe torche",
                },
                evidenceGloveFreeHands = {
                    description = "IDs de composants de mains considérés comme ne portant pas de gants.",
                    label = "Mains sans gants",
                },
                evidenceGsrDurationSeconds = {
                    description = "Nombre de secondes pendant lesquelles les résidus de tir restent sur les mains d'un joueur.",
                    label = "Durée des résidus de tir",
                },
                evidenceGsrGlovesProtectHands = {
                    description = "Empêche le dépôt de résidus de tir lorsque le tireur porte des gants.",
                    label = "Protection par les gants",
                },
                evidenceGsrIgnoredWeapons = {
                    description = "Armes qui ne déposent pas de résidus de tir.",
                    label = "Armes ignorées",
                },
                evidenceGsrWashCheckIntervalMs = {
                    description = "Millisecondes entre les vérifications de nettoyage par l'eau ou la pluie lorsque des résidus sont présents.",
                    label = "Intervalle de vérification du nettoyage",
                },
                evidenceGsrWashInRain = {
                    description = "Permet à la pluie de retirer les résidus de tir.",
                    label = "Nettoyage sous la pluie",
                },
                evidenceGsrWashInWater = {
                    description = "Permet à l'eau de retirer les résidus de tir.",
                    label = "Nettoyage dans l'eau",
                },
                evidenceMarkerColor = {
                    description = "Couleur RGBA utilisée pour les marqueurs de preuves de terrain.",
                    label = "Couleur du marqueur",
                },
                evidenceMarkerDrawDistance = {
                    description = "Distance d'affichage utilisée pour les marqueurs de preuves de terrain.",
                    label = "Distance d'affichage",
                },
                evidenceMarkerOffset = {
                    description = "Décalage vertical du marqueur utilisé pour les preuves de terrain.",
                    label = "Décalage",
                },
                evidenceMarkerScaleX = {
                    description = "Échelle X du marqueur utilisée pour les preuves de terrain.",
                    label = "Échelle X",
                },
                evidenceMarkerScaleY = {
                    description = "Échelle Y du marqueur utilisée pour les preuves de terrain.",
                    label = "Échelle Y",
                },
                evidenceMarkerScaleZ = {
                    description = "Échelle Z du marqueur utilisée pour les preuves de terrain.",
                    label = "Échelle Z",
                },
                evidenceMarkerType = {
                    description = "Type de marqueur utilisé pour les preuves de terrain.",
                    label = "Type de marqueur",
                },
                evidenceMaxCreateDistance = {
                    description = "Distance maximale pour créer des enregistrements de preuves.",
                    label = "Distance de création",
                },
                evidenceSalivaConsentTimeoutMs = {
                    description = "Millisecondes autorisées pour le consentement à l'échantillon salivaire.",
                    label = "Délai de consentement salivaire",
                },
                evidenceScannerDistance = {
                    description = "Distance utilisée pour les interactions du scanner de preuves.",
                    label = "Distance du scanner",
                },
                evidenceScannerDurationMs = {
                    description = "Durée de l'action d'empreinte/scanner en millisecondes.",
                    label = "Durée du scanner",
                },
                evidenceStorageMaxCompartments = {
                    description = "Nombre maximum de compartiments de stockage des preuves.",
                    label = "Compartiments de stockage",
                },
                fakePlateHeliDisplay = {
                    label = "Afficher la fausse plaque dans l'hélicam",
                    description = "Affiche la fausse plaque dans la caméra de l'hélicoptère.",
                },
                fakePlateNormalToolsDisplay = {
                    label = "Afficher la fausse plaque dans les outils standard",
                    description = "Affiche la fausse plaque dans les outils policiers standard.",
                },
                fakePlateRadarDisplay = {
                    label = "Afficher la fausse plaque sur le radar",
                    description = "Affiche la fausse plaque sur le radar embarqué.",
                },
                fakePlateRecognitionEnabled = {
                    description = "Permet aux systèmes de police de lire le statebag partagé des fausses plaques.",
                    label = "Reconnaître les fausses plaques",
                },
                fakePlateRecognitionStateBagKey = {
                    description = "Clé du statebag de l'entité véhicule publiée par Mechanic Job.",
                    label = "Clé du statebag",
                },
                fakePlateSpeedCamDisplay = {
                    label = "Afficher la fausse plaque sur le radar fixe",
                    description = "Affiche la fausse plaque dans les relevés des radars fixes.",
                },
                fakePlateVinAllowedGrades = {
                    description = "Liste facultative des métiers et grades autorisés. Laissez-la vide pour autoriser tous les grades des métiers permis.",
                    label = "Grades autorisés pour le VIN",
                },
                fakePlateVinAllowedGangs = {
                    label = "Gangs autorisés",
                    description = "Sélectionnez les noms internes des gangs ou organisations indépendantes. Un métier ou gang correspondant accorde l’autorisation ou l’exemption. Le service est exigé uniquement pour les métiers.",
                    itemLabel = "Gang",
                },
                fakePlateVinAllowedGangGrades = {
                    label = "Rangs minimums des gangs",
                    description = "Rangs minimums facultatifs. Une liste vide autorise tous les rangs. Les objets requis restent nécessaires.",
                },
                fakePlateVinAllowedJobs = {
                    label = "Métiers autorisés pour le VIN",
                    description = "Métiers autorisés à utiliser la vérification du VIN.",
                },
                fakePlateVinAudit = {
                    label = "Journaliser les vérifications VIN",
                    description = "Enregistre les vérifications de VIN dans le journal d'audit.",
                },
                fakePlateVinCheckEnabled = {
                    label = "Vérification du VIN activée",
                    description = "Active la commande de vérification du VIN des véhicules.",
                },
                fakePlateVinCommand = {
                    label = "Commande VIN",
                    description = "Commande utilisée pour vérifier le VIN d'un véhicule.",
                },
                fakePlateVinCooldown = {
                    label = "Délai du VIN",
                    description = "Délai entre deux vérifications de VIN.",
                },
                fakePlateVinDistance = {
                    label = "Distance maximale du VIN",
                    description = "Distance maximale entre l'agent et le véhicule pour vérifier son VIN.",
                },
                fakePlateVinIndicator = {
                    label = "Afficher l'indicateur de fausse plaque",
                    description = "Affiche un indicateur lorsqu'une vérification détecte une fausse plaque.",
                },
                fakePlateVinRequireDuty = {
                    label = "Service requis",
                    description = "Exige que l'agent soit en service pour vérifier un VIN.",
                },
                fakePlateVinRequireScanner = {
                    label = "Scanner requis",
                    description = "Exige l'objet scanner configuré pour vérifier un VIN.",
                },
                fakePlateVinScannerItem = {
                    label = "Objet scanner",
                    description = "Objet d'inventaire requis pour vérifier un VIN.",
                },
                gpsTrackerBeepDistance = {
                    description = "Distance à partir de laquelle le retour sonore du traceur GPS devient pertinent.",
                    label = "Distance du bip",
                },
                gpsTrackerBeepIntervalFarMs = {
                    description = "Millisecondes entre les bips lorsque loin d'un traceur.",
                    label = "Intervalle de bip lointain",
                },
                gpsTrackerBeepIntervalNearMs = {
                    description = "Millisecondes entre les bips lorsque proche d'un traceur.",
                    label = "Intervalle de bip proche",
                },
                gpsTrackerConsumeOnPlace = {
                    description = "Retirer l'objet traceur après la pose.",
                    label = "Consommer le traceur GPS",
                },
                gpsTrackerEnabled = {
                    description = "Activer la pose et le scan des traceurs GPS de véhicules.",
                    label = "Traceur GPS",
                },
                gpsTrackerItem = {
                    description = "Objet d'inventaire utilisé pour poser des traceurs GPS.",
                    label = "Objet traceur",
                },
                gpsTrackerMapUpdateIntervalMs = {
                    description = "Millisecondes entre les mises à jour de la carte du traceur.",
                    label = "Intervalle de mise à jour de la carte",
                },
                gpsTrackerPlaceDistance = {
                    description = "Distance maximale pour poser un traceur GPS sur un véhicule.",
                    label = "Distance de pose",
                },
                gpsTrackerRemoveDistance = {
                    description = "Distance maximale pour retirer un traceur GPS posé.",
                    label = "Distance de retrait",
                },
                gpsTrackerRemoveKey = {
                    description = "Code de contrôle utilisé pour retirer un traceur GPS posé.",
                    label = "Touche de retrait",
                },
                gpsTrackerRequireOnDuty = {
                    description = "Exiger l'état de service avant d'utiliser des traceurs GPS.",
                    label = "GPS nécessite le service",
                },
                gpsTrackerRequirePoliceJob = {
                    description = "Exiger que le joueur appartienne au groupe police avant d'utiliser des traceurs GPS.",
                    label = "GPS nécessite le job policier",
                },
                gpsTrackerReturnOnRemove = {
                    description = "Restituer l'objet traceur lorsqu'il est retiré.",
                    label = "Restituer le traceur au retrait",
                },
                gpsTrackerScanDistance = {
                    description = "Distance maximale pour scanner les traceurs.",
                    label = "Distance de scan GPS",
                },
                gpsTrackerScanDurationMs = {
                    description = "Millisecondes passées à scanner un traceur GPS.",
                    label = "Durée du scan",
                },
                gpsTrackerScannerWeapon = {
                    description = "Arme ou outil utilisé pour scanner les traceurs GPS.",
                    label = "Arme du scanner",
                },
                impoundAccount = {
                    description = "Compte utilisé pour facturer les restitutions de fourrière.",
                    label = "Compte de paiement",
                },
                impoundCreatorVehicleModel = {
                    description = "Modèle de véhicule affiché par l'aperçu du créateur de fourrière.",
                    label = "Modèle de véhicule du créateur",
                },
                impoundCustomGarageEnabled = {
                    description = "Utiliser une interface de fourrière garage personnalisée lorsque disponible.",
                    label = "Fourrière garage personnalisée",
                },
                impoundDefaultPrice = {
                    description = "Prix de restitution de fourrière par défaut.",
                    label = "Prix par défaut",
                },
                impoundDeliveryDistance = {
                    description = "Distance utilisée pour les interactions de livraison de fourrière.",
                    label = "Distance de livraison",
                },
                impoundDeliveryMarker = {
                    description = "Configuration de marqueur utilisée pour les livraisons de fourrière.",
                    label = "Marqueur de livraison",
                },
                impoundEnabled = {
                    description = "Activer les flux de fourrière.",
                    label = "Fourrière",
                },
                impoundMarker = {
                    description = "Configuration de marqueur utilisée pour les interactions de fourrière.",
                    label = "Marqueur de fourrière",
                },
                impoundRadialEnabled = {
                    description = "Activer les actions radiales de mise en fourrière.",
                    label = "Action de fourrière",
                },
                impoundRadialRequireOnDuty = {
                    description = "Exiger l'état de service avant d'utiliser l'action radiale de mise en fourrière.",
                    label = "Fourrière nécessite le service",
                },
                impoundRadialVehicleDistance = {
                    description = "Distance maximale du véhicule cible pour les actions radiales de mise en fourrière.",
                    label = "Distance du véhicule fourrière",
                },
                impoundReleaseDistance = {
                    description = "Distance utilisée pour les interactions de restitution de fourrière.",
                    label = "Distance de restitution",
                },
                impoundReleaseKey = {
                    description = "Code de contrôle utilisé pour restituer les véhicules mis en fourrière.",
                    label = "Touche de restitution",
                },
                impoundRequireDelivery = {
                    description = "Exiger la livraison à un dépôt de fourrière configuré.",
                    label = "Exiger la livraison",
                },
                impoundStorageBasePrice = {
                    description = "Prix de restitution de base pour les véhicules en stockage de fourrière.",
                    label = "Prix de base du stockage",
                },
                impoundStorageDailyFee = {
                    description = "Frais de stockage de fourrière supplémentaires par jour configuré.",
                    label = "Frais journaliers de stockage",
                },
                impoundStorageDaySeconds = {
                    description = "Nombre de secondes comptant comme un jour de facturation de stockage.",
                    label = "Secondes par jour de stockage",
                },
                impoundStorageEnabled = {
                    description = "Activer la gestion du stockage de fourrière payant.",
                    label = "Stockage de fourrière",
                },
                jailAssignRange = {
                    description = "Distance maximale pour assigner une cible en prison.",
                    label = "Portée d'assignation",
                },
                jailCanteenCooldownMinutes = {
                    description = "Minutes qu'un détenu doit attendre avant de réclamer un autre colis de cantine.",
                    label = "Minutes de délai",
                },
                jailCanteenPackage = {
                    description = "Objets accordés par le colis de la cantine de la prison.",
                    label = "Colis de cantine",
                },
                jailCellStreamDistance = {
                    description = "Distance utilisée pour le chargement des props des cellules d'isolement.",
                    label = "Distance de chargement des cellules",
                },
                jailClearInventory = {
                    description = "Vider l'inventaire du joueur lors de son envoi en prison.",
                    label = "Vider l'inventaire",
                },
                jailDefaultMonths = {
                    description = "Durée de prison par défaut à l'ouverture de l'interface d'assignation.",
                    label = "Mois par défaut",
                },
                jailDispatchJobs = {
                    description = "Jobs devant recevoir les répartitions de prison.",
                    itemLabel = "Métier",
                    label = "Jobs de répartition",
                },
                jailDoctorHealEvent = {
                    description = "Événement serveur ou client déclenché lorsque le médecin de la prison soigne un détenu.",
                    label = "Événement de soin",
                },
                jailElectricalCodeListItem = {
                    description = "Objet d'inventaire requis pour révéler les codes électriques générés.",
                    label = "Objet liste de codes",
                },
                jailElectricalCodeMax = {
                    description = "Valeur maximale du code aléatoire pour le boîtier électrique.",
                    label = "Code maximum",
                },
                jailElectricalCodeMin = {
                    description = "Valeur minimale du code aléatoire pour le boîtier électrique.",
                    label = "Code minimum",
                },
                jailElectricalCodesCount = {
                    description = "Nombre de codes candidats générés pour le boîtier électrique.",
                    label = "Nombre de codes",
                },
                jailElectricalEnabled = {
                    description = "Activer le mini-jeu d'évasion du boîtier électrique de la prison.",
                    label = "Boîtier électrique",
                },
                jailElectricalPinLength = {
                    description = "Nombre de chiffres utilisés pour les codes PIN du boîtier électrique.",
                    label = "Longueur du code PIN",
                },
                jailElectricalPropModel = {
                    description = "Modèle de prop du monde utilisé pour le boîtier électrique de la prison.",
                    label = "Modèle de prop",
                },
                jailElectricalShockDamage = {
                    description = "Dégâts infligés lorsqu'un détenu échoue la séquence électrique.",
                    label = "Dégâts de choc",
                },
                jailElectricalShockRagdollMs = {
                    description = "Millisecondes de ragdoll après un choc électrique.",
                    label = "Ragdoll du choc",
                },
                jailElectricalSuccessReduceMinutes = {
                    description = "Minutes de peine retirées après une tentative d'évasion électrique réussie.",
                    label = "Minutes de réduction en cas de succès",
                },
                jailInmateAlcoholicRequiredAmount = {
                    description = "Quantité requise pour l'échange avec le détenu alcoolique.",
                    label = "Quantité requise",
                },
                jailInmateAlcoholicRequiredItem = {
                    description = "Objet requis pour l'échange avec le détenu alcoolique.",
                    label = "Objet requis",
                },
                jailInmateAlcoholicRewardAmount = {
                    description = "Quantité de récompense pour l'échange avec le détenu alcoolique.",
                    label = "Quantité de récompense",
                },
                jailInmateAlcoholicRewardItem = {
                    description = "Objet de récompense pour l'échange avec le détenu alcoolique.",
                    label = "Objet de récompense",
                },
                jailInmateAlcoholicRewardLabel = {
                    description = "Étiquette de récompense affichée pour l'échange avec le détenu alcoolique.",
                    label = "Étiquette de récompense",
                },
                jailInmateCodeListRequiredAmount = {
                    description = "Quantité requise pour l'échange avec le détenu informateur.",
                    label = "Quantité requise",
                },
                jailInmateCodeListRequiredItem = {
                    description = "Objet requis pour l'échange avec le détenu informateur.",
                    label = "Objet requis",
                },
                jailInmateCodeListRewardAmount = {
                    description = "Quantité de récompense pour l'échange avec le détenu informateur.",
                    label = "Quantité de récompense",
                },
                jailInmateCodeListRewardItem = {
                    description = "Objet de récompense pour l'échange avec le détenu informateur.",
                    label = "Objet de récompense",
                },
                jailInmateCodeListRewardLabel = {
                    description = "Étiquette de récompense affichée pour l'échange avec le détenu informateur.",
                    label = "Étiquette de récompense",
                },
                jailInmateDrugDealerAcceptedItems = {
                    description = "Objets acceptés pour l'échange avec le détenu trafiquant de drogue.",
                    label = "Objets acceptés",
                },
                jailInmateDrugDealerRequiredAmount = {
                    description = "Quantité requise pour l'échange avec le détenu trafiquant de drogue.",
                    label = "Quantité requise",
                },
                jailInmateDrugDealerRewardAmount = {
                    description = "Quantité de récompense pour l'échange avec le détenu trafiquant de drogue.",
                    label = "Quantité de récompense",
                },
                jailInmateDrugDealerRewardItem = {
                    description = "Objet de récompense pour l'échange avec le détenu trafiquant de drogue.",
                    label = "Objet de récompense",
                },
                jailInmateDrugDealerRewardLabel = {
                    description = "Étiquette de récompense affichée pour l'échange avec le détenu trafiquant de drogue.",
                    label = "Étiquette de récompense",
                },
                jailInmateDrugDealerUseCleaningContraband = {
                    description = "Autoriser la contrebande trouvée pendant le nettoyage en prison à compter pour l'échange avec le détenu trafiquant de drogue.",
                    label = "Utiliser la contrebande de nettoyage",
                },
                jailInmateWireCutterRequiredAmount = {
                    description = "Quantité requise pour l'échange avec le détenu porteur d'outils.",
                    label = "Quantité requise",
                },
                jailInmateWireCutterRequiredItem = {
                    description = "Objet requis pour l'échange avec le détenu porteur d'outils.",
                    label = "Objet requis",
                },
                jailInmateWireCutterRewardAmount = {
                    description = "Quantité de récompense pour l'échange avec le détenu porteur d'outils.",
                    label = "Quantité de récompense",
                },
                jailInmateWireCutterRewardItem = {
                    description = "Objet de récompense pour l'échange avec le détenu porteur d'outils.",
                    label = "Objet de récompense",
                },
                jailInmateWireCutterRewardLabel = {
                    description = "Étiquette de récompense affichée pour l'échange avec le détenu porteur d'outils.",
                    label = "Étiquette de récompense",
                },
                jailJobsCarryBoxModel = {
                    description = "Modèle de prop utilisé pour la caisse du travail de portage en prison.",
                    label = "Modèle de la caisse de portage",
                },
                jailJobsCarryDropoffKey = {
                    description = "Code de contrôle utilisé pour déposer les caisses du travail de portage.",
                    label = "Touche de dépôt portage",
                },
                jailJobsCarryDropoffRadius = {
                    description = "Rayon de dépôt pour le travail de portage en prison.",
                    label = "Rayon de dépôt",
                },
                jailJobsCarryInspectKey = {
                    description = "Code de contrôle utilisé pour inspecter les caisses du travail de portage.",
                    label = "Touche d'inspection",
                },
                jailJobsCarryInspectionJunkItems = {
                    description = "Objets sans valeur pouvant être trouvés en inspectant les caisses du travail de portage.",
                    label = "Objets d'inspection sans valeur",
                },
                jailJobsCarryInspectionUsableChance = {
                    description = "Chance d'obtenir une récompense de butin utilisable lors de l'inspection des caisses.",
                    label = "Chance de butin utilisable",
                },
                jailJobsCarryInspectionUsableItems = {
                    description = "Objets utilisables pouvant être trouvés en inspectant les caisses du travail de portage.",
                    label = "Objets d'inspection utilisables",
                },
                jailJobsCarryInteractDistance = {
                    description = "Distance d'interaction pour le travail de portage en prison.",
                    label = "Distance d'interaction de portage",
                },
                jailJobsCarryMaxDistance = {
                    description = "Distance maximale autorisée pour la progression du travail de portage en prison.",
                    label = "Distance max de portage",
                },
                jailJobsCarryPickupKey = {
                    description = "Code de contrôle utilisé pour ramasser les caisses du travail de portage.",
                    label = "Touche de ramassage portage",
                },
                jailJobsCarryPickupOffset = {
                    description = "Objet de décalage utilisé pour l'emplacement de ramassage du travail de portage.",
                    label = "Décalage de ramassage",
                },
                jailJobsCarryTimeReduction = {
                    description = "Réduction de peine pour avoir terminé le travail de portage en prison.",
                    label = "Réduction de peine pour portage",
                },
                jailJobsCleaningDumpsterKey = {
                    description = "Code de contrôle utilisé au niveau de la benne de la prison.",
                    label = "Touche de la benne",
                },
                jailJobsCleaningDumpsterModel = {
                    description = "Modèle utilisé pour le prop de la benne de nettoyage en prison.",
                    label = "Modèle de la benne",
                },
                jailJobsCleaningIllegalFindChance = {
                    description = "Chance de trouver de la contrebande en nettoyant.",
                    label = "Chance de découverte illégale",
                },
                jailJobsCleaningIllegalFindItems = {
                    description = "Objets pouvant être trouvés en nettoyant en prison.",
                    label = "Objets de découverte illégale",
                },
                jailJobsCleaningIllegalFindPromptTimeoutMs = {
                    description = "Délai en millisecondes pour les invites de découverte illégale.",
                    label = "Délai de l'invite de découverte",
                },
                jailJobsCleaningInteractDistance = {
                    description = "Distance utilisée pour l'interaction avec les déchets à nettoyer.",
                    label = "Distance d'interaction de nettoyage",
                },
                jailJobsCleaningMaxDistance = {
                    description = "Distance maximale avant que les props de nettoyage ne se réinitialisent ou disparaissent.",
                    label = "Distance max de nettoyage",
                },
                jailJobsCleaningMaxTrashProps = {
                    description = "Nombre maximum simultané de props de déchets pour le nettoyage en prison.",
                    label = "Nombre max de props de déchets",
                },
                jailJobsCleaningMinSpawnRadius = {
                    description = "Distance minimale par rapport au centre pour l'apparition des déchets à nettoyer.",
                    label = "Rayon d'apparition minimum",
                },
                jailJobsCleaningPickupKey = {
                    description = "Code de contrôle utilisé pour ramasser les déchets de nettoyage en prison.",
                    label = "Touche de ramassage nettoyage",
                },
                jailJobsCleaningSpawnIntervalMs = {
                    description = "Millisecondes entre les tentatives d'apparition des déchets à nettoyer.",
                    label = "Intervalle d'apparition des déchets",
                },
                jailJobsCleaningSpawnRadius = {
                    description = "Rayon utilisé pour faire apparaître les props de déchets à nettoyer.",
                    label = "Rayon d'apparition des déchets",
                },
                jailJobsCleaningTrashModels = {
                    description = "Modèles de props de déchets utilisés pour le travail de nettoyage en prison.",
                    itemLabel = "Modèle",
                    label = "Modèles de déchets",
                },
                jailJobsCleaningTrashOutlineColor = {
                    description = "Couleur RGBA du contour utilisée pour les props de déchets de nettoyage en prison.",
                    label = "Couleur du contour",
                },
                jailJobsCleaningTrashOutlineEnabled = {
                    description = "Activer les contours sur les props de déchets de nettoyage en prison.",
                    label = "Contour des déchets",
                },
                jailJobsCleaningTrashOutlineShader = {
                    description = "ID du shader utilisé pour les contours des déchets de nettoyage en prison.",
                    label = "Shader de contour",
                },
                jailJobsTimeReduction = {
                    description = "Réduction de peine pour avoir terminé le travail de nettoyage en prison.",
                    label = "Réduction de peine pour nettoyage",
                },
                jailJobsTrashGoal = {
                    description = "Nombre de déchets nécessaires pour terminer le travail de nettoyage en prison.",
                    label = "Objectif de déchets à nettoyer",
                },
                jailMaxMonths = {
                    description = "Durée maximale sélectionnable de la peine de prison.",
                    label = "Mois maximum",
                },
                jailMinMonths = {
                    description = "Durée minimale sélectionnable de la peine de prison.",
                    label = "Mois minimum",
                },
                jailMonthMinutes = {
                    description = "Minutes en temps réel représentées par un mois de prison.",
                    label = "Minutes par mois",
                },
                jailObjectStreamDistance = {
                    description = "Distance utilisée pour le chargement des objets persistants du monde de la prison.",
                    label = "Distance de chargement des objets",
                },
                jailOutfitApplyDelayMs = {
                    description = "Délai après connexion avant que la tenue de prison ne soit appliquée.",
                    label = "Délai d'application de la tenue",
                },
                jailOutfitEnabled = {
                    description = "Activer les tenues de prison.",
                    label = "Tenue de prison",
                },
                jailOutfitFemaleArms = {
                    description = "Composant des bras de la tenue de prison féminine.",
                    label = "Bras",
                },
                jailOutfitFemaleChain1 = {
                    description = "Drawable de la chaîne de la tenue de prison féminine.",
                    label = "Chaîne 1",
                },
                jailOutfitFemaleChain2 = {
                    description = "Texture de la chaîne de la tenue de prison féminine.",
                    label = "Chaîne 2",
                },
                jailOutfitFemaleDecals1 = {
                    description = "Drawable des décalques de la tenue de prison féminine.",
                    label = "Décalques 1",
                },
                jailOutfitFemaleDecals2 = {
                    description = "Texture des décalques de la tenue de prison féminine.",
                    label = "Décalques 2",
                },
                jailOutfitFemaleGlasses1 = {
                    description = "Drawable des lunettes de la tenue de prison féminine (-1 retire les lunettes).",
                    label = "Lunettes 1",
                },
                jailOutfitFemaleGlasses2 = {
                    description = "Texture des lunettes de la tenue de prison féminine.",
                    label = "Lunettes 2",
                },
                jailOutfitFemaleHelmet1 = {
                    description = "Drawable du casque de la tenue de prison féminine.",
                    label = "Casque 1",
                },
                jailOutfitFemaleHelmet2 = {
                    description = "Texture du casque de la tenue de prison féminine.",
                    label = "Casque 2",
                },
                jailOutfitFemalePants1 = {
                    description = "Drawable du pantalon de la tenue de prison féminine.",
                    label = "Pantalon 1",
                },
                jailOutfitFemalePants2 = {
                    description = "Texture du pantalon de la tenue de prison féminine.",
                    label = "Pantalon 2",
                },
                jailOutfitFemaleShoes1 = {
                    description = "Drawable des chaussures de la tenue de prison féminine.",
                    label = "Chaussures 1",
                },
                jailOutfitFemaleShoes2 = {
                    description = "Texture des chaussures de la tenue de prison féminine.",
                    label = "Chaussures 2",
                },
                jailOutfitFemaleTorso1 = {
                    description = "Drawable du torse de la tenue de prison féminine.",
                    label = "Torse 1",
                },
                jailOutfitFemaleTorso2 = {
                    description = "Texture du torse de la tenue de prison féminine.",
                    label = "Torse 2",
                },
                jailOutfitFemaleTshirt1 = {
                    description = "Drawable du t-shirt de la tenue de prison féminine.",
                    label = "T-shirt 1",
                },
                jailOutfitFemaleTshirt2 = {
                    description = "Texture du t-shirt de la tenue de prison féminine.",
                    label = "T-shirt 2",
                },
                jailOutfitMaleArms = {
                    description = "Composant des bras de la tenue de prison masculine.",
                    label = "Bras",
                },
                jailOutfitMaleChain1 = {
                    description = "Drawable de la chaîne de la tenue de prison masculine.",
                    label = "Chaîne 1",
                },
                jailOutfitMaleChain2 = {
                    description = "Texture de la chaîne de la tenue de prison masculine.",
                    label = "Chaîne 2",
                },
                jailOutfitMaleDecals1 = {
                    description = "Drawable des décalques de la tenue de prison masculine.",
                    label = "Décalques 1",
                },
                jailOutfitMaleDecals2 = {
                    description = "Texture des décalques de la tenue de prison masculine.",
                    label = "Décalques 2",
                },
                jailOutfitMaleGlasses1 = {
                    description = "Drawable des lunettes de la tenue de prison masculine (-1 retire les lunettes).",
                    label = "Lunettes 1",
                },
                jailOutfitMaleGlasses2 = {
                    description = "Texture des lunettes de la tenue de prison masculine.",
                    label = "Lunettes 2",
                },
                jailOutfitMaleHelmet1 = {
                    description = "Drawable du casque de la tenue de prison masculine.",
                    label = "Casque 1",
                },
                jailOutfitMaleHelmet2 = {
                    description = "Texture du casque de la tenue de prison masculine.",
                    label = "Casque 2",
                },
                jailOutfitMalePants1 = {
                    description = "Drawable du pantalon de la tenue de prison masculine.",
                    label = "Pantalon 1",
                },
                jailOutfitMalePants2 = {
                    description = "Texture du pantalon de la tenue de prison masculine.",
                    label = "Pantalon 2",
                },
                jailOutfitMaleShoes1 = {
                    description = "Drawable des chaussures de la tenue de prison masculine.",
                    label = "Chaussures 1",
                },
                jailOutfitMaleShoes2 = {
                    description = "Texture des chaussures de la tenue de prison masculine.",
                    label = "Chaussures 2",
                },
                jailOutfitMaleTorso1 = {
                    description = "Drawable du torse de la tenue de prison masculine.",
                    label = "Torse 1",
                },
                jailOutfitMaleTorso2 = {
                    description = "Texture du torse de la tenue de prison masculine.",
                    label = "Torse 2",
                },
                jailOutfitMaleTshirt1 = {
                    description = "Drawable du t-shirt de la tenue de prison masculine.",
                    label = "T-shirt 1",
                },
                jailOutfitMaleTshirt2 = {
                    description = "Texture du t-shirt de la tenue de prison masculine.",
                    label = "T-shirt 2",
                },
                jailRemoveJobOnJail = {
                    description = "Définit le détenu comme sans emploi lorsqu'il est incarcéré.",
                    label = "Retirer le métier à l'incarcération",
                },
                jailRequireJailTerminal = {
                    description = "Autoriser les peines de prison prononcées par un agent uniquement près d'un terminal de la prison sélectionnée.",
                    label = "Terminal de prison requis",
                },
                jailRestoreOriginalJobOnRelease = {
                    description = "Restaure le métier d'origine du détenu à sa libération. Désactivez cette option pour le laisser sans emploi.",
                    label = "Restaurer le métier d'origine",
                },
                jailRestoreOutfitOnBreakout = {
                    description = "Restaurer la tenue civile sauvegardée lorsqu'un détenu s'évade.",
                    label = "Restaurer la tenue lors de l'évasion",
                },
                jailRestoreSpawnCorrectionMs = {
                    description = "Fenêtre de grâce après restauration avant que la correction du point d'apparition ne cesse de s'appliquer.",
                    label = "Fenêtre de correction de restauration",
                },
                jailTeleportRestoreOutsideZone = {
                    description = "Téléporter les détenus restaurés vers le point d'apparition de la prison s'ils se chargent en dehors de la zone de prison.",
                    label = "Téléporter les détenus restaurés",
                },
                jailTerminalRange = {
                    description = "Distance maximale entre l'agent et un terminal de la prison sélectionnée.",
                    label = "Portée du terminal",
                },
                jailZoneExitGraceMs = {
                    description = "Fenêtre de grâce avant qu'une sortie de la zone de prison ne soit comptée comme une évasion.",
                    label = "Grâce de sortie de zone",
                },
                mugshotAnimDict = {
                    description = "Dictionnaire d'animation utilisé pendant la capture de la photo.",
                    label = "Dictionnaire d'animation",
                },
                mugshotAnimFlag = {
                    description = "Indicateur d'animation utilisé pendant la capture de la photo.",
                    label = "Indicateur d'animation",
                },
                mugshotAnimName = {
                    description = "Nom de l'animation utilisée pendant la capture de la photo.",
                    label = "Nom de l'animation",
                },
                mugshotBoardHeader = {
                    description = "En-tête principal affiché sur le panneau de la photo d'identité.",
                    label = "En-tête du panneau",
                },
                mugshotBoardSubheader = {
                    description = "Sous-en-tête de secours affiché sur le panneau de la photo d'identité.",
                    label = "Sous-en-tête du panneau",
                },
                mugshotCameraCoordsX = {
                    description = "Coordonnée X du monde de la caméra utilisée pour les photos.",
                    label = "Caméra X",
                },
                mugshotCameraCoordsY = {
                    description = "Coordonnée Y du monde de la caméra utilisée pour les photos.",
                    label = "Caméra Y",
                },
                mugshotCameraCoordsZ = {
                    description = "Coordonnée Z du monde de la caméra utilisée pour les photos.",
                    label = "Caméra Z",
                },
                mugshotCameraFov = {
                    description = "Champ de vision utilisé pour les captures de photos.",
                    label = "Champ de vision de la caméra",
                },
                mugshotCameraRotX = {
                    description = "Rotation X de la caméra utilisée pour les photos.",
                    label = "Rotation X",
                },
                mugshotCameraRotY = {
                    description = "Rotation Y de la caméra utilisée pour les photos.",
                    label = "Rotation Y",
                },
                mugshotCameraRotZ = {
                    description = "Rotation Z de la caméra utilisée pour les photos.",
                    label = "Rotation Z",
                },
                mugshotCaptureTimeout = {
                    description = "Millisecondes maximum autorisées pour les rappels de capture de photo d'identité.",
                    label = "Délai de capture",
                },
                mugshotEnabled = {
                    description = "Activer la capture de photo d'identité lors de l'admission en prison.",
                    label = "Capture de photo d'identité",
                },
                mugshotHeading = {
                    description = "Cap appliqué lors de la capture de la photo.",
                    label = "Cap",
                },
                mugshotLocationX = {
                    description = "Coordonnée X du monde utilisée pour la capture de la photo.",
                    label = "Emplacement X",
                },
                mugshotLocationY = {
                    description = "Coordonnée Y du monde utilisée pour la capture de la photo.",
                    label = "Emplacement Y",
                },
                mugshotLocationZ = {
                    description = "Coordonnée Z du monde utilisée pour la capture de la photo.",
                    label = "Emplacement Z",
                },
                mugshotMetadataDescriptionFormat = {
                    description = "Format de description utilisé pour les métadonnées de la photo d'identité stockée.",
                    label = "Description des métadonnées",
                },
                mugshotMetadataName = {
                    description = "Nom de métadonnée d'inventaire utilisé pour la photo d'identité stockée.",
                    label = "Nom des métadonnées",
                },
                mugshotWaitMs = {
                    description = "Millisecondes à attendre avant de prendre la photo d'identité.",
                    label = "Millisecondes d'attente",
                },
                playerSearchAnimDict = {
                    description = "Dictionnaire d'animation utilisé pendant les fouilles de joueur.",
                    label = "Dictionnaire d'animation",
                },
                playerSearchAnimFlag = {
                    description = "Indicateur d'animation utilisé pendant les fouilles de joueur.",
                    label = "Indicateur d'animation",
                },
                playerSearchAnimName = {
                    description = "Nom de l'animation utilisée pendant les fouilles de joueur.",
                    label = "Nom de l'animation",
                },
                playerSearchDurationMs = {
                    description = "Durée de l'aperçu de fouille de joueur en millisecondes.",
                    label = "Durée de fouille",
                },
                playerSearchEnabled = {
                    description = "Activer le flux d'aperçu de fouille de joueur.",
                    label = "Fouille de joueur",
                },
                playerSearchRange = {
                    description = "Distance maximale pour commencer une fouille de joueur.",
                    label = "Portée de fouille",
                },
                playerSearchScenario = {
                    description = "Scénario utilisé lorsqu'aucune animation de fouille explicite n'est jouée.",
                    label = "Scénario de fouille",
                },
                policeBillingControl200 = {
                    label = "Facturation · Contrôle 200",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeBillingControl322 = {
                    label = "Facturation · Contrôle 322",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl10 = {
                    label = "Éditeur · Contrôle 10",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl11 = {
                    label = "Éditeur · Contrôle 11",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl172 = {
                    label = "Éditeur · Contrôle 172",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl173 = {
                    label = "Éditeur · Contrôle 173",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl174 = {
                    label = "Éditeur · Contrôle 174",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl175 = {
                    label = "Éditeur · Contrôle 175",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl177 = {
                    label = "Éditeur · Contrôle 177",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl191 = {
                    label = "Éditeur · Contrôle 191",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl201 = {
                    label = "Éditeur · Contrôle 201",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl202 = {
                    label = "Éditeur · Contrôle 202",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl21 = {
                    label = "Éditeur · Contrôle 21",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl32 = {
                    label = "Éditeur · Contrôle 32",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl322 = {
                    label = "Éditeur · Contrôle 322",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl33 = {
                    label = "Éditeur · Contrôle 33",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl34 = {
                    label = "Éditeur · Contrôle 34",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl35 = {
                    label = "Éditeur · Contrôle 35",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl36 = {
                    label = "Éditeur · Contrôle 36",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl37 = {
                    label = "Éditeur · Contrôle 37",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl38 = {
                    label = "Éditeur · Contrôle 38",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl44 = {
                    label = "Éditeur · Contrôle 44",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policeEditorControl73 = {
                    label = "Éditeur · Contrôle 73",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                policePrimaryColor = {
                    description = "Couleur par défaut du groupe des métiers de police.",
                    label = "Couleur principale",
                },
                primaryColor = {
                    description = "Couleur par défaut du groupe des métiers de police.",
                    label = "Couleur principale",
                },
                propPlacementConsumeItem = {
                    description = "Retirer un objet d'inventaire lorsqu'un prop est placé.",
                    label = "Consommer l'objet du prop",
                },
                propPlacementEnabled = {
                    description = "Autoriser le placement des props policiers configurés depuis des objets ou des véhicules.",
                    label = "Placement de props",
                },
                propPlacementItemNames = {
                    description = "Associer les modèles de props aux noms d'objets d'inventaire pour le placement de props basé sur des objets.",
                    label = "Noms des objets de props",
                },
                propPlacementRequireOnDuty = {
                    description = "Seuls les agents en service peuvent placer des props configurés.",
                    label = "Props nécessitent le service",
                },
                propPlacementReturnItem = {
                    description = "Rendre l'objet consommé lorsqu'un prop placé est retiré.",
                    label = "Restituer l'objet du prop",
                },
                propPlacementVehicleAccess = {
                    description = "Autoriser les véhicules de service à exposer leur équipement de props configuré.",
                    label = "Accès aux props du véhicule",
                },
                radialEnabled = {
                    description = "Activer les actions radiales policières.",
                    label = "Radial policier",
                },
                radialHandcuffKeybindCommand = {
                    description = "Nom de commande enregistré pour le raccourci de menottage.",
                    label = "Commande de menottage",
                },
                radialHandcuffKeybindDescription = {
                    description = "Description affichée pour le raccourci de menottage.",
                    label = "Description du menottage",
                },
                radialHandcuffKeybindEnabled = {
                    description = "Activer le raccourci clavier direct de menottage.",
                    label = "Raccourci de menottage",
                },
                radialHandcuffKeybindKey = {
                    description = "Touche du clavier utilisée pour l'action directe de menottage.",
                    label = "Touche de menottage",
                },
                radialKeybindsEnabled = {
                    description = "Activer les raccourcis clavier directs pour les actions radiales sélectionnées.",
                    label = "Raccourcis directs",
                },
                radialUnhandcuffKeybindCommand = {
                    description = "Nom de commande enregistré pour le raccourci de démenottage.",
                    label = "Commande de démenottage",
                },
                radialUnhandcuffKeybindDescription = {
                    description = "Description affichée pour le raccourci de démenottage.",
                    label = "Description du démenottage",
                },
                radialUnhandcuffKeybindEnabled = {
                    description = "Activer le raccourci clavier direct de démenottage.",
                    label = "Raccourci de démenottage",
                },
                radialUnhandcuffKeybindKey = {
                    description = "Touche du clavier utilisée pour l'action directe de démenottage.",
                    label = "Touche de démenottage",
                },
                socialWorkAssignRange = {
                    description = "Distance maximale pour assigner des tâches de travail social.",
                    label = "Portée d'assignation",
                },
                socialWorkDeadlineDefault = {
                    description = "Délai de travail social par défaut en minutes. Zéro désactive les délais.",
                    label = "Délai par défaut",
                },
                socialWorkDeadlineMax = {
                    description = "Délai maximum de travail social en minutes. Zéro désactive le plafond.",
                    label = "Délai maximum",
                },
                socialWorkDeadlineMin = {
                    description = "Délai minimum de travail social en minutes.",
                    label = "Délai minimum",
                },
                socialWorkDefaultTasks = {
                    description = "Nombre de tâches par défaut à l'ouverture de l'assignation de travail social.",
                    label = "Tâches par défaut",
                },
                socialWorkEnabled = {
                    description = "Activer les flux d'assignation et de tâches de travail social.",
                    label = "Travail social",
                },
                socialWorkImprisonmentJailId = {
                    description = "ID de prison utilisé lorsque des violations du travail social entraînent un emprisonnement.",
                    label = "ID de prison de secours",
                },
                socialWorkImprisonmentMonths = {
                    description = "Mois assignés lorsque des violations du travail social entraînent une peine de prison.",
                    label = "Mois d'emprisonnement",
                },
                socialWorkImprisonmentOfficerName = {
                    description = "Nom d'agent utilisé pour les registres d'emprisonnement du travail social.",
                    label = "Nom de l'agent d'emprisonnement",
                },
                socialWorkImprisonmentSolitary = {
                    description = "Envoyer les contrevenants à l'isolement lorsque l'emprisonnement se déclenche.",
                    label = "Utiliser l'isolement",
                },
                socialWorkInactivityMinutes = {
                    description = "Minutes avant que les pénalités d'inactivité du travail social ne s'appliquent.",
                    label = "Minutes d'inactivité",
                },
                socialWorkInactivityTaskPenalty = {
                    description = "Pénalité de tâches appliquée lorsqu'un joueur en travail social reste inactif trop longtemps.",
                    label = "Pénalité de tâches pour inactivité",
                },
                socialWorkMaxTasks = {
                    description = "Nombre maximum sélectionnable de tâches de travail social.",
                    label = "Tâches maximum",
                },
                socialWorkMinTasks = {
                    description = "Nombre minimum sélectionnable de tâches de travail social.",
                    label = "Tâches minimum",
                },
                speedCamBillingEnabled = {
                    description = "Émettre des amendes automatiques lorsque les radars de vitesse capturent une infraction correspondante. Nécessite que la fonctionnalité globale de facturation soit activée.",
                    label = "Amendes automatiques",
                },
                speedCamBillingExcludedJobs = {
                    description = "Métiers qui ne reçoivent jamais de factures automatiques des radars de vitesse.",
                    itemLabel = "Métier",
                    label = "Métiers exclus",
                },
                speedCamBillingExcludedModels = {
                    description = "Noms d'apparition des véhicules qui ne reçoivent jamais de factures automatiques des radars de vitesse.",
                    itemLabel = "Modèle",
                    label = "Modèles de véhicules exclus",
                },
                speedCamBillingRules = {
                    description = "Règles d'amende utilisées par les radars de vitesse. La plage d'excès la plus proche correspondante est facturée en premier ; si aucune règle ne correspond, les infractions SpeedViolation sont utilisées en secours.",
                    label = "Règles d'amende",
                },
                speedCamCameraEaseMs = {
                    description = "Durée pendant laquelle la vue se déplace vers l'angle du radar de vitesse. Plus bas = mouvement plus court ; trop bas peut désaligner la photo.",
                    label = "Transition de caméra (ms)",
                },
                speedCamCameraFov = {
                    description = "Champ de vision utilisé pour les captures du radar de vitesse.",
                    label = "Champ de vision de la caméra",
                },
                speedCamCheckIntervalMs = {
                    description = "Millisecondes entre les scans du radar de vitesse.",
                    label = "Intervalle de vérification",
                },
                speedCamCooldownMs = {
                    description = "Millisecondes avant que le même radar de vitesse ne puisse se redéclencher.",
                    label = "Délai de déclenchement",
                },
                speedCamDamageCooldownMs = {
                    description = "Millisecondes avant que des dégâts au radar de vitesse puissent à nouveau être appliqués.",
                    label = "Délai de dégâts",
                },
                speedCamDamagePerHit = {
                    description = "Dégâts de durabilité appliqués aux radars de vitesse par coup.",
                    label = "Dégâts par coup",
                },
                speedCamDamagedModelThreshold = {
                    description = "Pourcentage de la durabilité maximale à partir duquel, et en dessous, le modèle endommagé est affiché. Exemple : 50 avec une durabilité maximale de 200 fait basculer le modèle à 100.",
                    label = "Seuil du modèle endommagé (%)",
                },
                speedCamDefaultLimit = {
                    description = "Limite par défaut du radar de vitesse.",
                    label = "Limite de vitesse par défaut",
                },
                speedCamDefaultName = {
                    description = "Nom affiché proposé lors de la pose d'un radar. Ce nom peut être traduit sans modifier l'objet de l'inventaire ni le modèle.",
                    label = "Nom par défaut",
                },
                speedCamDefaultTolerance = {
                    description = "Tolérance par défaut du radar de vitesse.",
                    label = "Tolérance par défaut",
                },
                speedCamDisassembleDistance = {
                    description = "Distance utilisée pour démonter les radars de vitesse.",
                    label = "Distance de démontage",
                },
                speedCamEnabled = {
                    description = "Activer les radars de vitesse portables.",
                    label = "Radars de vitesse",
                },
                speedCamFlashColor = {
                    description = "Couleur RGBA du flash utilisée par les radars de vitesse.",
                    label = "Couleur du flash",
                },
                speedCamFlashDurationMs = {
                    description = "Temps d'estompage du flash rouge du radar de vitesse. Ne pas régler trop bas sinon le mouvement de la caméra devient visible.",
                    label = "Durée du flash (ms)",
                },
                speedCamHealthDisplayDistance = {
                    description = "Distance à laquelle l'état du radar de vitesse est affiché.",
                    label = "Distance d'affichage de l'état",
                },
                speedCamHealthDisplayDurationMs = {
                    description = "Millisecondes pendant lesquelles l'état du radar de vitesse reste visible.",
                    label = "Durée d'affichage de l'état",
                },
                speedCamHealthTextOffset = {
                    description = "Décalage vertical utilisé pour le texte d'état du radar de vitesse.",
                    label = "Décalage du texte d'état",
                },
                speedCamItem = {
                    description = "Nom interne exact de l'objet dans l'inventaire, par exemple speedcam. Saisissez la clé de l'objet, pas son nom affiché ; la boutique du métier doit fournir le même objet.",
                    label = "Nom de l'objet du radar",
                },
                speedCamMaintenanceThreshold = {
                    description = "Seuil de durabilité où la maintenance du radar de vitesse est recommandée.",
                    label = "Seuil de maintenance",
                },
                speedCamMaxDurability = {
                    description = "Durabilité maximale des radars de vitesse déployés.",
                    label = "Durabilité maximale",
                },
                speedCamMaxLimit = {
                    description = "Limite maximale configurable du radar de vitesse.",
                    label = "Limite de vitesse maximale",
                },
                speedCamMaxTolerance = {
                    description = "Tolérance maximale configurable du radar de vitesse.",
                    label = "Tolérance maximale",
                },
                speedCamPhotoLocale = {
                    description = "Locale optionnelle utilisée pour l'horodatage sur les photos du radar de vitesse. Laisser vide pour utiliser la locale du joueur flashé.",
                    label = "Locale de la photo",
                },
                speedCamPhotoTimeZone = {
                    description = "Fuseau horaire optionnel utilisé pour l'horodatage sur les photos du radar de vitesse. Laisser vide pour utiliser le fuseau horaire du joueur flashé.",
                    label = "Fuseau horaire de la photo",
                },
                speedCamPoliceNotification = {
                    description = "Envoyer une notification de répartition lorsque les radars de vitesse capturent des infractions.",
                    label = "Alerte policière radar",
                },
                speedCamPoliceNotificationGroup = {
                    description = "Traiter la cible de répartition du radar de vitesse comme un groupe de job.",
                    label = "Cible de répartition est un groupe",
                },
                speedCamPoliceNotificationJob = {
                    description = "Clé de job ou de groupe utilisée pour les notifications de répartition du radar de vitesse.",
                    label = "Cible de répartition",
                },
                speedCamPoliceNotificationRequireDuty = {
                    description = "Ne notifier que les cibles de répartition du radar de vitesse en service.",
                    label = "Répartition nécessite le service",
                },
                speedCamPoliceNotificationType = {
                    description = "Gravité/type de répartition utilisé pour les alertes de radar de vitesse.",
                    label = "Type de répartition",
                },
                speedCamPropModel = {
                    description = "Nom d'apparition du modèle intact du radar, par exemple sky_speedcam. Un préréglage sélectionne aussi les modèles endommagé et détruit. Les modèles personnalisés doivent être disponibles dans le jeu.",
                    label = "Modèle de prop radar",
                    custom = "Modèle personnalisé",
                    choose = "Choisir un modèle",
                    preview = "Aperçu 3D",
                    customPlaceholder = "Nom de spawn du prop",
                    previewDescription = "Affiche le prop choisi en jeu. L'aperçu ne sauvegarde rien.",
                    invalidModel = "Saisissez d'abord un nom de prop valide.",
                    modelMissing = "Ce modèle de prop n'est pas disponible en jeu.",
                    previewFailed = "Impossible d'ouvrir l'aperçu du modèle.",
                    intact = "Modèle intact",
                    previewRequiresGame = "Ouvrez /jobconfig dans FiveM pour voir le prop en direct.",
                    previewHelp = "Flèches : déplacer ; Page haut/bas : hauteur ; molette : pivoter ; Entrée : fermer ; Retour arrière : annuler.",
                    options = {
                        sky_speedcam = "Radar standard",
                        sky_germ_speedcam = "Radar allemand",
                    },
                },
                speedCamPropModelDamaged = {
                    description = "Nom d'apparition du modèle endommagé du radar, par exemple sky_speedcam2. Choisissez une variante correspondant au modèle intact.",
                    label = "Modèle de prop endommagé",
                },
                speedCamPropModelDestroyed = {
                    description = "Nom du modèle affiché lorsque la durabilité du radar atteint 0, par exemple sky_speedcam1. Choisissez une variante correspondant au modèle intact.",
                    label = "Modèle de prop détruit",
                },
                speedCamRepairAnimDict = {
                    description = "Dictionnaire d'animation utilisé lors de la réparation des radars de vitesse.",
                    label = "Dictionnaire d'animation de réparation",
                },
                speedCamRepairAnimFlag = {
                    description = "Indicateur d'animation utilisé lors de la réparation des radars de vitesse.",
                    label = "Indicateur d'animation de réparation",
                },
                speedCamRepairAnimName = {
                    description = "Nom de l'animation utilisée lors de la réparation des radars de vitesse.",
                    label = "Nom de l'animation de réparation",
                },
                speedCamRepairCancelDelayMs = {
                    description = "Millisecondes avant que la réparation du radar de vitesse ne puisse être annulée.",
                    label = "Délai d'annulation de réparation",
                },
                speedCamRepairDistance = {
                    description = "Distance utilisée pour réparer les radars de vitesse.",
                    label = "Distance de réparation",
                },
                speedCamRepairItem = {
                    description = "Nom interne exact de l'objet de réparation, par exemple fixtool. Saisissez la clé de l'objet, pas son nom affiché.",
                    label = "Nom de l'objet de réparation",
                },
                speedCamRepairPerTick = {
                    description = "Durabilité restaurée par tic de réparation du radar de vitesse.",
                    label = "Réparation par tic",
                },
                speedCamRepairTickMs = {
                    description = "Millisecondes entre les tics de réparation du radar de vitesse.",
                    label = "Intervalle de réparation",
                },
                speedCamStreamDistance = {
                    description = "Distance au joueur en mètres dans laquelle les modèles des radars sont chargés. Au-delà, les modèles sont déchargés ; les radars enregistrés restent en place.",
                    label = "Distance de chargement",
                },
                speedCamTriggerRadius = {
                    description = "Rayon de détection en mètres autour du radar pour les véhicules en excès de vitesse.",
                    label = "Rayon de déclenchement",
                },
                speedCamUseMph = {
                    description = "Afficher et traiter les limites du radar de vitesse en MPH.",
                    label = "Utiliser MPH",
                },
                speedCamWeaponDamageRestrictionAllowedWeapons = {
                    description = "Armes autorisées à endommager les radars de vitesse tant que la restriction est activée.",
                    itemLabel = "Arme",
                    label = "Armes autorisées",
                },
                speedCamWeaponDamageRestrictionEnabled = {
                    description = "Seules les armes listées peuvent endommager les radars de vitesse tant que ceci est activé.",
                    label = "Restriction activée",
                },
                speedCameraAppClearDistanceMeters = {
                    description = "Distance en mètres avant d'effacer les avertissements de radar de vitesse.",
                    label = "Distance d'effacement",
                },
                speedCameraAppDefaultApp = {
                    description = "Afficher l'application radar de vitesse comme application par défaut de la tablette.",
                    label = "Application par défaut",
                },
                speedCameraAppDescription = {
                    description = "Description affichée pour l'application radar de vitesse de la tablette.",
                    label = "Descriptif",
                },
                speedCameraAppDeveloper = {
                    description = "Étiquette de développeur affichée pour l'application radar de vitesse de la tablette.",
                    label = "Développeur",
                },
                speedCameraAppEnabled = {
                    description = "Activer l'application radar de vitesse de la tablette policière.",
                    label = "Application radar de vitesse tablette",
                },
                speedCameraAppHeaderEyebrow = {
                    description = "Sur-titre d'en-tête affiché dans l'application radar de vitesse.",
                    label = "Sur-titre de l'en-tête",
                },
                speedCameraAppHeaderTitle = {
                    description = "Titre d'en-tête affiché dans l'application radar de vitesse.",
                    label = "Titre de l'en-tête",
                },
                speedCameraAppIcon = {
                    description = "Chemin de l'icône utilisé pour l'application radar de vitesse de la tablette.",
                    label = "Chemin de l'icône",
                },
                speedCameraAppIdentifier = {
                    description = "Identifiant interne de l'application radar de vitesse de la tablette.",
                    label = "Identifiant",
                },
                speedCameraAppInFrontDot = {
                    description = "Seuil de produit scalaire utilisé pour déterminer si un radar de vitesse est devant le joueur.",
                    label = "Seuil de produit scalaire devant",
                },
                speedCameraAppMinimumVehicleSpeedKmh = {
                    description = "Vitesse minimale du véhicule avant que les avertissements ne soient affichés.",
                    label = "Vitesse minimale du véhicule",
                },
                speedCameraAppName = {
                    description = "Nom affiché de l'application radar de vitesse de la tablette.",
                    label = "Nom de l'application",
                },
                speedCameraAppNotifyDistanceMeters = {
                    description = "Distance en mètres avant de notifier des radars de vitesse à proximité.",
                    label = "Distance de notification",
                },
                speedCameraAppOnlyInVehicle = {
                    description = "N'avertir des radars de vitesse que lorsque le joueur est dans un véhicule.",
                    label = "Uniquement en véhicule",
                },
                speedCameraAppOverlayBackground = {
                    description = "Couleur de fond utilisée pour la superposition d'image de plaque.",
                    label = "Fond de superposition",
                },
                speedCameraAppOverlayBorder = {
                    description = "Couleur de bordure utilisée pour la superposition d'image de plaque.",
                    label = "Bordure de superposition",
                },
                speedCameraAppOverlayColor = {
                    description = "Couleur de texte utilisée pour la superposition d'image de plaque.",
                    label = "Couleur de superposition",
                },
                speedCameraAppOverlayEnabled = {
                    description = "Activer les superpositions d'image de plaque sur les images de radar de vitesse capturées.",
                    label = "Superposition activée",
                },
                speedCameraAppOverlayFontScale = {
                    description = "Échelle de police utilisée pour la superposition d'image de plaque.",
                    label = "Échelle de police de superposition",
                },
                speedCameraAppOverlayX = {
                    description = "Position X normalisée de la superposition de gauche à droite.",
                    label = "Superposition X",
                },
                speedCameraAppOverlayY = {
                    description = "Position Y normalisée de la superposition de haut en bas.",
                    label = "Superposition Y",
                },
                speedCameraAppRequireInFront = {
                    description = "N'avertir que pour les radars de vitesse situés devant le joueur.",
                    label = "Exiger devant",
                },
                speedCameraAppRoute = {
                    description = "Chemin de routeur ouvert par l'application radar de vitesse de la tablette.",
                    label = "Itinéraire",
                },
                speedCameraAppSize = {
                    description = "Taille de stockage rapportée pour l'application radar de vitesse de la tablette.",
                    label = "Taille de l'application",
                },
                speedCameraAppSoundCoord = {
                    description = "Jouer les sons d'avertissement de radar de vitesse aux coordonnées du monde.",
                    label = "Son aux coordonnées",
                },
                speedCameraAppSoundEnabled = {
                    description = "Activer les sons d'avertissement pour l'application radar de vitesse.",
                    label = "Son activé",
                },
                speedCameraAppSoundFrontend = {
                    description = "Jouer les sons d'avertissement de radar de vitesse sur le canal audio frontend.",
                    label = "Son frontend",
                },
                speedCameraAppSoundLayers = {
                    description = "Nombre de sons d'avertissement superposés joués par l'application radar de vitesse.",
                    label = "Couches sonores",
                },
                speedCameraAppSoundName = {
                    description = "Nom du son utilisé pour les avertissements de l'application radar de vitesse.",
                    label = "Nom du son",
                },
                speedCameraAppSoundRange = {
                    description = "Portée utilisée pour les sons d'avertissement de l'application radar de vitesse.",
                    label = "Portée du son",
                },
                speedCameraAppSoundRepeatCount = {
                    description = "Nombre de fois que le son d'avertissement de radar de vitesse se répète.",
                    label = "Nombre de répétitions",
                },
                speedCameraAppSoundRepeatDelayMs = {
                    description = "Millisecondes entre les répétitions du son d'avertissement de radar de vitesse.",
                    label = "Délai de répétition",
                },
                speedCameraAppSoundSet = {
                    description = "Ensemble sonore utilisé pour les avertissements de l'application radar de vitesse.",
                    label = "Ensemble sonore",
                },
                speedCameraAppSubscriptionAccount = {
                    description = "Compte utilisé pour les paiements d'abonnement de l'application radar de vitesse de la tablette.",
                    label = "Compte",
                },
                speedCameraAppSubscriptionEnabled = {
                    description = "Activer les abonnements payants pour l'application radar de vitesse de la tablette.",
                    label = "Abonnement activé",
                },
                speedCameraAppSubscriptionIntervalDays = {
                    description = "Jours entre les renouvellements d'abonnement de l'application radar de vitesse de la tablette.",
                    label = "Jours d'intervalle",
                },
                speedCameraAppSubscriptionPrice = {
                    description = "Prix facturé pour l'abonnement à l'application radar de vitesse de la tablette.",
                    label = "Prix de l'abonnement",
                },
                speedCameraAppThemeAccent = {
                    description = "Couleur d'accent utilisée par l'application radar de vitesse.",
                    label = "Accent",
                },
                speedCameraAppThemeBackground = {
                    description = "Fond en dégradé linéaire utilisé par l'application radar de vitesse.",
                    label = "Fond",
                },
                speedCameraAppThemeBorder = {
                    description = "Couleur de bordure utilisée par l'application radar de vitesse.",
                    label = "Bordure",
                },
                speedCameraAppThemeButtonText = {
                    description = "Couleur de texte de bouton utilisée par l'application radar de vitesse.",
                    label = "Texte du bouton",
                },
                speedCameraAppThemeDanger = {
                    description = "Couleur de danger utilisée par l'application radar de vitesse.",
                    label = "Danger",
                },
                speedCameraAppThemeGhost = {
                    description = "Couleur du bouton fantôme utilisée par l'application radar de vitesse.",
                    label = "Fantôme",
                },
                speedCameraAppThemeGhostText = {
                    description = "Couleur de texte fantôme utilisée par l'application radar de vitesse.",
                    label = "Texte fantôme",
                },
                speedCameraAppThemeGradientSoft = {
                    description = "Couleur de dégradé doux utilisée par l'application radar de vitesse.",
                    label = "Dégradé doux",
                },
                speedCameraAppThemeInactiveBorder = {
                    description = "Couleur de bordure inactive utilisée par l'application radar de vitesse.",
                    label = "Bordure inactive",
                },
                speedCameraAppThemeModal = {
                    description = "Couleur de fond de la modale utilisée par l'application radar de vitesse.",
                    label = "Modale",
                },
                speedCameraAppThemeMutedText = {
                    description = "Couleur de texte atténuée utilisée par l'application radar de vitesse.",
                    label = "Texte atténué",
                },
                speedCameraAppThemeOverlay = {
                    description = "Couleur de superposition utilisée par l'application radar de vitesse.",
                    label = "Superposition",
                },
                speedCameraAppThemePillText = {
                    description = "Couleur de texte de badge utilisée par l'application radar de vitesse.",
                    label = "Texte de badge",
                },
                speedCameraAppThemePrimaryFrom = {
                    description = "Couleur de début du dégradé principal utilisée par l'application radar de vitesse.",
                    label = "Dégradé principal départ",
                },
                speedCameraAppThemePrimaryTo = {
                    description = "Couleur de fin du dégradé principal utilisée par l'application radar de vitesse.",
                    label = "Dégradé principal fin",
                },
                speedCameraAppThemeShadow = {
                    description = "Couleur d'ombre utilisée par l'application radar de vitesse.",
                    label = "Ombre",
                },
                speedCameraAppThemeSpotlight = {
                    description = "Couleur d'accent projecteur utilisée par l'application radar de vitesse.",
                    label = "Projecteur",
                },
                speedCameraAppThemeSubtleText = {
                    description = "Couleur de texte discrète utilisée par l'application radar de vitesse.",
                    label = "Texte discret",
                },
                speedCameraAppThemeSuccess = {
                    description = "Couleur de succès utilisée par l'application radar de vitesse.",
                    label = "Succès",
                },
                speedCameraAppThemeSurface = {
                    description = "Couleur de surface utilisée par l'application radar de vitesse.",
                    label = "Surface",
                },
                speedCameraAppThemeSurfaceSoft = {
                    description = "Couleur de surface douce utilisée par l'application radar de vitesse.",
                    label = "Surface douce",
                },
                speedCameraAppThemeText = {
                    description = "Couleur de texte principale utilisée par l'application radar de vitesse.",
                    label = "Texte",
                },
                speedCameraAppWarningUiAccent = {
                    description = "Couleur d'accent RGBA utilisée pour l'interface d'avertissement de radar de vitesse.",
                    label = "Accent RGBA",
                },
                speedCameraAppWarningUiBackground = {
                    description = "Couleur RGBA utilisée pour le fond de l'interface d'avertissement de radar de vitesse.",
                    label = "Fond RGBA",
                },
                speedCameraAppWarningUiIcon = {
                    description = "Couleur d'icône RGBA utilisée pour l'interface d'avertissement de radar de vitesse.",
                    label = "Icône RGBA",
                },
                speedCameraAppWarningUiIconText = {
                    description = "Couleur de texte d'icône RGBA utilisée pour l'interface d'avertissement de radar de vitesse.",
                    label = "Texte d'icône RGBA",
                },
                speedCameraAppWarningUiSeconds = {
                    description = "Secondes pendant lesquelles l'interface d'avertissement reste visible.",
                    label = "Secondes de l'interface d'avertissement",
                },
                speedCameraAppWarningUiSubText = {
                    description = "Couleur de sous-texte RGBA utilisée pour l'interface d'avertissement de radar de vitesse.",
                    label = "Sous-texte RGBA",
                },
                speedCameraAppWarningUiText = {
                    description = "Couleur de texte RGBA utilisée pour l'interface d'avertissement de radar de vitesse.",
                    label = "Texte RGBA",
                },
                speedCameraAppWarningUiTitle = {
                    description = "Couleur de titre RGBA utilisée pour l'interface d'avertissement de radar de vitesse.",
                    label = "Titre RGBA",
                },
                spikeStripsCheckIntervalMs = {
                    description = "Millisecondes entre les vérifications de proximité des herses.",
                    label = "Intervalle de vérification",
                },
                spikeStripsEnabled = {
                    description = "Activer les herses déployées.",
                    label = "Herses",
                },
                spikeStripsModels = {
                    description = "Modèles de props traités comme des herses actives.",
                    itemLabel = "Modèle",
                    label = "Modèles",
                },
                spikeStripsRetryIntervalMs = {
                    description = "Millisecondes avant que le scan des herses ne recommence après aucune correspondance.",
                    label = "Intervalle de nouvelle tentative",
                },
                spikeStripsScanDistance = {
                    description = "Distance utilisée pour scanner les herses à proximité.",
                    label = "Distance de scan",
                },
                spikeStripsTriggerDistance = {
                    description = "Distance à laquelle les pneus sont crevés par une herse.",
                    label = "Distance de déclenchement",
                },
                stationCreatorBlipCategoryLabel = {
                    description = "Étiquette de catégorie utilisée pour les blips du créateur de station.",
                    label = "Catégorie du blip de station",
                },
                stationCreatorBlipColor = {
                    description = "Couleur de blip sur la carte utilisée pour les commissariats.",
                    label = "Couleur du blip de station",
                },
                stationCreatorBlipScale = {
                    description = "Échelle utilisée pour les blips des commissariats.",
                    label = "Échelle du blip de station",
                },
                stationCreatorBlipShortRange = {
                    description = "N'afficher les blips de station qu'à courte portée.",
                    label = "Blip de station courte portée",
                },
                stationCreatorBlipSprite = {
                    description = "Sprite de blip sur la carte utilisé pour les commissariats.",
                    label = "Sprite du blip de station",
                },
                stationCreatorBlipUseStationName = {
                    description = "Utiliser le nom de station configuré pour l'étiquette du blip de la carte.",
                    label = "Utiliser le nom de la station",
                },
                tabletAutoFillCitizens = {
                    description = "Préremplir le registre des citoyens depuis la base de données du framework.",
                    label = "Remplissage auto des citoyens",
                },
                tabletAutoFillVehicles = {
                    description = "Préremplir le registre des véhicules depuis la base de données du framework.",
                    label = "Remplissage auto des véhicules",
                },
                tabletBolos = {
                    description = "Afficher l'application BOLO.",
                    label = "Avis de recherche",
                },
                tabletCases = {
                    description = "Afficher l'application des dossiers.",
                    label = "Dossiers",
                },
                tabletCitizens = {
                    description = "Afficher l'application du registre des citoyens.",
                    label = "Citoyens",
                },
                tabletConfiscations = {
                    description = "Afficher le registre des objets saisis lors des fouilles.",
                    label = "Saisies",
                },
                tabletOffences = {
                    description = "Afficher l'application des infractions.",
                    label = "Infractions",
                },
                tabletPrison = {
                    description = "Afficher l'application prison.",
                    label = "Prison",
                },
                tabletReportEnforcement = {
                    description = "Permet d'attribuer des infractions et d'appliquer amendes ou peines depuis les rapports enregistrés.",
                    label = "Exécution des rapports",
                },
                tabletReports = {
                    description = "Afficher l'application des rapports.",
                    label = "Rapports",
                },
                tabletSocialWork = {
                    description = "Afficher l'application de travail social.",
                    label = "Travail social",
                },
                tabletVehicles = {
                    description = "Afficher l'application du registre des véhicules.",
                    label = "Véhicules",
                },
                tabletWarrants = {
                    description = "Afficher l'application des mandats.",
                    label = "Mandats",
                },
                tabletWeapons = {
                    description = "Afficher l'application du registre des armes.",
                    label = "Armes",
                },
                tackleCommand = {
                    description = "Commande enregistrée pour plaquer la personne la plus proche. Saisissez son nom sans barre oblique.",
                    label = "Commande de plaquage",
                },
                tackleCuffCommand = {
                    description = "Commande enregistrée pour menotter la personne maintenue après un plaquage. Saisissez son nom sans barre oblique.",
                    label = "Commande de menottage après plaquage",
                },
                tackleCuffDescription = {
                    description = "Description affichée pour le raccourci de menottage après plaquage dans les paramètres de touches FiveM.",
                    label = "Description du raccourci de menottage",
                },
                tackleCuffKey = {
                    description = "Touche clavier par défaut pour menotter la personne maintenue après un plaquage.",
                    label = "Touche de menottage après plaquage",
                },
                tackleDescription = {
                    description = "Description affichée pour ce raccourci dans les paramètres de touches FiveM.",
                    label = "Description du raccourci de plaquage",
                },
                tackleEnabled = {
                    description = "Permet de plaquer la personne la plus proche et de la maintenir au sol.",
                    label = "Plaquage",
                },
                tackleKey = {
                    description = "Touche clavier par défaut de la commande de plaquage.",
                    label = "Touche de plaquage",
                },
                tackleMaxDistance = {
                    description = "Distance maximale de la cible au début du plaquage.",
                    label = "Distance de plaquage",
                },
                tackleNeedsSprint = {
                    description = "Exige que l'agent soit en train de sprinter avant de plaquer une personne.",
                    label = "Course requise pour plaquer",
                },
                tackleReleaseCommand = {
                    description = "Commande enregistrée pour libérer la personne maintenue après un plaquage. Saisissez son nom sans barre oblique.",
                    label = "Commande de libération après plaquage",
                },
                tackleReleaseDescription = {
                    description = "Description affichée pour le raccourci de libération après plaquage dans les paramètres de touches FiveM.",
                    label = "Description du raccourci de libération",
                },
                tackleReleaseKey = {
                    description = "Touche clavier par défaut pour libérer la personne maintenue après un plaquage.",
                    label = "Touche de libération après plaquage",
                },
                tackleRequireOnDuty = {
                    description = "Exige que l'agent soit en service avant de pouvoir plaquer une personne.",
                    label = "Service requis pour plaquer",
                },
                vehicleRadarAlertCooldownMs = {
                    description = "Millisecondes avant qu'une autre alerte radar puisse être déclenchée.",
                    label = "Délai d'alerte",
                },
                vehicleRadarAllowedVehicleClasses = {
                    description = "Classes de véhicules autorisées à utiliser le radar.",
                    label = "Classes de véhicules autorisées",
                },
                vehicleRadarAutoFastLock = {
                    description = "Marquer automatiquement les cibles très rapides dans le radar.",
                    label = "Verrouillage rapide auto",
                },
                vehicleRadarAutoFastLockThreshold = {
                    description = "Seuil de vitesse utilisé pour le verrouillage rapide automatique.",
                    label = "Seuil de verrouillage rapide",
                },
                vehicleRadarCustomizeCommand = {
                    description = "Commande utilisée pour ouvrir ou fermer l'éditeur de disposition du radar. Saisissez son nom sans barre oblique.",
                    label = "Commande de disposition du radar",
                },
                vehicleRadarDecreaseLimitKey = {
                    description = "Association de touche utilisée pour diminuer la limite de vitesse du radar.",
                    label = "Touche de diminution de limite",
                },
                vehicleRadarDefaultLimit = {
                    description = "Limite de vitesse par défaut utilisée par le radar véhicule.",
                    label = "Limite radar par défaut",
                },
                vehicleRadarEnabled = {
                    description = "Activer le radar du véhicule de patrouille.",
                    label = "Radar véhicule",
                },
                vehicleRadarIncreaseLimitKey = {
                    description = "Association de touche utilisée pour augmenter la limite de vitesse du radar.",
                    label = "Touche d'augmentation de limite",
                },
                vehicleRadarLimitStep = {
                    description = "Quantité modifiée par ajustement de la limite radar.",
                    label = "Pas de limite",
                },
                vehicleRadarLockFrontKey = {
                    description = "Association de touche utilisée pour verrouiller la cible du radar avant.",
                    label = "Touche verrouillage avant",
                },
                vehicleRadarLockRearKey = {
                    description = "Association de touche utilisée pour verrouiller la cible du radar arrière.",
                    label = "Touche verrouillage arrière",
                },
                vehicleRadarMaxLimit = {
                    description = "Limite de vitesse maximale autorisée dans le radar véhicule.",
                    label = "Limite radar maximum",
                },
                vehicleRadarMaxPitchDeg = {
                    description = "Inclinaison maximale autorisée pour le ciblage radar.",
                    label = "Degrés d'inclinaison max",
                },
                vehicleRadarMinLimit = {
                    description = "Limite de vitesse minimale autorisée dans le radar véhicule.",
                    label = "Limite radar minimum",
                },
                vehicleRadarMinTargetSpeed = {
                    description = "Vitesse minimale avant que le radar ne considère une cible valide.",
                    label = "Vitesse cible minimale",
                },
                vehicleRadarModeFrontKey = {
                    description = "Association de touche utilisée pour changer le mode radar avant.",
                    label = "Touche mode avant",
                },
                vehicleRadarModeRearKey = {
                    description = "Association de touche utilisée pour changer le mode radar arrière.",
                    label = "Touche mode arrière",
                },
                vehicleRadarMovingScanIntervalMs = {
                    description = "Millisecondes entre les scans du radar pendant que le véhicule de patrouille est en mouvement.",
                    label = "Intervalle de scan en mouvement",
                },
                vehicleRadarPassengerControl = {
                    description = "Autoriser les passagers à contrôler le radar véhicule.",
                    label = "Contrôle passager",
                },
                vehicleRadarPassengerEnabled = {
                    description = "Autoriser les passagers à voir les données radar en miroir.",
                    label = "Miroir passager",
                },
                vehicleRadarPassengerSyncIntervalMs = {
                    description = "Millisecondes entre les mises à jour de synchronisation du radar pour les passagers.",
                    label = "Intervalle de synchro passager",
                },
                vehicleRadarProjectionThreshold = {
                    description = "Seuil de projection utilisé lors de l'évaluation des cibles radar.",
                    label = "Seuil de projection",
                },
                vehicleRadarRequireLineOfSight = {
                    description = "Exiger une ligne de vue dégagée avant que le radar ne verrouille une cible.",
                    label = "Exiger la ligne de vue",
                },
                vehicleRadarRequireOnDuty = {
                    description = "Exiger l'état de service avant d'utiliser le radar véhicule.",
                    label = "Radar nécessite le service",
                },
                vehicleRadarResetLayoutCommand = {
                    description = "Commande utilisée pour restaurer la disposition par défaut du radar. Saisissez son nom sans barre oblique.",
                    label = "Commande de réinitialisation du radar",
                },
                vehicleRadarScanIntervalMs = {
                    description = "Millisecondes entre les scans du radar à l'arrêt.",
                    label = "Intervalle de scan",
                },
                vehicleRadarScanRadius = {
                    description = "Rayon de scan du radar véhicule.",
                    label = "Rayon de scan",
                },
                vehicleRadarToggleKey = {
                    description = "Association de touche utilisée pour basculer le radar véhicule.",
                    label = "Touche de bascule",
                },
                vehicleRadarUseMph = {
                    description = "Afficher les valeurs de vitesse du radar en MPH.",
                    label = "Radar utilise MPH",
                },
                vehicleRadarVehiclePoolRefreshMs = {
                    description = "Millisecondes entre les rafraîchissements du pool de véhicules à proximité.",
                    label = "Rafraîchissement du pool de véhicules",
                },
                vehicleRadarXmitFrontKey = {
                    description = "Association de touche utilisée pour XMIT/HOLD du radar avant.",
                    label = "Touche XMIT avant",
                },
                vehicleRadarXmitRearKey = {
                    description = "Association de touche utilisée pour XMIT/HOLD du radar arrière.",
                    label = "Touche XMIT arrière",
                },
                wheelClampConsumeItem = {
                    description = "Retirer l'objet sabot de roue après la pose.",
                    label = "Consommer l'objet sabot",
                },
                wheelClampEnabled = {
                    description = "Activer l'action de pose du sabot de roue.",
                    label = "Sabot de roue",
                },
                wheelClampItem = {
                    description = "Objet d'inventaire utilisé pour la pose du sabot de roue.",
                    label = "Objet sabot",
                },
                wheelClampPropModel = {
                    description = "Modèle de prop utilisé pour le sabot de roue posé.",
                    label = "Modèle de prop du sabot",
                },
                wheelClampRequireItem = {
                    description = "Exiger l'objet sabot de roue configuré. Garder cette option activée lorsque le mode d'utilisation du sabot est réglé sur Inventaire ou Les deux.",
                    label = "Sabot nécessite l'objet",
                },
                wheelClampRequireOnDuty = {
                    description = "Exiger l'état de service avant de poser des sabots de roue.",
                    label = "Sabot nécessite le service",
                },
                wheelClampTyreDistance = {
                    description = "Distance maximale du pneu lors de la pose ou du soudage d'un sabot.",
                    label = "Distance du pneu",
                },
                wheelClampUseItem = {
                    description = "Utiliser le radial, l'inventaire ou les deux pour la pose du sabot de roue. Inventaire ou Les deux doivent être associés à Sabot nécessite l'objet.",
                    label = "Mode d'utilisation du sabot",
                    options = {
                        both = "Les deux",
                        inventory = "Inventaire",
                        radial = "Radial",
                    },
                },
                wheelClampVehicleDistance = {
                    description = "Distance maximale du véhicule cible lors de la pose d'un sabot.",
                    label = "Distance du véhicule",
                },
                wheelClampWeldBurstTyre = {
                    description = "Faire éclater le pneu après le soudage d'un sabot.",
                    label = "Crever le pneu",
                },
                wheelClampWeldDurationMs = {
                    description = "Millisecondes nécessaires pour retirer un sabot par soudure.",
                    label = "Durée de soudure",
                },
                wheelClampWeldEnabled = {
                    description = "Autoriser le retrait des sabots de roue à l'aide d'un poste à souder.",
                    label = "Soudure du sabot",
                },
                wheelClampWeldItem = {
                    description = "Objet d'inventaire requis pour souder le sabot.",
                    label = "Objet de soudure",
                },
                wheelClampWeldMinigame = {
                    description = "Exiger le mini-jeu de soudure du sabot avant que le retrait ne se termine.",
                    label = "Mini-jeu de soudure",
                },
                ziptiesConsumeItem = {
                    description = "Retirer un objet attache zip lorsqu'il est appliqué.",
                    label = "Consommer les attaches zip",
                },
                ziptiesCutterConsumeItem = {
                    description = "Retirer l'objet coupe-attaches après avoir coupé les attaches zip.",
                    label = "Consommer l'objet coupe-attaches",
                },
                ziptiesCutterEnabled = {
                    description = "Autoriser les pinces coupantes à retirer les attaches zip.",
                    label = "Coupe-attaches zip",
                },
                ziptiesCutterItem = {
                    description = "Objet d'inventaire utilisé pour couper les attaches zip.",
                    label = "Objet coupe-attaches",
                },
                ziptiesEnabled = {
                    description = "Activer les actions d'attache zip.",
                    label = "Attaches zip",
                },
                ziptiesItem = {
                    description = "Objet d'inventaire utilisé pour les actions d'attache zip.",
                    label = "Objet attache zip",
                },
                ziptiesRequireHandsUp = {
                    description = "Exiger l'état mains en l'air avant d'appliquer des attaches zip.",
                    label = "Mains en l'air pour attaches zip",
                },
                ziptiesRequireItem = {
                    description = "Exiger l'objet attache zip configuré.",
                    label = "Attaches zip nécessitent l'objet",
                },
                ziptiesReturnOnRemove = {
                    description = "Restituer un objet attache zip lorsqu'il est retiré.",
                    label = "Restituer les attaches zip",
                },
                speedCamAdvancedAllowFakePlateApproval = {
                    description = "Permettre aux évaluateurs de facturer le propriétaire enregistré même lorsque la plaque capturée est marquée comme fausse ou clonée.",
                    label = "Autoriser les fausses plaques suspectées",
                },
                speedCamAdvancedPageSize = {
                    description = "Captures maximales retournées par page de tablette.",
                    label = "Taille de la page de révision",
                },
                speedCamAdvancedRecognizedSides = {
                    description = "Les côtés du véhicule dont les photos peuvent être utilisées pour la reconnaissance des plaques. Utilisez avant et/ou arrière.",
                    itemLabel = "Côté",
                    label = "Partis reconnus",
                },
                speedCamAdvancedRequireEvidence = {
                    description = "Autoriser seulement l'approbation après le téléchargement de la photo de la caméra de vitesse.",
                    label = "Besoin d'une preuve photographique",
                },
                speedCamAdvancedReviewPermission = {
                    description = "Bossmenu autorisation nécessaire pour approuver ou jeter des captures. 18 est Gérer la facturation.",
                    label = "Révision de l'autorisation ID",
                },
                speedCamAdvancedStoreUnregistered = {
                    description = "Conserver les captures dont la plaque n'est pas présente dans la base de données des véhicules immatriculés.",
                    label = "Stocker les véhicules non immatriculés",
                },
                tabletSpeedcamReviews = {
                    description = "Afficher l'application de révision de la caméra de vitesse avancée lorsque le mode avancé est activé.",
                    label = "Critiques de la caméra de vitesse",
                },
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
            warnings = {
                cuffsConsumeRequiresItem = "Les menottes de consommation n'ont pas d'effet alors que les exigences relatives aux menottes sont désactivées.",
                wheelClampUseItemRequiresItem = "Mode d'utilisation de la pince Inventaire ou les deux nécessite Clamp exige que l'article reste activé.",
                ziptiesConsumeRequiresItem = "Les fermetures à glissière de consommation n'ont pas d'effet alors que les exigences relatives aux fermetures à zip sont désactivées.",
            },
            locationDescriptions = {
                jail_public_blip = "La position reprend automatiquement le point d’apparition de la prison ou, à défaut, le premier terminal de la prison.",
            },
        },
    },
    JobConfiguratorImportFailed = "Impossible d'importer les valeurs de config.lua pour '%s': %s.",
    JobConfiguratorImportHistoryFailed = "L'importation a réussi, mais son entrée historique n'a pas pu être sauvée.",
    JobConfiguratorImportNoData = "'%s' ne fournit aucune donnée d'importation config.lua.",
    JobConfiguratorImportSuccess = "Valeurs de config.lua importées pour '%s': %d professions, %d réglage, %d fonction, et %d écarts d'interaction appliqués.",
    JobConfiguratorTitle = "Configurateur de métier",
    JobConfiguratorUnknown = "Configurateur de profession inconnu.",
}
