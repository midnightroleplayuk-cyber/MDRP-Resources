/* ============================================================
   CONTRATOS - tipos JSDoc dos pushes (Lua → NUI) e dos RPCs (NUI → servidor)
   ------------------------------------------------------------
   Espelho da secção 5 do docs/ARQUITETURA.md, sem passo de build. Não precisa
   de ser carregado no index.html: serve de referência a quem escreve apps e ao
   editor (/// <reference path="contracts.js" /> ou @type {import(...)}).
   Quando um contrato muda, muda aqui E no documento.
   ============================================================ */

/* ---------------------------------------------------------------
   Resultado uniforme
   --------------------------------------------------------------- */

/**
 * Resposta de `Bridge.request(name, data)`. Nunca rejeita.
 * - `null` / `false` do servidor → `{ success:false, data:null, error:'empty' }`
 * - `{ error }` → `{ success:false, error, data:<objeto original> }`
 * - `{ ok:false }` → `{ success:false, error:'failed', data:<objeto original> }`
 * - resto → `{ success:true, data:<resposta>, error:null }`
 * @template T
 * @typedef {{ success: boolean, data: (T|null), error: (string|null) }} BridgeResult
 */

/* ---------------------------------------------------------------
   Pushes (client.lua → NUI: Bridge.on(evento, fn))
   --------------------------------------------------------------- */

/**
 * Ação de uma notificação (máx. 3). O `id` volta ao servidor em `notifs.action`.
 * @typedef {{ id: string, label: string }} NotificationAction
 */

/**
 * Push `notification` (e argumento de `Notify.push`).
 * `icon` é um id de app ou um URL; `type` escolhe o canal.
 * @typedef {Object} NotificationPush
 * @property {number} [id]            id da linha em apex_phone_notifications (quando persistida)
 * @property {string} app
 * @property {string} title
 * @property {string} msg
 * @property {string} [description]
 * @property {string} [icon]
 * @property {string} [image]
 * @property {number} [duration]      ms
 * @property {NotificationAction[]} [actions]
 * @property {'banner'|'silent'|'island'|'lock'} [type]
 * @property {*} [data]
 */

/**
 * Push `session`: a personagem carregou (multicharacter). Se o citizenid for outro, o
 * System troca de personagem (System.switchCharacter).
 * @typedef {{ citizenid: string }} SessionPush
 */

/**
 * Push `openURL`: o Lua pede para abrir um deep link. Aceita também a string direta.
 * @typedef {({ url: string }|string)} OpenURLPush
 */

/**
 * Push `callMute` (ao outro participante da chamada).
 * @typedef {{ src: number, on: boolean }} CallMutePush
 */

/**
 * Push `player` (dados da personagem).
 * @typedef {Object} PlayerPush
 * @property {string} citizenid
 * @property {string} firstname
 * @property {string} lastname
 * @property {string} phone
 * @property {{ name: string, label: string, grade?: (string|number) }} [job]
 * @property {{ cash: number, bank: number }} [money]
 */

/**
 * Resposta do NUI callback `ready` (client/main.lua). Campos novos da Fase 1 no fim.
 * `safeZone` não tem forma fixada na secção 5: o System aceita
 *   - número 0.5-1 → GetSafeZoneSize() (margem = (1 − n) / 2 de cada lado)
 *   - { x, y } com valores ≤ 1 → frações da janela; > 1 → píxeis
 * @typedef {Object} ReadyConfig
 * @property {boolean} inFiveM
 * @property {string} [defaultPin]
 * @property {string} [frame]
 * @property {number} [scale]
 * @property {{ right: number, bottom: number }} [offset]
 * @property {number} [peekSeconds]
 * @property {PlayerPush} [player]
 * @property {'pt'|'en'|'es'} [defaultLang]
 * @property {'light'|'dark'|'auto'} [defaultTheme]
 * @property {string} [veraKey]        '' = sem tecla
 * @property {boolean} [debug]
 * @property {(number|{ x: number, y: number })} [safeZone]
 * @property {{ attempts: number }} [pinLock]
 * @property {boolean} [allowWalking]
 * @property {boolean} [showCursor]
 * @property {{ pageSize?: number, editWindowMin?: number, deleteForAllMin?: number, typingMs?: number, reactions?: string[], maxGroupMembers?: number }} [messages]  Fase 2: Config.Messages → System.config.messages
 * @property {{ maxImageBytes?: number, maxAudioSec?: number, maxAudioBytes?: number, chunkBytes?: number }} [media]  Fase 2: Config.Media → System.config.media
 * @property {{ maxAttachments?: number, draftsMax?: number }} [mail]  Fase 2: Config.Mail → System.config.mail
 */

