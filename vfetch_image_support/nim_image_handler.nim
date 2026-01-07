# nim_image_handler.nim - Nim program to handle image display using terminal protocols

import strutils, os, osproc

type
  DisplayMode* = enum
    Normal,    # Display image using terminal protocols
    Ascii,     # Convert to ASCII art
    Auto       # Auto-detect best method

proc validateImage*(path: string): bool =
  ## Validate if the image file exists and has a supported format
  if not fileExists(path):
    return false
  
  let ext = splitFile(path).ext.toLowerAscii()
  return ext in [".png", ".jpg", ".jpeg", ".gif"]

proc getTerminalSupport*(): seq[string] =
  ## Detect what image display methods are supported
  var supported: seq[string] = @[]
  
  # Check for chafa (supports many formats including GIF)
  if execCmdEx("which chafa 2>/dev/null").exitCode == 0:
    supported.add("chafa")

  # Check for img2txt (caca-utils)
  if execCmdEx("which img2txt 2>/dev/null").exitCode == 0:
    supported.add("img2txt")

  # Check for ImageMagick
  if execCmdEx("which convert 2>/dev/null").exitCode == 0:
    supported.add("imagemagick")

  # Check for terminal-image-viewer
  if execCmdEx("which tiv 2>/dev/null").exitCode == 0:
    supported.add("tiv")
  
  return supported

proc displayNormalImage*(path: string) =
  ## Display image using terminal protocols (if supported)
  let supported = getTerminalSupport()
  var displayed = false
  
  # Try chafa first (good for GIF, PNG, JPG)
  if "chafa" in supported:
    let cmd = "chafa -f symbols -c 256 \"" & path & "\""
    try:
      let (output, exitCode) = execCmdEx(cmd)
      if exitCode == 0:
        echo output
        displayed = true
    except:
      discard
  
  # Try terminal-image-viewer
  if not displayed and "tiv" in supported:
    let cmd = "tiv \"" & path & "\""
    try:
      let (output, exitCode) = execCmdEx(cmd)
      if exitCode == 0:
        echo output
        displayed = true
    except:
      discard
  
  if not displayed:
    echo "Normal image display not supported in this terminal."

proc convertToAscii*(path: string) =
  ## Convert image to ASCII art using available tools
  let supported = getTerminalSupport()
  var converted = false
  
  # Try img2txt from caca-utils
  if "img2txt" in supported:
    let cmd = "img2txt -W 60 \"" & path & "\""
    try:
      let (output, exitCode) = execCmdEx(cmd)
      if exitCode == 0:
        echo output
        converted = true
    except:
      discard
  
  # Try chafa in ASCII mode
  if not converted and "chafa" in supported:
    let cmd = "chafa -f symbols -c none \"" & path & "\""
    try:
      let (output, exitCode) = execCmdEx(cmd)
      if exitCode == 0:
        echo output
        converted = true
    except:
      discard
  
  # Try terminal-image-viewer in ASCII mode
  if not converted and "tiv" in supported:
    let cmd = "tiv -w 60 \"" & path & "\""
    try:
      let (output, exitCode) = execCmdEx(cmd)
      if exitCode == 0:
        echo output
        converted = true
    except:
      discard
  
  if not converted:
    echo "ASCII conversion not supported. Available tools: " & join(supported, ", ")
    # Fallback ASCII representation
    echo "  ╔══════════════════════════════════════════════════════════════╗"
    echo "  ║                                                              ║"
    echo "  ║                    IMAGE PLACEHOLDER                         ║"
    echo "  ║                                                              ║"
    echo "  ║  This would display your image as ASCII art using           ║"
    echo "  ║  appropriate conversion tools.                              ║"
    echo "  ║                                                              ║"
    echo "  ╚══════════════════════════════════════════════════════════════╝"

proc displayImage*(path: string, mode: DisplayMode = Auto) =
  ## Display image with specified mode
  if not validateImage(path):
    echo "Error: Invalid image file: " & path
    echo "Supported formats: PNG, JPG, JPEG, GIF"
    return
  
  let ext = splitFile(path).ext.toLowerAscii()
  echo "Displaying image: " & path & " (Format: " & ext[1..^1].toUpperAscii() & ")"
  echo ""
  
  case mode:
  of Normal:
    displayNormalImage(path)
  of Ascii:
    convertToAscii(path)
  of Auto:
    # Try normal display first, fall back to ASCII
    let supported = getTerminalSupport()
    if "chafa" in supported or "tiv" in supported:
      displayNormalImage(path)
    else:
      convertToAscii(path)

proc setImage*(path: string, mode: DisplayMode = Auto) =
  ## Set image for future vfetch runs
  if not validateImage(path):
    echo "Error: Invalid image file: " & path
    echo "Supported formats: PNG, JPG, JPEG, GIF"
    return
  
  # In a real implementation, we would save this to a config file
  # For now, just display it
  echo "Setting image for vfetch: " & path
  displayImage(path, mode)

proc listDisplayModes*() =
  ## List available display modes and terminal support
  echo "Available display methods:"
  let supported = getTerminalSupport()
  if supported.len == 0:
    echo "  No image display tools found in system"
  else:
    for display_method in supported:
      echo "  - " & display_method
  
  echo ""
  echo "Display modes:"
  echo "  - Normal: Display image using terminal protocols"
  echo "  - ASCII:  Convert image to ASCII art"
  echo "  - Auto:   Automatically choose best method"

when isMainModule:
  if paramCount() < 1:
    echo "Usage: nim r nim_image_handler.nim <image_path> [mode]"
    echo "Modes: normal, ascii, auto (default: auto)"
    echo ""
    echo "Available display methods in your terminal:"
    listDisplayModes()
    quit(0)
  
  let imagePath = paramStr(1)
  var mode = Auto
  
  if paramCount() >= 2:
    let modeStr = paramStr(2).toLowerAscii()
    case modeStr:
    of "normal": mode = Normal
    of "ascii": mode = Ascii
    of "auto": mode = Auto
    else:
      echo "Invalid mode: " & modeStr
      echo "Use: normal, ascii, or auto"
      quit(1)
  
  setImage(imagePath, mode)