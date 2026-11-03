-- Discord and media CDN configuration. Keep credentials server-side and restart sky_jobs_base after changes.
-- FiveManage: https://docs.fivemanage.com/guides/uploading-files/first-steps
-- Qbox CDN: https://docs.qbox.re/dashboard/cdn
Webhooks = {
    businessAnnouncements = {
        public = "", -- Discord webhook for the public civilian channel.
        admin = "", -- Discord webhook for the private administrator log channel.
    },
    media = {
        provider = "fivemanage", -- Built in: "fivemanage", "qbox"; custom names are registered server-side.
        providers = {
            -- Custom provider configuration is stored here under its registered name.
            -- my_provider = { timeoutMs = 10000 }
        }
    },
    fivemanage = {
        apiKey = "", -- Example: "YOUR_MEDIA_API_KEY"
        baseUrl = "https://api.fivemanage.com/api/v3/file",
        timeoutMs = 10000
    },
    qbox = {
        apiKey = "", -- Example: "qbox_live_abc123" or "Bearer qbox_live_abc123"
        baseUrl = "https://api.qbox.re/v1/file",
        timeoutMs = 10000
    }
}
