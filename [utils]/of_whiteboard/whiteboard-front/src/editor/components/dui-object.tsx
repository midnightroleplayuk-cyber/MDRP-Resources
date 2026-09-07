import { useEffect, useState } from "react"

interface PosterData {
  imageSrc: string
  width: number
  height: number
}

export default function DuiObject() {
  const [poster, setPoster] = useState<PosterData | null>(null)
  const [imageLoaded, setImageLoaded] = useState(false)
  const [imageError, setImageError] = useState(false)

  useEffect(() => {
    const handler = (event: MessageEvent) => {
      const data = event.data
      if (data.action === "setDuiProperties") {
        setPoster({
          imageSrc: data.imageSrc,
          width: data.width,
          height: data.height,
        })

        setImageLoaded(false)
        setImageError(false)
      }
    }

    window.addEventListener("message", handler)
    return () => {
      window.removeEventListener("message", handler)
    }
  }, [])

  const handleImageLoad = () => {
    setImageLoaded(true)
  }

  const handleImageError = () => {
    setImageError(true)
    setImageLoaded(false)
  }

  if (!poster) return (
    <div
      style={{
        width: "0",
        height: "0",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        background: "transparent",
      }}
    ></div>
  )

  return (
    <div
      style={{
        width: poster.width,
        height: poster.height,
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        background: "transparent",
      }}
    >
      {imageError ? (
        <span style={{ color: "red", fontSize: "14px", textAlign: "center" }}>
          Error loading image
        </span>
      ) : (
        <img
          src={poster.imageSrc}
          alt="Poster"
          onLoad={handleImageLoad}
          onError={handleImageError}
          style={{
            // The pooled DUI surface is a fixed square that the game then maps onto
            // the poster's quad, so letterboxing here would show up as bars in-world
            // on top of the quad's own aspect. Fill the surface and let the bounds
            // decide the shape
            width: "100%",
            height: "100%",
            objectFit: "fill",
            opacity: imageLoaded ? 1 : 0,
            transition: "opacity 0.5s ease-in-out",
          }}
        />
      )}
    </div>
  )
}