Locale                          = Locale or {}

Locale['fr'] = { -- 'fr' est la référence qui sera utilisée pour 'Config.Language'

    -- DEBUG SECTION

    --- Client-Side debugging
    DebugName                   = "[DEBUG]",
    ActualHatGlasses            = "ID du chapeau actuel : %s ID des lunettes actuelles : %s",
    PredictedHatGlasses         = "ID du chapeau prédit : %s ID des lunettes prédites : %s",
    PlayerHasHatGlasses         = "Le joueur a un chapeau? %s Le joueur a des lunettes? %s",
    HatFound                    = "Chapeau trouvé !",
    GlassesFound                = "Lunettes trouvées !",
    ComeCloser                  = "Come closer to inspect",
    HatCoordsSet                = "Coordonnées du chapeau définies : %s Rotation du chapeau définie : %s Entité : %s",
    GlassesCoordsSet            = "Coordonnées des lunettes définies : %s Rotation des lunettes définie : %s Entité : %s",
    DroppedPropCoordsSet        = "Coordonnées du prop relaché définies : %s Rotation du prop relaché définie : %s Entité : %s",
    NotPickableGender           = "%s\nPeut être ramassé : Non\nPourquoi : Sexe incorrect\nSexe : %s",
    NotPickableItem             = "%s\nPeut être ramassé : Non\nPourquoi : N'est pas un objet PickItBack",
    NotPickableAlredyEquipped   = "%s\nPeut être ramassé : Non\nPourquoi: Déjà equipé",
    PickableItem                = "%s\nPeut être ramassé : Oui\nID du dessin : %s\nID de la texture : %s\nSexe : %s",
    Hat                         = "Chapeau",
    Glasses                     = "Lunettes",
    PlayerInterrupted           = "Joueur interrompu pendant le ramassage",
    StartPickup                 = "Début du ramassage de l'objet : Type %s, Identifiant %s",
    PickupCompleted             = "Ramassage de l'objet réussi : Type %s, Identifiant %s",
    PickupFailed                = "Échec du ramassage de l'objet : Type %s, Identifiant %s",
    SyncingBackProps            = "Synchronisation des objets après échec du ramassage pour l'Identifiant %s",
    SyncingPropCoords           = "Synchronisation des coordonnées de l'objet pour l'Identifiant %s",
    PlayerInterruptedDetails    = "Mort ou mourrant : %s, Ragdoll : %s, Blessé : %s",

    --- Melee Debug
    MeleeDebugWeapon           = "Debug mêlée - Hash de l'arme de l'attaquant : %s",
    MeleeDebugConditions       = "Conditions de mêlée - IsMeleeHit: %s, IsConfigEnabled: %s",
    MeleeDebugWeaponName       = "Arme de mêlée détectée - Nom : %s",
    MeleeDebugNotMelee         = "Pas une arme de mêlée - Hash : %s",
    MeleeDebugConfigMissing    = "Attention : La configuration de mêlée est manquante ou invalide",
    MeleeDebugDropSuccess      = "Conditions mêlée remplies",
    MeleeDebugDropFailed       = "Conditions mêlée non remplies",

    --- Vehicle Hit Debug
    VehicleDebugHit            = "Vérification collision véhicule - Touché par véhicule : %s",
    VehicleDebugSpeed          = "Vitesse du véhicule - Actuelle : %.2f %s, Requise : %.2f %s",
    VehicleDebugConfigMissing  = "Attention : La configuration de collision véhicule est manquante ou invalide",
    VehicleDebugDropSuccess    = "Conditions de collision véhicule remplies",
    VehicleDebugDropFailed     = "Conditions de collision véhicule non remplies",

    --- Bone Shot Debug
    BoneDebugShot              = "Vérification os touché - ID de l'os : %s",
    BoneDebugList              = "IDs des os configurés : %s",
    BoneDebugMatch             = "Vérification os - L'os touché %s correspond à l'os configuré %s",
    BoneDebugNoMatch           = "Vérification os - Aucun os correspondant trouvé",
    BoneDebugConfigMissing     = "Attention : La configuration de tir sur os est manquante ou invalide",
    BoneDebugDropSuccess       = "Conditions de tir sur os remplies",
    BoneDebugDropFailed        = "Conditions de tir sur os non remplies",

    --- General Debug
    DebugVictimAttacker        = "Événement de dégât - Victime : %s, Attaquant : %s",
    DebugConditionMet          = "Vérification finale - Condition remplie : %s",
    DebugNoAccessories         = "Pas d'accessoires à lâcher - Chapeau : %s, Lunettes : %s",

    --- Server-Side debugging
    PlayerConnected             = "Le joueur %d est connecté",
    PlayerNotConnected          = "Le joueur %d n'est plus connecté",
    SyncingDroppedProps         = "Synchronisation des objets déposés : Chapeau %s, Lunettes %s",
    DroppedEntitiesUpdated      = "Entités déposées mises à jour : Chapeau %s, Lunettes %s",
    PickingUpProp               = "Ramassage de l'objet : Type %s, Identifiant %s",
    PropPickedUp                = "L'objet avec l'identifiant %s a été ramassé et sera supprimé",
    PropAlreadyPickedUp         = "L'objet avec l'identifiant %s a déjà été ramassé",
    SyncingDroppedPropsCoords   = "Synchronisation des coordonnées des objets déposés pour le chapeau %s et les lunettes %s",
    SyncingDroppedPropCoords    = "Synchronisation des coordonnées de l'objet déposé avec l'identifiant %s",
    SyncingIKOnPickup           = "Synchronisation de l'IK lors du ramassage aux coordonnées %s",
    SyncingBackDroppedProps     = "Synchronisation du retour des objets déposés pour l'identifiant %s",

    -- GENERAL SECTION

    DefaultInteractionText      = "Appuyez sur  ~INPUT_DE2E528F~pour ramasser", -- Oui, l'espacement étrange de ~INPUT_DE2E528F~ est intentionnel afin que la touche soit affiché correctement

}