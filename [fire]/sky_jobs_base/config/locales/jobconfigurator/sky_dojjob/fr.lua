JobConfigLocales["sky_dojjob:fr"] = {
    Nui = {
        tablet = { apps = { doj_finance = "Finances" ,
                doj_conditions = "Conditions générales",
                doj_elections = "Élections",
                doj_files = "Explorateur de fichiers de cas",
                doj_hearings = "Audiences",
                doj_law = "Codes juridiques",
                doj_offences = "Catalogue fin",
                doj_shared_files = "Documents partagés",
            } },
        workshopConfig = {
            recordsAccessGuide = {
                title = "Configurer l'accès aux dossiers",
                description = "Choisissez qui peut accéder aux dossiers et dans quel domaine. Les grades sans affectation n'ont aucun accès.",
                status = {
                    unpublished = "L'affectation n'est pas encore publiée",
                    conflict = "Résolvez les affectations en double",
                    disabled = "La tablette du DOJ est désactivée",
                    incomplete = "Affectez au moins un grade",
                    ready = "Prêt à enregistrer",
                },
                steps = {
                    tabletTitle = "Activer la tablette du DOJ",
                    tabletText = "La tablette doit être activée pour ouvrir les applications de dossiers.",
                    gradesTitle = "Affecter les grades du DOJ",
                    gradesText = "Sélectionnez exactement un domaine de dossiers pour chaque grade qui doit obtenir un accès.",
                    publishTitle = "Publier et enregistrer",
                    publishText = "Une nouvelle version de l'affectation est préparée automatiquement après chaque modification.",
                },
                grades = {
                    title = "Affectation des grades",
                    description = "Sélectionnez un domaine par grade. Choisissez Aucun accès pour les grades qui doivent rester bloqués.",
                    search = "Rechercher des grades",
                    conflict = "Un grade possède plusieurs affectations. Sélectionnez un domaine ou Aucun accès pour résoudre le conflit.",
                    notFound = "N'existe plus dans le framework",
                    noResults = "Aucun grade correspondant.",
                    empty = "Aucun grade trouvé pour le métier DOJ configuré.",
                    emptyHint = "Créez d'abord les grades DOJ dans votre framework, puis rouvrez le configurateur.",
                    gradeColumn = "Catégorie",
                    domainColumn = "Domaine de dossiers",
                    noAccess = "Aucun accès",
                    chooseDomain = "Résoudre l'affectation",
                    assigned = "grades affectés",
                },
                publish = {
                    saveHint = "Cliquez sur Enregistrer en haut pour appliquer vos modifications. Les joueurs pourront ensuite vérifier leur accès à nouveau.",
                },
            },
            registryFiles = { licenseType = "Type de licence", licenseLabel = "Nom du registre", marriages = "Registre des mariages" },
            features = {
                dojHandovers = {
                    label = "Transmissions",
                    description = "Active les transmissions, les décisions judiciaires et les rapports d’exécution. Les documents et leur partage restent disponibles.",
                },
                dojBodycamRequests = {
                    label = "Demandes de vidéos embarquées",
                    description = "Demander des vidéos de police. Nécessite les transmissions ; les enregistrements sauvegardés restent disponibles séparément.",
                },
                dojFinance = { label = "Finances", description = "Soldes des factions, virements du Trésor et historique." },
                dojConditions = {
                    description = "Activer les conditions structurées, les preuves, les délais et le suivi des violations.",
                    label = "Conditions générales",
                },
                dojCourtroom = {
                    description = "Activer des séances d'audience en direct sécurisées, la présentation d'éléments de preuve et les interactions avec les salles de conférence axées sur le rôle.",
                    label = "Salle d ' audience en direct",
                },
                dojElections = {
                    description = "Activer l'administration électorale et sécuriser le vote dans les bureaux de vote enregistrés.",
                    label = "Élections",
                },
                dojHearings = {
                    description = "Activer le calendrier des audiences, l'enregistrement et les contrôles de l'état des audiences faisant autorité.",
                    label = "Audiences",
                },
                dojLegalCodes = {
                    description = "Activer les livres juridiques, l'édition en texte riche et l'historique des révisions.",
                    label = "Codes juridiques",
                },
                dojOffences = {
                    description = "Activez le catalogue d'infraction compact et l'aperçu de calculateur.",
                    label = "Catalogue fin",
                },
                dojPrinters = {
                    description = "Activer les imprimantes physiques et leur infrastructure d'exécution.",
                    label = "Imprimantes",
                },
                dojPublicDisplays = {
                    description = "Activer les données en direct filtrées par la vie privée pour les affichages du palais de justice.",
                    label = "Salles d ' audience publiques",
                },
                dojTablet = {
                    description = "Activez l'accès aux applications de la tablette DOJ.",
                    label = "DOJ comprimé",
                },
                dojTaxes = {
                    description = "Recueillir périodiquement les taxes sur les véhicules et les maisons auprès des joueurs en ligne.",
                    label = "Impôts sur les actifs",
                },
            },
            settingSections = {
                finance = "Finances",
                courtroom = "Salle d ' audience",
                registries = "Registre",
                courthouses = "Palais de justice",
                general = "Général",
                legalCodes = "Codes juridiques",
                offences = "Catalogue fin",
                recordsAccess = "Accès au dossier",
                tablet = "Tablette",
                taxes = "Impôts",
            },
            settings = {
                dojRegistryLicenses = {
                    label = "Registres des licences",
                    description = "Choisissez les licences que le DOJ peut délivrer. Chaque entrée forme un registre distinct. Supprimer une entrée ne révoque pas les licences existantes.",
                },
                dojRegistryAccess = {
                    ["label"] = "Accès aux fichiers de registre",
                    ["description"] = "Modifiez l’accès aux registres de config/registry. Une liste vide utilise les valeurs des fichiers. Les champs et fonctions serveur/client se modifient dans les fichiers Lua.",
                },
                dojTreasuryJob = { label = "Métier du Trésor", description = "Métier dont le compte commun reçoit les prélèvements et finance les virements." },
                dojFinanceJobs = { label = "Factions visibles", description = "Identifiants des métiers enregistrés disponibles dans les comptes. Le Trésor est toujours inclus." },
                dojFinanceLimit = { label = "Plafond par opération", description = "Montant maximal par virement ou prélèvement." },
                dojFinePaymentMode = { label = "Paiement des amendes imposées", description = "Paiement bancaire direct ou facture externe. Créer une facture ne confirme pas son paiement.", options = { bank = "Paiement bancaire", billing = "Facture" } },
                dojFineSociety = { label = "Bénéficiaire des amendes", description = "Métier dont le compte commun reçoit les amendes imposées." },
                dojCourtroomBoardMove = {
                    label = "Déplacer la salle d'audience",
                    description = "Clé par défaut pour saisir ou libérer une carte mobile (p. ex. F). Les joueurs peuvent la surcharger dans les liaisons de touches FiveM. Le mouvement est temporaire et se réinitialise après le redémarrage.",
                },
                dojCourtroomGavel = {
                    label = "Le juge a donné",
                    description = "Modèle de gavel, fixation à la main, animation, son et motifs de frappe. Les changements s'appliquent également sans redémarrer.",
                },
                dojHearingParticipantRoles = {
                    label = "Rôles des participants",
                    description = "Rôles par défaut : défendeur, témoin, juré, juge. Ajouter des clés de rôle en minuscules personnalisées ici (jusqu'à 24 caractères, soulignement autorisé).",
                },
                dojWarrantTemplateCodes = {
                    label = "Codes du modèle de mandat",
                    description = "Codes types indiqués sous PD Mandats après signature judiciaire et partage. Défauts : HB, DB, RB.",
                },
                dojRegistryCatalog = {
                    label = "DOJ registres",
                    description = "Activer et nommer DOJ les registres, puis fixer l'accès à l'emploi et l'autorisation. DOJ Les permissions de rôle s'appliquent toujours. RP les registres sont gérés dans la base d'emplois.",
                },
                dojCourthouseBlipCategory = {
                    description = "Étiquette de catégorie utilisée pour les blips de carte du palais de justice.",
                    label = "Catégorie de glissement",
                },
                dojCourthouseBlipColor = {
                    description = "Couleur de carte utilisée pour les palais de justice.",
                    label = "Couleur du blip",
                },
                dojCourthouseBlipScale = {
                    description = "Échelle de carte utilisée pour les blips du palais de justice.",
                    label = "Échelle de glissement",
                },
                dojCourthouseBlipShortRange = {
                    description = "Ne montrez que les blips du palais de justice à courte portée.",
                    label = "Courte portée",
                },
                dojCourthouseBlipSprite = {
                    description = "Carte sprite utilisée pour les tribunaux.",
                    label = "Sprite du blip",
                },
                dojLegalBookItem = {
                    description = "Item d'inventaire pour une édition de code légal fixe. Première utilisation enregistre son contenu et sa date; nécessite des éléments individuels avec des métadonnées.",
                    label = "Élément du carnet de codes juridiques",
                },
                dojLegalCreateBookRateLimitMs = {
                    description = "Minimum millisecondes entre les demandes de création de livres juridiques.",
                    label = "Créer le cooldown du livre",
                },
                dojLegalCreateRevisionRateLimitMs = {
                    description = "Minimum millisecondes entre les requêtes de création de révision.",
                    label = "Créer un cooldown de révision",
                },
                dojLegalDeleteBookRateLimitMs = {
                    description = "Minimum millisecondes entre les demandes de suppression de livres légaux.",
                    label = "Supprimer le refroidissement du livre",
                },
                dojLegalDeleteRevisionRateLimitMs = {
                    description = "Minimum millisecondes entre les requêtes de suppression de révision.",
                    label = "Supprimer le refroidissement de la révision",
                },
                dojLegalGetBookRateLimitMs = {
                    description = "Minimum millisecondes entre les demandes d'un livre légal.",
                    label = "Refroidissement du carnet de chargement",
                },
                dojLegalGetBooksRateLimitMs = {
                    description = "Minimum millisecondes entre les demandes de liste de livres juridiques.",
                    label = "Recharger la bibliothèque",
                },
                dojLegalLargeRequestTimeoutMs = {
                    description = "Délai minimum utilisé pour les demandes de documents volumineux.",
                    label = "Délai de demande important en millisecondes",
                },
                dojLegalMaxAbbreviationLength = {
                    description = "Nombre maximal de caractères autorisés dans une abréviation de livre légal.",
                    label = "Longueur maximale de l'abréviation",
                },
                dojLegalMaxBookTitleLength = {
                    description = "Nombre maximal de caractères autorisés dans un titre de livre légal.",
                    label = "Durée maximale du titre du livre",
                },
                dojLegalMaxContentBytes = {
                    description = "Taille maximale sérialisée d'une révision complète du livre juridique.",
                    label = "Taille maximale du contenu en octets",
                },
                dojLegalMaxParagraphTitleLength = {
                    description = "Durée maximale du titre acceptée lors de l'importation des anciens paragraphes structurés.",
                    label = "Durée maximale du titre du paragraphe précédent",
                },
                dojLegalMaxParagraphsPerBook = {
                    description = "Nombre maximal de paragraphes structurés acceptés lors des importations antérieures.",
                    label = "Le maximum de paragraphes hérités par livre",
                },
                dojLegalMaxRevisionSummaryLength = {
                    description = "Nombre maximal de caractères admis dans une note de révision.",
                    label = "Longueur maximale de la note de révision",
                },
                dojLegalMaxRichTextNodes = {
                    description = "Nombre maximal de nœuds d'éditeurs autorisés dans une révision.",
                    label = "Nœuds de texte riche maximum",
                },
                dojLegalPayloadBytesPerSecond = {
                    description = "Limite de bande passante par joueur utilisée pour transférer de grands documents juridiques.",
                    label = "Taux de transfert en octets par seconde",
                },
                dojLegalReorderBooksRateLimitMs = {
                    description = "Minimum millisecondes entre les demandes de réordre de livres légaux.",
                    label = "Recommander les livres refroidir",
                },
                dojLegalUpdateBookRateLimitMs = {
                    description = "Minimum millisecondes entre les mises à jour des métadonnées du livre juridique.",
                    label = "Mettre à jour le cooldown du livre",
                },
                dojLegalVisibleRevisionHistory = {
                    description = "Nombre maximal de révisions chargées lors de l'ouverture d'un livre légal.",
                    label = "Historique des révisions visibles",
                },
                dojOffenceCalculateRateLimitMs = {
                    description = "Minimum de millisecondes entre les prévisualisations de calculatrice côté serveur.",
                    label = "Refroidissement de la calculatrice",
                },
                dojOffenceGetCatalogueRateLimitMs = {
                    description = "Minimum de millisecondes entre les demandes de catalogue.",
                    label = "Refroidissement du catalogue de chargement",
                },
                dojOffenceMaxSelection = {
                    description = "Nombre maximal d'infractions incluses dans un aperçu de calculateur.",
                    label = "Sélection maximale",
                },
                dojOffenceMutationRateLimitMs = {
                    description = "Minimum millisecondes entre les changements apportés au catalogue des infractions.",
                    label = "Refroidissement de la modification du catalogue",
                },
                dojOffenceMirandaWarning = {
                    description = "Avertissement personnalisé affiché dans le catalogue fin. Laissez vide pour utiliser le texte standard dans la langue sélectionnée.",
                    label = "Avertissement de Miranda",
                },
                dojPrimaryColor = {
                    description = "Couleur principale utilisée par le groupe professionnel DOJ et tablette.",
                    label = "Couleur principale",
                },
                dojRecordsCourtAdministrationGradeKeys = {
                    description = "Ces grades travaillent avec l'administration des tribunaux et les dossiers du greffe.",
                    label = "Administration judiciaire",
                },
                dojRecordsJudiciaryGradeKeys = {
                    description = "Ces grades travaillent avec les dossiers et les décisions judiciaires.",
                    label = "Pouvoir judiciaire",
                },
                dojRecordsMappingVersion = {
                    description = "Révision publiée de la cartographie grade-to-records-domaine. Une valeur vide maintient l'accès aux enregistrements désactivés.",
                    label = "Version de publication",
                },
                dojRecordsProsecutionGradeKeys = {
                    description = "Ces grades travaillent avec les dossiers des poursuites.",
                    label = "Poursuite",
                },
                dojTabletRequireDuty = {
                    description = "Seuls les employés en service DOJ peuvent ouvrir l'application de code juridique.",
                    label = "Exiger un devoir",
                },
                dojTaxCurrency = {
                    description = "Sky Base currency used only when the payment method is direct.",
                    label = "Monnaie directe",
                },
                dojTaxHouseAmount = {
                    description = "Montant facturé pour chaque maison appartenant à un joueur.",
                    label = "Impôt par maison",
                },
                dojTaxInitialDelaySeconds = {
                    description = "Secondes à attendre avant la première collecte quand aucun cycle fiscal précédent n'est stocké.",
                    label = "Délai initial",
                },
                dojTaxIntervalMinutes = {
                    description = "Minutes entre les cycles automatiques de recouvrement de l'impôt sur les actifs.",
                    label = "Intervalle de collecte",
                },
                dojTaxNotifyPlayer = {
                    description = "Avisez les joueurs après une collecte directe, une soumission de facture ou des fonds insuffisants.",
                    label = "Prévenez les joueurs",
                },
                dojTaxPaymentMode = {
                    description = "Utilisez le solde bancaire ou monétaire sélectionné directement ou soumettez une facture de société Sky Base par joueur imposable et cycle fiscal.",
                    label = "Mode de paiement",
                    options = {
                        bills = "Sky Base bills",
                        direct = "Solde bancaire/monétaire",
                    },
                },
                dojTaxSocietyJob = {
                    description = "DOJ profession dont le compte de société configuré reçoit toutes les recettes fiscales perçues.",
                    label = "Bénéficiaire DOJ profession",
                },
                dojTaxVehicleAmount = {
                    description = "Montant facturé pour chaque véhicule appartenant à un joueur.",
                    label = "Taxe par véhicule",
                },
            },
            printers = {
                groups = {
                    paper = "Papier",
                    ink = "Encre",
                    general = "Imprimante",
                    printing = "Impression et accès",
                    placement = "Modèle et placement",
                },
                actions = {
                    selectExisting = "Sélectionner une imprimante existante",
                    selectExistingHint = "Visez l’imprimante. Entrée : sélectionner · Échap : annuler",
                    add = "Ajouter une imprimante",
                    open = "Examiner l’imprimante",
                    place = "Placer l’imprimante",
                    setPosition = "Utiliser la position actuelle",
                },
                classes = {
                    office = "Bureau",
                    professional = "Professionnelle",
                    standard = "Norme",
                },
                description = "Configurer les imprimantes, les consommables, les files, les accès et le placement pour ce métier.",
                fieldDescriptions = {
                    paperCapacity = "Quantité maximale de papier pour chaque imprimante de ce métier.",
                    paperEnabled = "Lorsque cette option est activée, les imprimantes de ce métier sont initialement vides et nécessitent l’objet de recharge commun.",
                    refillAmount = "Quantité de papier ajoutée à une imprimante de ce métier avec l’objet de recharge commun.",
                    refillItem = "Nom interne de l’objet d’inventaire consommé lors du rechargement d’une imprimante de ce métier.",
                },
                fields = {
                    active = "Actif",
                    class = "Catégorie",
                    heading = "Orientation",
                    id = "Identifiant stable",
                    label = "Nom",
                    maxQueue = "Capacité de la file",
                    minimumGrade = "Grade minimum",
                    paperCapacity = "Capacité en papier",
                    paperEnabled = "Exiger du papier",
                    propModel = "Modèle de l’objet",
                    refillAmount = "Papier par recharge",
                    refillItem = "Objet de recharge",
                    deleteCopiesAfterRestart = "Supprimer les copies au redémarrage",
                    deleteCopiesAfterRestartHint = "Supprimer les impressions non récupérées au redémarrage du service d’impression.",
                    spawnProp = "Créer l’objet",
                    speed = "Vitesse d’impression",
                    status = "État",
                    x = "X",
                    y = "Y",
                    z = "Z",
                },
                info = {
                    class = "Catégorie : {class}",
                    paper = "Papier : {paper} / {capacity}",
                    queue = "File : {queue} / {maxQueue}",
                    status = "État : {status}",
                    title = "Imprimante",
                },
                messages = {
                    grade_too_low = "Votre grade ne permet pas d’utiliser cette imprimante.",
                    invalid_amount = "La quantité de recharge est invalide.",
                    missingModel = "Choisissez un modèle d’imprimante valide avant de le placer.",
                    missing_refill_item = "Vous ne possédez pas l’objet de recharge configuré.",
                    no_refill_printer = "Aucune imprimante accessible nécessitant du papier à proximité.",
                    paper_capacity_exceeded = "La capacité en papier serait dépassée.",
                    paper_disabled = "La consommation de papier est désactivée pour cette imprimante.",
                    paper_full = "Le bac à papier de cette imprimante est déjà plein.",
                    printer_inactive = "Cette imprimante est désactivée.",
                    printer_not_found = "Cette imprimante n’existe plus.",
                    refill_cooldown = "Patientez un instant avant de recharger à nouveau.",
                    refilled = "{amount} feuilles ajoutées. Stock : {paper} / {capacity}.",
                    too_far_away = "Rapprochez-vous de l’imprimante.",
                    unavailable = "Imprimante indisponible.",
                    wrong_job = "Votre métier ne permet pas d’utiliser cette imprimante.",
                },
                settings = {
                    description = "Ces paramètres s’appliquent à toutes les imprimantes configurées pour ce métier.",
                    title = "Paramètres des imprimantes du métier",
                },
                statuses = {
                    maintenance = "Entretien",
                    offline = "Hors ligne",
                    online = "En ligne",
                },
                title = "Imprimantes",
                values = {
                    disabled = "Désactivé",
                    enabled = "Activé",
                    selectItem = "Choisir un objet",
                },
            },
            configs = {
                sky_dojjob = {
                    subtitle = "Configurer DOJ professions, lieux de tribunal, et l'application de code juridique.",
                    title = "Ministère de la Justice",
                },
            },
            creatorSections = {
                courthouses = {
                    entryLabel = "Palais de justice",
                    entryPluralLabel = "Palais de justice",
                    label = "Palais de justice",
                },
            },
            extensions = {
                invalidSelection = "Sélection invalide : {value}",
                trainingSettings = {
                    description = "Configurez l'accès à la formation, l'inscription, les approbations et la planification des cours pour cet emploi.",
                    label = "Paramètres d'entraînement",
                },
            },
            locations = {
                stationPosition = "Lieu / Blip sur la carte",
                stationPositionHint = "Point principal de cet emplacement de job. Si le blip sur la carte est activé sous Job → Blips, il apparaîtra ici.",
                addCourtroom = "Ajouter une salle d'audience",
                courtroom = "Salle d ' audience",
                courtroom_display_desk_27 = "Affichage des éléments de preuve de la salle d'audience – moniteur de bureau 27 pouces",
                courtroom_display_wall_55 = "Affichage des éléments de preuve de la salle d'audience – mur 55-inch TV",
                courtroom_display_wall_75 = "Affichage des éléments de preuve de la salle d'audience – mur 75-inch TV",
                courtroom_display_wall_100 = "Affichage des éléments de preuve de la salle d'audience – mur 100-inch TV",
                courtroom_display_wall_120 = "Affichage des éléments de preuve de la salle d'audience – mur 120-inch TV",
                courtroom_display_wall_150 = "Affichage des éléments de preuve de la salle d'audience – mur 150-inch TV",
                courtroom_display_board_93 = "Tableau interactif de la salle d'audience – support mobile 150-inch",
                courtroom_display_projection = "Affichage des preuves de la salle d'audience – écran de projection 4.5 m",
                courtroom_judge_mic = "Salle d'audience – microphone du juge",
                courtroom_jury_room = "Salle d'audience – salle de jury",
                courtroom_room = "Salle d'audience – audience / centre de salle",
                courtroom_witness = "Salle d'audience – stand des témoins",
                electionBooth = "Organisation des votes",
                publicDisplayDesk27 = "Affichage public – moniteur de bureau 27 pouces",
                publicDisplayTerminal43 = "Affichage public – Terminal au sol de 43 pouces",
                publicDisplayWall55 = "Affichage public – mur 55-inch TV",
                publicDisplayWall75 = "Affichage public – mur 75-inch TV",
                publicDisplayWall100 = "Affichage public – mur 100-inch TV",
                publicDisplayWall120 = "Affichage public – mur 120-inch TV",
                publicDisplayWall150 = "Affichage public – mur 150-inch TV",
                publicDisplayProjection = "Affichage public – écran de projection 4.5 m",
                publicLegalCode = "Code juridique public",
            },
            settingGroups = {
                dojWarrants = {
                    label = "Mandats judiciaires",
                },
                dojAccess = {
                    label = "Accès",
                },
                dojCourthouseBlip = {
                    label = "Carte blip",
                },
                dojLegalBooks = {
                    label = "Livres",
                },
                dojLegalContentLimits = {
                    label = "Limites de contenu",
                },
                dojLegalItem = {
                    label = "Objet d'inventaire",
                },
                dojLegalRateLimits = {
                    label = "Limites de taux",
                },
                dojLegalRevisions = {
                    label = "Révisions",
                },
                dojLegalTransfers = {
                    label = "Grands documents",
                },
                dojOffenceCalculation = {
                    label = "Calculatrice",
                },
                dojOffenceRateLimits = {
                    label = "Limites de taux",
                },
                dojOffenceMiranda = {
                    label = "Guide des catalogues",
                },
                dojOffenceSource = {
                    label = "Source du catalogue",
                },
                dojRecordsGradeBindings = {
                    description = "Assignez chaque grade disponible DOJ à un domaine d'enregistrement, puis publiez le mapping.",
                    label = "Niveaux et domaines d'enregistrement",
                },
                dojTaxPayment = {
                    label = "Paiement",
                },
                dojTaxRates = {
                    label = "Taux",
                },
                dojTaxSchedule = {
                    label = "Tableau",
                },
            },
            registryCatalog = {
                names = {
                    notarial_contracts = "Contrats notariés",
                    powers_of_attorney = "Pouvoirs",
                    name_changes = "Changements de nom",
                    company_registry = "Registre des entreprises",
                    association_registry = "Registre des associations",
                    licensing = "Délivrance de licences",
                    administrative_decisions = "Décisions administratives",
                    administrative_objections = "Objections administratives",
                },
            },
            gavel = {
                enabled = "Activé",
                cooldown = "Refroidissement de déclenchement (ms)",
                defaultPreset = "Modèle de frappe par défaut",
                prop = "Poignée de javel",
                model = "Nom du modèle",
                bone = "Os des mains ID",
                offset = "Dépassement (en mètres)",
                rotation = "Rotation (degrés)",
                presets = "Modèles de grève",
                single = "Une seule grève",
                double = "Double grève",
                strikes = "Nombre de grèves",
                interval = "Intervalle de frappe (ms)",
                impact = "Délai sonore (ms)",
                audio = "Son",
                asset = "Atout audio",
                volume = "Volume",
                animation = "Animation",
                dict = "Dictionnaire d'animation",
                clip = "Nom de l'animation",
                duration = "Durée du mouvement (ms)",
                flag = "Drapeaux d'animation",
                x = "X",
                y = "Y",
                z = "Z",
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
        },
    },
}
