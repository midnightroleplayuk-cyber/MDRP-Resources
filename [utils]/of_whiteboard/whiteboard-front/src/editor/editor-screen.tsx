import React, { useEffect, useState } from 'react'
import clsx from 'clsx'
import Nui from '@/utils/Nui'
import ImageEditor from '@/vendor/react-image-editor/components/imageEditor/ImageEditor'
import { ImageUploader } from './components/image-uploader'
import { isEnvBrowser } from '@/utils'
import { Loader } from './components/loader'

// Kept in sync with Config.images in config/whiteboard.lua
const EXPORT_MAX_PX = 1024
const EXPORT_QUALITY = 0.85

// The bytes travel to the server over the game's event channel, so the export is
// downscaled and webp-encoded to keep it small
const encodeExport = (blob: Blob): Promise<{ data: string, width: number, height: number }> => {
  return new Promise((resolve, reject) => {
    const img = new Image()
    const url = URL.createObjectURL(blob)

    img.onload = () => {
      URL.revokeObjectURL(url)

      const scale = Math.min(1, EXPORT_MAX_PX / Math.max(img.width, img.height))
      const width = Math.max(1, Math.round(img.width * scale))
      const height = Math.max(1, Math.round(img.height * scale))

      const canvas = document.createElement('canvas')
      canvas.width = width
      canvas.height = height

      const ctx = canvas.getContext('2d')
      if (!ctx) return reject(new Error('Failed to get canvas context'))

      ctx.drawImage(img, 0, 0, width, height)

      const data = canvas.toDataURL('image/webp', EXPORT_QUALITY)
      resolve({ data, width, height })
    }

    img.onerror = () => {
      URL.revokeObjectURL(url)
      reject(new Error('Failed to load image'))
    }

    img.src = url
  })
}

export const EditorScreen: React.FC = () => {
  const [visible, setVisible] = useState<boolean>(isEnvBrowser)
  const [image, setImage] = useState<string | null>(null)
  const [canvas, setCanvas] = useState<string | undefined>(undefined)
  const [isSaving, setIsSaving] = useState<boolean>(false)

  const closeMenu = () => {
    setVisible(false)
    Nui.post('nui:handleClose')
  }

  const resetCanvas = () => {
    setImage(null)
    setCanvas(undefined)
  }

  // `canvas` is the editable object graph behind the flattened export; the server
  // stores both so reopening a poster restores real objects, not a picture of them
  const handleSave = async (imageBlob: Blob | null, canvasJson: string | null) => {
    setIsSaving(true)

    try {
      if (!imageBlob) {
        throw new Error('Export produced no image (tainted canvas from a cross-origin url, or a disposed one)')
      }

      const { data, width, height } = await encodeExport(imageBlob)
      console.log(`Exporting ${width}x${height}, ${Math.round(data.length / 1024)} KB`)

      Nui.post("nui:handleFrameExport", { data, width, height, canvas: canvasJson })
    } catch (err) {
      console.error("Couldn't export image:", err)
      Nui.post("nui:exportFailed")
    } finally {
      Nui.post('nui:handleClose').then(() => {
        Nui.emitEvent("nui:resetCanvas", {})

        setTimeout(() => {
          setIsSaving(false)
        }, 300)
      })
    }
  }

  useEffect(() => {

    const handleKeyClose = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && !isSaving && visible) {
        closeMenu()
      }
    }
    window.addEventListener("keydown", handleKeyClose)

    return () => {
      window.removeEventListener("keydown", handleKeyClose)
    }
  }, [isSaving, visible])

  useEffect(() => {
    // `initialImage` means the game reopened an existing poster rather than
    // starting a fresh one, so skip the uploader and seed the editor
    const handler = (payload: { display: boolean, initialImage?: string, initialCanvas?: string }) => {
      setVisible(payload.display)

      if (payload.display && payload.initialImage) {
        setImage(payload.initialImage)
        setCanvas(payload.initialCanvas)
      }
    }

    Nui.onEvent('nui:handleMenuDisplay', handler)
    return () => Nui.offEvent('nui:handleMenuDisplay', handler)
  }, [])

  useEffect(() => {
    Nui.onEvent('nui:resetCanvas', resetCanvas)
    return () => Nui.offEvent('nui:resetCanvas', resetCanvas)
  }, [])

  return (
    <>
      <div className={clsx(
        'h-full min-w-[500px] absolute left-1/2 -translate-x-1/2 transition-all duration-200 flex items-center',
        visible ? 'opacity-100' : 'opacity-0 hidden'
      )}>
        { !image && !isSaving && <ImageUploader onImageSelect={setImage} onClose={closeMenu} /> }
        { image && !isSaving && (
          <ImageEditor
            key={image}
            className={clsx("h-full")}
            imageUrl={image}
            initialCanvasJson={canvas}
            onSave={handleSave}
            onCancel={closeMenu}
            onChangeImage={resetCanvas}
          />
        ) }
      </div>

      {isSaving && <Loader />}
    </>
  )
}
