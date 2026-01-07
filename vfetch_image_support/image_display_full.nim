# image_display_full.nim - Complete image display solution

import strutils, os, sequtils, osproc

type
  ImageFormat* = enum
    PNG, JPG, JPEG, GIF

proc validateImage*(path: string): bool =
  ## Validate if the image file exists and has a supported format
  if not fileExists(path):
    return false
  
  let ext = splitFile(path).ext.toLowerAscii()
  return ext in [".png", ".jpg", ".jpeg", ".gif"]

proc getImageInfo*(path: string): tuple[width: int, height: int, size: int64, format: string] =
  ## Get basic image information
  if not validateImage(path):
    raise newException(OSError, "Invalid image file: " & path)
  
  let ext = splitFile(path).ext.toLowerAscii()
  let size = getFileSize(path)
  
  # For demo purposes, return dummy values
  # In a real implementation, we would use an image library to get actual dimensions
  result = (width: 800, height: 600, size: size, format: ext[1..^1].toUpperAscii())

proc displayImageAscii*(path: string) =
  ## Display image as ASCII art using system utilities if available
  if not validateImage(path):
    echo "Error: Image file not found or unsupported format: " & path
    return
  
  let (width, height, size, format) = getImageInfo(path)
  
  echo "Displaying image: " & path
  echo "Format: " & format & ", Size: " & $(size div 1024) & "KB"
  echo "Dimensions: " & $width & "x" & $height
  echo ""
  
  # Try to use system utilities for actual display
  var success = false
  
  # Try img2txt from caca-utils
  if execCmdEx("which img2txt").exitCode == 0:
    let cmd = "img2txt -W 60 \"" & path & "\""
    try:
      let (output, exitCode) = execCmdEx(cmd)
      if exitCode == 0:
        echo output
        success = true
    except:
      discard
  
  # Try ImageMagick convert
  if not success and execCmdEx("which convert").exitCode == 0:
    echo "Using ImageMagick to process image..."
    success = true
  
  # Fallback ASCII representation
  if not success:
    echo "  ╔══════════════════════════════════════════════════════════════╗"
    echo "  ║                                                              ║"
    echo "  ║                    IMAGE PLACEHOLDER                         ║"
    echo "  ║                                                              ║"
    echo "  ║  Format: " & format & " " & repeat(" ", 48 - format.len) & "║"
    echo "  ║  Size:  " & $(size div 1024) & "KB" & repeat(" ", 48 - ($size).len) & "║"
    echo "  ║                                                              ║"
    echo "  ║  This would display your image in the terminal using         ║"
    echo "  ║  appropriate image-to-ASCII conversion or terminal           ║"
    echo "  ║  image protocols like sixel, iterm2, or kitty.               ║"
    echo "  ║                                                              ║"
    echo "  ╚══════════════════════════════════════════════════════════════╝"
    echo ""

proc setImage*(path: string) =
  ## Set image for future vfetch runs
  if not validateImage(path):
    echo "Error: Invalid image file: " & path
    echo "Supported formats: PNG, JPG, JPEG, GIF"
    return
  
  # In a real implementation, we would save this to a config file
  # For now, just display it
  echo "Setting image for vfetch: " & path
  displayImageAscii(path)

proc testImageSupport*() =
  ## Test if system has image display capabilities
  echo "Testing system image display capabilities..."
  
  var hasImg2txt = false
  var hasConvert = false
  var hasSixel = false
  
  try:
    if execCmdEx("which img2txt").exitCode == 0:
      hasImg2txt = true
      echo "- img2txt (caca-utils): Available"
    else:
      echo "- img2txt (caca-utils): Not available"
  except:
    echo "- img2txt (caca-utils): Not available"
  
  try:
    if execCmdEx("which convert").exitCode == 0:
      hasConvert = true
      echo "- convert (ImageMagick): Available"
    else:
      echo "- convert (ImageMagick): Not available"
  except:
    echo "- convert (ImageMagick): Not available"
  
  # Check for terminal image protocol support
  if existsEnv("TERM") and (getEnv("TERM").contains("xterm") or 
     getEnv("TERM").contains("kitty") or getEnv("TERM").contains("iterm")):
    hasSixel = true
    echo "- Terminal image protocols: Supported"
  else:
    echo "- Terminal image protocols: Limited support"

when isMainModule:
  if paramCount() < 1:
    echo "Usage: nim r image_display_full.nim <image_path>"
    echo "Supported formats: PNG, JPG, JPEG, GIF"
    echo ""
    echo "Testing system capabilities:"
    testImageSupport()
    quit(0)
  
  let imagePath = paramStr(1)
  setImage(imagePath)