/* ---------------------------------------------------------------
   RPCs (Bridge.rpc / Bridge.request)
   --------------------------------------------------------------- */

/**
 * Item de `notifs.list`. `actions`, `type` e `duration` só vêm quando foram gravados com a notificação
 * (NotifyPlayer/NotifyCitizen com opts): a entregue ao entrar e a do histórico mostram os mesmos botões de um push.
 * @typedef {{ id: number, app: string, title: string, msg: (string|null), data: *, icon: (string|null), image: (string|null), read: boolean, created: number, actions?: NotificationAction[], type?: ('banner'|'silent'|'island'|'lock'), duration?: number }} NotificationRow
 */
/**
 * RPC `notifs.list` `{ before?, limit? }` → isto. `limit` por omissão 30 (máx. 100), mais recentes primeiro.
 * `before` = id do último item recebido (as mais antigas do que ele); um valor ≥ 1e11 é lido como data em ms.
 * (O @typedef tem de abrir a sua própria linha: a meio do texto o JSDoc não o reconhece.)
 * @typedef {{ items: NotificationRow[], more: boolean }} NotifsListResult
 */
/** RPC `notifs.read` `{ ids:number[] }` ou `{ all:true, app? }` → `{ ok }` */
/** RPC `notifs.remove` `{ ids:number[] }` → `{ ok }` · `notifs.clear` `{ app? }` → `{ ok }` */
/**
 * RPC `notifs.open` `{ id }` → `{ ok }` · `notifs.action` `{ id, action }` → `{ ok }`.
 * O `notifs.action` só aceita uma ação GRAVADA com essa notificação (`{ ok:false, error:'invalid' }` para qualquer
 * outra, e para notificações antigas sem ações gravadas; `'notfound'` para um id que não é do jogador). A mesma ação
 * pode chegar mais do que uma vez: quem ouve `apex_phone:notificationAction` tem de ser idempotente.
 */

/**
 * RPC `account.get` → conta SEM `pin`.
 * @typedef {Object} Account
 * @property {string} citizenid
 * @property {string} account_id
 * @property {string} username
 * @property {string} phone
 * @property {boolean} hasPin
 * @property {0|4|6} pinLen
 * @property {number} avatar
 * @property {string} device_id
 * @property {string} sim_id
 * @property {number} created
 * @property {Object|null} settings
 * @property {Object|null} layout
 * @property {string|null} [face]
 */

/**
 * RPC `account.verifyPin` `{ pin }`.
 * `attempts` = tentativas que AINDA RESTAM antes do bloqueio (0 quando bloqueado);
 * `lockedUntil` = epoch em ms (relógio do servidor) até ao fim do bloqueio;
 * `wait` = segundos que faltam (server/main.lua manda-o - é o que a NUI deve usar, não depende do relógio do PC).
 * Sem código na conta responde sempre `{ ok:true }`.
 * @typedef {{ ok: boolean, attempts?: number, lockedUntil?: number, wait?: number }} VerifyPinResult
 */

/**
 * RPC `account.setPin` `{ old, new }` → `{ ok, error? }`. `new = ''` desativa o código; `new` em falta é 'invalid';
 * sem código atual o `old` é ignorado. Um `old` errado conta no MESMO contador do verifyPin.
 * Erros: 'invalid' (não é 4/6 dígitos), 'badpin', 'locked' (estes dois trazem attempts/lockedUntil/wait), 'noacc', 'noplayer'.
 * @typedef {{ ok: boolean, error?: string, hasPin?: boolean, pinLen?: number, attempts?: number, lockedUntil?: number, wait?: number }} SetPinResult
 */

/**
 * RPC `account.create` `{ username, pin?, avatar?, settings?, face? }` → {@link Account} ou `{ error }`.
 * Nunca reescreve uma conta que exista: `'exists'` = esta personagem já tem conta (o assistente carrega-a com
 * `account.get` e arranca bloqueado, com o código dela). Outros erros: 'invalid', 'taken', 'badpin', 'noplayer',
 * 'busy' (5 números novos seguidos apanhados por outras contas ao mesmo tempo - tentar outra vez).
 * RPC `account.swapSim` → `{ phone, sim_id }` · `{ error:'busy' }` (tentar outra vez) · nada (sem conta / desativada).
 * @typedef {{ error: ('exists'|'invalid'|'taken'|'badpin'|'noplayer'|'busy') }} AccountCreateError
 */

