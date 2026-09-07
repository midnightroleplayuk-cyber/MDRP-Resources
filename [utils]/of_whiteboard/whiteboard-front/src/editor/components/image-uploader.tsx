import React, { useRef, useState } from 'react'
import { Upload, X, Link, FileText } from 'lucide-react'
import clsx from 'clsx'

// Square so the editor opens on a neutral surface; a poster's real shape comes
// from the area drawn in-game, not from this
const BLANK_CANVAS_PX = 1024

const blankCanvas = (): string => {
  const canvas = document.createElement('canvas')
  canvas.width = BLANK_CANVAS_PX
  canvas.height = BLANK_CANVAS_PX

  const ctx = canvas.getContext('2d')
  if (ctx) {
    ctx.fillStyle = '#ffffff'
    ctx.fillRect(0, 0, BLANK_CANVAS_PX, BLANK_CANVAS_PX)
  }

  return canvas.toDataURL('image/png')
}

interface ImageUploaderProps {
  onImageSelect: (imageUrl: string | null) => void
  onClose: () => void
}

export const ImageUploader: React.FC<ImageUploaderProps> = ({ onImageSelect, onClose }) => {
  const fileInputRef = useRef<HTMLInputElement>(null)
  const [dragActive, setDragActive] = useState(false)
  const [urlInput, setUrlInput] = useState('')
  const [urlError, setUrlError] = useState('')

  const handleFileSelect = (file: File) => {
    if (file && file.type.startsWith('image/')) {
      const url = URL.createObjectURL(file)
      onImageSelect(url)
    }
  }

  const handleFileInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (file) {
      handleFileSelect(file)
    }
  }

  const handleDrop = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault()
    setDragActive(false)
    const file = e.dataTransfer.files[0]
    if (file) {
      handleFileSelect(file)
    }
  }

  const handleDrag = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault()
    e.stopPropagation()
    if (e.type === 'dragenter' || e.type === 'dragover') {
      setDragActive(true)
    } else if (e.type === 'dragleave') {
      setDragActive(false)
    }
  }

  const validateImageUrl = (url: string): Promise<boolean> => {
    return new Promise((resolve) => {
      const img = new Image()
      img.onload = () => resolve(true)
      img.onerror = () => resolve(false)
      img.src = url
    })
  }

  const handleUrlSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setUrlError('')
    
    if (!urlInput.trim()) {
      setUrlError('Please enter a URL')
      return
    }

    try {
      const isValidImage = await validateImageUrl(urlInput.trim())
      if (isValidImage) {
        onImageSelect(urlInput.trim())
        setUrlInput('')
      } else {
        setUrlError('Invalid image URL or image could not be loaded')
      }
    } catch (error) {
      setUrlError('Error loading image from URL')
    }
  }

  return (
    <div className={clsx(
      'w-full max-w-md h-fit text-main_white',
      'py-5 border-box rounded-tl-sm rounded-bl-sm rounded-br-sm cursor-pointer z-999 relative flex flex-col gap-2'
    )}>
      <div
        onClick={onClose}
        className={clsx(
          'absolute right-0 -top-[20px] mt-full px-4 w-fit h-[fit] bg-secondary_black rounded-sm py-1',
          'uppercase flex items-center justify-center font-bold'
        )}
      >
        <X></X>
      </div>
      <div
        className={`rounded-lg p-8 text-center cursor-pointer transition-colors bg-secondary_black ${
          dragActive 
            ? 'border-blue-400 bg-blue-50' 
            : 'border-gray-300 hover:border-gray-400'
        }`}
        onDragEnter={handleDrag}
        onDragLeave={handleDrag}
        onDragOver={handleDrag}
        onDrop={handleDrop}
        onClick={() => fileInputRef.current?.click()}
      >
        <Upload className="w-12 h-12 text-gray-400 mx-auto mb-4" />
        <p className="text-gray-600 mb-2">
          Drag and drop an image here, or click to select
        </p>
        <p className="text-sm text-gray-500">
          Supports PNG, JPG up to 10MB
        </p>
        <input
          ref={fileInputRef}
          type="file"
          accept="image/png, image/jpeg"
          onChange={handleFileInputChange}
          className="hidden"
        />
      </div>

      <button
        type="button"
        onClick={() => onImageSelect(blankCanvas())}
        className={clsx(
          'rounded-lg p-4 flex items-center justify-center gap-2 bg-secondary_black',
          'text-gray-300 hover:text-white transition-colors border border-transparent hover:border-gray-600'
        )}
      >
        <FileText className="w-5 h-5" />
        <span>Start with a blank page</span>
      </button>

      <span className='w-3/4 h-1 bg-secondary_black/80 rounded-md ml-[50%] -translate-x-1/2 my-1 animate-pulse'></span>

      <div className='bg-secondary_black rounded-lg min-h-[40px] p-4'>
        <form onSubmit={handleUrlSubmit} className="flex flex-col gap-2">
          <div className="flex items-center gap-2">
            <Link className="w-5 h-5 text-gray-400 flex-shrink-0" />
            <input
              type="url"
              value={urlInput}
              onChange={(e) => setUrlInput(e.target.value)}
              placeholder="https://coolimage.com/......png"
              className="flex-1 bg-transparent border border-gray-600 rounded px-3 py-1 text-white placeholder-gray-400 focus:outline-none focus:border-blue-400"
            />
            <button
              type="submit"
              className="bg-blue-600 hover:bg-blue-700 px-4 py-1 rounded text-white font-medium transition-colors"
            >
              Load
            </button>
          </div>
          {urlError && (
            <p className="text-red-400 text-sm">{urlError}</p>
          )}
        </form>
      </div>
    </div>
  )
}
