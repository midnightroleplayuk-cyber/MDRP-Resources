export const SUPPORTED_IMAGE_TYPES = [
  "image/jpeg",
  "image/png",
  "image/gif",
  "image/webp",
  "image/svg+xml",
  "image/bmp",
] as const;

export type SupportedImageType = (typeof SUPPORTED_IMAGE_TYPES)[number];

export interface ImageValidationResult {
  valid: boolean;
  error?: string;
  mimeType?: string;
}

export function validateImageFile(
  file: File,
  allowedTypes: readonly string[] = SUPPORTED_IMAGE_TYPES
): ImageValidationResult {
  if (!file) {
    return {
      valid: false,
      error: "No file provided",
    };
  }

  const mimeType = file.type;

  if (!mimeType) {
    return {
      valid: false,
      error: "File has no MIME type. Cannot determine file format.",
      mimeType: undefined,
    };
  }

  if (!mimeType.startsWith("image/")) {
    return {
      valid: false,
      error: `Invalid file type: ${mimeType}. Please select an image file.`,
      mimeType,
    };
  }

  if (!allowedTypes.includes(mimeType)) {
    const allowedList = allowedTypes
      .map((t) => t.replace("image/", ""))
      .join(", ");
    return {
      valid: false,
      error: `Unsupported image format: ${mimeType.replace("image/", "")}. Supported formats: ${allowedList}`,
      mimeType,
    };
  }

  return {
    valid: true,
    mimeType,
  };
}

export function createValidatedImageURL(
  file: File | null | undefined,
  allowedTypes?: readonly string[]
): { url: string | null; error?: string; mimeType?: string } {
  if (!file) {
    return { url: null, error: "No file provided" };
  }

  const validation = validateImageFile(file, allowedTypes);

  if (!validation.valid) {
    return {
      url: null,
      error: validation.error,
      mimeType: validation.mimeType,
    };
  }

  return {
    url: URL.createObjectURL(file),
    mimeType: validation.mimeType,
  };
}
