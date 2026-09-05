/** Served from /public — cache-bust when replacing the file. */
const DEV_PREVIEW_BG = `${import.meta.env.BASE_URL}dev-preview-bg.png?v=2`

export function DevPreviewBackground() {
  return (
    <div className="pointer-events-none fixed inset-0 z-0">
      <img
        src={DEV_PREVIEW_BG}
        alt=""
        className="h-full w-full object-cover"
        draggable={false}
        aria-hidden
      />
    </div>
  )
}
