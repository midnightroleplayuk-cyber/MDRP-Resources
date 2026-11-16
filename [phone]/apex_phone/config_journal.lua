-- ------------------------------------------------------------
-- JOURNAL (app "Diário")
-- Personal diary per character, stored on the server (apex_phone_journal): text, mood,
-- one photo from the gallery (by id, the image itself never travels with the entry),
-- the place where it was written (nearest known place or rounded coordinates), the
-- in-game weather at that moment and a favourite flag. Entries are private: no RPC
-- ever returns another character's entries.
-- ------------------------------------------------------------
Config.Journal = {
    enabled = true,       -- false: the app says the server turned the journal off
    maxEntries = 500,     -- entries per character (the app refuses new ones above this)
    maxChars = 8000,      -- characters of text per entry
    photos = true,        -- false hides the photo button (entries keep text, mood, place and weather)
    pageSize = 40,        -- entries per page in journal.list
}
