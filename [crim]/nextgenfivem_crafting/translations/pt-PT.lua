Translation = {
    ['error_occurred'] = 'Ocorreu um erro. (%s)',
    ['not_allowed'] = 'Não tem permissão para usar este editor.',
    ['afk_timeout'] = 'Foi expulso por inatividade.',

    ['errors'] = {
        ['couldnt_get_inventory'] = 'Não foi possível obter o inventário.',
        ['no_player_id'] = 'ID de jogador em falta.',
        ['invalid_quantity'] = 'Quantidade inválida.',
        ['couldnt_get_recipe'] = 'Não foi possível obter a receita.',
        ['not_enough_level'] = 'O seu nível não é suficiente para criar este item.',
        ['not_enough_category_level'] = 'O seu nível de categoria não é suficiente para criar este item.',
        ['missing_ingredients'] = 'Não tem ingredientes suficientes para criar este item.',
        ['missing_blueprint'] = 'Falta-lhe uma planta para criar este item.',
        ['no_session'] = 'Nenhuma sessão encontrada.',
        ['invalid_session_data'] = 'Dados de sessão inválidos.',
        ['not_finished'] = 'A criação ainda não está concluída.',
        ['invalid_data'] = 'Dados inválidos.',
        ['not_enough_space'] = 'Você não tem espaço suficiente para fazer isso.',
        ['queue_limit_reached'] = 'Você atingiu o número máximo de criações na fila.',
        ['max_craft_amount_exceeded'] = 'Você não pode criar mais de %s itens de uma vez.'
    },

    ['crafting'] = {
        ['title_small'] = 'Bancada de Trabalho',
        ['title_big'] = 'Criação',
        ['recipes'] = 'Receitas',
        ['level'] = 'Nível',
        ['level_short'] = 'Nível',
        ['use'] = 'Usar',
        ['pickup'] = 'Recolher',
        ['no_access'] = 'Não tem acesso a isto.',
        ['not_using'] = 'Não está a usar isto.',
        ['already_using'] = 'Já está a usar isto.',
        ['already_in_use'] = 'Alguém está a usar isto neste momento.',
        ['craft'] = 'Criar',
        ['crafting'] = 'A Criar...',
        ['crafting_queue'] = 'Fila de Criação',
        ['exit'] = 'Sair',
        ['missing_items'] = 'Faltam-lhe %s %s',
        ['item'] = 'Item',
        ['items'] = 'Itens',
        ['cancel_craft'] = 'Cancelar Criação',
        ['requirements'] = 'Requisitos',
        ['ingredients'] = 'Ingredientes',
        ['blueprints'] = 'Plantas',
        ['result_items'] = 'Itens Resultantes',
        ['error_fetching_recipes'] = 'Ocorreu um erro ao obter as receitas.',
        ['no_recipes'] = 'Nenhuma receita encontrada.',
        ['bench_placed'] = 'Bancada de trabalho colocada.',
        ['not_near_bench'] = 'Não está perto da bancada de trabalho.',
        ['no_blueprints_needed'] = 'Nenhuma planta necessária.',
        ['cooldown_crafts_remaining'] = '%s criações restantes',
        ['cooldown_available_in'] = 'Disponível em %s',
        ['cooldown_on_cooldown'] = 'Em cooldown',
        ['cooldown_window'] = 'Janela: %s',
        -- v1.2.1: Failure Chance
        ['craft_failed'] = 'Falhou!',
        ['craft_partial'] = '%s/%s Bem-sucedido(s)',
        -- v1.2.1: View Locked Recipes
        ['recipe_locked'] = 'Bloqueado',
        ['recipe_locked_level'] = 'Alcance o nível necessário para desbloquear esta receita.',
        ['recipe_locked_blueprint'] = 'Um projeto é necessário para desbloquear esta receita.',

        ['stored_queue'] = {
            ['title'] = 'Fila Guardada',
            ['description'] = 'Você tem uma fila guardada de antes. Gostaria de usá-la?',
            ['use_queue'] = 'Usar Fila',
        }
    },

    ['item-descriptions'] = {
        ['portable_bench'] = 'Uma bancada de trabalho portátil do tipo (%s). Use para colocar a bancada.',
        ['blueprint'] = 'Uma planta para criar %s.'
    },

    ['item-labels'] = {
        ['portable_bench'] = 'Bancada de Trabalho (%s)',
        ['blueprint'] = 'Planta (%s)'
    },

    ['editor'] = {
        ['title'] = 'Editor de Criação',
        ['description'] =
        'Use este editor para colocar a bancada de trabalho. Certifique-se de que está completamente visível e que há espaço suficiente para interação.',
        -- v1.4.0: Walk Placement
        ['hint'] = {
            ['title'] = 'Não acontece nada?',
            ['description'] =
            'Sem cursor do rato, o gizmo não pode ser usado. Mude para a colocação a pé — só precisa do teclado.',
            ['action'] = 'Mudar para colocação a pé'
        },
        ['ghost'] = {
            ['title'] = 'Colocação a Pé',
            ['description'] =
            'Caminhe até ao sítio onde quer a bancada de trabalho e coloque-a. Use as teclas abaixo para a ajustar, não é preciso rato.'
        },
        ['controls'] = {
            ['gizmoSelect'] = 'Selecionar',
            ['gizmoTranslation'] = 'Modo de Movimento',
            ['gizmoRotation'] = 'Modo de Rotação',
            ['gizmoLocal'] = 'Relativo/Mundo',
            ['gizmoSnapToGround'] = 'Ajustar ao Solo',
            ['gizmoClose'] = 'Colocar',
            ['gizmoCancel'] = 'Cancelar',
            -- v1.4.0: Walk Placement
            ['gizmoSwitchMode'] = 'Colocação a Pé',
            ['moveCamera'] = 'Mover a Câmara',
            ['movePlayer'] = 'Caminhar',
            ['rotateWheel'] = 'Rodar',
            ['ghostRotateLeft'] = 'Rodar para a Esquerda',
            ['ghostRotateRight'] = 'Rodar para a Direita',
            ['ghostMoveAway'] = 'Afastar',
            ['ghostMoveCloser'] = 'Aproximar',
            ['ghostMoveUp'] = 'Subir',
            ['ghostMoveDown'] = 'Descer',
            ['ghostToggleSnap'] = 'Ajuste ao Solo',
            ['ghostConfirm'] = 'Colocar',
            ['ghostCancel'] = 'Cancelar',
            ['ghostSwitchMode'] = 'Colocação com Gizmo'
        },

        ['app'] = {
            ['title'] = 'Editor de Fabrico',
            ['search'] = 'Pesquisar',
            ['refresh'] = 'Atualizar',
            -- v1.2.1: Version & Changelog System
            ['version'] = {
                ['outdated'] = 'Atualização disponível',
                ['uptodate'] = 'Atualizado',
                ['behind'] = '%s atualizações em atraso',
                ['changelogs'] = 'Registo de alterações',
                ['no_changelogs'] = 'Nenhum registo de alterações disponível.',
                ['new'] = 'Novo',
                ['current'] = 'Atual',
                ['hotfixes'] = 'Correções',
                ['hotfix_available'] = 'Correção disponível',
                ['hotfix_desc'] = 'Leia as notas de versão para determinar se esta correção se aplica ao seu servidor.',
            },
            ['columns'] = {
                ['id'] = 'ID',
                ['name'] = 'Nome',
                ['created_at'] = 'Criado em',
                ['locations'] = 'Localizações',
                ['bench_type'] = 'Tipo de Bancada',
                ['created_by'] = 'Criado por',
                ['is_portable'] = 'É Portátil',
                ['coordinates'] = 'Coordenadas',
            },
            ['rows_per_page'] = 'Linhas por página',
            ['page_of'] = 'Página %s de %s',
            ['selected'] = '%s selecionado(s)',
            ['edit'] = 'Editar',
            ['delete'] = 'Eliminar',
            ['reset'] = 'Repor',
            ['no_results'] = 'Nenhum resultado...',
            ['clear_filters'] = 'Limpar filtros',

            ['benches'] = {
                ['label'] = 'Bancadas',
                ['description'] = 'Visualize e gerencie todas as bancadas disponíveis. Pode criar, editar e eliminar.',
                ['types'] = {
                    ['label'] = 'Tipos',
                    ['create_button'] = 'Novo Tipo de Bancada',
                    ['no_locations'] = 'Sem localizações',
                    ['locations'] = '%s localização(ões)',
                    ['add_location'] = 'Adicionar Localização',
                    ['view_locations'] = 'Ver Localizações',
                    ['actions'] = {
                        ['view_locations'] = 'Ver Localizações',
                        ['add_location'] = 'Adicionar Localização',
                        ['give_portable_item'] = 'Dar Item Portátil ao Jogador',
                    },
                    ['map'] = {
                        ['title'] = 'Localizações para o tipo de bancada "%s"',
                        ['error'] = 'Erro ao obter localizações',
                        ['no_locations'] = 'Nenhuma localização encontrada...',
                        ['coordinates'] = 'Coordenadas',
                        ['actions'] = {
                            ['teleport_to'] = 'Teleportar para Localização',
                            ['edit'] = 'Editar',
                            ['remove'] = 'Remover',
                        }
                    }
                },
                ['locations'] = {
                    ['label'] = 'Localizações',
                    ['create_button'] = 'Nova Localização de Bancada',
                    ['actions'] = {
                        ['teleport_to'] = 'Teleportar para Localização',
                        ['copy_id'] = 'Copiar ID',
                        ['copy_bench_type_id'] = 'Copiar ID do Tipo de Bancada',
                    }
                }
            },

            ['recipes'] = {
                ['label'] = 'Receitas',
                ['description'] =
                'Visualize e gerencie todas as receitas disponíveis. Pode criar, editar e eliminar. Abra uma categoria para ver as receitas dentro dela e clique numa receita para ver os seus detalhes.',
                ['no_categories_found'] = 'Nenhuma categoria encontrada.',
                ['create_a_category'] = 'Crie uma categoria!',
                ['category_title'] = 'Categoria: %s',
                ['create_button'] = 'Criar Categoria',
                ['edit_button'] = 'Editar Categoria',
                ['delete_button'] = 'Eliminar Categoria',
                ['no_recipes_found'] = 'Nenhuma receita encontrada...',
                ['recipes_error'] = 'Falha ao carregar receitas.',
                ['create_recipe'] = 'Criar Receita',
                ['crafting_time_desc'] = 'O tempo necessário para criar este item.',
                ['xp'] = '%s XP',
                ['xp_reward_desc'] = 'A recompensa de XP por fabricar este item.',
                ['prop_model_desc'] = 'O modelo de prop a ser exibido ao fabricar este item.',
                ['results'] = 'Resultados',
                ['results_desc'] = 'Estes são os resultados de fabricar este item.',
                ['level'] = 'Nível',
                ['level_desc'] = 'O nível necessário para fabricar este item.',
                ['category_level'] = 'Nível da Categoria',
                ['category_level_desc'] = 'O nível da categoria necessário para fabricar este item.',
                ['ingredients'] = 'Ingredientes',
                ['ingredients_desc'] = 'Estes são os ingredientes necessários para fabricar este item.',
                ['blueprints'] = 'Plantas',
                ['blueprints_desc'] = 'Estas são as plantas necessárias para fabricar este item',
            },

            ['blueprints'] = {
                ['label'] = 'Plantas',
                ['description'] =
                'Visualize e gerencie todas as plantas. Pode criar, editar e eliminar plantas nesta página. As plantas são usadas para definir receitas de fabrico.',
                ['search'] = 'Pesquisar plantas...',
                ['error'] = 'Ocorreu um erro ao obter as plantas.',
                ['create_button'] = 'Criar Planta',
            },

            ['forms'] = {
                ['name'] = 'Nome',
                ['create'] = 'Criar',
                ['update'] = 'Atualizar',
                ['save'] = 'Guardar',
                ['delete'] = 'Eliminar',
                ['cancel'] = 'Cancelar',
                ['edit'] = 'Editar',

                ['bench_type'] = {
                    ['new_title'] = 'Novo Tipo de Bancada',
                    ['edit_title'] = 'Editar Tipo de Bancada: %s',
                    ['delete_title'] = 'Eliminar Tipo de Bancada: %s',
                    ['delete_description'] =
                    'Tem a certeza de que deseja eliminar o tipo de bancada %s? Esta ação não pode ser desfeita. Todas as localizações de bancadas que utilizam este tipo serão eliminadas.',
                    ['name'] = 'Nome',
                    ['model'] = 'Modelo',
                    ['choose_a_model'] = 'Escolher um modelo',
                    ['none_model'] = 'Nenhum (personalizado)',
                    ['none_model_desc'] =
                    'Sem modelo. Usado para utilizar a bancada de fabrico em modelos já existentes.',
                    ['no_model'] = 'Nenhum modelo',
                    ['no_models'] = 'Nenhum modelo encontrado',
                    ['change'] = 'Alterar',
                    ['fullaccess'] = 'Acesso Total',
                    ['fullaccess_description'] = 'Permitir que este tipo de bancada tenha acesso a todas as categorias?',
                    ['categories'] = 'Categorias',
                    ['categories_description'] = 'Estas são as categorias às quais este tipo de bancada tem acesso.',
                    ['manage_recipe_restrictions'] = 'Gerir restrições de receitas',
                    ['recipe_restrictions'] = {
                        ['title'] = 'Categoria %s - Restrições de Receita',
                        ['description'] = 'Defina restrições para esta categoria. Permita ou negue receitas de fabrico.',
                        ['set_denied_as_default'] = 'Definir como negado por padrão',
                        ['set_denied_as_default_desc'] =
                        'Nota: Isto negará todas as receitas por padrão. Por exemplo, se quiser permitir apenas algumas receitas, pode definir isto como verdadeiro. Isto também irá redefinir todas as restrições de receita atuais.',
                        ['no_recipes'] = 'Nenhuma receita... Adicione algumas antes de definir restrições.',
                        ['recipe_error'] = 'Falha ao carregar receitas...',
                        ['denied_recipes'] = 'Receitas Negadas',
                        ['allowed_recipes'] = 'Receitas Permitidas',
                    },
                    ['access'] = 'Acesso',
                    ['access_description'] = 'O identificador de acesso para este tipo de bancada.',
                    ['selected'] = '%s selecionado(s)',
                    ['none'] = 'Nenhum',
                    ['no_categories'] =
                    'Nenhuma categoria encontrada. Crie uma categoria antes de adicionar um tipo de bancada.',
                    ['categories_error'] = 'Ocorreu um erro ao obter as categorias.',
                    ['change_rank_options'] = 'Alterar opções de classificação',
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
                    ['new_title'] = 'Nova Localização de Bancada',
                    ['edit_title'] = 'Editar Localização de Bancada',
                    ['delete_title'] = 'Eliminar Localização de Bancada: %s',
                    ['delete_description'] =
                    'Tem a certeza de que deseja eliminar a localização da bancada para o Tipo de Bancada %s? Esta ação não pode ser desfeita.',
                    ['add_location_for_bench_type'] = 'Adicionar localização para o tipo de bancada "%s"',
                    ['bench_type'] = 'Tipo de Bancada',
                    ['bench_type_description'] = 'Tipo da bancada.',
                    ['location'] = 'Localização',
                    ['location_description'] = 'Localização da bancada. Use o botão para posicioná-la.',
                    ['location_description_2'] =
                    'Certifique-se de que toda a bancada está visível e há espaço suficiente para o jogador interagir com ela.',
                    ['is_portable'] = 'É Portátil',
                    ['is_portable_description'] = 'A bancada é portátil? (Pode ser movida pelos jogadores)',
                    -- v1.2.1: Shared Mode Overrides
                    ['shared_levels_override'] = 'Override Shared Levels',
                    ['shared_levels_override_description'] =
                    'Override the bench type shared levels setting for this location. Leave unchecked to inherit from bench type.',
                    ['shared_queue_override'] = 'Override Shared Queue',
                    ['shared_queue_override_description'] =
                    'Override the bench type shared queue setting for this location. Leave unchecked to inherit from bench type.',
                    ['place_out'] = 'Colocar',
                    ['select_bench_type_first'] = 'Por favor, selecione primeiro um tipo de bancada.',
                    ['select_bench_type'] = 'Selecionar tipo de bancada',
                    ['search_bench_types'] = 'Pesquisar tipos de bancada...',
                    ['no_bench_types'] = 'Nenhum tipo de bancada encontrado.',
                    ['loading_bench_types'] = 'A carregar tipos de bancada...',
                    ['bench_types_error'] = 'Erro ao carregar os tipos de bancada.',
                },

                ['give_portable_item'] = {
                    ['title'] = 'Dar Item Portátil ao Jogador',
                    ['player_id'] = 'ID do Jogador',
                    ['give_item'] = 'Dar Item'
                },

                ['category'] = {
                    ['new_title'] = 'Nova Categoria',
                    ['edit_title'] = 'Editar Categoria: %s',
                    ['delete_title'] = 'Eliminar Categoria: %s',
                    ['delete_description'] =
                    'Tem a certeza de que deseja eliminar a categoria %s? Esta ação não pode ser desfeita.',
                    ['delete_warning'] =
                    'Aviso: Isto também eliminará todas as receitas nesta categoria e não pode ser desfeito.',
                    ['title'] = 'Título',
                    ['description'] = 'Descrição',
                    ['use_image_url'] = 'Usar URL de Imagem',
                    ['use_image_url_desc'] = 'Use um URL de imagem em vez de um ícone',
                    ['icon'] = 'Ícone',
                    ['icon_desc'] = 'Encontre um ícone em https://fonts.google.com/icons',
                    ['image'] = 'URL da Imagem',
                },

                ['recipe'] = {
                    ['new_title'] = 'Nova Receita',
                    ['edit_title'] = 'Editar Receita: %s',
                    ['delete_title'] = 'Eliminar Receita: %s',
                    ['delete_description'] =
                    'Tem a certeza de que deseja eliminar a receita %s? Esta ação não pode ser desfeita.',
                    ['title'] = 'Título',
                    ['description'] = 'Descrição',
                    ['required_level'] = 'Nível Requerido',
                    ['required_level_desc'] =
                    'Nível global necessário para fabricar esta receita. Deixe em branco para não haver requisitos.',
                    ['required_category_level'] = 'Nível de Categoria Requerido',
                    ['required_category_level_desc'] =
                    'Nível de categoria necessário para fabricar esta receita. Deixe em branco para não haver requisitos.',
                    ['crafting_time'] = 'Tempo de Fabrico (em segundos)',
                    ['crafting_time_desc'] = 'Quanto tempo leva para fabricar esta receita (em segundos).',
                    ['xp_reward'] = 'Recompensa de XP',
                    ['xp_reward_desc'] = 'Quantidade de XP atribuída ao fabricar esta receita. (o padrão é 25)',
                    ['prop_model'] = 'Modelo de Prop',
                    ['prop_model_desc'] =
                    'Modelo de prop a ser exibido ao fabricar esta receita. Deixe em branco para nenhum prop. (ex: prop_tool_hammer)',
                    ['prop_rot'] = 'Rotação do Prop',
                    ['prop_rot_desc'] = 'Rotação do modelo de prop.',
                    ['prop_offset'] = 'Deslocamento do Prop',
                    ['prop_offset_desc'] =
                    'Deslocamento do modelo de prop. Ajuste para centrar o prop. X: frente/trás, Y: esquerda/direita, Z: cima/baixo',
                    ['blueprints'] = 'Plantas',
                    ['blueprints_desc'] = 'Plantas necessárias para fabricar esta receita.',
                    ['ingredients'] = 'Ingredientes',
                    ['ingredients_desc'] =
                    'Ingredientes necessários para fabricar esta receita. Mínimo de 1 é necessário.',
                    ['results'] = 'Resultados',
                    ['results_desc'] = 'Resultados do fabrico desta receita. Mínimo de 1 é necessário.',
                    ['cooldown_limit'] = 'Limite de cooldown',
                    ['cooldown_limit_desc'] = 'Máximo total criado dentro da janela. Coloque 0/vazio para desativar.',
                    ['cooldown_window'] = 'Janela de cooldown',
                    ['cooldown_window_desc'] = 'Duração da janela de cooldown (dias, horas, minutos, segundos).',
                    -- v1.2.1: Failure Chance
                    ['failure_chance'] = 'Chance de Falha (%)',
                    ['failure_chance_desc'] =
                    'Chance de a fabricação falhar (0-100). Ingredientes são consumidos em caso de falha.',
                    ['failure_mode'] = 'Modo de Falha',
                    ['failure_mode_desc'] =
                    'batch = uma rolagem para toda a fabricação, individual = cada item é rolado separadamente.',

                    ['add'] = 'Adicionar'
                },

                ['blueprint'] = {
                    ['new_title'] = 'Nova Planta',
                    ['edit_title'] = 'Editar Planta: %s',
                    ['delete_title'] = 'Eliminar Planta: %s',
                    ['delete_description'] =
                    'Tem a certeza de que deseja eliminar a planta %s? Esta ação não pode ser desfeita.',
                    ['label'] = 'Etiqueta',
                    ['description'] = 'Descrição',
                    ['uses'] = 'Usos',
                    ['uses_description'] =
                    'Usado apenas com `enableBlueprintItems`, `removeBlueprintOnCraft` e `blueprintDurability` ativados.'
                },

                ['select_blueprint'] = {
                    ['label'] = 'Planta',
                    ['select_blueprint'] = 'Selecionar planta',
                    ['search_blueprints'] = 'Pesquisar plantas...',
                    ['loading'] = 'A carregar plantas...',
                    ['error'] = 'Erro ao carregar plantas.',
                    ['duplicate'] = 'Planta já adicionada. Por favor, selecione uma planta diferente.',
                    ['no_found'] = 'Nenhuma planta encontrada.'
                },

                ['select_item'] = {
                    ['label'] = 'Item',
                    ['count'] = 'Quantidade',
                    ['select_item'] = 'Selecionar item',
                    ['search_items'] = 'Pesquisar itens...',
                    ['loading'] = 'A carregar itens...',
                    ['error'] = 'Erro ao carregar itens.',
                    ['no_found'] = 'Nenhum item encontrado.',
                    ['set_metadata'] = 'Definir metadados',
                    ['metadata_title'] = 'Metadados para: %s',
                },

                ['errors'] = {
                    ['name_is_required'] = 'O nome é obrigatório.',
                    ['name_too_short'] = 'O nome deve ter pelo menos 2 caracteres.',
                    ['category_is_required'] = 'Pelo menos uma categoria é obrigatória.',
                    ['item_is_required'] = 'O item é obrigatório',
                    ['min_one_item'] = 'Deve adicionar pelo menos um item.',
                }
            }
        }
    },

    ['command'] = {
        ['error'] = 'Erro',
        ['not_allowed'] = 'Não tem permissão para usar este comando.',
        ['no_subcommand'] = 'Subcomando inválido. Digite /crafting help para uma lista de comandos.',
        ['no_player'] = 'Nenhum jogador encontrado com este ID.',
        ['no_blueprint_found'] = 'Nenhuma planta encontrada com esse nome ou ID.',
        ['already_has_blueprint'] = 'O jogador já possui essa planta.',
        ['gave_blueprint'] = 'Planta %s dada ao jogador %s.',
        ['removed_blueprint'] = 'Planta %s removida do jogador %s.',
        ['set_level'] = 'Definiu o nível %s para o jogador %s.',
        ['set_category_level'] = 'Definiu o nível de categoria %s para o jogador %s.',
        ['no_category_found'] = 'Nenhuma categoria encontrada com esse nome ou ID.',
        ['category_level'] = 'Nível de Categoria',
        ['player_level'] = 'Níveis para %s (%s)',
        ['invalid_level'] = 'Nível inválido.',
        ['gave_portable_item'] = 'Item portátil para bancada de trabalho (%s) dado ao jogador %s.',
        ['missing_arguments'] = 'Argumentos em falta. Digite /crafting help para ver os detalhes do comando.',
        ['help'] = {
            ['title'] = 'Comandos de Criação',
            ['description'] = 'Lista de comandos disponíveis',
            ['subcommands'] = {
                ['help'] = 'Ver menu de ajuda',
                ['blueprints'] = 'Ver suas plantas',
                ['level'] = 'Ver seu nível',
                ['editor'] = 'Abrir o editor',
                ['getblueprints'] = 'Ver as plantas de um jogador',
                ['giveblueprint'] = 'Dar uma planta a um jogador',
                ['removeblueprint'] = 'Remover uma planta de um jogador',
                ['getlevel'] = 'Ver o nível de um jogador',
                ['setlevel'] = 'Definir o nível de um jogador',
                ['setcategorylevel'] = 'Definir o nível de categoria de um jogador',
                ['editbench'] = 'Editar a bancada mais próxima',
                ['removebench'] = 'Remover a bancada mais próxima',
                ['giveportableitem'] = 'Dar uma bancada de trabalho portátil a um jogador'
            },
            ["params"] = {
                ["id"] = "ID do jogador",
                ["blueprint"] = "ID da planta",
                ["level"] = "Nível",
                ["category"] = "Categoria",
                ["bench"] = "ID/Nome da bancada"
            }
        }
    },

    ["discord_logs"] =
    "## Jogador %s criou %sx %s (ID: %s)\nTipo de bancada: `%s (%s)`\nLocalização da bancada: `%s`\nItens resultantes: `%s`\nItens de ingredientes: `%s`"
}