/**
 * Autorizações das apps externas GRAVADAS NO SERVIDOR (tabela apex_phone_app_grants; "uma vez" só em memória até sair).
 * `perm` ∈ 'sms' | 'contacts' | 'photos' | 'bank' (+ tipos de Config.ExternalApps.sensitive).
 * - RPC `apps.grant` `{ app, perm, once? }` → `{ ok, once? }` · `{ ok:false, error: 'invalid'|'limit'|'noplayer' }`
 *   (chamado pelo thirdparty.js DEPOIS de o jogador responder ao pedido de permissão)
 * - RPC `apps.revoke` `{ app, perm?, once? }` → `{ ok }` (sem perm = todas as da app; once:true = só as "uma vez")
 * - RPC `apps.grants` `{}` → isto (listas vazias podem chegar como `{}` - tabela vazia do Lua)
 * Nenhum dos três aceita pedidos de apps externas.
 * @typedef {{ items: ({ app: string, perm: string, created: number }[]|Object), once: ({ app: string, perm: string }[]|Object) }} AppGrantsResult
 */

/**
 * Dispatcher - pedidos de apps externas: o thirdparty.js (iframes e `RKPhone.rpc`) marca `data.__ext = <id da app>`
 * (id: letras, números, _ - . :, até 64). O servidor tira o campo antes do RPC e responde:
 * `{ error:'forbidden' }` (id inválido ou RPC fora de Config.ExternalApps.rpc), `{ error:'nogrant' }` (RPC sensível sem
 * autorização gravada), `{ error:'ratelimit' }` (balde próprio de cada app). `messages.send` externo = só SMS simples para
 * um número; `player.get` externo sem `money` sem a autorização 'bank'.
 * @typedef {('forbidden'|'nogrant'|'ratelimit')} ExternalRpcError
 */

/**
 * Custódia de itens (Marketplace e Onion, `Config.Marketplace.transferItems` / `Config.Onion.transferItems`).
 * RPC `escrow.config` → `{ market: boolean, onion: boolean }` (custódias novas ligadas).
 * Campo `item` (aditivo) nas respostas que mexem no item: market.update/delete/buy, onion.update/delete/buy/ship/confirm.
 * `status`: 'given' | 'returned' | 'pending' (reason 'invfull' | 'offline' | 'retry') | 'reserved' (onion.buy) | 'sent' (onion.ship).
 * Anúncios: market.list/mine/get → `escrow` (há unidades guardadas), `item_count` (soma das linhas guardadas), `custody`;
 * onion.list → `escrow`; onion.mine → `escrow`, `custody`. Erros novos: 'noitem', 'noinv', 'escrow', 'busy'.
 * @typedef {{ status: ('given'|'returned'|'pending'|'reserved'|'sent'), reason?: string, name?: string, label?: string, count?: number }} EscrowItemResult
 */

/**
 * RPC `messages.search` `{ q }` → no máx. 20, só SMS do próprio. `number` = o outro lado.
 * @typedef {{ id: number, app: string, number: string, content: string, created: number }} MessageSearchRow
 */

/** RPC `calls.mute` `{ callId, on }` → `{ ok }` */

/* ---------------------------------------------------------------
   Fase 2 - Comunicação (docs/ARQUITETURA.md secção 8). Tudo ADITIVO: as respostas antigas continuam válidas.
   Listas que o Lua manda vazias chegam como {} (json.encode de uma tabela vazia): quem percorre usa Array.isArray
   com Object.values de recurso. `reactions` só vem quando há reações.
   --------------------------------------------------------------- */

/**
 * Citação de uma mensagem (`replyTo` nas mensagens e nos pushes). `deleted` = a original foi apagada para todos (preview '').
 * @typedef {{ id: number, sender?: string, preview: string, deleted?: boolean }} ReplyRef
 */
/** @typedef {{ emoji: string, who: string, mine?: boolean }} Reaction   `mine` só nas respostas (nos pushes compara-se `who`) */

