// Gets the full url for an asset dev and prod, since absolute url changes for fivem resource files
function getAssetPath(relativePath: string): string {
  const base = import.meta.env.DEV
    ? '/'
    : import.meta.env.BASE_URL

  return `${base}${relativePath}`
}


export {
  getAssetPath,
}
