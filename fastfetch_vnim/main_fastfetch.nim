# main_fastfetch.nim - Main program for V-Nim FastFetch

import strutils, os

# Define the SystemInfo structure to match the V struct
type
  SystemInfo* = object
    host*: cstring
    kernel*: cstring
    uptime*: cstring
    packages*: cstring
    shell*: cstring
    de*: cstring
    wm*: cstring
    cpu*: cstring
    gpu*: cstring
    memory*: cstring
    disk*: cstring
    network*: cstring
    username*: cstring
    os_name*: cstring

# Import the V functions
proc get_system_info*(): ptr SystemInfo {.importc: "get_system_info", dynlib: "libvnim_fastfetch.so".}
proc free_system_info*(info: ptr SystemInfo) {.importc: "free_system_info", dynlib: "libvnim_fastfetch.so".}

# ASCII art logo for the system info display
const LogoAscii = """
```                        `
  ` `.....---.......--.```   -/
  +o   .--`         /y:`      +.
   yo`:.            :o      `+-
    y/               -/`   -o/
   .-                  ::/sy+:.
   /                     `--  /
  `:                          :`
  `:                          :`
   /                          /
   .-                        -.
    --                      -.
     `:`                  `:`
       .--             `--.
          .---.....----."""

# Function to render system information with ASCII art
proc render_system_info*(sys_info: ptr SystemInfo) =
  echo LogoAscii
  echo $sys_info.username & "@" & $sys_info.os_name
  echo("----------------")
  echo("Host: " & $sys_info.host)
  echo("Kernel: " & $sys_info.kernel)
  echo("Uptime: " & $sys_info.uptime)
  echo("Packages: " & $sys_info.packages)
  echo("Shell: " & $sys_info.shell)
  echo("DE: " & $sys_info.de)
  echo("WM: " & $sys_info.wm)
  echo("CPU: " & $sys_info.cpu)
  echo("GPU: " & $sys_info.gpu)
  echo("Memory: " & $sys_info.memory)
  echo("Disk: " & $sys_info.disk)
  echo("Network: " & $sys_info.network)

# Main procedure to run the FastFetch-like utility
proc run_fastfetch*() =
  let sys_info = get_system_info()
  if sys_info != nil:
    render_system_info(sys_info)
    # Note: We don't call free_system_info here as the memory is static in V
    # In a real implementation, we would handle memory management properly
  else:
    echo "Failed to get system information"

# Entry point
when isMainModule:
  run_fastfetch()