/**
 * Mensagem (linha de `messages.get`, `last` de `messages.threads`, resposta de `messages.send` e push `message`).
 * `status` = estado de uma mensagem MINHA ('read' quando um dos lados desligou os recibos nunca aparece; nos grupos 'read'
 * = todos os outros membros ativos leram). `deleted` = apagada para todos (content '' e payload null).
 * Tipos: 'text' | 'image' (payload { mediaId } ou o antigo { url, seed }) | 'audio' (payload { mediaId, duration ms, waveform ≤ 64 números 0..1 })
 * | 'location' { x, y, label } | 'contact' { name, number } | 'app' { app } | 'system' (só grupos; payload { action, by, targets?, title?, role?, admin?, avatar?, auto? }).
 * @typedef {Object} Message
 * @property {number} id
 * @property {string} app
 * @property {string} sender
 * @property {string} receiver          número, username social ou 'g:<id>' nos grupos
 * @property {string} type
 * @property {string} content
 * @property {Object|null} payload
 * @property {boolean} read
 * @property {number} created
 * @property {'sent'|'delivered'|'read'} [status]
 * @property {number} [deliveredAt]
 * @property {number} [readAt]
 * @property {number} [editedAt]
 * @property {boolean} [deleted]
 * @property {number} [deletedAt]
 * @property {number} [conversation]    id do grupo
 * @property {ReplyRef} [replyTo]
 * @property {Reaction[]} [reactions]
 */

/**
 * Push `message`: {@link Message} + no grupo `group: { id, title, avatar }`; `muted: true` quando quem recebe silenciou a
 * conversa (ou, num grupo, bloqueou quem escreveu) - a NUI não avisa. A NUI é quem notifica (1:1 e grupos); um push
 * com `notified` boolean quer dizer que quem o mandou já notificou. As mensagens 'system' nunca notificam.
 * @typedef {Message & { group?: { id: number, title: string, avatar: (number|null) }, muted?: boolean, notified?: boolean }} MessagePush
 */

/**
 * Push `messageStatus`:
 * - 1:1 `{ ids, status: 'delivered'|'read', at, number, app }` (number = quem recebeu/leu)
 * - grupo lida `{ conversation, ids, status: 'read', at, who, upTo }` (só aos remetentes das mensagens lidas, com recibos ligados)
 * - grupo entregue `{ conversation, ids, status: 'delivered', at, app }` (ao entrar alguém que estava desligado)
 * @typedef {{ ids: number[], status: ('delivered'|'read'), at: number, number?: string, app?: string, conversation?: number, who?: string, upTo?: number }} MessageStatusPush
 */
/**
 * Push `messageUpdate`: `{ id, app, number, conversation?, content, editedAt }` (editada) ou `{ id, app, number, conversation?, deleted: true, deletedAt }`.
 * @typedef {{ id: number, app: string, number: string, conversation?: number, content?: string, editedAt?: number, deleted?: boolean, deletedAt?: number }} MessageUpdatePush
 */
/** @typedef {{ id: number, app: string, number: string, conversation?: number, reactions?: Reaction[] }} MessageReactionPush   push `messageReaction` (sem `reactions` = nenhuma) */
/** @typedef {{ id: number, app: string, number: string, conversation?: number }} MessageDeletedPush   push `messageDeleted` (pedido antigo messages.delete SEM scope) */
/** @typedef {{ from: string, app: string, conversation?: number, on: boolean }} TypingPush   push `typing` */
/**
 * Push `groupUpdate` a todos os membros ativos (e ao removido, com `removed: true`).
 * @typedef {{ id: number, action: ('create'|'rename'|'avatar'|'add'|'remove'|'role'|'leave'), by: string, title?: string, avatar?: (number|null), targets?: string[], role?: ('admin'|'member'), admin?: string, removed?: boolean }} GroupUpdatePush
 */

/**
 * Item de `messages.threads` `{ app }`. 1:1: `{ number, name?, unread, last, ts, pinned, mutedUntil?, pinnedMsg?, online, lastSeen?, lastStatus? }`.
 * Grupo: `{ conversation, number: 'g:<id>', name, group: { id, title, avatar, members: [{ member, role }], memberCount, role }, unread, last, ts, pinned, mutedUntil?, pinnedMsg?, lastStatus? }`.
 * Conversas limpas por mim (messages.clear) só voltam com mensagens novas.
 * @typedef {{ number: string, name?: (string|null), unread: number, last: (Message|null), ts: number, pinned: boolean, mutedUntil?: number, pinnedMsg?: number, online?: boolean, lastSeen?: number, lastStatus?: ('sent'|'delivered'|'read'), conversation?: number, group?: Object }} ThreadRow
 */

