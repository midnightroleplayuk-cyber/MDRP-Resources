Config.Permissions = {
    'manage_members',
    'manage_ranks',
    'treasury_view',
    'treasury_withdraw',
    'treasury_deposit',
    'diplomacy',
    'contracts_accept',
    'rackets',
    'graffiti',
    'sell_drugs',
    'enterprise_manage',
    'safehouse_access',
    'heists',
}

-- Copied to every new gang; leaders can rename/edit afterwards. '*' = all permissions.
Config.DefaultRanks = {
    { grade = 0, label = 'Associate',  wage = 0, permissions = { 'graffiti', 'sell_drugs', 'treasury_deposit' } },
    { grade = 1, label = 'Soldier',    wage = 0, permissions = { 'graffiti', 'sell_drugs', 'treasury_deposit', 'contracts_accept', 'rackets', 'safehouse_access' } },
    { grade = 2, label = 'Lieutenant', wage = 0, permissions = { 'graffiti', 'sell_drugs', 'treasury_deposit', 'treasury_view', 'contracts_accept', 'rackets', 'safehouse_access', 'manage_members' } },
    { grade = 3, label = 'Underboss',  wage = 0, permissions = { 'graffiti', 'sell_drugs', 'treasury_deposit', 'treasury_view', 'treasury_withdraw', 'contracts_accept', 'rackets', 'safehouse_access', 'manage_members', 'diplomacy', 'enterprise_manage', 'heists' } },
    { grade = 4, label = 'Boss',       wage = 0, permissions = { '*' } },
}
