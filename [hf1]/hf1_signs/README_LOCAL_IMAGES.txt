HF1 Signs 1.3.0 - Local image support

1. Back up your database and existing hf1_signs folder.
2. Replace resource with this version. Keep your config permissions.
3. Put images into hf1_signs/html/images/ (example: logo.png).
4. Restart hf1_signs after adding or changing files.
5. /sign -> Manage Signs -> select existing sign -> change Image URL to local:logo.png.
6. For new signs, use either local:logo.png or an HTTPS direct image URL.

Existing database rows remain valid. No SQL migration is required. See sql/UPGRADE_EXISTING_DATABASE.sql.
Local images are streamed by FiveM NUI, not a third-party image host. Local images use DUI textures; remote images keep the existing server fetch/render mechanism.
File names: letters, numbers, underscores, hyphens; extensions png/jpg/jpeg/webp/gif.
Local files are included in fxmanifest.lua.