/**
 * RPCs das Mensagens (Fase 2). Erros como `{ error }` (send) ou `{ ok:false, error }` - ler com `Bridge.rpcRaw`.
 * - `messages.get` `{ number | conversation, app, before?, limit? ≤ 50 }` → Message[] cronológico (sem `limit`: até 300, como antes;
 *   grupo: só membros e só desde que entrei)
 * - `messages.send` `{ to | conversation, type?, content, payload?, app?, replyTo?, mediaId? }` → Message ·
 *   erros: badtype, badreply, badmedia, badwave, toolarge, target, noidentity, blocked, nomatch, nogroups, notmember, notfound, invalid, media, internal, db
 * - `messages.read` `{ number | conversation, app }` → `{ ok }` · `messages.typing` `{ number | conversation, app, on }` → `{ ok }`
 * - `messages.react` `{ id, emoji | null }` → `{ ok, id, reactions? }` · erros: notfound, deleted, badreaction
 * - `messages.edit` `{ id, content }` → `{ ok, id, content, editedAt? }` · erros: notfound, notsender, deleted, nottext, window, empty
 * - `messages.delete` `{ id, scope?: 'me'|'all' }` → `{ ok, deleted? }` · erros: badscope, notfound, notsender, window, unsupported
 * - `messages.clear` `{ number | conversation, app }` → `{ ok, clearedBefore? }`
 * - `thread.set` `{ number | conversation, app, pinned?, mutedUntil? (ms | true/-1 = para sempre 4102444800000 | false/0 = tirar), pinnedMsg? (id | false/0) }`
 *   → `{ ok, pinned, mutedUntil, pinnedMsg }` · erros: invalid, notfound, notmember, target
 * - `presence.get` `{ numbers: string[] ≤ 50 }` → `{ [número]: { online, lastSeen? } }` (respeita settings.lastSeen e bloqueios)
 * - `blocks.list` → `[{ number, created, name? }]` · `blocks.add` / `blocks.remove` `{ number }` → `{ ok, number }` · erros: invalid, self, limit, noplayer
 * - `media.begin` `{ kind: 'image'|'audio', mime, size (caracteres), duration? ms, meta? }` → `{ id, chunk }` · `media.upload` `{ id, i ≥ 1, total, data }` → `{ ok, i }`
 *   · `media.finish` `{ id }` → `{ ok, id, size }` · `media.get` `{ id, i? }` → `{ id, kind, mime, duration, meta, i, total, size, data }` (juntar os `data` = data: URL)
 *   · erros: badkind, badmime, badsize, toolarge, toolong, badduration, busy, notfound, badchunk, order, baddata, missing, noplayer, db
 * @typedef {string} MessagesRpcPhase2
 */

/**
 * RPC `groups.info` `{ id }` (e resposta de create/rename/setAvatar/add/remove/role). `add` junta `added` [+ `already`, `skipped`].
 * `groups.leave` → `{ ok, id, deleted, admin? }`. Erros `{ ok:false, error }`: invalid, noidentity, nophone, name, members, toomany (+max),
 * badnumber (+numbers), notfound (não existe OU não és membro), notadmin, notmember, lastadmin, media, limit (+max), cooldown, busy, db.
 * @typedef {{ ok: true, id: number, app: string, title: string, avatar?: (number|null), createdBy: string, created: number, lastId: (number|null), myRole: ('admin'|'member'), me: string, max: number, memberCount: number, pinned: boolean, mutedUntil?: number, members: { member: string, role: ('admin'|'member'), joined: number, name?: string, isMe?: boolean }[] }} GroupInfo
 */

/**
 * Anexo de um email. Pedido: `{ type: 'photo', id }` (foto da galeria, copiada no servidor) · `{ type: 'photo'|'media', mediaId }` ·
 * `{ type: 'location', x, y, label }` · `{ type: 'contact', name, number }`. Resposta/gravado: `{ type:'photo', mediaId, mime, size }` |
 * `{ type:'photo', url }` | `{ type:'photo', seed }` | location | contact | `{ type:'media', mediaId, kind, mime, size, duration }`.
 * RPCs: mail.list `{ folder?, before?, limit?, q?, flagged? }` · mail.counts · mail.get `{ id }` · mail.send `{ to, subject, body, attachments?, draftId? }`
 * → `{ ok, id, delivered, attachments }` · mail.saveDraft `{ id?, to, subject, body, attachments? }` · mail.move `{ id, folder }` · mail.flag `{ id, on }`
 * · mail.attachment `{ id, index, i? }` → `{ i, total, len, kind, mime, duration, data }`. Erro de anexos: `{ ok:false, error:'attachments', reason, index, max }`.
 * Push `mail`: a linha do email + `notified` (a notificação persistente já saiu pelo servidor).
 * @typedef {{ type: ('photo'|'media'|'location'|'contact'), mediaId?: number, id?: number, url?: string, seed?: number, mime?: string, size?: number, kind?: string, duration?: number, x?: number, y?: number, label?: string, name?: string, number?: string }} MailAttachment
 */

