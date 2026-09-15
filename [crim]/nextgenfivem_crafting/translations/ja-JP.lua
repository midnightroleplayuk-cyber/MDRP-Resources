Translation = {
    ['error_occurred'] = 'エラーが発生しました（%s）',
    ['not_allowed'] = 'このエディターを使用する権限がありません',
    ['afk_timeout'] = 'AFKのためキックされました',

    ['errors'] = {
        ['couldnt_get_inventory'] = 'インベントリを取得できませんでした',
        ['no_player_id'] = 'プレイヤーIDが指定されていません',
        ['invalid_quantity'] = '数量が無効です',
        ['couldnt_get_recipe'] = 'レシピを取得できませんでした',
        ['not_enough_level'] = 'レベル語りません',
        ['not_enough_category_level'] = 'カテゴリレベルが足りません',
        ['missing_ingredients'] = '必要な材料が不足しています',
        ['missing_blueprint'] = '設計図が必要です',
        ['no_session'] = 'セッションが見つかりません',
        ['invalid_session_data'] = 'セッションデータが無効です',
        ['not_finished'] = 'クラフトが完了していません',
        ['invalid_data'] = 'データが無効です',
        ['not_enough_space'] = 'スペースが不足しています',
        ['queue_limit_reached'] = 'キュー内の最大クラフト数に達しました。',
        ['max_craft_amount_exceeded'] = '一度に%s個以上のアイテムをクラフトすることはできません。'
    },

    ['crafting'] = {
        ['title_small'] = '作業台',
        ['title_big'] = 'クラフト',
        ['recipes'] = '利用可能なレシピ',
        ['level'] = 'レベル',
        ['level_short'] = 'Lv',
        ['use'] = '使用',
        ['pickup'] = '回収',
        ['no_access'] = 'アクセス権がありません',
        ['not_using'] = '現在使用していません',
        ['already_using'] = 'すでに使用中です',
        ['already_in_use'] = '他のプレイヤーが使用中です',
        ['craft'] = 'クラフト',
        ['crafting'] = 'クラフト中...',
        ['crafting_queue'] = 'クラフトキュー',
        ['exit'] = '閉じる',
        ['missing_items'] = '不足: %s %s',
        ['item'] = 'アイテム',
        ['items'] = 'アイテム',
        ['cancel_craft'] = 'クラフトをキャンセル',
        ['requirements'] = '要件',
        ['ingredients'] = '材料',
        ['blueprints'] = '設計図',
        ['result_items'] = '結果アイテム',
        ['error_fetching_recipes'] = 'レシピ取得エラー',
        ['no_recipes'] = 'レシピがありません',
        ['bench_placed'] = '作業台を設置しました',
        ['not_near_bench'] = '作業台の近くにいません',
        ['no_blueprints_needed'] = '設計図は不要',
        ['cooldown_crafts_remaining'] = '%s 個の制作が残り',
        ['cooldown_available_in'] = '%s 後に利用可能',
        ['cooldown_on_cooldown'] = 'クールダウン中',
        ['cooldown_window'] = 'ウィンドウ: %s',
        -- v1.2.1: Failure Chance
        ['craft_failed'] = '失敗！',
        ['craft_partial'] = '%s/%s 成功',
        -- v1.2.1: View Locked Recipes
        ['recipe_locked'] = 'ロック中',
        ['recipe_locked_level'] = '必要なレベルに達するとこのレシピが解放されます。',
        ['recipe_locked_blueprint'] = 'このレシピを解放するには設計図が必要です。',

        ['stored_queue'] = {
            ['title'] = '保存済みキュー',
            ['description'] = '以前のキューがあります使用しますか？',
            ['use_queue'] = 'キューを使用',
        }
    },

    ['item-descriptions'] = {
        ['portable_bench'] = 'タイプ (%s) 用の携帯作業台使用して設置します',
        ['blueprint'] = '%s のクラフト設計図'
    },

    ['item-labels'] = {
        ['portable_bench'] = 'クラフト作業台 (%s)',
        ['blueprint'] = '設計図 (%s)'
    },

    ['editor'] = {
        ['title'] = 'クラフトエディター',
        ['description'] = 'このエディターで作業台を配置します完全に見える位置に設置し、十分なスペースを確保してください',
        -- v1.4.0: Walk Placement
        ['hint'] = {
            ['title'] = '何も起きませんか',
            ['description'] =
            'マウスカーソルが出ない場合ギズモは使えません歩いて配置に切り替えてくださいキーボードだけで操作できます',
            ['action'] = '歩いて配置に切り替える'
        },
        ['ghost'] = {
            ['title'] = '歩いて配置',
            ['description'] = '作業台を置きたい場所まで歩いて配置します下のキーで調整できマウスは不要です',
        },
        ['controls'] = {
            ['gizmoSelect'] = 'ツール選択',
            ['gizmoTranslation'] = '移動モード',
            ['gizmoRotation'] = '回転モード',
            ['gizmoLocal'] = 'ローカル/ワールド',
            ['gizmoSnapToGround'] = '地面に設置',
            ['gizmoClose'] = '配置',
            ['gizmoCancel'] = 'キャンセル',
            -- v1.4.0: Walk Placement
            ['gizmoSwitchMode'] = '歩いて配置',
            ['moveCamera'] = 'カメラ調整',
            ['movePlayer'] = '移動',
            ['rotateWheel'] = '回転',
            ['ghostRotateLeft'] = '左に回転',
            ['ghostRotateRight'] = '右に回転',
            ['ghostMoveAway'] = '遠ざける',
            ['ghostMoveCloser'] = '近づける',
            ['ghostMoveUp'] = '上げる',
            ['ghostMoveDown'] = '下げる',
            ['ghostToggleSnap'] = '地面に設置の切替',
            ['ghostConfirm'] = '配置',
            ['ghostCancel'] = 'キャンセル',
            ['ghostSwitchMode'] = 'ギズモ配置'
        },

        ['app'] = {
            ['title'] = 'クラフトエディター',
            ['search'] = '検索',
            ['refresh'] = '更新',
            -- v1.2.1: Version & Changelog System
            ['version'] = {
                ['outdated'] = 'アップデートがあります',
                ['uptodate'] = '最新',
                ['behind'] = '%s件のアップデートが未適用',
                ['changelogs'] = '更新履歴',
                ['no_changelogs'] = '更新履歴はありません。',
                ['new'] = '新規',
                ['current'] = '現在',
                ['hotfixes'] = 'ホットフィックス',
                ['hotfix_available'] = 'ホットフィックスあり',
                ['hotfix_desc'] = 'このホットフィックスがサーバーに適用されるかどうか、リリースノートをお読みください。',
            },
            ['columns'] = {
                ['id'] = 'ID',
                ['name'] = '名前',
                ['created_at'] = '作成日時',
                ['locations'] = '設置数',
                ['bench_type'] = '作業台タイプ',
                ['created_by'] = '作成者',
                ['is_portable'] = '携帯式',
                ['coordinates'] = '座標',
            },
            ['rows_per_page'] = '1 ページの行数',
            ['page_of'] = 'ページ %s / %s',
            ['selected'] = '%s 件選択',
            ['edit'] = '編集',
            ['delete'] = '削除',
            ['reset'] = 'リセット',
            ['no_results'] = '結果なし...',
            ['clear_filters'] = 'フィルタをクリア',

            ['benches'] = {
                ['label'] = '作業台',
                ['description'] = 'すべての作業台を表示・管理します 作成、編集、削除が可能です',
                ['types'] = {
                    ['label'] = 'タイプ',
                    ['create_button'] = '新規作業台タイプ',
                    ['no_locations'] = '設置なし',
                    ['locations'] = '%s 件の設置',
                    ['add_location'] = '設置を追加',
                    ['view_locations'] = '設置を表示',
                    ['actions'] = {
                        ['view_locations'] = '設置を表示',
                        ['add_location'] = '設置を追加',
                        ['give_portable_item'] = 'プレイヤーに携帯アイテムを付与',
                    },
                    ['map'] = {
                        ['title'] = '作業台タイプ "%s" の設置',
                        ['error'] = '設置の取得に失敗',
                        ['no_locations'] = '設置が見つかりません...',
                        ['coordinates'] = '座標',
                        ['actions'] = {
                            ['teleport_to'] = '場所へテレポート',
                            ['edit'] = '編集',
                            ['remove'] = '削除',
                        }
                    }
                },
                ['locations'] = {
                    ['label'] = '設置',
                    ['create_button'] = '新規作業台設置',
                    ['actions'] = {
                        ['teleport_to'] = '場所へテレポート',
                        ['copy_id'] = 'IDをコピー',
                        ['copy_bench_type_id'] = '作業台タイプIDをコピー',
                    }
                }
            },

            ['recipes'] = {
                ['label'] = 'レシピ',
                ['description'] = 'すべてのレシピを表示・管理します 作成、編集、削除が可能ですカテゴリを開いて中のレシピを表示し、レシピをクリックして詳細を表示します',
                ['no_categories_found'] = 'カテゴリが見つかりません',
                ['create_a_category'] = 'カテゴリを作成してください！',
                ['category_title'] = 'カテゴリ: %s',
                ['create_button'] = 'カテゴリを作成',
                ['edit_button'] = 'カテゴリを編集',
                ['delete_button'] = 'カテゴリを削除',
                ['no_recipes_found'] = 'レシピが見つかりません...',
                ['recipes_error'] = 'レシピの読み込みに失敗しました',
                ['create_recipe'] = 'レシピを作成',
                ['crafting_time_desc'] = 'このアイテムのクラフト時間',
                ['xp'] = '%s XP',
                ['xp_reward_desc'] = 'このアイテムをクラフトした際のXP報酬',
                ['prop_model_desc'] = 'クラフト中に表示するプロップモデル',
                ['results'] = '結果',
                ['results_desc'] = 'このアイテムをクラフトした際の結果です',
                ['level'] = 'レベル',
                ['level_desc'] = 'このアイテムをクラフトするのに必要なレベル',
                ['category_level'] = 'カテゴリレベル',
                ['category_level_desc'] = 'このアイテムをクラフトするのに必要なカテゴリレベル',
                ['ingredients'] = '材料',
                ['ingredients_desc'] = 'このアイテムをクラフトするのに必要な材料',
                ['blueprints'] = '設計図',
                ['blueprints_desc'] = 'このアイテムをクラフトするのに必要な設計図',
            },

            ['blueprints'] = {
                ['label'] = '設計図',
                ['description'] = 'すべての設計図を表示・管理しますここで作成、編集、削除が可能です設計図はクラフトレシピの定義に使用します',
                ['search'] = '設計図を検索...',
                ['error'] = '設計図の取得中にエラーが発生しました',
                ['create_button'] = '設計図を作成',
            },

            ['forms'] = {
                ['name'] = '名前',
                ['create'] = '作成',
                ['update'] = '更新',
                ['save'] = '保存',
                ['delete'] = '削除',
                ['cancel'] = 'キャンセル',
                ['edit'] = '編集',

                ['bench_type'] = {
                    ['new_title'] = '新規作業台タイプ',
                    ['edit_title'] = '作業台タイプを編集: %s',
                    ['delete_title'] = '作業台タイプを削除: %s',
                    ['delete_description'] = '本当に作業台タイプ %s を削除しますか？この操作は取り消せませんすべての関連設置も削除されます',
                    ['name'] = '名前',
                    ['model'] = 'モデル',
                    ['choose_a_model'] = 'モデルを選択',
                    ['none_model'] = 'なし（カスタム）',
                    ['none_model_desc'] = 'モデルなし既存モデル上で作業台を使用する際に使用します',
                    ['no_model'] = 'モデルなし',
                    ['no_models'] = 'モデルが見つかりません',
                    ['change'] = '変更',
                    ['fullaccess'] = 'フルアクセス',
                    ['fullaccess_description'] = 'この作業台タイプにすべてのカテゴリへのアクセスを許可しますか？',
                    ['categories'] = 'カテゴリ',
                    ['categories_description'] = 'この作業台タイプがアクセスできるカテゴリです',
                    ['manage_recipe_restrictions'] = 'レシピ制限を管理',
                    ['recipe_restrictions'] = {
                        ['title'] = '%s カテゴリ - レシピ制限',
                        ['description'] = 'このカテゴリの制限を設定しますレシピを許可または拒否します',
                        ['set_denied_as_default'] = '拒否をデフォルトに設定',
                        ['set_denied_as_default_desc'] =
                        '注: これによりすべてのレシピがデフォルトで拒否されます例: 一部のレシピのみ許可したい場合に設定します現在の制限もリセットされます',
                        ['no_recipes'] = 'レシピがありません... 制限を設定する前に追加してください',
                        ['recipe_error'] = 'レシピの読み込みに失敗しました...',
                        ['denied_recipes'] = '拒否されたレシピ',
                        ['allowed_recipes'] = '許可されたレシピ',
                    },
                    ['access'] = 'アクセス',
                    ['access_description'] = 'この作業台タイプのアクセス識別子',
                    ['selected'] = '%s 件選択',
                    ['none'] = 'なし',
                    ['no_categories'] = 'カテゴリがありませんカテゴリを作成してから作業台タイプを追加してください',
                    ['categories_error'] = 'カテゴリの取得中にエラーが発生しました',
                    ['change_rank_options'] = 'ランクオプションを変更',
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
                    ['new_title'] = '新規作業台設置',
                    ['edit_title'] = '作業台設置を編集',
                    ['delete_title'] = '作業台設置を削除: %s',
                    ['delete_description'] = '本当に作業台タイプ %s の設置を削除しますか？この操作は取り消せません',
                    ['add_location_for_bench_type'] = '作業台タイプ "%s" に設置を追加',
                    ['bench_type'] = '作業台タイプ',
                    ['bench_type_description'] = '作業台のタイプ',
                    ['location'] = '位置',
                    ['location_description'] = '作業台の位置ボタンを使って配置します',
                    ['location_description_2'] = '作業台全体が見え、プレイヤーが操作できる十分なスペースを確保してください',
                    ['is_portable'] = '携帯式',
                    ['is_portable_description'] = '作業台は携帯可能ですか？（プレイヤーが移動可能）',
                    -- v1.2.1: Shared Mode Overrides
                    ['shared_levels_override'] = 'Override Shared Levels',
                    ['shared_levels_override_description'] =
                    'Override the bench type shared levels setting for this location. Leave unchecked to inherit from bench type.',
                    ['shared_queue_override'] = 'Override Shared Queue',
                    ['shared_queue_override_description'] =
                    'Override the bench type shared queue setting for this location. Leave unchecked to inherit from bench type.',
                    ['place_out'] = '配置',
                    ['select_bench_type_first'] = '先に作業台タイプを選択してください',
                    ['select_bench_type'] = '作業台タイプを選択',
                    ['search_bench_types'] = '作業台タイプを検索...',
                    ['no_bench_types'] = '作業台タイプが見つかりません',
                    ['loading_bench_types'] = '作業台タイプを読み込み中...',
                    ['bench_types_error'] = '作業台タイプの読み込みにエラー',
                },

                ['give_portable_item'] = {
                    ['title'] = 'プレイヤーに携帯アイテムを付与',
                    ['player_id'] = 'プレイヤー ID',
                    ['give_item'] = 'アイテムを付与'
                },

                ['category'] = {
                    ['new_title'] = '新規カテゴリ',
                    ['edit_title'] = 'カテゴリを編集: %s',
                    ['delete_title'] = 'カテゴリを削除: %s',
                    ['delete_description'] = '本当にカテゴリ %s を削除しますか？この操作は取り消せません',
                    ['delete_warning'] = '警告: これによりこのカテゴリのすべてのレシピが削除され、元に戻せません',
                    ['title'] = 'タイトル',
                    ['description'] = '説明',
                    ['use_image_url'] = '画像URLを使用',
                    ['use_image_url_desc'] = 'アイコンの代わりに画像URLを使用',
                    ['icon'] = 'アイコン',
                    ['icon_desc'] = 'https://fonts.google.com/icons でアイコンを探してください',
                    ['image'] = '画像URL',
                },

                ['recipe'] = {
                    ['new_title'] = '新規レシピ',
                    ['edit_title'] = 'レシピを編集: %s',
                    ['delete_title'] = 'レシピを削除: %s',
                    ['delete_description'] = '本当にレシピ %s を削除しますか？この操作は取り消せません',
                    ['title'] = 'タイトル',
                    ['description'] = '説明',
                    ['required_level'] = '必要レベル',
                    ['required_level_desc'] = 'このレシピをクラフトするためのグローバルレベル空白で制限なし',
                    ['required_category_level'] = '必要カテゴリレベル',
                    ['required_category_level_desc'] = 'このレシピをクラフトするためのカテゴリレベル空白で制限なし',
                    ['crafting_time'] = 'クラフト時間（秒）',
                    ['crafting_time_desc'] = 'このレシピをクラフトする所要時間（秒）',
                    ['xp_reward'] = 'XP 報酬',
                    ['xp_reward_desc'] = 'このレシピをクラフトした際に付与される XP（デフォルト 25）',
                    ['prop_model'] = 'プロップモデル',
                    ['prop_model_desc'] = 'このレシピをクラフト中に表示するプロップモデル空白でプロップなし（例: prop_tool_hammer）',
                    ['prop_rot'] = 'プロップ回転',
                    ['prop_rot_desc'] = 'プロップモデルの回転',
                    ['prop_offset'] = 'プロップオフセット',
                    ['prop_offset_desc'] = 'プロップモデルの位置オフセット中心調整用X: 前後 Y: 左右 Z: 上下',
                    ['blueprints'] = '設計図',
                    ['blueprints_desc'] = 'このレシピをクラフトするのに必要な設計図',
                    ['ingredients'] = '材料',
                    ['ingredients_desc'] = 'このレシピをクラフトするのに必要な材料最低 1 つ',
                    ['results'] = '結果',
                    ['results_desc'] = 'このレシピをクラフトした結果最低 1 つ',
                    ['cooldown_limit'] = 'クールダウン制限',
                    ['cooldown_limit_desc'] = 'ウィンドウ内での最大制作数 0/空欄で無効',
                    ['cooldown_window'] = 'クールダウンウィンドウ',
                    ['cooldown_window_desc'] = 'クールダウンウィンドウの長さ (日、時間、分、秒)',
                    -- v1.2.1: Failure Chance
                    ['failure_chance'] = '失敗確率 (%)',
                    ['failure_chance_desc'] = 'クラフトが失敗する確率 (0-100)。失敗時も材料は消費されます。',
                    ['failure_mode'] = '失敗モード',
                    ['failure_mode_desc'] = 'batch = 全体で1回の判定、individual = 各アイテムごとに個別判定。',

                    ['add'] = '追加'
                },

                ['blueprint'] = {
                    ['new_title'] = '新規設計図',
                    ['edit_title'] = '設計図を編集: %s',
                    ['delete_title'] = '設計図を削除: %s',
                    ['delete_description'] = '本当に設計図 %s を削除しますか？この操作は取り消せません',
                    ['label'] = 'ラベル',
                    ['description'] = '説明',
                    ['uses'] = '使用回数',
                    ['uses_description'] =
                    '`enableBlueprintItems`, `removeBlueprintOnCraft`, `blueprintDurability` が有効な場合にのみ使用'
                },

                ['select_blueprint'] = {
                    ['label'] = '設計図',
                    ['select_blueprint'] = '設計図を選択',
                    ['search_blueprints'] = '設計図を検索...',
                    ['loading'] = '設計図を読み込み中...',
                    ['error'] = '設計図の読み込みにエラー',
                    ['duplicate'] = '設計図は既に追加されています別の設計図を選択してください',
                    ['no_found'] = '設計図が見つかりません'
                },

                ['select_item'] = {
                    ['label'] = 'アイテム',
                    ['count'] = '数量',
                    ['select_item'] = 'アイテムを選択',
                    ['search_items'] = 'アイテムを検索...',
                    ['loading'] = 'アイテムを読み込み中...',
                    ['error'] = 'アイテムの読み込みにエラー',
                    ['no_found'] = 'アイテムが見つかりません',
                    ['set_metadata'] = 'メタデータを設定',
                    ['metadata_title'] = 'メタデータ: %s',
                },

                ['errors'] = {
                    ['name_is_required'] = '名前は必須です',
                    ['name_too_short'] = '名前は2文字以上でなければなりません',
                    ['category_is_required'] = '少なくとも1つのカテゴリが必要です',
                    ['item_is_required'] = 'アイテムは必須です',
                    ['min_one_item'] = '少なくとも1つのアイテムを追加してください',
                }
            }
        }
    },

    ['command'] = {
        ['error'] = 'コマンドエラー',
        ['not_allowed'] = 'このコマンドを使用する権限がありません',
        ['no_subcommand'] = '無効なサブコマンドです/crafting help で一覧を確認してください',
        ['no_player'] = 'そのIDのプレイヤーが見つかりません',
        ['no_blueprint_found'] = 'その名前またはIDの設計図が見つかりません',
        ['already_has_blueprint'] = 'プレイヤーは既にこの設計図を所有しています',
        ['gave_blueprint'] = 'プレイヤー %s に設計図 %s を付与しました',
        ['removed_blueprint'] = 'プレイヤー %s から設計図 %s を削除しました',
        ['set_level'] = 'プレイヤー %s のレベルを %s に設定しました',
        ['set_category_level'] = 'プレイヤー %s のカテゴリレベル %s を設定しました',
        ['no_category_found'] = 'その名前またはIDのカテゴリが見つかりません',
        ['category_level'] = 'カテゴリレベル',
        ['player_level'] = '%s のレベル (%s)',
        ['invalid_level'] = '無効なレベルが指定されました',
        ['gave_portable_item'] = '作業台タイプ (%s) の携帯アイテムをプレイヤー %s に付与しました',
        ['missing_arguments'] = '引数が不足しています/crafting help で詳細を確認してください',
        ['help'] = {
            ['title'] = 'クラフトコマンド',
            ['description'] = '利用可能なコマンド一覧',
            ['subcommands'] = {
                ['help'] = 'ヘルプメニューを表示',
                ['blueprints'] = '自分の設計図を表示',
                ['level'] = '自分のレベルを表示',
                ['editor'] = 'クラフトエディターを開く',
                ['getblueprints'] = 'プレイヤーの設計図を表示',
                ['giveblueprint'] = 'プレイヤーに設計図を付与',
                ['removeblueprint'] = 'プレイヤーから設計図を削除',
                ['getlevel'] = 'プレイヤーのレベルを表示',
                ['setlevel'] = 'プレイヤーレベルを設定',
                ['setcategorylevel'] = 'プレイヤーのカテゴリレベルを設定',
                ['editbench'] = '最寄りの作業台を編集',
                ['removebench'] = '最寄りの作業台を削除',
                ['giveportableitem'] = 'プレイヤーに携帯作業台アイテムを付与'
            },
            ['params'] = {
                ['id'] = 'プレイヤーID',
                ['blueprint'] = '設計図ID',
                ['level'] = 'レベル',
                ['category'] = 'カテゴリ',
                ['bench'] = '作業台ID/名称'
            }
        }
    },

    ['discord_logs'] =
    '## プレイヤー %s が %sx %s (ID: %s) をクラフトしました\n作業台タイプ: `%s (%s)`\n作業台位置: `%s`\n結果アイテム: `%s`\n材料アイテム: `%s`'
}
