JobConfigLocales["sky_ambulancejob:fr"] = {
    Nui = {
        tablet = {
            apps = {
                medicalEvaluations = "Évaluations médicales",
                sharedMedicalEvaluations = "Évaluations médicales partagées",
            },
        },
        workshopConfig = {
            creatorFields = {
                hospitalBeds = {
                    allowRespawn = {
                        label = "Autoriser le respawn",
                        description = "Controle si ce lit peut etre choisi pour le respawn des joueurs.",
                    },
                },
            },
            configs = {
                sky_ambulancejob = {
                    subtitle = "Configurez les tâches d'ambulance, les lits d'hôpitaux, les systèmes de décès, les interactions et les paramètres des fonctionnalités principales.",
                    title = "Emplois Ambulanciers",
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
                minimumCrew = "Nombre minimum d'employés dans les unités sélectionnées pour ce plan d'intervention.",
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
            },
            extensions = {
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
            },
            features = {
                bleeding = {
                    description = "Activez le système de purge.",
                    label = "Saignement",
                },
                bodybags = {
                    description = "Activer les sacs mortuaires et les flux de livraison des sacs mortuaires.",
                    label = "Sacs mortuaires",
                },
                consciousScenarioBloodPressure = {
                    description = "Autoriser les contrôles de tension artérielle pendant que le patient est conscient.",
                    label = "Pression artérielle consciente",
                },
                deathTimeout = {
                    description = "Activez le flux de délai d'expiration de la mort.",
                    label = "Délai de mort",
                },
                fractures = {
                    description = "Permettre la gestion et le traitement des fractures.",
                    label = "Fractures",
                },
                knockout = {
                    description = "Activez le système knock-out.",
                    label = "Assommer",
                },
                legShotRagdoll = {
                    description = "Fait chuter le joueur lorsqu'une zone configurée de la jambe ou du pied est touchée.",
                    label = "Chute après un tir à la jambe",
                },
                pain = {
                    description = "Activez le système de douleur.",
                    label = "Douleur",
                },
                respawnInBed = {
                    description = "Respawn a réanimé les joueurs dans un lit d'hôpital lorsqu'il était disponible.",
                    label = "Réapparaître au lit",
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
                gang = "Gang",
                allowInVehicle = "Autoriser dans le véhicule",
                allowMovement = "Autoriser le mouvement",
                animDict = "Dictionnaire d'animation",
                animFlag = "Indicateur d'animation",
                animName = "Nom de l'animation",
                bleeding = "Saignement",
                cause = "Cause",
                chance = "Probabilité",
                class = "Classe",
                companyPrice = "Prix entreprise",
                companyPricePerEmployee = "Prix par employé",
                copayPercent = "Quote-part %",
                description = "Descriptif",
                dictionary = "Dictionnaire d'animation",
                duration = "Durée",
                durationMs = "Durée (ms)",
                effect = "Effet",
                effectDurationMs = "Durée de l'effet (ms)",
                effectDurationSeconds = "Durée de l'effet (secondes)",
                enabled = "Activé",
                extractionType = "Type d'extraction",
                foreignObject = "Corps étranger",
                heal = "Soin",
                id = "ID",
                itemName = "Nom de l'article",
                key = "Clé",
                label = "Étiquette",
                lang = "Langue",
                limit = "Limite",
                lossPerSecond = "Perte par seconde",
                max = "Maximum",
                min = "minimum",
                minGrade = "Note minimale",
                minigame = "Mini-jeu",
                model = "Modèle d'accessoire",
                name = "Nom du travail",
                options = "Options (types de sélection)",
                pain = "Douleur",
                pauseBleedingSeconds = "Suspendre le saignement (secondes)",
                price = "Prix",
                progressbarAllowInVehicle = "Progression : autoriser dans le véhicule",
                progressbarAllowMovement = "Progression : autoriser le mouvement",
                progressbarCanCancel = "Progression annulable",
                progressbarDisableCarMovement = "Progression : bloquer le véhicule",
                progressbarDisableCombat = "Progression : bloquer le combat",
                progressbarDisableMouse = "Progression : bloquer la souris",
                progressbarDisableMovement = "Progression : bloquer le mouvement",
                progressbarDisableSprint = "Progression : bloquer le sprint",
                progressbarDuration = "Durée de progression",
                progressbarEnabled = "Barre de progression activée",
                progressbarLabel = "Texte de progression",
                progressbarUseWhileDead = "Progression utilisable en étant mort",
                questions = "Questions",
                requireItems = "Exiger des éléments",
                required = "Requis",
                requiresExtraction = "Extraction requise",
                requiresOpenWound = "Plaie ouverte requise",
                sort = "Ordre",
                state = "État",
                stopBleeding = "Arrêter le saignement",
                threshold = "Seuil",
                time = "Temps",
                type = "Type",
                useAnimation = "Utiliser des animations",
                value = "Valeur",
                zone = "Zone",
                zones = "Zones",
                systolic = "Pression systolique",
                diastolic = "Pression diastolique",
                cardiacArrest = "Arrêt cardiaque",
            },
            settingGroups = {
                appointmentsGeneral = {
                    label = "Général",
                },
                appointmentsLimits = {
                    label = "Limites",
                },
                appointmentsNotifications = {
                    label = "Notifications",
                },
                appointmentsScheduling = {
                    label = "Planification",
                },
                billingGeneral = {
                    label = "Général",
                },
                billingRange = {
                    label = "Gamme",
                },
                billingReasons = {
                    label = "Préréglages de raison",
                },
                billingUi = {
                    label = "UI",
                },
                bodyBagAnimation = {
                    label = "Animation",
                },
                bodyBagAttachGeneral = {
                    label = "Attacher",
                },
                bodyBagAttachOffsets = {
                    label = "Compensations",
                },
                bodyBagAttachRotation = {
                    label = "Rotation",
                },
                bodyBagDeliveryGeneral = {
                    label = "Général",
                },
                bodyBagDeliveryRewardGeneral = {
                    label = "Général",
                },
                bodyBagDeliveryRewardPayment = {
                    label = "Paiement",
                },
                bodyBagDeliveryUi = {
                    label = "UI",
                },
                bodyBagGeneral = {
                    label = "Général",
                },
                crutchAssign = {
                    label = "Affectation",
                },
                crutchDuration = {
                    label = "Durée",
                },
                crutchGeneral = {
                    label = "Général",
                },
                crutchItems = {
                    label = "Article",
                },
                crutchRestrictions = {
                    label = "Restrictions",
                },
                damageHandlingBladeWeapons = {
                    label = "Armes à lame",
                },
                damageHandlingBleedingBlacklist = {
                    label = "Liste noire des saignements",
                },
                damageHandlingBleedingClasses = {
                    label = "Cours de saignement",
                },
                damageHandlingBloodSystem = {
                    label = "Système sanguin",
                },
                damageHandlingDeathInjuries = {
                    label = "Blessures mortelles",
                },
                damageHandlingInjuryEffects = {
                    label = "Effets des blessures",
                },
                damageHandlingInjuryThresholds = {
                    label = "Seuils de blessures",
                },
                damageHandlingLegShotRagdoll = {
                    label = "Ragdoll tir dans la jambe",
                },
                damageHandlingLegShotRagdollZones = {
                    label = "Zones de tir dans la jambe",
                },
                damageHandlingLiveDamageFractures = {
                    label = "Fractures avec dommages réels",
                },
                damageHandlingLiveDamageFracturesZones = {
                    label = "Chances de zone",
                },
                damageHandlingLiveOpenWoundStacks = {
                    label = "Accumulations de plaies ouvertes",
                },
                damageHandlingLiveOpenWoundStacksZones = {
                    label = "Limites par zone",
                },
                damageHandlingLiveWoundBleedingClass = {
                    label = "Cours sur les blessures vivantes",
                },
                damageHandlingMedications = {
                    label = "Médicaments",
                },
                damageHandlingPainClasses = {
                    label = "Cours sur la douleur",
                },
                damageHandlingPainEffects = {
                    label = "Effets de la douleur",
                },
                damageHandlingStatusEffects = {
                    label = "Effets de statut",
                },
                damageHandlingVehicleDamage = {
                    label = "Dommages au véhicule",
                },
                damageHandlingVehicleImpactCauses = {
                    label = "Causes des dommages",
                },
                damageHandlingVehicleImpactInjuries = {
                    label = "Blessures",
                },
                damageHandlingVehicleImpactProtection = {
                    label = "Protection contre les chocs du véhicule",
                },
                deathAnimal = {
                    label = "Repli des animaux",
                },
                deathAnimalAnimation = {
                    label = "Animation animale",
                },
                deathAnimation = {
                    label = "Animation",
                },
                deathGeneral = {
                    label = "Général",
                },
                deathModels = {
                    label = "Remplacements par modèle",
                },
                deathScreenAiMedic = {
                    label = "Général",
                },
                deathScreenAiMedicAvailability = {
                    label = "Disponibilité",
                },
                deathScreenAiMedicBehaviour = {
                    label = "Comportement",
                },
                deathScreenAiMedicForceRevive = {
                    label = "Forcer la réanimation",
                },
                deathScreenAiMedicPayment = {
                    label = "Paiement",
                },
                deathScreenAiMedicReviveInBed = {
                    label = "Revivre au lit",
                },
                deathScreenAiMedicSpawn = {
                    label = "Frayer",
                },
                deathScreenAiMedicTiming = {
                    label = "Délais",
                },
                deathScreenControls = {
                    label = "Contrôles",
                },
                deathScreenDamageLogs = {
                    label = "Journaux de dégâts",
                },
                deathScreenDimensions = {
                    label = "Dimensions",
                },
                deathScreenDispatch = {
                    label = "Expédition",
                },
                deathScreenEarlyRespawn = {
                    label = "Général",
                },
                deathScreenEarlyRespawnAvailability = {
                    label = "Disponibilité",
                },
                deathScreenEarlyRespawnPayment = {
                    label = "Paiement",
                },
                deathScreenGeneral = {
                    label = "Général",
                },
                deathScreenHospitalSelection = {
                    label = "Sélection d'hôpital",
                },
                deathScreenHospitalSelectionCamera = {
                    label = "Caméra de sélection",
                },
                deathScreenInformation = {
                    label = "Général",
                },
                deathScreenIntegration = {
                    label = "Intégration",
                },
                deathScreenLogs = {
                    label = "Journaux de décès",
                },
                deathScreenMinigame = {
                    label = "Mini-jeu",
                },
                deathScreenRespawn = {
                    label = "Général",
                },
                deathScreenRespawnAccounts = {
                    label = "Comptes",
                },
                deathScreenRespawnFallback = {
                    label = "Coordonnées de secours",
                },
                deathScreenRespawnItems = {
                    label = "Articles",
                },
                deathScreenRespawnWeapons = {
                    label = "Armes",
                },
                deathScreenStyle = {
                    label = "Style d'écran de mort",
                },
                deathScreenVoice = {
                    label = "Voix",
                },
                deathTimeoutGeneral = {
                    label = "Général",
                },
                deathTimeoutWhitelist = {
                    label = "Emplois sur liste blanche",
                },
                diagnoseAnim = {
                    label = "Animation",
                },
                diagnoseCpr = {
                    label = "CPR",
                },
                diagnoseFullHeal = {
                    label = "Soin complet",
                },
                diagnoseGeneral = {
                    label = "Général",
                },
                doctorNpcAvailability = {
                    label = "Disponibilité",
                },
                doctorNpcGeneral = {
                    label = "Général",
                },
                doctorNpcHealOther = {
                    label = "Guérir les autres",
                },
                doctorNpcHealSelf = {
                    label = "Guérir soi-même",
                },
                doctorNpcRanges = {
                    description = "Ces distances ne contrôlent pas la distance à laquelle un joueur doit se trouver pour ouvrir l'interaction médecin-PNJ. Ils ne s'appliquent qu'après l'ouverture du menu du médecin.",
                    label = "Gammes",
                },
                doctorNpcRevive = {
                    label = "Relancer",
                },
                doctorNpcReviveInBed = {
                    label = "Revivre au lit",
                },
                firstAidAnimation = {
                    label = "Animation",
                },
                firstAidGeneral = {
                    label = "Général",
                },
                firstAidLicenseAdd = {
                    label = "Ajouter une licence",
                },
                firstAidLicenseRemove = {
                    label = "Supprimer la licence",
                },
                firstAidPosition = {
                    label = "Poste",
                },
                healthCompatibility = {
                    label = "Compatibilité de santé",
                },
                healthInsuranceExpiration = {
                    label = "Expiration",
                },
                healthInsuranceGeneral = {
                    label = "Général",
                },
                healthInsurancePayment = {
                    label = "Paiement",
                },
                healthInsuranceProviders = {
                    label = "Fournisseurs",
                },
                hospitalBedsBedAnimation = {
                    label = "Animation de lit",
                },
                hospitalBedsCreator = {
                    label = "Créateur",
                },
                hospitalBedsDistances = {
                    label = "Distances",
                },
                hospitalBedsGeneral = {
                    label = "Général",
                },
                hospitalBedsGetupAnimation = {
                    label = "Animation de mise en place",
                },
                hospitalBedsModels = {
                    label = "Modèles",
                },
                hospitalBedsOffsets = {
                    label = "Compensations",
                },
                hospitalBlip = {
                    label = "Extrait de l'hôpital",
                },
                imagingGeneral = {
                    label = "Général",
                },
                imagingRanges = {
                    label = "Gammes",
                },
                keybinds = {
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                    label = "Raccourcis",
                },
                knockoutGeneral = {
                    label = "Général",
                },
                knockoutWeapons = {
                    label = "Armes",
                },
                medicCarryAttach = {
                    label = "Attacher",
                },
                medicCarryAttachOffsets = {
                    label = "Compensations",
                },
                medicCarryAttachRotation = {
                    label = "Rotation",
                },
                medicCarryCarrierAnimation = {
                    label = "Animation du porteur",
                },
                medicCarryGeneral = {
                    label = "Général",
                },
                medicCarryPassengerAnimation = {
                    label = "Animation des passagers",
                },
                medicCarryRestrictions = {
                    label = "Restrictions",
                },
                medicRevivePersistence = {
                    label = "Général",
                },
                medicalEvaluationRecipients = {
                    label = "Métiers destinataires",
                },
                medicalEvaluationSharing = {
                    label = "Champs partagés",
                },
                medicalEvaluationTypes = {
                    label = "Types d'évaluation",
                },
                medicalEvaluationsGeneral = {
                    label = "Général",
                },
                medicalWearablesArmRestrictions = {
                    label = "Restrictions du plâtre de bras",
                },
                medicalWearablesCasts = {
                    label = "Plâtres",
                },
                medicalWearablesDuration = {
                    label = "Durée de port",
                },
                medicalWearablesGeneral = {
                    label = "Général",
                },
                medicalWearablesHeadBandage = {
                    label = "Bandage crânien",
                },
                medicalWearablesLegRestrictions = {
                    label = "Restrictions du plâtre de jambe",
                },
                medicalWearablesNeckBrace = {
                    label = "Minerve",
                },
                medicalWearablesOxygenMask = {
                    label = "Masque à oxygène",
                },
                medicalWearablesPatientHud = {
                    label = "HUD patient",
                },
                medicalWearablesRemoval = {
                    label = "Retrait",
                },
                medicalWearablesSplints = {
                    label = "Attelles",
                },
                medicalWearablesTorsoBandage = {
                    label = "Bandage du torse",
                },
                minigamesBloodTransfusionGeneral = {
                    label = "Général",
                },
                minigamesCprGeneral = {
                    label = "Général",
                },
                minigamesEnabled = {
                    label = "Activé",
                },
                minigamesRandomization = {
                    label = "Variation aléatoire",
                },
                minigamesVentilationGeneral = {
                    label = "Général",
                },
                operationsAnesthesia = {
                    label = "Anesthésie",
                },
                operationsDistances = {
                    label = "Distances",
                },
                operationsDoctorAnimation = {
                    label = "Animation du chirurgien",
                },
                operationsGeneral = {
                    label = "Général",
                },
                operationsPatientAnimation = {
                    label = "Animation du patient",
                },
                operationsTrainingAnimation = {
                    label = "Animation d'entraînement",
                },
                propPlacement = {
                    label = "Placement des accessoires",
                },
                propPlacementItems = {
                    label = "Objets accessoires",
                },
                publicTreatmentGeneral = {
                    label = "Général",
                },
                publicTreatmentJobs = {
                    label = "Emplois autorisés",
                },
                publicTreatmentRequirements = {
                    label = "Exigences",
                },
                reviveRewardGeneral = {
                    label = "Général",
                },
                reviveRewardPayment = {
                    label = "Paiement",
                },
                selfDiagnoseGeneral = {
                    label = "Général",
                },
                stretcherAnimation = {
                    label = "Animation",
                },
                stretcherCarryAttach = {
                    label = "Attache de transport",
                },
                stretcherFolded = {
                    label = "Variante pliée",
                },
                stretcherFoldedPatientAttach = {
                    label = "Attache patient pliée",
                },
                stretcherGeneral = {
                    label = "Général",
                },
                stretcherHelicopter = {
                    label = "Hélicoptère",
                },
                stretcherPatientAttach = {
                    label = "Attachement du patient",
                },
                stretcherTreatmentAnim = {
                    label = "Animation",
                },
                stretcherVehicleAttach = {
                    label = "Attachement de véhicule",
                },
                stretcherVehicleLists = {
                    label = "Modèles de véhicules",
                },
                treatmentAnim = {
                    label = "Animation",
                },
                treatmentEnable = {
                    label = "Activer",
                },
                trunk = {
                    label = "Tronc",
                },
                vehiclePullGeneral = {
                    label = "Général",
                },
                wheelchairAssign = {
                    label = "Affectation",
                },
                wheelchairDuration = {
                    label = "Durée",
                },
                wheelchairGeneral = {
                    label = "Général",
                },
                wheelchairItems = {
                    label = "Article",
                },
                wheelchairRestrictions = {
                    label = "Restrictions",
                },
                xrayGeneral = {
                    label = "Général",
                },
                xrayRanges = {
                    label = "Gammes",
                },
            },
            settingSections = {
                billing = "Facturation",
                bodyBag = "Sac mortuaire",
                damageHandling = "Gestion des dommages",
                death = "La mort",
                deathScreen = "Écran de la mort",
                diagnose = "Diagnostiquer",
                doctorNpc = "Docteur PNJ",
                general = "Général",
                healthInsurance = "Assurance maladie",
                hospitalBeds = "Lits d'hôpitaux",
                knockout = "Assommer",
                medicCarry = "Transport médical",
                minigames = "Mini-jeux",
                mobilityAid = "Aides à la mobilité",
                operations = "Opérations",
                organization = "Organisation",
                rewards = "Récompenses",
                treatment = "Traitement",
                vehiclePull = "Traction du véhicule",
            },
            settingSubsections = {
                aiMedic = "Médecin IA",
                anesthesia = "Anesthésie",
                animation = "Animation",
                animations = "Animations",
                appointments = "Rendez-vous",
                attach = "Attacher",
                bedAnimation = "Animation de lit",
                blood = "Sang",
                bloodTransfusion = "Transfusion sanguine",
                bodyBagDeliveryReward = "Récompense de livraison de sac mortuaire",
                carrierAnimation = "Animation du porteur",
                classification = "Classement",
                cpr = "CPR",
                crutch = "Béquille",
                deathInjuries = "Blessures mortelles",
                deathScreenStyle = "Style d'écran de mort",
                deathTimeout = "Délai de mort",
                delivery = "Livraison",
                diagnoseAnim = "Diagnostiquer l'animation",
                dispatch = "Expédition",
                earlyRespawn = "Réapparition précoce",
                effects = "Effets",
                firstAid = "PREMIERS SECOURS",
                general = "Général",
                getupAnimation = "Animation de mise en place",
                imaging = "Imagerie",
                information = "Informations",
                keybinds = "Raccourcis",
                liveDamage = "Dégâts réels",
                logs = "Journaux",
                medicRevivePersistence = "Médecin ravivant la persistance",
                medicalEvaluations = "Évaluations médicales",
                medicalWearables = "Dispositifs médicaux",
                medications = "Médicaments",
                minigame = "Mini-jeu",
                passengerAnimation = "Animation des passagers",
                pricing = "Tarifs",
                propPlacement = "Placement des accessoires",
                publicTreatment = "Traitement public",
                respawn = "Réapparaître",
                reviveInBed = "Revivre au lit",
                reviveReward = "Récompense de réanimation",
                selfDiagnose = "Auto-diagnostic",
                stretcher = "Tendeur",
                stretcherTreatmentAnim = "Animation de traitement sur civière",
                thresholds = "Seuils",
                treatmentAnim = "Animation de traitement",
                trunk = "Tronc",
                vehicleImpact = "Impact sur le véhicule",
                ventilation = "Ventilation",
                wheelchair = "Fauteuil roulant",
                xray = "Rayon X",
            },
            settings = {
                ambulanceEditorControl172 = {
                    label = "Éditeur · Contrôle 172",
                    description = "Configuration: Éditeur: Déplacer vers le haut.",
                },
                ambulanceEditorControl173 = {
                    label = "Éditeur · Contrôle 173",
                    description = "Configuration: Éditeur: Déplacer vers le bas.",
                },
                ambulanceEditorControl174 = {
                    label = "Éditeur · Contrôle 174",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceEditorControl175 = {
                    label = "Éditeur · Contrôle 175",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceEditorControl177 = {
                    label = "Éditeur · Contrôle 177",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceEditorControl201 = {
                    label = "Éditeur · Contrôle 201",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceEditorControl202 = {
                    label = "Éditeur · Contrôle 202",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceEditorControl21 = {
                    label = "Éditeur · Contrôle 21",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceEditorControl32 = {
                    label = "Éditeur · Contrôle 32",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceEditorControl33 = {
                    label = "Éditeur · Contrôle 33",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceEditorControl34 = {
                    label = "Éditeur · Contrôle 34",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceEditorControl35 = {
                    label = "Éditeur · Contrôle 35",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceEditorControl36 = {
                    label = "Éditeur · Contrôle 36",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceEditorControl37 = {
                    label = "Éditeur · Contrôle 37",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceEditorControl38 = {
                    label = "Éditeur · Contrôle 38",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceEditorControl44 = {
                    label = "Éditeur · Contrôle 44",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceFirstAidControl38 = {
                    label = "Premiers secours · Contrôle 38",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceStretcherEditorControl177 = {
                    label = "Interaction · Contrôle 177",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceStretcherEditorControl201 = {
                    label = "Interaction · Contrôle 201",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceStretcherEditorControl202 = {
                    label = "Interaction · Contrôle 202",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceStretcherEditorControl21 = {
                    label = "Interaction · Contrôle 21",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceStretcherEditorControl241 = {
                    label = "Interaction · Contrôle 241",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceStretcherEditorControl242 = {
                    label = "Interaction · Contrôle 242",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceStretcherEditorControl25 = {
                    label = "Interaction · Contrôle 25",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceStretcherEditorControl32 = {
                    label = "Interaction · Contrôle 32",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceStretcherEditorControl33 = {
                    label = "Interaction · Contrôle 33",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceStretcherEditorControl34 = {
                    label = "Interaction · Contrôle 34",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceStretcherEditorControl35 = {
                    label = "Interaction · Contrôle 35",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceStretcherEditorControl36 = {
                    label = "Interaction · Contrôle 36",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceStretcherEditorControl38 = {
                    label = "Interaction · Contrôle 38",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                ambulanceStretcherEditorControl44 = {
                    label = "Interaction · Contrôle 44",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                appointmentsBookingCooldownSeconds = {
                    description = "Délai en secondes entre les tentatives de réservation d'un patient.",
                    label = "Délai entre les réservations",
                },
                appointmentsEnabled = {
                    description = "Active la prise de rendez-vous des patients et le calendrier personnel des médecins.",
                    label = "Activé",
                },
                appointmentsMaxAdvanceDays = {
                    description = "Nombre maximal de jours à l'avance pendant lesquels les patients peuvent réserver.",
                    label = "Réservation maximale à l'avance",
                },
                appointmentsMaxAppointmentsPerPlayer = {
                    description = "Nombre maximal de rendez-vous futurs actifs qu'un patient peut conserver.",
                    label = "Nombre maximal de rendez-vous par patient",
                },
                appointmentsMinLeadMinutes = {
                    description = "Nombre minimal de minutes entre la réservation et le rendez-vous.",
                    label = "Délai minimal",
                },
                appointmentsNotificationApp = {
                    description = "Identifiant de l'application téléphonique utilisée pour les notifications de rendez-vous.",
                    label = "Application de notification",
                },
                appointmentsNotificationsEnabled = {
                    description = "Informe les patients sur leur téléphone lorsqu'un rendez-vous est réservé ou annulé.",
                    label = "Notifications téléphoniques",
                },
                appointmentsReasonMaxLength = {
                    description = "Nombre maximal de caractères autorisés pour le motif du rendez-vous.",
                    label = "Limite de caractères du motif",
                },
                appointmentsSlotDurationMinutes = {
                    description = "Durée et intervalle de la grille d'un créneau de rendez-vous, en minutes.",
                    label = "Durée d'un créneau",
                },
                billingAccount = {
                    description = "Ancien compte de société de secours utilisé pour la facturation.",
                    label = "Compte",
                },
                billingCloseOnSuccess = {
                    description = "Fermez automatiquement l'interface utilisateur de facturation après une facture réussie.",
                    label = "Proche du succès",
                },
                billingCurrency = {
                    description = "Clé de devise facultative utilisée pour la facturation des paiements.",
                    label = "Devise",
                },
                billingCustomBillingReasons = {
                    description = "Autorisez les médecins à saisir des motifs de facturation personnalisés.",
                    label = "Raisons personnalisées",
                },
                billingDepositToSociety = {
                    description = "Déposez les revenus de facturation sur le compte de la société.",
                    label = "Dépôt à la société",
                },
                billingEnabled = {
                    description = "Activez le système de facturation médicale.",
                    label = "Activé",
                },
                billingMaxReasonLength = {
                    description = "Longueur maximale des motifs de facturation personnalisés.",
                    label = "Longueur maximale du motif",
                },
                billingMode = {
                    description = "Choisissez si les factures médicales sont facturées instantanément, nécessitent une confirmation ou utilisent le système de facturation cadre.",
                    label = "Mode de facturation",
                    options = {
                        consent = "Payer ou refuser",
                        framework = "Projet de loi-cadre",
                        instant = "Charge instantanée",
                    },
                },
                billingRange = {
                    description = "Portée maximale pour trouver des patients facturables.",
                    label = "Gamme",
                },
                billingReasonPresets = {
                    description = "Motifs de facturation prédéfinis affichés dans l'interface utilisateur de facturation.",
                    itemLabel = "Raison",
                    label = "Préréglages de motifs",
                },
                billingRefreshSeconds = {
                    description = "Secondes entre les actualisations des lecteurs facturables.",
                    label = "Actualiser les secondes",
                },
                bladeWeapons = {
                    description = "Noms ou hachages d'armes qui doivent être classés comme dégâts de couteau plutôt que comme objets contondants.",
                    itemLabel = "Arme",
                    label = "Armes à lame",
                },
                bleedingBlacklist = {
                    description = "Des armes qui ne doivent jamais provoquer de saignements vifs ni de blessures ouvertes.",
                    itemLabel = "Arme",
                    label = "Liste noire des saignements",
                },
                bleedingClassesProfiles = {
                    description = "Profils de gravité des saignements et taux de perte de sang.",
                    label = "Cours de saignement",
                },
                bloodSystemDebugLogInterval = {
                    description = "Secondes entre les messages du journal de débogage du système sanguin.",
                    label = "Intervalle du journal de débogage",
                },
                bloodSystemMaxVolume = {
                    description = "Valeur maximale du volume sanguin utilisée par le système d’état du patient.",
                    label = "Volume maximum",
                },
                bloodSystemRegenPerSecond = {
                    description = "Régénération sanguine passive appliquée lorsque le patient ne saigne pas activement.",
                    label = "Régénération par seconde",
                },
                bloodSystemTickIntervalMs = {
                    description = "Intervalle de tick du serveur utilisé pour les mises à jour de perte de sang et de récupération.",
                    label = "Intervalle de tique ms",
                },
                bloodSystemUnconsciousThreshold = {
                    description = "Seuil de volume sanguin en dessous duquel le patient perd connaissance.",
                    label = "Seuil inconscient",
                },
                bodyBagAnimationDict = {
                    description = "Dictionnaire d'animation utilisé pour transporter un sac mortuaire.",
                    label = "Dictionnaire d'animation",
                },
                bodyBagAnimationEnabled = {
                    description = "Utilisez une animation de transport dédiée lorsque vous portez un sac mortuaire.",
                    label = "Activé",
                },
                bodyBagAnimationFlag = {
                    description = "Indicateur TaskPlayAnim utilisé pour l'animation de report.",
                    label = "Drapeau d'animation",
                },
                bodyBagAnimationName = {
                    description = "Clip d'animation utilisé pour transporter un sac mortuaire.",
                    label = "Nom de l'animation",
                },
                bodyBagAttachBone = {
                    description = "Nom de l'os du péd ou ID de l'os utilisé pour la fixation du sac mortuaire.",
                    label = "Os",
                },
                bodyBagAttachRx = {
                    description = "Le sac mortuaire attache une rotation X.",
                    label = "Joindre RX",
                },
                bodyBagAttachRy = {
                    description = "Le sac mortuaire attache la rotation en Y.",
                    label = "Attacher RY",
                },
                bodyBagAttachRz = {
                    description = "Le sac mortuaire attache la rotation Z.",
                    label = "Attacher RZ",
                },
                bodyBagAttachX = {
                    description = "Fixation du sac mortuaire X offset.",
                    label = "Joindre X",
                },
                bodyBagAttachY = {
                    description = "Sac mortuaire attaché en Y décalé.",
                    label = "Joindre Y",
                },
                bodyBagAttachZ = {
                    description = "Fixez le sac mortuaire en décalage Z.",
                    label = "Attacher Z",
                },
                bodyBagDeliveryHelpLabelKey = {
                    description = "Clé locale utilisée pour l'invite d'aide au dépôt de la housse mortuaire.",
                    label = "Clé d'étiquette d'aide",
                },
                bodyBagDeliveryInteractDistance = {
                    description = "Distance utilisée pour la validation du dépôt des sacs mortuaires.",
                    label = "Distance d'interaction",
                },
                bodyBagDeliveryInteractKey = {
                    description = "ID de contrôle utilisé pour les interactions de dépôt des sacs mortuaires.",
                    label = "Clé d'interaction",
                },
                bodyBagDeliveryInteraction = {
                    description = "Clé du modèle d'interaction utilisée pour le dépôt des housses mortuaires.",
                    label = "Modèle d'interaction",
                },
                bodyBagDeliveryRequireDropOff = {
                    description = "Exiger que les médecins remettent les sacs mortuaires aux points de dépôt configurés.",
                    label = "Exiger un dépôt",
                },
                bodyBagDeliveryRequireOnDuty = {
                    description = "Exiger que des médecins soient en service avant la livraison des sacs mortuaires.",
                    label = "Exiger en service",
                },
                bodyBagDeliveryRewardAccount = {
                    description = "Clé de compte principale utilisée pour les récompenses de livraison de sacs mortuaires.",
                    label = "Compte",
                },
                bodyBagDeliveryRewardAccountType = {
                    description = "Type de compte principal utilisé pour les récompenses de livraison de housses mortuaires.",
                    label = "Type de compte",
                },
                bodyBagDeliveryRewardAmount = {
                    description = "Montant de la récompense payé pour une livraison de sac mortuaire.",
                    label = "Montant",
                },
                bodyBagDeliveryRewardCurrency = {
                    description = "Clé de devise personnalisée en option utilisée pour les récompenses de livraison de sacs mortuaires.",
                    label = "Devise",
                },
                bodyBagDeliveryRewardEnabled = {
                    description = "Payez une récompense configurée une fois la livraison d'une housse mortuaire terminée.",
                    label = "Activé",
                },
                bodyBagDeliveryRewardPayFromSociety = {
                    description = "Déduisez les récompenses pour la livraison des sacs mortuaires de l'association pour l'emploi partagé avant de payer le médecin.",
                    label = "Payer de la société",
                },
                bodyBagEnabled = {
                    description = "Activez le système de sac mortuaire.",
                    label = "Activé",
                },
                bodyBagHidePatient = {
                    description = "Cachez le patient pendant que le sac mortuaire est attaché.",
                    label = "Masquer le patient",
                },
                bodyBagModel = {
                    description = "Modèle d'accessoire utilisé pour les sacs mortuaires.",
                    label = "Modèle",
                },
                bodyBagPatientAlpha = {
                    description = "Alpha appliqué au patient alors qu'il était ensaché.",
                    label = "Patient alpha",
                },
                crutchAssignMaxDistance = {
                    description = "Distance maximale pour attribuer une béquille à un autre joueur.",
                    label = "Attribuer une distance maximale",
                },
                crutchAutoUnequipOnExpire = {
                    description = "Déséquipez automatiquement la béquille lorsque la mission expire.",
                    label = "Déséquipement automatique à l'expiration",
                },
                crutchClipset = {
                    description = "Clips de mouvement appliqués lors de l'utilisation de la béquille.",
                    label = "Ensemble de clips",
                },
                crutchDefaultDurationMinutes = {
                    description = "Durée de béquille attribuée par défaut en minutes.",
                    label = "Durée par défaut",
                },
                crutchDisableSprint = {
                    description = "Bloquez le sprint lorsqu’une béquille est équipée.",
                    label = "Désactiver le sprint",
                },
                crutchDisableWeapons = {
                    description = "Bloquer l'utilisation d'une arme lorsqu'une béquille est équipée.",
                    label = "Désactiver les armes",
                },
                crutchItemName = {
                    description = "Article d'inventaire utilisé pour la béquille.",
                    label = "Nom de l'article",
                },
                crutchMaxDurationMinutes = {
                    description = "Durée maximale autorisée d'affectation des béquilles en minutes.",
                    label = "Durée maximale",
                },
                crutchMinDurationMinutes = {
                    description = "Durée minimale autorisée d'affectation des béquilles en minutes.",
                    label = "Durée minimale",
                },
                crutchProp = {
                    description = "Modèle accessoire utilisé pour la béquille.",
                    label = "Soutenir",
                },
                damageLogBatchIntervalSeconds = {
                    description = "Secondes pendant lesquelles les coups sont regroupés dans un message.",
                    label = "Intervalle de regroupement",
                },
                damageLogMaxEntriesPerMessage = {
                    description = "Nombre maximal de coups individuels dans un message Discord.",
                    label = "Coups par message",
                },
                damageLogsEnabled = {
                    description = "Envoyer à Discord les coups non mortels confirmés par le serveur.",
                    label = "Journaux de dégâts",
                },
                deathAnimalAnimationDictionary = {
                    description = "Dictionnaire d'animation utilisé pour l'animation de la mort d'un animal par repli.",
                    label = "Dictionnaire des animaux",
                },
                deathAnimalAnimationName = {
                    description = "Clip d'animation utilisé pour l'animation de la mort de repli d'un animal.",
                    label = "Nom de l'animation animale",
                },
                deathAnimalUseAnimation = {
                    description = "Autorisez l'animal de secours configuré à utiliser une animation de mort scriptée.",
                    label = "Animations animales",
                },
                deathAnimationDictionary = {
                    description = "Dictionnaire d'animation utilisé pour l'animation de mort par défaut.",
                    label = "Dictionnaire d'animation",
                },
                deathAnimationName = {
                    description = "Clip d'animation utilisé pour l'animation de mort par défaut.",
                    label = "Nom de l'animation",
                },
                deathInjuriesProfiles = {
                    description = "Profils de blessures appliqués lorsqu'un joueur décède pour une cause spécifique.",
                    itemLabel = "Blessure",
                    label = "Blessures mortelles",
                },
                deathModels = {
                    description = "Remplacez le comportement de l'animation de mort par modèle péd ou hachage de modèle.",
                    label = "Remplacements de modèle",
                },
                deathScreenAiMedicAccount = {
                    description = "Compte principal facturé pour le médecin IA.",
                    label = "Compte",
                },
                deathScreenAiMedicAddDeathTimerSeconds = {
                    description = "Secondes ajoutées au chronomètre de purge lorsque le médecin IA est demandé.",
                    label = "Ajouter une minuterie de mort",
                },
                deathScreenAiMedicAllowFatalWounds = {
                    description = "Permettez au médecin IA de raviver les blessures mortelles.",
                    label = "Autoriser les blessures mortelles",
                },
                deathScreenAiMedicApproachDistance = {
                    description = "Distance à laquelle le médecin IA s'arrête et s'approche à pied.",
                    label = "Distance d'approche",
                },
                deathScreenAiMedicCooldownSeconds = {
                    description = "Temps de recharge avant que le médecin IA puisse être rappelé.",
                    label = "Secondes de recharge",
                },
                deathScreenAiMedicCurrency = {
                    description = "Clé de devise facultative utilisée pour les paiements médicaux par l'IA.",
                    label = "Devise",
                },
                deathScreenAiMedicCurrencyFormatter = {
                    description = "Formateur de devises utilisé pour les paiements médicaux par l'IA.",
                    label = "Formateur de devises",
                },
                deathScreenAiMedicDespawnDelaySeconds = {
                    description = "Quelques secondes avant que le médecin IA ne disparaisse après avoir terminé.",
                    label = "Délai de disparition",
                },
                deathScreenAiMedicDispatchDelaySeconds = {
                    description = "Délai avant le début de l'envoi du médecin IA.",
                    label = "Retard d'expédition",
                },
                deathScreenAiMedicDriveSpeed = {
                    description = "Vitesse de conduite utilisée par le véhicule médical AI.",
                    label = "Vitesse de conduite",
                },
                deathScreenAiMedicDriveTimeoutSeconds = {
                    description = "Temps de conduite maximum avant les déclenchements de réanimation forcée.",
                    label = "Expiration du délai de conduite",
                },
                deathScreenAiMedicEnabled = {
                    description = "Activez le flux de sauvetage médical AI.",
                    label = "Activé",
                },
                deathScreenAiMedicFallbackAccount = {
                    description = "Compte de secours utilisé lorsque le compte AI medic principal ne dispose pas de fonds suffisants.",
                    label = "Compte de secours",
                },
                deathScreenAiMedicForceReviveEnabled = {
                    description = "Forcez une réanimation si le médecin de l'IA ne peut pas atteindre le joueur.",
                    label = "Forcer la réanimation activée",
                },
                deathScreenAiMedicMaxMedicsOnline = {
                    description = "Le médecin IA ne fonctionne que lorsque le nombre de médecins en service est égal ou inférieur à ce nombre.",
                    label = "Max médecins en ligne",
                },
                deathScreenAiMedicMissionTimeoutSeconds = {
                    description = "Durée maximale de la mission avant les déclencheurs de réanimation forcée.",
                    label = "Expiration du délai de mission",
                },
                deathScreenAiMedicPedModel = {
                    description = "Modèle pédagogique utilisé pour le médecin IA.",
                    label = "Modèle pédagogique",
                },
                deathScreenAiMedicPlayerRequestMode = {
                    description = "Destination utilisée lorsque le joueur à terre appelle le médecin IA.",
                    label = "Destination de la demande du joueur",
                    options = {
                        hospital = "Hôpital",
                        location = "Position actuelle",
                    },
                },
                deathScreenAiMedicPrice = {
                    description = "Prix ​​facturé pour appeler le médecin de l'IA.",
                    label = "Prix",
                },
                deathScreenAiMedicRemoteDispatchDelaySeconds = {
                    description = "Secondes après la mort du joueur avant qu'un médecin puisse proposer un médecin IA à distance.",
                    label = "Attente avant envoi à distance",
                },
                deathScreenAiMedicRemoteDispatchEnabled = {
                    description = "Autorisez les médecins à envoyer le médecin de l'IA à un joueur abattu à partir de la carte de répartition et de la commande /aimedic.",
                    label = "Expédition à distance",
                },
                deathScreenAiMedicRemoteDispatchMaxMedicsOnline = {
                    description = "La répartition à distance des médecins par l'IA ne fonctionne que lorsque les médecins en service sont égaux ou inférieurs à ce nombre.",
                    label = "Envoi à distance de médecins maximum en ligne",
                },
                deathScreenAiMedicRemoteDispatchMode = {
                    description = "Destination utilisée lorsqu'un médecin IA à distance est envoyé et accepté.",
                    label = "Destination de l'envoi à distance",
                    options = {
                        hospital = "Hôpital",
                        location = "Position actuelle",
                    },
                },
                deathScreenAiMedicRemoteOfferTimeoutSeconds = {
                    description = "Secondes pendant lesquelles le joueur peut accepter une offre de médecin IA à distance.",
                    label = "Expiration de l'offre à distance",
                },
                deathScreenAiMedicReviveDistance = {
                    description = "Distance requise avant que le médecin IA ne commence à se réanimer.",
                    label = "Raviver la distance",
                },
                deathScreenAiMedicReviveDurationSeconds = {
                    description = "Secondes passées à réanimer le joueur.",
                    label = "Durée de réanimation",
                },
                deathScreenAiMedicReviveInBedEnabled = {
                    description = "Téléportez le joueur vers un lit d'hôpital au lieu de le réanimer sur place.",
                    label = "Revivre au lit",
                },
                deathScreenAiMedicReviveInBedSearchRadius = {
                    description = "Rayon de recherche utilisé pour trouver un lit de réanimation.",
                    label = "Rayon de recherche de lit",
                },
                deathScreenAiMedicSecondsTillAvailable = {
                    description = "Quelques secondes après la mort, avant que le médecin IA ne soit disponible.",
                    label = "Quelques secondes jusqu'à ce qu'il soit disponible",
                },
                deathScreenAiMedicSpawnRadiusMax = {
                    description = "Rayon maximum d'apparition du médecin IA.",
                    label = "Rayon d'apparition maximum",
                },
                deathScreenAiMedicSpawnRadiusMin = {
                    description = "Rayon minimum d'apparition du médecin IA.",
                    label = "Rayon d'apparition min.",
                },
                deathScreenAiMedicVehicleModel = {
                    description = "Modèle de véhicule utilisé par le médecin IA.",
                    label = "Modèle de véhicule",
                },
                deathScreenAllowVoiceWhileUnconscious = {
                    description = "Mode vocal pendant l'inconscience : aucun, écoute ou complet.",
                    label = "Mode vocal",
                    options = {
                        full = "complet",
                        listen = "écouter",
                        none = "aucun",
                    },
                },
                deathScreenAllowedControls = {
                    description = "Contrôlez les identifiants qui restent activés même si vous êtes inconscient.",
                    label = "Contrôles autorisés",
                },
                deathScreenAutoRespawnOnExpiredReconnect = {
                    description = "Réapparaître automatiquement les joueurs si le délai de purge a déjà expiré alors qu'ils étaient déconnectés.",
                    label = "Réapparition automatique, reconnexion expirée",
                },
                deathScreenBackgroundEnd = {
                    description = "Couleur de fin du fond de l'écran de la mort.",
                    label = "Fin du fond",
                },
                deathScreenBackgroundStart = {
                    description = "Couleur de départ de l’arrière-plan de l’écran de la mort.",
                    label = "Début en arrière-plan",
                },
                deathScreenBleedOutTimerSeconds = {
                    description = "Quelques secondes avant l'expiration du délai de purge.",
                    label = "Minuterie de purge",
                },
                deathScreenBlockedDimensions = {
                    description = "Dimensions où le flux de réapparition de l'écran de mort est bloqué.",
                    label = "Dimensions bloquées",
                },
                deathScreenBorderColor = {
                    description = "Couleur de bordure utilisée par l'écran de la mort.",
                    label = "Couleur de la bordure",
                },
                deathScreenDispatchEnabled = {
                    description = "Envoyez des événements de répartition à partir du flux d’écran de mort.",
                    label = "Expédition activée",
                },
                deathScreenDispatchFallbackJobs = {
                    description = "Destinataires de remplacement si aucun destinataire principal n’est vivant et en service. Laisser vide pour toujours alerter les métiers principaux.",
                    itemLabel = "Métier",
                    label = "Métiers de remplacement",
                },
                deathScreenDispatchJobs = {
                    description = "Métiers alertés lorsqu’un joueur à terre demande de l’aide.",
                    itemLabel = "Métier",
                    label = "Métiers alertés",
                },
                deathScreenEarlyRespawnAccount = {
                    description = "Compte principal facturé pour une réapparition précoce.",
                    label = "Compte",
                },
                deathScreenEarlyRespawnAllowFatalWounds = {
                    description = "Gardez une réapparition précoce disponible même pour les blessures mortelles.",
                    label = "Autoriser les blessures mortelles",
                },
                deathScreenEarlyRespawnCurrency = {
                    description = "Clé de devise facultative utilisée pour les paiements de réapparition anticipée.",
                    label = "Devise",
                },
                deathScreenEarlyRespawnCurrencyFormatter = {
                    description = "Formateur de devises utilisé pour les paiements de réapparition anticipée.",
                    label = "Formateur de devises",
                },
                deathScreenEarlyRespawnEnabled = {
                    description = "Activer la réapparition anticipée payante.",
                    label = "Activé",
                },
                deathScreenEarlyRespawnFallbackAccount = {
                    description = "Compte de secours utilisé lorsque le compte principal ne dispose pas de fonds suffisants.",
                    label = "Compte de secours",
                },
                deathScreenEarlyRespawnPaymentLabel = {
                    description = "Étiquette facultative affichée pour le paiement de réapparition anticipée.",
                    label = "Étiquette de paiement",
                },
                deathScreenEarlyRespawnPrice = {
                    description = "Prix ​​facturé pour une réapparition précoce.",
                    label = "Prix",
                },
                deathScreenEarlyRespawnRequireNoMedics = {
                    description = "N'autorisez la réapparition précoce que lorsqu'aucun médecin n'est en service.",
                    label = "Ne nécessite aucun médecin",
                },
                deathScreenEarlyRespawnSecondsTillAvailable = {
                    description = "Quelques secondes après la mort avant que la réapparition précoce ne soit disponible.",
                    label = "Quelques secondes jusqu'à ce qu'il soit disponible",
                },
                deathScreenEnableKeyboard = {
                    description = "Autoriser l'utilisation du clavier sur l'écran de la mort.",
                    label = "Activer le clavier",
                },
                deathScreenExternalVoiceSystem = {
                    description = "Backend vocal externe pour couper le son lorsqu'il est activé.",
                    label = "Système vocal externe",
                    options = {
                        saltychat = "chat salé",
                        yaca = "yaca",
                    },
                },
                deathScreenFocusKey = {
                    label = "Interaction souris de l’écran de mort",
                    description = "Touche FiveM par défaut, par exemple E, F6 ou MOUSE_BUTTON:MOUSE_RIGHT. Un champ vide indique aucune touche par défaut. Les joueurs peuvent personnaliser leurs touches dans les paramètres FiveM ; leurs affectations enregistrées sont conservées.",
                },
                deathScreenHandlingMode = {
                    description = "Utilise l'animation de mort statique ou conserve la physique ragdoll naturelle jusqu'à la stabilisation du corps.",
                    label = "Gestion du décès",
                    options = {
                        natural = "Naturelle",
                        static = "Statique",
                    },
                },
                deathScreenHideOverlayWithoutFocus = {
                    description = "Masque l'écran de mort lorsque ESPACE active les commandes du jeu ; désactivez cette option pour conserver l'ancienne interface visible.",
                    label = "Masquer l'interface avec les commandes du jeu",
                },
                deathScreenHospitalSelectionCameraFocusHeight = {
                    description = "Décalage de hauteur appliqué à la cible de mise au point de la caméra.",
                    label = "Hauteur de mise au point",
                },
                deathScreenHospitalSelectionCameraFov = {
                    description = "Aperçu du champ de vision de la caméra.",
                    label = "Champ de vision",
                },
                deathScreenHospitalSelectionCameraHeadingOffset = {
                    description = "Décalage de cap utilisé lors du placement de la caméra de prévisualisation.",
                    label = "Décalage de cap",
                },
                deathScreenHospitalSelectionCameraHeight = {
                    description = "Décalage de hauteur appliqué à la caméra de prévisualisation.",
                    label = "Hauteur de la caméra",
                },
                deathScreenHospitalSelectionCameraPitch = {
                    description = "Pas appliqué à la caméra de prévisualisation.",
                    label = "Pas",
                },
                deathScreenHospitalSelectionCameraRadius = {
                    description = "Distance entre la caméra de prévisualisation et le point d'apparition.",
                    label = "Rayon de la caméra",
                },
                deathScreenHospitalSelectionCameraTransition = {
                    description = "Utilisez une transition douce lors de l’ouverture de la caméra de sélection de l’hôpital.",
                    label = "Transition en douceur",
                },
                deathScreenHospitalSelectionEnabled = {
                    description = "Permettez aux joueurs de sélectionner un hôpital avant de réapparaître.",
                    label = "Sélection d'hôpital",
                },
                deathScreenHospitalSelectionRequireMultipleHospitals = {
                    description = "Afficher la sélection d'hôpital uniquement lorsqu'il existe plusieurs hôpitaux.",
                    label = "Nécessite plusieurs hôpitaux",
                },
                deathScreenInformationEnabled = {
                    description = "Affichez le bloc d'informations sur l'écran de la mort.",
                    label = "Activé",
                },
                deathScreenInformationShowDeathCause = {
                    description = "Affichez la cause du décès dans le bloc d’informations de l’écran de décès.",
                    label = "Afficher la cause du décès",
                },
                deathScreenInformationShowInjuries = {
                    description = "Afficher les blessures dans le bloc d’informations de l’écran de la mort.",
                    label = "Afficher les blessures",
                },
                deathScreenInformationShowKiller = {
                    description = "Affichez le nom du tueur dans le bloc d'informations de l'écran de mort.",
                    label = "Montrer le tueur",
                },
                deathScreenInformationShowWeapon = {
                    description = "Montrez l'arme dans le bloc d'informations de l'écran de mort.",
                    label = "Montrer l'arme",
                },
                deathScreenInformationWhitelistedGangs = {
                    label = "Gangs sur liste blanche",
                    description = "Sélectionnez les noms internes des gangs ou organisations indépendantes. Un métier ou gang correspondant accorde l’autorisation ou l’exemption. Le service est exigé uniquement pour les métiers.",
                    itemLabel = "Gang",
                },
                deathScreenInformationWhitelistedJobs = {
                    description = "Les travaux permettent d'afficher des informations étendues sur l'écran de décès.",
                    itemLabel = "Emploi",
                    label = "Emplois sur liste blanche",
                },
                deathScreenLogScreenshotTimeoutSeconds = {
                    description = "Nombre maximal de secondes pour chaque envoi de capture de décès.",
                    label = "Délai des captures",
                },
                deathScreenLogScreenshots = {
                    description = "Importer les vues de la victime et du tueur confirmé après le journal texte.",
                    label = "Captures d’écran",
                },
                deathScreenLogsEnabled = {
                    description = "Envoyer un journal Discord à chaque décès d’un joueur.",
                    label = "Journaux de décès",
                },
                deathScreenMedicNearbyRadius = {
                    description = "Distance en mètres utilisée pour compter un médecin comme étant à proximité.",
                    label = "Médecin à proximité",
                },
                deathScreenMinigameEnabled = {
                    description = "Activez le mini-jeu de l'écran de la mort.",
                    label = "Activé",
                },
                deathScreenMinigameUrl = {
                    description = "URL ouverte pour le mini-jeu de l'écran de la mort.",
                    label = "URL du mini-jeu",
                },
                deathScreenMode = {
                    description = "Utilise l'écran de mort intégré ou une intégration externe.",
                    label = "Mode d'écran",
                    options = {
                        external = "Externe",
                        internal = "Interne",
                    },
                },
                deathScreenMuteExternalVoiceOnDeath = {
                    description = "Coupez le son des systèmes vocaux externes lorsque le joueur est mort.",
                    label = "Couper la voix externe",
                },
                deathScreenMutedTextColor = {
                    description = "Couleur du texte atténuée utilisée par l'écran de mort.",
                    label = "Couleur du texte en sourdine",
                },
                deathScreenNaturalRagdollDebug = {
                    description = "Affiche les raisons détaillées côté client et serveur tant que le corps reste en ragdoll.",
                    label = "Débogage du ragdoll naturel",
                },
                deathScreenNaturalStabilizationMode = {
                    description = "Stabilise automatiquement les corps immobiles ou exige qu'un secouriste en service les place en position latérale de sécurité.",
                    label = "Stabilisation naturelle",
                    options = {
                        automatic = "Automatique",
                        medic = "Secouriste requis",
                    },
                },
                deathScreenPanelBackground = {
                    description = "Couleur d’arrière-plan du panneau utilisée par l’écran de la mort.",
                    label = "Fond du panneau",
                },
                deathScreenPreventAutoRespawn = {
                    description = "Bloquez la réapparition automatique après une purge.",
                    label = "Empêcher la réapparition automatique",
                },
                deathScreenPreventAutoRespawnIfMedicNearby = {
                    description = "Bloquez la réapparition automatique lorsqu'un médecin est à proximité.",
                    label = "Bloquer lorsqu'un médecin est à proximité",
                },
                deathScreenPreventReviveOnExpiry = {
                    description = "Le bloc reprend vie après l'expiration du délai de purge.",
                    label = "Empêcher la réactivation à l'expiration",
                },
                deathScreenPrimaryColor = {
                    description = "Couleur CSS de base utilisée pour le thème de l'écran de la mort.",
                    label = "Couleur primaire",
                },
                deathScreenPrimaryDark = {
                    description = "Couleur d'accent plus sombre en option pour l'écran de la mort.",
                    label = "Sombre primaire",
                },
                deathScreenPrimaryStrong = {
                    description = "Couleur d'accent plus forte en option pour l'écran de la mort.",
                    label = "Primaire fort",
                },
                deathScreenRespawnDefaultHeading = {
                    description = "Cap utilisé lorsque la station n'a pas de cap défini.",
                    label = "Titre par défaut",
                },
                deathScreenRespawnFallbackCoordsHeading = {
                    description = "Titre de réapparition de secours utilisé lorsqu'aucun poste d'hôpital n'existe.",
                    label = "Rubrique de repli",
                },
                deathScreenRespawnFallbackCoordsX = {
                    description = "Coordonnée X de réapparition de secours utilisée lorsqu'aucune position d'hôpital n'existe.",
                    label = "Repli X",
                },
                deathScreenRespawnFallbackCoordsY = {
                    description = "Coordonnée Y de réapparition de secours utilisée lorsqu'aucune position d'hôpital n'existe.",
                    label = "Repli Y",
                },
                deathScreenRespawnFallbackCoordsZ = {
                    description = "Coordonnée Z de réapparition de secours utilisée lorsqu'aucune position d'hôpital n'existe.",
                    label = "Repli Z",
                },
                deathScreenRespawnHospitalId = {
                    description = "Choisissez un hôpital fixe pour les réapparitions. Laissez-le vide pour utiliser l'hôpital le plus proche.",
                    label = "Hôpital de réapparition",
                },
                deathScreenRespawnRemoveAccountsEnabled = {
                    description = "Supprimez les soldes des comptes à la réapparition.",
                    label = "Supprimer des comptes",
                },
                deathScreenRespawnRemoveAccountsNames = {
                    description = "Noms de compte supprimés à la réapparition.",
                    itemLabel = "Compte",
                    label = "Noms de compte",
                },
                deathScreenRespawnRemoveItemsEnabled = {
                    description = "Supprimez les éléments de l'inventaire à la réapparition.",
                    label = "Supprimer des éléments",
                },
                deathScreenRespawnRemoveItemsIgnore = {
                    description = "Objets d'inventaire conservés lors de la réapparition.",
                    itemLabel = "Article",
                    label = "Éléments ignorés",
                },
                deathScreenRespawnRemoveWeaponsEnabled = {
                    description = "Supprimez les armes de la roue d'armes à la réapparition.",
                    label = "Retirer les armes",
                },
                deathScreenRespawnRemoveWeaponsIgnore = {
                    description = "Armes conservées lors de la réapparition.",
                    itemLabel = "Arme",
                    label = "Armes ignorées",
                },
                deathScreenRespawnTeleportToHospital = {
                    description = "Téléportez le joueur dans un hôpital lors de sa réapparition.",
                    label = "Téléportation à l'hôpital",
                },
                deathScreenResumeBleedOutOnReconnect = {
                    description = "Reprenez le minuteur de purge après la reconnexion au lieu de le réinitialiser.",
                    label = "Reprendre à la reconnexion",
                },
                deathScreenShadowLight = {
                    description = "Couleur d'ombre douce utilisée par l'écran de la mort.",
                    label = "Lumière d'ombre",
                },
                deathScreenShadowMid = {
                    description = "Couleur d'ombre moyenne utilisée par l'écran de la mort.",
                    label = "Ombre au milieu",
                },
                deathScreenShowNearestMedic = {
                    description = "Montrez le médecin le plus proche sur l'écran de la mort.",
                    label = "Afficher le médecin le plus proche",
                },
                deathScreenTextColor = {
                    description = "Couleur de texte principale utilisée par l'écran de mort.",
                    label = "Couleur du texte",
                },
                deathScreenTextShadow = {
                    description = "Couleur de l'ombre du texte utilisée par l'écran de la mort.",
                    label = "Ombre du texte",
                },
                deathTimeoutApplyOnKnockout = {
                    description = "Appliquez également le délai de mort après la résurrection par KO.",
                    label = "Postuler par KO",
                },
                deathTimeoutSeconds = {
                    description = "Quelques secondes après une réanimation, ce combat reste désactivé.",
                    label = "Secondes",
                },
                deathTimeoutShowUi = {
                    description = "Afficher la bannière du compte à rebours du délai d'expiration lorsqu'il est actif.",
                    label = "Afficher l'interface utilisateur",
                },
                deathTimeoutWhitelistedGangs = {
                    label = "Gangs sur liste blanche",
                    description = "Sélectionnez les noms internes des gangs ou organisations indépendantes. Un métier ou gang correspondant accorde l’autorisation ou l’exemption. Le service est exigé uniquement pour les métiers.",
                    itemLabel = "Gang",
                },
                deathTimeoutWhitelistedJobs = {
                    description = "Emplois exemptés des restrictions de délai d'attente en cas de décès.",
                    itemLabel = "Emploi",
                    label = "Emplois sur liste blanche",
                },
                deathUseAnimation = {
                    description = "Jouez l'animation de mort configurée pour les pédiatres pris en charge.",
                    label = "Utiliser des animations",
                },
                diagnoseAnimClip = {
                    description = "Clip d'animation utilisé lors de l'ouverture du diagnostic. Laissez vide pour utiliser un scénario à la place.",
                    label = "Nom de l'animation",
                },
                diagnoseAnimDict = {
                    description = "Dictionnaire d'animation utilisé lors de l'ouverture du diagnostic. Laissez vide pour utiliser un scénario à la place.",
                    label = "Dictionnaire d'animation",
                },
                diagnoseAnimScenario = {
                    description = "Scénario utilisé lors de l'ouverture du diagnostic. Laissez vide pour utiliser dict + clip à la place.",
                    label = "Scénario",
                },
                diagnoseCprAnimDict = {
                    description = "Dictionnaire d'animation utilisé pour la RCR.",
                    label = "Dictionnaire d'animation",
                },
                diagnoseCprAnimName = {
                    description = "Clip d'animation utilisé pour la RCR.",
                    label = "Nom de l'animation",
                },
                diagnoseFullHealDelaySeconds = {
                    description = "Temps de diagnostic continu requis avant l'affichage du soin complet.",
                    label = "Délai en secondes",
                },
                diagnoseRequireRescueBackpack = {
                    label = "Exiger un sac de secours",
                    description = "Exiger rescue_backpack pour afficher la barre d’outils d’examen à gauche. Désactiver pour toujours l’afficher ; les objets requis par chaque outil restent nécessaires.",
                },
                diagnoseFullHealEnabled = {
                    description = "Autorise le soin complet après une session de diagnostic continue.",
                    label = "Activé",
                },
                diagnoseInteractDistance = {
                    description = "Distance maximale requise pour diagnostiquer ou mettre en sac mortuaire un patient.",
                    label = "Distance d'interaction",
                },
                diagnosePatientMovementMode = {
                    label = "Déplacement du patient",
                    description = "Immobiliser le patient tant qu'un autre joueur garde le menu de soins ouvert, ou autoriser ses déplacements et fermer le menu au-delà de la distance de soins. L'autodiagnostic se configure séparément.",
                    options = {
                        freeze = "Immobiliser le patient",
                        distance = "Fermer au-delà de la distance",
                    },
                },
                diagnoseMaxTreatmentDistance = {
                    label = "Distance de soins (m)",
                    description = "Distance maximale entre le soignant et le patient avant la fermeture du menu en mode distance. La distance d'ouverture se configure séparément.",
                },
                diagnoseKey = {
                    description = "ID de contrôle utilisé pour diagnostiquer les interactions.",
                    label = "Clé d'interaction",
                },
                diagnoseOpenDelayMs = {
                    description = "Délai avant l'ouverture de l'interface utilisateur de diagnostic.",
                    label = "Retard d'ouverture ms",
                },
                diagnosePromptDistance = {
                    description = "Distance utilisée pour afficher l'invite de diagnostic.",
                    label = "Distance rapide",
                },
                diagnoseTreatmentDurationMs = {
                    description = "Durée utilisée pour les animations de traitement.",
                    label = "Durée du traitement ms",
                },
                doctorNpcAddRevenueToSociety = {
                    description = "Déposez les paiements du médecin sur le compte de la société partagée lors de la facturation directe.",
                    label = "Ajouter des revenus à la société",
                },
                doctorNpcEnabled = {
                    description = "Activez le service médecin NPC.",
                    label = "Activé",
                },
                doctorNpcHealOtherAccount = {
                    description = "Clé de compte principale utilisée pour charger la guérison d'un autre joueur.",
                    label = "Compte",
                },
                doctorNpcHealOtherAccountType = {
                    description = "Type de compte principal utilisé pour charger la guérison d'un autre joueur.",
                    label = "Type de compte",
                },
                doctorNpcHealOtherCurrency = {
                    description = "Clé de devise personnalisée en option utilisée pour facturer la guérison d'un autre joueur.",
                    label = "Devise",
                },
                doctorNpcHealOtherPrice = {
                    description = "Prix ​​pour soigner un autre joueur chez le PNJ médecin.",
                    label = "Prix",
                },
                doctorNpcHealSelfAccount = {
                    description = "Clé de compte principale utilisée pour facturer l'auto-réparation.",
                    label = "Compte",
                },
                doctorNpcHealSelfAccountType = {
                    description = "Type de compte principal utilisé pour facturer l'auto-réparation.",
                    label = "Type de compte",
                },
                doctorNpcHealSelfCurrency = {
                    description = "Clé de devise personnalisée en option utilisée pour facturer l'auto-réparation.",
                    label = "Devise",
                },
                doctorNpcHealSelfPrice = {
                    description = "Prix ​​pour vous soigner chez le médecin PNJ.",
                    label = "Prix",
                },
                doctorNpcInteractionRange = {
                    description = "À quelle distance l'utilisateur doit rester du PNJ médecin lorsqu'il utilise le menu ouvert du médecin. Cela ne change pas la distance initiale de l'invite du PNJ.",
                    label = "Plage d'interaction",
                },
                doctorNpcMaxMedicsOnline = {
                    description = "Le Docteur NPC ne fonctionne que lorsque les médecins en service sont en dessous de cette limite.",
                    label = "Max médecins en ligne",
                },
                doctorNpcPatientRange = {
                    description = "À quelle distance le patient doit-il être du médecin PNJ pour soigner les autres ou se remettre au travail après avoir sélectionné l'action.",
                    label = "Gamme de patients",
                },
                doctorNpcPaymentMode = {
                    description = "Facturez les joueurs immédiatement ou envoyez une facture.",
                    label = "Mode de paiement",
                    options = {
                        bill = "facture",
                        remove = "retirer",
                    },
                },
                doctorNpcPlayerScanRange = {
                    description = "Utilisé uniquement pour répertorier les joueurs à proximité dans l'interface utilisateur du médecin PNJ. Il ne permet pas de traiter à lui seul.",
                    label = "Portée de numérisation du joueur",
                },
                doctorNpcReviveAccount = {
                    description = "Clé de compte principale utilisée pour facturer les réanimations du médecin.",
                    label = "Compte",
                },
                doctorNpcReviveAccountType = {
                    description = "Type de compte principal utilisé pour facturer les réanimations du médecin.",
                    label = "Type de compte",
                },
                doctorNpcReviveAllowFatalWounds = {
                    description = "Permet au médecin PNJ de réanimer les blessures mortelles ou non réanimables. Un délai d'agonie expiré bloque toujours la réanimation.",
                    label = "Autoriser les blessures mortelles",
                },
                doctorNpcReviveCurrency = {
                    description = "Clé de devise personnalisée en option utilisée pour facturer les réanimations du médecin.",
                    label = "Devise",
                },
                doctorNpcReviveInBedEnabled = {
                    description = "Placez les joueurs réanimés dans le lit d’hôpital le plus proche après la réanimation d’un médecin.",
                    label = "Activé",
                },
                doctorNpcReviveInBedSearchRadius = {
                    description = "Distance maximale utilisée pour trouver un lit d'hôpital à proximité pour les réanimations médicales.",
                    label = "Rayon de recherche",
                },
                doctorNpcRevivePrice = {
                    description = "Prix ​​pour réanimer un joueur chez le PNJ médecin.",
                    label = "Prix",
                },
                enforceMaxHealth = {
                    description = "Maintient la santé maximale des joueurs à 200. Désactivez cette option lorsqu'une autre ressource gère la santé maximale.",
                    label = "Forcer 200 points de santé maximum",
                },
                firstAidActionDurationMs = {
                    description = "Combien de temps durent les premiers secours.",
                    label = "Durée d'action ms",
                },
                firstAidAnimationDict = {
                    description = "Dictionnaire d'animation utilisé lors de l'action de premiers secours.",
                    label = "Dictionnaire d'animation",
                },
                firstAidAnimationFlag = {
                    description = "Indicateur TaskPlayAnim utilisé lors de l'action de premiers secours.",
                    label = "Drapeau d'animation",
                },
                firstAidAnimationName = {
                    description = "Clip d'animation utilisé lors de l'action de premiers secours.",
                    label = "Nom de l'animation",
                },
                firstAidBleedoutExtensionSeconds = {
                    description = "Secondes ajoutées au minuteur de saignement du patient après les premiers soins.",
                    label = "Secondes d'extension de saignement",
                },
                firstAidEnabled = {
                    description = "Activez la fonction de premiers secours pour les joueurs licenciés.",
                    label = "Premiers secours activés",
                },
                firstAidLicense = {
                    description = "Nom de licence cadre utilisé pour valider l’accès aux premiers secours.",
                    label = "Nom de la licence",
                },
                firstAidLicenseManagementAddEnabled = {
                    description = "Autoriser le personnel ambulancier à délivrer le permis de premiers secours.",
                    label = "Ajouter une licence activée",
                },
                firstAidLicenseManagementAddRadial = {
                    description = "Affichez l'action d'ajout de licence dans le menu radial.",
                    label = "Ajouter une licence radiale",
                },
                firstAidLicenseManagementAddRequireDuty = {
                    description = "Exiger le devoir EMS avant que l'action d'ajout de licence puisse être utilisée.",
                    label = "Ajouter une licence nécessite un devoir",
                },
                firstAidLicenseManagementAdditionalLicenses = {
                    description = "Licences framework supplémentaires que le personnel ambulancier peut attribuer ou retirer dans le dossier patient. La licence de premiers secours configurée est toujours incluse.",
                    itemLabel = "Licence",
                    label = "Licences patient supplémentaires",
                },
                firstAidLicenseManagementRemoveEnabled = {
                    description = "Autoriser le personnel ambulancier à retirer le permis de secourisme.",
                    label = "Supprimer la licence activée",
                },
                firstAidLicenseManagementRemoveRadial = {
                    description = "Affichez l'action de suppression de licence dans le menu radial.",
                    label = "Supprimer le radial de licence",
                },
                firstAidLicenseManagementRemoveRequireDuty = {
                    description = "Exiger le devoir EMS avant que l'action de suppression de licence puisse être utilisée.",
                    label = "Supprimer la licence nécessite un devoir",
                },
                firstAidPositionChestOffset = {
                    description = "Décalage thoracique utilisé lors de l’alignement pour les premiers secours.",
                    label = "Décalage de la poitrine",
                },
                firstAidPositionSideOffset = {
                    description = "Décalage latéral utilisé lors de l'alignement pour les premiers secours.",
                    label = "Décalage latéral",
                },
                firstAidPositionZOffset = {
                    description = "Décalage vertical utilisé lors de l'alignement pour les premiers secours.",
                    label = "Décalage Z",
                },
                firstAidRequireLicense = {
                    description = "Exiger la licence de premiers secours configurée avant qu'un joueur puisse utiliser les premiers secours.",
                    label = "Exiger une licence",
                },
                firstAidTargetDistance = {
                    description = "Distance maximale autorisée pour les premiers secours.",
                    label = "Distance cible",
                },
                healthInsuranceAccount = {
                    description = "Clé de compte de secours utilisée pour les paiements d’assurance.",
                    label = "Compte",
                },
                healthInsuranceAccountType = {
                    description = "Type de compte principal utilisé pour les paiements d'assurance.",
                    label = "Type de compte",
                },
                healthInsuranceAvailableDays = {
                    description = "Durées d'assurance disponibles en jours.",
                    label = "Jours disponibles",
                },
                healthInsuranceCommand = {
                    description = "Commande de chat utilisée pour ouvrir l'interface utilisateur de l'assurance maladie.",
                    label = "Commande",
                },
                healthInsuranceCurrency = {
                    description = "Clé de devise personnalisée en option utilisée pour les paiements d'assurance.",
                    label = "Devise",
                },
                healthInsuranceEnabled = {
                    description = "Activer le système d’assurance maladie.",
                    label = "Activé",
                },
                healthInsurancePricesManagedInTablet = {
                    description = "Autorise les employés habilités à modifier les tarifs d’assurance sur la tablette. Désactivez cette option pour imposer les tarifs du tableau des fournisseurs ci-dessous.",
                    label = "Gestion des tarifs sur la tablette",
                },
                healthInsuranceProviders = {
                    description = "Des assurances proposées aux joueurs.",
                    itemLabel = "Fournisseur",
                    label = "Fournisseurs",
                },
                healthInsuranceSharedAcrossJobs = {
                    description = "Utilise les mêmes assureurs et contrats pour tous les métiers enregistrés dans cette ressource ambulancière.",
                    label = "Partager entre les métiers ambulanciers",
                },
                hospitalBedsBedAnimationDict = {
                    description = "Le dictionnaire d'animation tourne en boucle pendant que le joueur est allongé sur le lit. Laissez vide pour utiliser l’animation de mort par défaut.",
                    label = "Dictionnaire d'animation",
                },
                hospitalBedsBedAnimationDurationMs = {
                    description = "Durée manuelle facultative pour l’animation du lit en boucle. Utilisé uniquement lorsqu'une animation de lit personnalisée est configurée.",
                    label = "Durée ms",
                },
                hospitalBedsBedAnimationFlag = {
                    description = "Indicateur TaskPlayAnim utilisé pour l'animation du lit en boucle. Utilisé uniquement lorsqu'une animation de lit personnalisée est configurée.",
                    label = "Drapeau d'animation",
                },
                hospitalBedsBedAnimationName = {
                    description = "Clip d'animation en boucle pendant que le joueur est allongé sur le lit. Laissez vide pour utiliser l’animation de mort par défaut.",
                    label = "Nom de l'animation",
                },
                hospitalBedsBreakDistance = {
                    description = "Distance au bout de laquelle le joueur est forcé de quitter le lit.",
                    label = "Distance de rupture",
                },
                hospitalBedsCreatorPedModel = {
                    description = "Aperçu du modèle pédologique utilisé dans l'éditeur de position du lit d'hôpital.",
                    label = "Modèle pédagogique créateur",
                },
                hospitalBedsEnabled = {
                    description = "Activez les interactions configurées avec les lits d’hôpital.",
                    label = "Activé",
                },
                hospitalBedsGetupAnimationDict = {
                    description = "Dictionnaire d'animation joué lorsque le joueur se lève du lit. Laissez vide pour utiliser le comportement debout par défaut.",
                    label = "Dictionnaire d'animation",
                },
                hospitalBedsGetupAnimationDurationMs = {
                    description = "Durée manuelle optionnelle pour l'animation de lever. Utilisé uniquement lorsqu'une animation de lever personnalisée est configurée.",
                    label = "Durée ms",
                },
                hospitalBedsGetupAnimationFlag = {
                    description = "Indicateur TaskPlayAnim utilisé pour l'animation de montée. Utilisé uniquement lorsqu'une animation de lever personnalisée est configurée.",
                    label = "Drapeau d'animation",
                },
                hospitalBedsGetupAnimationName = {
                    description = "Clip d'animation diffusé lorsque le joueur se lève du lit. Laissez vide pour utiliser le comportement debout par défaut.",
                    label = "Nom de l'animation",
                },
                hospitalBedsHeadingOffset = {
                    description = "Décalage de cap appliqué lors du placement du joueur sur le lit.",
                    label = "Décalage de cap",
                },
                hospitalBedsHeightOffset = {
                    description = "Décalage vertical appliqué lors du placement du joueur sur le lit.",
                    label = "Décalage de hauteur",
                },
                hospitalBedsInteractDistance = {
                    description = "Distance maximale requise pour utiliser un lit d'hôpital.",
                    label = "Distance d'interaction",
                },
                hospitalBedsInteractKey = {
                    description = "ID de contrôle utilisé pour entrer ou sortir d’un lit d’hôpital.",
                    label = "Clé d'interaction",
                },
                hospitalBedsModels = {
                    description = "Modèles d'objets du monde traités comme des lits d'hôpitaux utilisables.",
                    itemLabel = "Modèle",
                    label = "Modèles de lits",
                },
                hospitalBedsSearchRadius = {
                    description = "Rayon utilisé pour trouver des accessoires de lit à proximité ou des lits configurés.",
                    label = "Rayon de recherche",
                },
                hospitalBlipColor = {
                    description = "ID de couleur du blip utilisé pour les blips de la carte de l'hôpital.",
                    label = "Couleur",
                },
                hospitalBlipEnabled = {
                    description = "Afficher les icônes de la carte de l'hôpital pour les positions hospitalières configurées.",
                    label = "Activé",
                },
                hospitalBlipName = {
                    description = "Nom du blip de l’hôpital de secours utilisé lorsqu’aucun nom de station n’est disponible.",
                    label = "Nom",
                },
                hospitalBlipScale = {
                    description = "Échelle de points utilisée pour les points de carte d'hôpital.",
                    label = "Échelle",
                },
                hospitalBlipSprite = {
                    description = "ID de sprite de blip utilisé pour les blips de carte d'hôpital.",
                    label = "Lutin",
                },
                imagingInteractionRange = {
                    description = "Distance maximale de la station d'imagerie pour l'opérateur.",
                    label = "Plage d'interaction",
                },
                imagingPatientRange = {
                    description = "Distance maximale de la station d'imagerie pour le patient.",
                    label = "Gamme de patients",
                },
                imagingScanDurationSeconds = {
                    description = "Durée en secondes pour les résultats de tomodensitométrie et d'IRM.",
                    label = "Durée de l'analyse",
                },
                injuryEffectsBleedingOverlayIntensity = {
                    description = "Multiplicateur visuel uniquement pour les effets de superposition de saignements.",
                    label = "Intensité de superposition des saignements",
                },
                injuryEffectsPainScreenIntensity = {
                    description = "Multiplicateur visuel uniquement pour les effets d'écran de douleur.",
                    label = "Intensité de l'écran de douleur",
                },
                injuryThresholdBleedingPainMinPercent = {
                    description = "Pourcentage minimum de santé maximale perdue en un seul coup avant que le saignement et la douleur ne soient appliqués.",
                    label = "Pourcentage minimum de saignement/douleur",
                },
                injuryThresholdRespectArmor = {
                    description = "Évitez les saignements et la douleur lorsque le coup a été absorbé par l'armure.",
                    label = "Respecter l'armure",
                },
                knockoutRegenerateDamage = {
                    description = "Régénérez les dégâts par KO après l'expiration du délai de réapparition.",
                    label = "Régénérer les dégâts",
                },
                knockoutRegenerateDurationSeconds = {
                    description = "Secondes pendant lesquelles les dégâts par KO sont soignés.",
                    label = "Durée de régénération",
                },
                knockoutRespawnSeconds = {
                    description = "Quelques secondes avant une réapparition automatique lorsqu'un joueur est éliminé.",
                    label = "Secondes de réapparition",
                },
                knockoutWeapons = {
                    description = "Noms ou hachages d'armes qui devraient déclencher un KO au lieu de l'écran de mort complet.",
                    itemLabel = "Arme",
                    label = "Armes",
                },
                legShotRagdollChance = {
                    description = "Pourcentage de chance qu un impact valide declenche le ragdoll.",
                    label = "Probabilité",
                },
                legShotRagdollCooldownMs = {
                    description = "Delai minimum entre deux ragdolls apres tir dans la jambe.",
                    label = "Refroidissement ms",
                },
                legShotRagdollDebug = {
                    description = "Journalise les decisions de ragdoll pour les tests.",
                    label = "Débogues",
                },
                legShotRagdollDurationMs = {
                    description = "Duree du ragdoll.",
                    label = "Duree ms",
                },
                legShotRagdollFeet = {
                    description = "Autorise les impacts sur les pieds a declencher le ragdoll.",
                    label = "Pieds",
                },
                legShotRagdollIgnoreArmorHits = {
                    description = "Ignore le ragdoll si l armure a absorbe le coup.",
                    label = "Ignorer les impacts sur l armure",
                },
                legShotRagdollLeftLowerLeg = {
                    description = "Autorise les impacts sur la jambe inferieure gauche.",
                    label = "Jambe inferieure gauche",
                },
                legShotRagdollLeftUpperLeg = {
                    description = "Autorise les impacts sur la jambe superieure gauche.",
                    label = "Jambe superieure gauche",
                },
                legShotRagdollOnlyGunshots = {
                    description = "Seuls les tirs peuvent declencher le ragdoll.",
                    label = "Seulement les tirs",
                },
                legShotRagdollRightLowerLeg = {
                    description = "Autorise les impacts sur la jambe inferieure droite.",
                    label = "Jambe inferieure droite",
                },
                legShotRagdollRightUpperLeg = {
                    description = "Autorise les impacts sur la jambe superieure droite.",
                    label = "Jambe superieure droite",
                },
                liveDamageFracturesChance = {
                    description = "La probabilité de base qu'un dommage conscient entraîne une fracture.",
                    label = "Probabilité",
                },
                liveDamageFracturesEnabled = {
                    description = "Permettez aux coups de dégâts conscients de faire rouler les fractures.",
                    label = "Activé",
                },
                liveDamageFracturesMinDamagePercent = {
                    description = "Pourcentage minimal de santé maximale perdu en un coup avant qu'une fracture puisse être déclenchée.",
                    label = "Pourcentage minimal de dégâts",
                },
                liveDamageFracturesZones = {
                    description = "Risques de fracture par zone pour des dommages réels.",
                    label = "Chances de zone",
                },
                liveOpenWoundStacksDefault = {
                    description = "Nombre maximum de plaies ouvertes par zone sans remplacement de zone.",
                    label = "Limite par defaut",
                },
                liveOpenWoundStacksZones = {
                    description = "Limites optionnelles de plaies ouvertes par zone.",
                    itemLabel = "Zone",
                    label = "Limites par zone",
                },
                liveWoundBleedingClassProfiles = {
                    description = "Classe de saignement initiale appliquée par cause de dommage réelle.",
                    label = "Cours de saignement de plaies vivantes",
                },
                medicCarryAllowCarrierInVehicle = {
                    description = "Autorise le porteur à entrer et conduire un véhicule sans déposer le patient.",
                    label = "Autoriser le porteur en véhicule",
                },
                medicCarryAllowConsciousTargets = {
                    description = "Autoriser le transport de joueurs conscients.",
                    label = "Autoriser les cibles conscientes",
                },
                medicCarryAllowSprint = {
                    description = "Autoriser le sprint en transportant un patient.",
                    label = "Autoriser le sprint",
                },
                medicCarryAttachBone = {
                    description = "Index osseux servant à attacher le joueur transporté.",
                    label = "Attacher l'os",
                },
                medicCarryAttachOffsetsPitch = {
                    description = "Effectuez la rotation du pas de fixation.",
                    label = "Pas",
                },
                medicCarryAttachOffsetsRoll = {
                    description = "Rotation du rouleau d'attache de transport.",
                    label = "Rouler",
                },
                medicCarryAttachOffsetsX = {
                    description = "Chargez la fixation X offset.",
                    label = "Décalage X",
                },
                medicCarryAttachOffsetsY = {
                    description = "Transportez l'attache Y décalée.",
                    label = "Décalage Y",
                },
                medicCarryAttachOffsetsYaw = {
                    description = "Transportez la rotation de lacet de fixation.",
                    label = "Embardée",
                },
                medicCarryAttachOffsetsZ = {
                    description = "Chargez la fixation Z offset.",
                    label = "Décalage Z",
                },
                medicCarryCarrierAnimationDict = {
                    description = "Dictionnaire d'animation utilisé par le médecin lors du transport d'un patient.",
                    label = "Dictionnaire d'animation",
                },
                medicCarryCarrierAnimationFlag = {
                    description = "Indicateur TaskPlayAnim utilisé par l'animation de transport médical.",
                    label = "Drapeau d'animation",
                },
                medicCarryCarrierAnimationName = {
                    description = "Clip d'animation utilisé par le médecin alors qu'il transporte un patient.",
                    label = "Nom de l'animation",
                },
                medicCarryEnabled = {
                    description = "Activez le système de transport médical.",
                    label = "Activé",
                },
                medicCarryMaxDistance = {
                    description = "Distance maximale requise pour récupérer un patient.",
                    label = "Distance maximale",
                },
                medicCarryPassengerAnimationDict = {
                    description = "Dictionnaire d'animation utilisé par le patient transporté.",
                    label = "Dictionnaire d'animation",
                },
                medicCarryPassengerAnimationFlag = {
                    description = "Indicateur TaskPlayAnim utilisé par l’animation du patient transporté.",
                    label = "Drapeau d'animation",
                },
                medicCarryPassengerAnimationName = {
                    description = "Clip d'animation utilisé par le patient transporté.",
                    label = "Nom de l'animation",
                },
                medicCarryReapplyDeathAnimation = {
                    description = "Réappliquez l'animation de mort après avoir laissé tomber un patient inconscient.",
                    label = "Réappliquer l'animation de mort",
                },
                medicCarryRequireOnDuty = {
                    description = "Seuls les médecins de service peuvent démarrer un transport.",
                    label = "Exiger en service",
                },
                medicReviveAllowFatalWounds = {
                    description = "Permet aux médecins en service de traiter et réanimer les blessures mortelles ou non réanimables. Un délai d'agonie expiré bloque toujours la réanimation.",
                    label = "Autoriser les blessures mortelles",
                },
                medicRevivePersistenceKeepInjuries = {
                    description = "Conservez les blessures non résolues après le traitement ou la liste de contrôle.",
                    label = "Gardez les blessures",
                },
                medicRevivePersistenceKeepPain = {
                    description = "Conservez les valeurs de douleur après le traitement ou la liste de contrôle réapparaît lorsque les blessures sont préservées.",
                    label = "Gardez la douleur",
                },
                medicalEvaluationPatientSelectionRange = {
                    description = "Distance maximale utilisée pour lister les joueurs proches lors de la création d'une évaluation médicale.",
                    label = "Distance des patients proches",
                },
                medicalEvaluationRecipientJobs = {
                    description = "Métiers auxquels les évaluations médicales peuvent être délivrées et partagées.",
                    label = "Métiers destinataires",
                },
                medicalEvaluationShareBirthDate = {
                    description = "Autorise les métiers destinataires à voir la date de naissance du patient.",
                    label = "Partager la date de naissance",
                },
                medicalEvaluationShareConclusion = {
                    description = "Autorise les métiers destinataires à voir la conclusion médicale.",
                    label = "Partager la conclusion",
                },
                medicalEvaluationShareEvaluationTypes = {
                    description = "Autorise les métiers destinataires à voir les types d'évaluation effectués.",
                    label = "Partager les types d'évaluation",
                },
                medicalEvaluationShareFullName = {
                    description = "Autorise les métiers destinataires à voir le nom complet du patient.",
                    label = "Partager le nom complet",
                },
                medicalEvaluationShareGender = {
                    description = "Autorise les métiers destinataires à voir le genre du patient.",
                    label = "Partager le genre",
                },
                medicalEvaluationShareHeight = {
                    description = "Autorise les métiers destinataires à voir la taille du patient.",
                    label = "Partager la taille",
                },
                medicalEvaluationShareHobbies = {
                    description = "Autorise les métiers destinataires à voir les loisirs et centres d'intérêt du patient.",
                    label = "Partager les loisirs",
                },
                medicalEvaluationShareIssuer = {
                    description = "Afficher le nom de l’auteur. Le service émetteur reste visible comme dossier dans les documents partagés.",
                    label = "Partager les détails de l’auteur",
                },
                medicalEvaluationSharePersonalId = {
                    description = "Autorise les métiers destinataires à voir l'identifiant personnel du patient.",
                    label = "Partager l'identifiant personnel",
                },
                medicalEvaluationShareProfession = {
                    description = "Autorise les métiers destinataires à voir la profession du patient.",
                    label = "Partager la profession",
                },
                medicalEvaluationShareQuestionnaireAnswers = {
                    description = "Autorise les métiers destinataires à voir les questions du questionnaire et les réponses enregistrées.",
                    label = "Partager les questions et réponses",
                },
                medicalEvaluationShareResult = {
                    description = "Autorise les métiers destinataires à voir si l'évaluation est en attente, réussie ou échouée.",
                    label = "Partager le résultat",
                },
                medicalEvaluationShareWeight = {
                    description = "Autorise les métiers destinataires à voir le poids du patient.",
                    label = "Partager le poids",
                },
                medicalEvaluationTypes = {
                    description = "Configure les types d'évaluation, les questions, les types de réponse et l'activation de chaque question.",
                    label = "Types d'évaluation et questionnaires",
                    options = {
                        boolean = "Oui / Non",
                        boolean_text = "Oui / Non avec détails",
                        date = "Date",
                        multi_select = "Choix multiple",
                        number = "Nombre",
                        rating = "Note",
                        select = "Choix unique",
                        text = "Texte",
                        textarea = "Zone de texte",
                        time = "Heure",
                    },
                },
                medicalEvaluationsEnabled = {
                    description = "Active les évaluations médicales dans la tablette ambulancière.",
                    label = "Activé",
                },
                medicalWearablesAllowUntilRemoved = {
                    description = "Propose une durée permanente qui reste active jusqu'au retrait du dispositif par un médecin.",
                    label = "Autoriser jusqu'au retrait",
                },
                medicalWearablesArmCastsDisableMelee = {
                    description = "Empêche les attaques au corps à corps lorsqu'un plâtre de bras est porté.",
                    label = "Désactiver le corps à corps",
                },
                medicalWearablesArmCastsDisableWeapons = {
                    description = "Force le combat à mains nues et empêche de changer d'arme lorsqu'un plâtre de bras est porté.",
                    label = "Désactiver les armes",
                },
                medicalWearablesArmCastsRestrictionsEnabled = {
                    description = "Applique des restrictions de combat lorsqu'un plâtre de bras est porté.",
                    label = "Activé",
                },
                medicalWearablesAutoFromFractures = {
                    description = "Traite la fracture correspondante lors de la pose d'un plâtre ou d'une attelle.",
                    label = "Intégration des fractures",
                },
                medicalWearablesCastsEnabled = {
                    description = "Autorise les plâtres sur les bras et les jambes gauches et droits.",
                    label = "Activé",
                },
                medicalWearablesCastsItem = {
                    description = "Objet d'inventaire consommé lors de la pose d'un plâtre.",
                    label = "Objet",
                },
                medicalWearablesCastsMinigame = {
                    description = "Mini-jeu de traitement existant utilisé pour les plâtres.",
                    label = "Mini-jeu",
                },
                medicalWearablesDefaultDurationMinutes = {
                    description = "Durée par défaut du dispositif médical en minutes. Utilisez 0 pour le maintenir jusqu'au retrait.",
                    label = "Minutes par défaut",
                },
                medicalWearablesDurationOptionsMinutes = {
                    description = "Durées des dispositifs médicaux proposées aux médecins, en minutes.",
                    label = "Options de durée",
                },
                medicalWearablesEnabled = {
                    description = "Active les modèles de plâtres, attelles, bandages, minerves et masques à oxygène dans l'interface de traitement.",
                    label = "Activé",
                },
                medicalWearablesExpiryCheckSeconds = {
                    description = "Fréquence de retrait des dispositifs médicaux temporisés expirés.",
                    label = "Vérification d'expiration (secondes)",
                },
                medicalWearablesHeadBandageEnabled = {
                    description = "Autorise le modèle de bandage crânien.",
                    label = "Activé",
                },
                medicalWearablesHeadBandageItem = {
                    description = "Objet d'inventaire consommé pour un bandage crânien.",
                    label = "Objet",
                },
                medicalWearablesHeadBandageMinigame = {
                    description = "Mini-jeu de traitement existant utilisé pour un bandage crânien.",
                    label = "Mini-jeu",
                },
                medicalWearablesLegCastsDisableJump = {
                    description = "Empêche de sauter lorsqu'un plâtre de jambe est porté.",
                    label = "Désactiver le saut",
                },
                medicalWearablesLegCastsDisableSprint = {
                    description = "Empêche de sprinter lorsqu'un plâtre de jambe est porté.",
                    label = "Désactiver le sprint",
                },
                medicalWearablesLegCastsForceInjuredWalk = {
                    description = "Force le jeu d'animations de déplacement blessé lorsqu'un plâtre de jambe est porté.",
                    label = "Forcer la démarche blessée",
                },
                medicalWearablesLegCastsMoveRate = {
                    description = "Remplace la vitesse de déplacement lorsqu'un plâtre de jambe est porté.",
                    label = "Vitesse de déplacement",
                },
                medicalWearablesLegCastsRestrictionsEnabled = {
                    description = "Applique des restrictions de déplacement lorsqu'un plâtre de jambe est porté.",
                    label = "Activé",
                },
                medicalWearablesNeckBraceEnabled = {
                    description = "Autorise le modèle de minerve.",
                    label = "Activé",
                },
                medicalWearablesNeckBraceItem = {
                    description = "Objet d'inventaire consommé pour une minerve.",
                    label = "Objet",
                },
                medicalWearablesNeckBraceMinigame = {
                    description = "Mini-jeu de traitement existant utilisé pour une minerve.",
                    label = "Mini-jeu",
                },
                medicalWearablesOxygenMaskEnabled = {
                    description = "Autorise le modèle de masque à oxygène.",
                    label = "Activé",
                },
                medicalWearablesOxygenMaskItem = {
                    description = "Objet d'inventaire consommé pour un masque à oxygène.",
                    label = "Objet",
                },
                medicalWearablesOxygenMaskMinigame = {
                    description = "Mini-jeu de traitement existant utilisé pour un masque à oxygène.",
                    label = "Mini-jeu",
                },
                medicalWearablesPatientHudEnabled = {
                    description = "Affiche au patient ses dispositifs médicaux actifs et le temps de port restant.",
                    label = "Activé",
                },
                medicalWearablesPatientHudPosition = {
                    description = "Choisit l'emplacement du HUD des dispositifs médicaux du patient.",
                    label = "Poste",
                    options = {
                        ["bottom-center"] = "Bas centré",
                        ["bottom-left"] = "En bas à gauche",
                        ["bottom-right"] = "En bas à droite",
                        center = "Centre",
                        ["center-left"] = "Centre gauche",
                        ["center-right"] = "Centre droit",
                        ["top-center"] = "Haut centré",
                        ["top-left"] = "En haut à gauche",
                        ["top-right"] = "En haut à droite",
                    },
                },
                medicalWearablesPersistence = {
                    description = "Restaure les plâtres, attelles, minerves et bandages du torse temporisés après une reconnexion ou un redémarrage de la ressource.",
                    label = "Persistance des dispositifs médicaux",
                },
                medicalWearablesRemoval = {
                    description = "Permet aux médecins de retirer les plâtres, attelles, minerves et bandages du torse actifs depuis l'interface de traitement.",
                    label = "Retrait par un médecin",
                },
                medicalWearablesRemovalTreatmentEnabled = {
                    description = "Affiche le retrait d'un dispositif médical avec l'outil configuré dans l'interface de traitement.",
                    label = "Traitement de retrait activé",
                },
                medicalWearablesRemovalTreatmentItem = {
                    description = "Outil d'inventaire réutilisable requis pour retirer un dispositif médical.",
                    label = "Objet",
                },
                medicalWearablesRemovalTreatmentMinigame = {
                    description = "Mini-jeu de retrait des dispositifs médicaux (cast_saw par défaut).",
                    label = "Mini-jeu",
                },
                medicalWearablesSplintsEnabled = {
                    description = "Autorise les attelles en écharpe sur les bras gauche et droit.",
                    label = "Activé",
                },
                medicalWearablesSplintsItem = {
                    description = "Objet d'inventaire consommé lors de la pose d'une attelle.",
                    label = "Objet",
                },
                medicalWearablesSplintsMinigame = {
                    description = "Mini-jeu de traitement existant utilisé pour les attelles.",
                    label = "Mini-jeu",
                },
                medicalWearablesTorsoBandageEnabled = {
                    description = "Autorise le modèle de bandage du torse.",
                    label = "Activé",
                },
                medicalWearablesTorsoBandageItem = {
                    description = "Objet d'inventaire consommé pour un bandage du torse.",
                    label = "Objet",
                },
                medicalWearablesTorsoBandageMinigame = {
                    description = "Mini-jeu de traitement existant utilisé pour un bandage du torse.",
                    label = "Mini-jeu",
                },
                medicationsProfiles = {
                    description = "Entrées déclaratives de médicaments utilisées pour le traitement et l’automédication.",
                    itemLabel = "Médicament",
                    label = "Médicaments",
                },
                minigamesBagValveMaskEnabled = {
                    description = "Activez le mini-jeu du masque de valve de sac.",
                    label = "Masque à valve de sac",
                },
                minigamesCastSawEnabled = {
                    description = "Active le mini-jeu de scie pour retirer les dispositifs médicaux.",
                    label = "Scie à plâtre",
                },
                minigamesBandageWrapEnabled = {
                    description = "Activez le mini-jeu d'enveloppement de bandage.",
                    label = "Enveloppement de bandage",
                },
                minigamesBandageWrapRandomization = {
                    description = "Fait varier la direction, la forme et les proportions du trajet de la gaze.",
                    label = "Variation de la pose du bandage",
                },
                minigamesBloodPressureEnabled = {
                    description = "Activez le mini-jeu de tension artérielle.",
                    label = "Pression artérielle",
                },
                minigamesBloodTransfusionAccessRandomization = {
                    description = "Fait varier le trajet de l'accès veineux pour les transfusions sanguines.",
                    label = "Variation de l'accès pour transfusion",
                },
                minigamesBloodTransfusionEnabled = {
                    description = "Activez le mini-jeu de transfusion sanguine.",
                    label = "Transfusion sanguine",
                },
                minigamesBloodTransfusionVenousAccess = {
                    description = "Exige la procédure d'accès veineux en plusieurs étapes avant le contrôle du débit. Désactivez cette option pour conserver l'ancienne version simplifiée.",
                    label = "Étape d'accès veineux",
                },
                minigamesBulletExtractionEnabled = {
                    description = "Activez le mini-jeu d’extraction de balles.",
                    label = "Extraction de balles",
                },
                minigamesBulletExtractionRandomization = {
                    description = "Fait varier la forme, la largeur et les obstacles du canal de la blessure.",
                    label = "Variation de l'extraction de balle",
                },
                minigamesCprBreathsPerCycle = {
                    description = "Respirations nécessaires à chaque phase de ventilation.",
                    label = "Respirations par cycle",
                },
                minigamesCprCompressionDurationPerSet = {
                    description = "Quelques secondes pour terminer un jeu de compression.",
                    label = "Durée de compression par série",
                },
                minigamesCprCompressionWindow = {
                    description = "Décalage autorisé lors de l'atteinte d'un battement de compression.",
                    label = "Fenêtre de compression",
                },
                minigamesCprCompressionsEnabled = {
                    description = "Activez l’étape du mini-jeu des compressions CPR.",
                    label = "Compressions de RCP",
                },
                minigamesCprCompressionsPerSet = {
                    description = "Nombre de compressions par jeu.",
                    label = "Compressions par série",
                },
                minigamesCprCycles = {
                    description = "Combien de cycles de RCP sont nécessaires pour terminer le mini-jeu.",
                    label = "Cycles",
                },
                minigamesCprEnabled = {
                    description = "Activez le mini-jeu CPR.",
                    label = "CPR",
                },
                minigamesCprIntroDelaySeconds = {
                    description = "Compte à rebours avant le début des compressions CPR.",
                    label = "Secondes de retard d'introduction",
                },
                minigamesCprMaxMisses = {
                    description = "Manques autorisés avant d’échouer au mini-jeu CPR.",
                    label = "Max rate",
                },
                minigamesCprSetsPerCycle = {
                    description = "Combien de séries de compression sont exécutées avant une étape respiratoire.",
                    label = "Ensembles par cycle",
                },
                minigamesCprVentilationEnabled = {
                    description = "Activez l’étape du mini-jeu de ventilation CPR.",
                    label = "Ventilation RCR",
                },
                minigamesGlucoseMeterEnabled = {
                    description = "Activez le mini-jeu du glucomètre.",
                    label = "Glucomètre",
                },
                minigamesPulseMeasurementEnabled = {
                    description = "Activez le mini-jeu de mesure du pouls.",
                    label = "Mesure du pouls",
                },
                minigamesPulseOximeterEnabled = {
                    description = "Activez le mini-jeu de l'oxymètre de pouls.",
                    label = "Oxymètre de pouls",
                },
                minigamesSalineInfusionEnabled = {
                    description = "Activez le mini-jeu d'infusion de solution saline.",
                    label = "Infusion saline",
                },
                minigamesVentilationBreathTimeoutSeconds = {
                    description = "Quelques secondes avant l'expiration d'une tentative de ventilation. Définissez 0 pour désactiver.",
                    label = "Secondes d'expiration du souffle",
                },
                minigamesVentilationEnabled = {
                    description = "Activez le mini-jeu de ventilation.",
                    label = "Ventilation",
                },
                minigamesVentilationTolerance = {
                    description = "Tolérance de distance des pixels lors du traçage de l'onde de flux d'air.",
                    label = "Tolérance",
                },
                operationsBreakDistance = {
                    description = "Distance maximale des participants à la salle avant l'interruption de l'intervention.",
                    label = "Distance d'interruption",
                },
                operationsDoctorAnimationDict = {
                    description = "Dictionnaire d'animation GTA utilisé par le chirurgien pendant une véritable intervention.",
                    label = "Dictionnaire d'animation du chirurgien",
                },
                operationsDoctorAnimationFlag = {
                    description = "Indicateur d'animation GTA appliqué à l'animation du chirurgien pendant l'intervention.",
                    label = "Indicateur d'animation du chirurgien",
                },
                operationsDoctorAnimationName = {
                    description = "Clip d'animation utilisé par le chirurgien pendant une véritable intervention.",
                    label = "Nom de l'animation du chirurgien",
                },
                operationsEnabled = {
                    description = "Active les salles d'opération et les interventions chirurgicales.",
                    label = "Activé",
                },
                operationsFadeInMs = {
                    description = "Durée en millisecondes du retour à l'image du patient lors du réveil.",
                    label = "Fondu de réveil (ms)",
                },
                operationsFadeOutMs = {
                    description = "Durée en millisecondes du fondu au noir du patient lors de l'anesthésie.",
                    label = "Fondu d'anesthésie (ms)",
                },
                operationsIdleTimeoutSeconds = {
                    description = "Durée maximale sans action valide dans le mini-jeu avant l’annulation de la session.",
                    label = "Délai d’inactivité (s)",
                },
                operationsInteractDistance = {
                    description = "Distance maximale d'affichage et d'utilisation des interactions de la salle d'opération.",
                    label = "Distance d'interaction",
                },
                operationsInteractKey = {
                    description = "ID de contrôle utilisé pour interagir avec la table d'opération et la position du chirurgien.",
                    label = "Touche d'interaction",
                },
                operationsPatientAnimationDict = {
                    description = "Dictionnaire d'animation GTA utilisé lorsque le patient est allongé sous anesthésie générale.",
                    label = "Dictionnaire d'animation du patient",
                },
                operationsPatientAnimationFlag = {
                    description = "Indicateur d'animation GTA appliqué à l'animation allongée du patient.",
                    label = "Indicateur d'animation du patient",
                },
                operationsPatientAnimationName = {
                    description = "Clip d'animation utilisé lorsque le patient est allongé sous anesthésie générale.",
                    label = "Nom de l'animation du patient",
                },
                operationsPatientRange = {
                    description = "Rayon maximal utilisé pour détecter un patient allongé sur la table d'opération.",
                    label = "Rayon du patient",
                },
                operationsRequireOnDuty = {
                    description = "Exige que les chirurgiens soient en service avant d'utiliser une salle d'opération.",
                    label = "Service requis",
                },
                operationsSelectionTimeoutSeconds = {
                    description = "Durée maximale pendant laquelle le chirurgien peut rester sur le choix de l’opération avant l’annulation de la session.",
                    label = "Délai de sélection (s)",
                },
                operationsTrainingAnimationDict = {
                    description = "Dictionnaire d'animation GTA utilisé pour l'entraînement chirurgical sans patient.",
                    label = "Dictionnaire d'animation d'entraînement",
                },
                operationsTrainingAnimationFlag = {
                    description = "Indicateur d'animation GTA appliqué à l'animation d'entraînement chirurgical.",
                    label = "Indicateur d'animation d'entraînement",
                },
                operationsTrainingAnimationName = {
                    description = "Clip d'animation utilisé pour l'entraînement chirurgical sans patient.",
                    label = "Nom de l'animation d'entraînement",
                },
                painClassesProfiles = {
                    description = "Seuils de douleur, étiquettes et effets de post-traitement.",
                    label = "Cours sur la douleur",
                },
                painEffectsMinPainLevel = {
                    description = "Niveau de douleur minimum avant le début des effets d’écran de douleur.",
                    label = "Niveau de douleur minimum",
                },
                primaryColor = {
                    description = "Couleur principale de l'interface EMS et du groupe des métiers ambulanciers.",
                    label = "Couleur primaire",
                },
                propPlacementConsumeItem = {
                    description = "Consommez l'objet d'inventaire correspondant lorsque l'accessoire est placé.",
                    label = "Consommer l'article",
                },
                propPlacementEnabled = {
                    description = "Autoriser le placement d'accessoires EMS configurés à partir d'éléments d'inventaire utilisables.",
                    label = "Activé",
                },
                propPlacementItemNames = {
                    description = "Mappez les modèles d’accessoires EMS aux noms d’articles d’inventaire pour un placement basé sur les articles.",
                    label = "Noms des éléments d'accessoires",
                },
                propPlacementRequireOnDuty = {
                    description = "Exigez que le joueur soit en service avant de placer les accessoires EMS.",
                    label = "Exiger en service",
                },
                propPlacementReturnItem = {
                    description = "Rendez l'objet consommé lorsqu'un accessoire placé est supprimé.",
                    label = "Retourner l'article lors du retrait",
                },
                propPlacementVehicleAccess = {
                    description = "Autorisez les accessoires de tronc à ouvrir le flux de placement au lieu d'une utilisation uniquement pour les éléments.",
                    label = "Accès aux véhicules",
                },
                publicTreatmentAllowConsciousPatients = {
                    description = "Autoriser le traitement public des joueurs conscients.",
                    label = "Autoriser les patients conscients",
                },
                publicTreatmentAllowedGangs = {
                    label = "Gangs autorisés",
                    description = "Sélectionnez les noms internes des gangs ou organisations indépendantes. Un métier ou gang correspondant accorde l’autorisation ou l’exemption. Le service est exigé uniquement pour les métiers. Rangs minimums facultatifs. Une liste vide autorise tous les rangs. Les objets requis restent nécessaires.",
                },
                publicTreatmentAllowedJobs = {
                    description = "Emplois pouvant recourir au traitement public sans être EMS.",
                    label = "Emplois autorisés",
                },
                publicTreatmentEnabled = {
                    description = "Permettre le traitement public pour les intervenants non-EMS avec un accès valide.",
                    label = "Traitement public activé",
                },
                publicTreatmentInteractDistance = {
                    description = "Distance maximale requise pour démarrer un traitement public.",
                    label = "Distance d'interaction",
                },
                publicTreatmentKeybind = {
                    description = "Combinaison de touches d'interaction par défaut utilisée pour le traitement public.",
                    label = "Affectation de touches",
                },
                publicTreatmentInteractionEnabled = {
                    description = "Affiche l’invite de soins et active la touche associée. Désactivez cette option si vous utilisez des exports ou un menu radial personnalisé.",
                    label = "Interaction au clavier activée",
                },
                publicTreatmentPromptDistance = {
                    description = "Distance utilisée pour afficher l'invite de traitement public.",
                    label = "Distance rapide",
                },
                publicTreatmentRequireAllItems = {
                    description = "Exigez tous les articles médicaux répertoriés au lieu d’un seul.",
                    label = "Exiger tous les éléments",
                },
                publicTreatmentRequiredItems = {
                    description = "Inventaire des articles qui comptent comme équipement de traitement public valide.",
                    itemLabel = "Article",
                    label = "Éléments requis",
                },
                reviveRewardAccount = {
                    description = "Clé de compte principale utilisée pour relancer les paiements de récompense.",
                    label = "Compte",
                },
                reviveRewardAccountType = {
                    description = "Type de compte principal utilisé pour relancer les paiements de récompense.",
                    label = "Type de compte",
                },
                reviveRewardAmount = {
                    description = "Montant de la récompense versée au médecin pour une réanimation.",
                    label = "Montant",
                },
                reviveRewardCurrency = {
                    description = "Clé de devise personnalisée en option utilisée pour relancer les paiements de récompense.",
                    label = "Devise",
                },
                reviveRewardEnabled = {
                    description = "Payez une récompense configurée après une réanimation médicale réussie.",
                    label = "Activé",
                },
                reviveRewardPayFromSociety = {
                    description = "Déduisez les récompenses de relance de la société de travail partagé avant de payer le médecin.",
                    label = "Payer de la société",
                },
                selfDiagnoseCommand = {
                    description = "Commande de chat utilisée pour ouvrir l'auto-diagnostic.",
                    label = "Commande",
                },
                selfDiagnoseEnabled = {
                    description = "Autoriser les joueurs à ouvrir l'interface utilisateur de diagnostic sur eux-mêmes.",
                    label = "Auto-diagnostic activé",
                },
                selfDiagnoseKeybind = {
                    description = "Combinaison de touches par défaut utilisée pour ouvrir l'auto-diagnostic.",
                    label = "Affectation de touches",
                },
                selfDiagnoseOpenDelayMs = {
                    description = "Délai avant l'ouverture de l'interface utilisateur d'auto-diagnostic.",
                    label = "Retard d'ouverture ms",
                },
                selfDiagnoseRequireMedicJob = {
                    description = "Restreindre l'autodiagnostic aux emplois médicaux uniquement.",
                    label = "Exiger un travail médical",
                },
                selfDiagnoseSkipFreezeOnSelf = {
                    description = "Ne figez pas le lecteur pendant l'auto-diagnostic.",
                    label = "Passer le gel sur soi-même",
                },
                statusEffectsProfiles = {
                    description = "Effets d'écran configurés et seuils de saignement, d'hypoglycémie, de faim et de soif.",
                    label = "Effets de statut",
                },
                stretcherAnimDict = {
                    description = "Dictionnaire d'animation utilisé lors du transport de la civière.",
                    label = "Dicton d'animation",
                },
                stretcherAnimName = {
                    description = "Nom de l'animation utilisé lors du transport de la civière.",
                    label = "Nom de l'animation",
                },
                stretcherAttachRx = {
                    description = "Carry attach X rotation pour la civière.",
                    label = "Joindre RX",
                },
                stretcherAttachRy = {
                    description = "Carry attach Y rotation pour la civière.",
                    label = "Attacher RY",
                },
                stretcherAttachRz = {
                    description = "Carry attach Z rotation pour la civière.",
                    label = "Attacher RZ",
                },
                stretcherAttachX = {
                    description = "Attache de transport X décalée pour la civière.",
                    label = "Joindre X",
                },
                stretcherAttachY = {
                    description = "Attache de transport Y déportée pour le brancard.",
                    label = "Joindre Y",
                },
                stretcherAttachZ = {
                    description = "Attache de transport décalée Z pour la civière.",
                    label = "Attacher Z",
                },
                stretcherFoldedEnabled = {
                    description = "Activez la variante optionnelle de civière pliée à l’intérieur des véhicules.",
                    label = "Plié activé",
                },
                stretcherFoldedModel = {
                    description = "Modèle d'accessoire utilisé pour la variante de civière pliée.",
                    label = "Modèle plié",
                },
                stretcherFoldedPatientAttachHeading = {
                    description = "Tête de patient utilisée pour la variante de civière pliée.",
                    label = "Tête de patient pliée",
                },
                stretcherFoldedPatientAttachX = {
                    description = "Le patient fixe le décalage X pour la civière pliée.",
                    label = "Patient plié X",
                },
                stretcherFoldedPatientAttachY = {
                    description = "Le patient fixe le décalage en Y pour la civière pliée.",
                    label = "Patient plié Y",
                },
                stretcherFoldedPatientAttachZ = {
                    description = "Le patient fixe le décalage Z pour la civière pliée.",
                    label = "Patient plié Z",
                },
                stretcherHelicopterInteractDistance = {
                    description = "Remplacement de la distance d'interaction utilisé pour les hélicoptères.",
                    label = "Distance d'interaction de l'hélicoptère",
                },
                stretcherHelicopterModels = {
                    description = "Modèles de véhicules traités comme des hélicoptères civières.",
                    itemLabel = "Modèle",
                    label = "Modèles d'hélicoptères",
                },
                stretcherHelicopterPickupDistance = {
                    description = "Annulation de distance de prise en charge utilisée pour les hélicoptères.",
                    label = "Distance de prise en charge en hélicoptère",
                },
                stretcherInteractDistance = {
                    description = "Distance maximale pour les invites d'interaction avec la civière.",
                    label = "Distance d'interaction",
                },
                stretcherItemEnabled = {
                    description = "Active l'objet de brancard dans l'inventaire, y compris son achat en boutique et son utilisation.",
                    label = "Objet brancard",
                },
                stretcherItemPickupEnabled = {
                    description = "Autorise le retour dans l'inventaire des brancards déployés depuis l'objet d'inventaire.",
                    label = "Récupération de l'objet",
                },
                stretcherModel = {
                    description = "Modèle d'accessoire de civière principal utilisé par le système de civière EMS.",
                    label = "Modèle",
                },
                stretcherPatientAnimationDict = {
                    description = "Dictionnaire d’animation des patients sur brancard et du PNJ de prévisualisation.",
                    label = "Dictionnaire d’animation du patient",
                },
                stretcherPatientAnimationName = {
                    description = "Clip d’animation des patients sur brancard et du PNJ de prévisualisation.",
                    label = "Nom de l’animation du patient",
                },
                stretcherPatientAttachHeading = {
                    description = "Tête de patient utilisée en position couchée sur la civière.",
                    label = "En-tête du patient",
                },
                stretcherPatientAttachX = {
                    description = "Le patient fixe le décalage X sur la civière.",
                    label = "Patient X",
                },
                stretcherPatientAttachY = {
                    description = "Le patient fixe le décalage Y sur la civière.",
                    label = "Patiente Y",
                },
                stretcherPatientAttachZ = {
                    description = "Le patient fixe le décalage Z sur la civière.",
                    label = "Patient Z",
                },
                stretcherPickupDistance = {
                    description = "Distance requise pour récupérer et interagir avec la civière.",
                    label = "Distance de prise en charge",
                },
                stretcherTreatmentAnimClip = {
                    description = "Clip d'animation utilisé lors du traitement d'un patient sur une civière. Laissez vide pour utiliser un scénario ou le repli de l'animation de traitement.",
                    label = "Nom de l'animation",
                },
                stretcherTreatmentAnimDict = {
                    description = "Dictionnaire d'animation utilisé lors du traitement d'un patient sur une civière. Laissez vide pour utiliser un scénario ou le repli de l'animation de traitement.",
                    label = "Dictionnaire d'animation",
                },
                stretcherTreatmentAnimScenario = {
                    description = "Scénario facultatif utilisé lors du traitement d’un patient sur une civière. Laissez vide pour utiliser dict + clip ou le repli de l'animation de traitement.",
                    label = "Scénario",
                },
                stretcherVehicleAttachEditor = {
                    description = "Positionne et oriente la civière dans une ambulance configurée.",
                    label = "Fixation au véhicule",
                },
                stretcherVehicleAttachRx = {
                    description = "Fixation du véhicule rotation X pour charger la civière.",
                    label = "Véhicule RX",
                },
                stretcherVehicleAttachRy = {
                    description = "Rotation en Y de fixation du véhicule pour le chargement de la civière.",
                    label = "Véhicule RY",
                },
                stretcherVehicleAttachRz = {
                    description = "Fixation du véhicule rotation Z pour charger la civière.",
                    label = "Véhicule RZ",
                },
                stretcherVehicleAttachX = {
                    description = "Fixation du véhicule déport X pour le chargement de la civière.",
                    label = "Véhicule X",
                },
                stretcherVehicleAttachY = {
                    description = "Fixation du véhicule déport en Y pour le chargement de la civière.",
                    label = "Véhicule Y",
                },
                stretcherVehicleAttachZ = {
                    description = "Fixation du véhicule déport Z pour le chargement de la civière.",
                    label = "Véhicule Z",
                },
                stretcherVehicleModels = {
                    description = "Modèles de véhicules autorisés à charger la civière.",
                    itemLabel = "Modèle",
                    label = "Modèles de véhicules",
                },
                treatmentAnimClip = {
                    description = "Clip d'animation utilisé lors du traitement d'un patient. Laissez vide pour utiliser un scénario à la place.",
                    label = "Nom de l'animation",
                },
                treatmentAnimDict = {
                    description = "Dictionnaire d'animation utilisé lors du traitement d'un patient. Laissez vide pour utiliser un scénario à la place.",
                    label = "Dictionnaire d'animation",
                },
                treatmentAnimScenario = {
                    description = "Scénario utilisé lors du traitement d'un patient. Laissez vide pour utiliser dict + clip à la place.",
                    label = "Scénario",
                },
                trunkPropsEnabled = {
                    label = "Props du véhicule",
                    description = "Choisissez les props près d’un véhicule de service.",
                },
                trunkEnabled = {
                    description = "Activez la fonction de coffre du véhicule pour les véhicules d’ambulance.",
                    label = "Activé",
                },
                vehicleDamageModifier = {
                    description = "Multiplicateur de dégâts appliqué lorsque le joueur est à l'intérieur d'un véhicule.",
                    label = "Modificateur de dégâts du véhicule",
                },
                vehicleImpactProtectionCauses = {
                    description = "Causes de décès qui devraient être considérées comme des impacts de véhicules protégés.",
                    itemLabel = "Cause",
                    label = "Causes des dommages",
                },
                vehicleImpactProtectionEnabled = {
                    description = "Empêchez les impacts de véhicules à basse vitesse de tuer le joueur.",
                    label = "Activé",
                },
                vehicleImpactProtectionFatalSpeedKmh = {
                    description = "Les impacts de véhicules en dessous de cette vitesse ne peuvent pas tuer le joueur.",
                    label = "Vitesse fatale km/h",
                },
                vehicleImpactProtectionFullDamageSpeedKmh = {
                    description = "Les impacts de véhicules à cette vitesse ou au-dessus utilisent la configuration normale de blessure mortelle.",
                    label = "Vitesse totale de dégâts km/h",
                },
                vehicleImpactProtectionInjuries = {
                    description = "Blessures appliquées lorsque la protection contre les chocs du véhicule bloque un coup mortel.",
                    itemLabel = "Blessure",
                    label = "Blessures",
                },
                vehicleImpactProtectionSurvivalHealthPercent = {
                    description = "Pourcentage de santé maximale préservée lorsqu'un impact protégé aurait tué le joueur.",
                    label = "Pourcentage de santé de survie",
                },
                vehiclePullEnabled = {
                    description = "Permet de retirer les patients des véhicules.",
                    label = "Activé",
                },
                vehiclePullMaxDistance = {
                    description = "Distance maximale requise pour tirer un patient d'un véhicule.",
                    label = "Distance maximale",
                },
                wheelchairAssignMaxDistance = {
                    description = "Distance maximale pour attribuer un fauteuil roulant à un autre joueur.",
                    label = "Attribuer une distance maximale",
                },
                wheelchairAutoUnequipOnExpire = {
                    description = "Déséquipez automatiquement le fauteuil roulant à l'expiration de la mission.",
                    label = "Déséquipement automatique à l'expiration",
                },
                wheelchairDefaultDurationMinutes = {
                    description = "Durée attribuée par défaut au fauteuil roulant en minutes.",
                    label = "Durée par défaut",
                },
                wheelchairDisableSprint = {
                    description = "Bloquez le sprint pendant que le fauteuil roulant est équipé.",
                    label = "Désactiver le sprint",
                },
                wheelchairDisableWeapons = {
                    description = "Bloquez l’utilisation d’armes lorsque le fauteuil roulant est équipé.",
                    label = "Désactiver les armes",
                },
                wheelchairExitControl = {
                    description = "ID de contrôle utilisé pour quitter le fauteuil roulant.",
                    label = "Contrôle de sortie",
                },
                wheelchairItemName = {
                    description = "Article d'inventaire utilisé pour le fauteuil roulant.",
                    label = "Nom de l'article",
                },
                wheelchairMaxDurationMinutes = {
                    description = "Durée maximale autorisée de l'affectation d'un fauteuil roulant en minutes.",
                    label = "Durée maximale",
                },
                wheelchairMinDurationMinutes = {
                    description = "Durée minimale autorisée de l'affectation d'un fauteuil roulant en minutes.",
                    label = "Durée minimale",
                },
                wheelchairVehicle = {
                    description = "Modèle de véhicule utilisé pour le fauteuil roulant.",
                    label = "Modèle de véhicule",
                },
                xrayInteractionRange = {
                    description = "Distance maximale de la station de radiographie pour l'opérateur.",
                    label = "Plage d'interaction",
                },
                xrayPatientRange = {
                    description = "Distance maximale de la station de radiographie pour le patient.",
                    label = "Gamme de patients",
                },
                xrayScanDurationSeconds = {
                    description = "Durée en secondes du résultat de la radiographie.",
                    label = "Durée de l'analyse",
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
                firstAidPublicTreatmentConflict = "Les premiers secours et le traitement public ne peuvent pas être activés en même temps. L'enregistrement désactive les deux.",
            },
        },
    },
}
