Strings = {}

Strings.Notify = {
    runStarted = 'You received a new contract',
    runStopped = 'You stopped receiving new contracts',
    noContracts = 'You can no longer run contracts',
    runsEnded = 'You have no more money - no further contracts will be assigned',
    noPolice = 'There are not enough police in the city',
    noMoney = 'You do not have enough money',
    notAuthorized = 'You are not authorized to enter',
    requireItem = 'I don\'t think you\'re ready..',
    noAccess = 'You do not have access to this',
    remaining = {
        base = 'You\'re money will be ready in',
        hours = 'hours,',
        minutes = 'minutes',
        aand = 'and',
        seconds = 'seconds'
    }
}

Strings.Targets = {
    start = {
        name = 'Talk',
        label = 'Talk',
        icon = 'fas fa-money-bill-wave',
        iconColor = '',
        distance = 2.0
    },
    clean = {
        name = 'Talk',
        label = 'Talk',
        icon = 'fas fa-comments',
        iconColor = '',
        distance = 2.0
    },
    enterWarehouse = {
        name = 'enterWarehouse',
        label = 'Enter',
        icon = 'fas fa-right-to-bracket',
        iconColor = '',
        radius = 1.0,
        distance = 2.0
    },
    exitWarehouse = {
        name = 'exitWarehouse',
        label = 'Exit',
        icon = 'fas fa-right-from-bracket',
        iconColor = '',
        radius = 1.0,
        distance = 2.0
    },
    startWashing = {
        name = 'startWashing',
        label = 'Start washing',
        icon = 'fas fa-hands-bubbles',
        iconColor = '',
        radius = 1.0,
        distance = 2.0
    },
    pickupMoney = {
        name = 'pickupMoney',
        label = 'Grab money',
        icon = 'fas fa-hand-holding-dollar',
        iconColor = '',
        radius = 1.0,
        distance = 2.0
    },
    countMoney = {
        name = 'counter',
        label = 'Start counting',
        icon = 'fas fa-sack-dollar',
        iconColor = '',
        distance = 2.0
    }
}

Strings.TextUI = {
    start = {
        label = '**Money Laundering**  \n E - Talk',
        icon = 'fas fa-sack-dollar'
    },
    clean = {
        label = '**Launder Cash**  \n E - Talk',
        icon = 'fas fa-sack-dollar'
    },
    enterWarehouse = {
        label = '**Warehouse**  \n E - Enter',
        icon = 'fas fa-right-to-bracket'
    },
    exitWarehouse = {
        label = '**Warehouse**  \n E - Exit',
        icon = 'fas fa-right-from-bracket'
    },
    startWashing = {
        label = '**Washing Machine**  \n E - Start wash',
        icon = 'fas fa-hands-bubbles'
    },
    pickupMoney = {
        label = '**Washing Machine**  \n E - Grab Cash',
        icon = 'fas fa-hand-holding-dollar'
    },
    countMoney = {
        label = '**Count Money**  \n E - Start counting',
        icon = 'fas fa-sack-dollar'
    }
}

Strings.Alert = {
    notEnough = { header = '**Sorry**', content = 'You don\'t have enough money on you, please don\'t waste my time.', centered = true, cancel = false },
    rejected = { header = '**No Thanks**', content = 'I\'m not interested in doing business with you.. good luck.', centered = true, cancel = false },
    denyNegotiate = { header = '**Goodbye**', content = 'No thanks, I\'m not interested in your offer..', centered = true, cancel = false },
    buyKey = { header = '**Confirm**', content = 'Are you sure you want to purchase a warehouse key for £', centered = true, cancel = true }
}

Strings.Inputs = {
    wash = {
        header = 'Wash Money',
        label = 'Quantity',
        desc = 'You have: £',
        desc2 = '. How much are you cleaning?',
        icon = 'hashtag'
    },
    count = {
        header = 'Count Money',
        label = 'Quantity',
        desc = 'You have: £',
        desc2 = '. How much are you counting?',
        icon = 'hashtag'
    }
}