/**
 * Contacto (`contacts.list/add/update`): + `notes` (≤ 500, '' limpa) e `avatarPhoto` (id de foto DO PRÓPRIO; false/0 tira; alheia → `{ error:'photo' }`).
 * @typedef {{ id: number, name: string, number: string, avatar?: *, favorite: boolean, notes?: (string|null), avatarPhoto?: (number|null) }} Contact
 */

/**
 * Chamadas: push `callState` `{ callId, state, peer?, channel? }` (no 'active' vêm o src do outro e o canal de voz 50000 + callId);
 * `calls.start` → `{ callId?, status: 'ringing'|'busy'|'offline'|'unavailable'|'self'|'nophone'|'ended', name? }` ('unavailable' = bloqueado);
 * linha de `calls.history` + `status` ('answered'|'missed'|'declined'|'busy'|'cancelled'|'offline'|'unavailable').
 * @typedef {{ callId: number, state: string, peer?: number, channel?: number }} CallStatePush
 */

/* ---------------------------------------------------------------
   NUI - estado e módulos
   --------------------------------------------------------------- */

/**
 * `System.state.notifApps[app]` (o antigo `notif[app] === false` equivale a `allow:false`).
 * @typedef {Object} NotifAppSettings
 * @property {boolean} allow
 * @property {boolean} sound
 * @property {boolean} badge
 * @property {boolean} lock
 * @property {boolean} banner
 * @property {'always'|'unlocked'|'never'} preview
 */

/**
 * Chaves de `System.state` acrescentadas na Fase 1.
 * @typedef {Object} SystemStatePhase1
 * @property {Object<string, NotifAppSettings>} notifApps
 * @property {boolean} notifAll         false = nenhuma app mostra notificações
 * @property {'none'|'dnd'|'work'|'sleep'} focus   mantém-se sincronizado com o antigo `dnd` (dnd = focus !== 'none')
 * @property {boolean} reduceMotion     body[data-motion="reduced"]
 * @property {boolean} clock24          usado por UI.fmtTime (true = "09:41", false = "9:41")
 * @property {string} deviceName        '' = "PearPhone de <username>" (System.deviceName())
 * @property {string[]} recentApps      ids das últimas apps abertas (mais recente primeiro, máx. 12)
 */

/**
 * Deep link: `System.openURL('phone://<app>/<caminho>?a=b')` abre a app (pede desbloqueio se
 * preciso) e entrega isto aos handlers de `System.route(app, fn)` e ao evento `deeplink`.
 * @typedef {{ app: string, path: string, parts: string[], query: Object<string,string>, url: string }} DeepLink
 */

/**
 * Eventos internos (Bridge.emit) do System relevantes para outros módulos:
 * - `session:changed` `{ from, to }` - a personagem mudou; o Store já aponta para a nova. Quem
 *   guarda em memória coisas lidas do Store deve voltar a lê-las.
 * - `deeplink` {@link DeepLink}
 * - `factory:reset`, `ready`, `state` (patch), `app:open`/`app:close`/`app:kill` (id)
 * @typedef {string} SystemEvent
 */

/**
 * `UI.skeleton(kind, n)` → elemento de marcação de carregamento (só opacity anima).
 * @typedef {'list'|'grid'|'feed'} SkeletonKind
 */

/**
 * `Perm.request(app, kinds)` → Promise<boolean>. Botões: Não permitir / Permitir uma vez / Permitir.
 * "Permitir uma vez" vale só em memória, até a app ser morta (ou a página recarregar).
 * 'sms' e 'bank' são os pedidos das apps externas (thirdparty.js); nas externas, depois do "sim" do jogador a
 * autorização é também gravada no servidor ({@link AppGrantsResult}) e Definições › Privacidade mostra/revoga essas.
 * @typedef {'camera'|'mic'|'photos'|'location'|'contacts'|'notifications'|'sms'|'bank'} PermKind
 */

window.Contracts = window.Contracts || { version: 1 };
