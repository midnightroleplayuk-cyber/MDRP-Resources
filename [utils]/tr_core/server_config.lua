-- tr_core settings only the server sees: this file is never sent to players' games, so secrets go here.

return {
    -- Discord webhooks for TR scripts' logs. Each log names its channel at the bottom ('security', 'money', ...).
    webhooks = {
        default = '',     -- every log
        -- security = '', -- a channel with its own webhook
    },
}