Strings.Menu = {
    main = { -- Main money laundering menu
        title = 'Money Laundering',
        level = {
            title = 'Level',
            desc = 'Current laundering level: ',
            desc2 = ' - Tax Rate: ',
            desc3 = '%',
            icon = 'fas fa-ranking-star',
            iconColor = ''
        },
        xp = {
            title = 'Experience',
            desc = 'Progress towards next level: ',
            desc2 = '%',
            icon = 'fas fa-chart-bar',
            iconColor = ''
        },
        contracts = {
            title = 'Contracts',
            desc = 'Total contracts completed: ',
            icon = 'fas fa-file-signature',
            iconColor = ''
        },
        money = {
            title = 'Money Cleaned',
            desc = 'Total amount of money cleaned: £',
            icon = 'fas fa-money-bill-wave',
            iconColor = ''
        },
        start = {
            title = 'New Contract',
            desc = 'Start receiving new money laundering contracts',
            icon = 'fas fa-circle-play',
            iconColor = '#51cf66',
        },
        stop = {
            title = 'Stop Contracts',
            desc = 'Stop receiving new money laundering contracts',
            icon = 'fas fa-circle-stop',
            iconColor = '#fa5252'
        },
        warehouse = {
            title = 'Warehouse',
            desc = 'Purchase the key needed to access the warehouse',
            icon = 'fas fa-key',
            iconColor = ''
        },
        vehicle = {
            title = 'Return Vehicle',
            desc = 'Return the vehicle you borrowed and get money back',
            icon = 'fas fa-car',
            iconColor = ''
        }
    },
    negotiate = {
        title = 'Negotiate',
        accept = {
            title = 'Accept Offer',
            desc = 'Current offer is £',
            desc2 = ' *clean* for £',
            desc3 = ' *dirty*.',
            icon = 'fas fa-check',
            iconColor = ''
        },
        negotiate = {
            title = 'Negotiate',
            desc = 'Renegotiate the offer with the buyer',
            icon = 'fas fa-repeat',
            iconColor = ''
        }
    },
    final = {
        title = 'Final Offer',
        accept = {
            title = 'Accept Offer',
            desc = 'Final offer is £',
            desc2 = ' *clean* for £',
            desc3 = ' *dirty*.',
            icon = 'fas fa-check',
            iconColor = ''
        },
        deny = {
            title = 'Deny Offer',
            desc = 'Turn down this buyers final offer',
            icon = 'fas fa-rectangle-xmark',
            iconColor = ''
        }
    },
    colors = { -- Various colors used for progress bars in ox_lib menu
        red = '#fa5252',
        yellow = '#fcc419',
        green = '#51cf66'
    },
}

Strings.Phone = {
    title = 'Warehouse',
    sender = 'Warehouse',
    name = 'Warehouse',
    subject = 'Money Status',
    message = 'Your money is now done & ready to be picked up.'
}

Strings.Logs = {
    colors = {
        green = 65280,
        red = 16711680,
        yellow = 16776960,
    },
    titles = {
        levelUp = '⬆️ Leveled Up',
        contract = '💰 Contract Completed',
        warehouse = '🧽 Wash Completed',
        counting = '#️⃣ Counting Completed',
        negotiate = '🤝 Contract Negotiated',
        rejected = '❌ Contract Rejected',
        warehouseKey = '🔑 Warehouse Key Purchased',
    },
    messages = {
        playerName = '**Player Name**: ',
        playerID = '\n **Player ID**: ',
        playerIdent = '\n **Identifier**: ',
        message = '\n **Message**: ',
        levelUp = 'User has just leveled up to level ',
        contract = 'User has just laundered £',
        contract2 = ' worth of dirty money into £',
        contract3 = ' clean cash',
        warehouse = 'User has just laundered £',
        warehouse2 = ' worth of dirty money into £',
        warehouse3 = ' uncounted cash',
        counting = 'User has finished counting money and received £',
        negotiate = 'User negotiated a contract offer from £',
        negotiate2 = ' to £',
        negotiate3 = ' dirty money',
        negotiateAccepted = ' - Accepted ✅',
        negotiateDenied = ' - Denied ❌',
        rejected = 'User was rejected during a contract attempt',
        warehouseKey = 'User purchased a warehouse key for £',
    }
}