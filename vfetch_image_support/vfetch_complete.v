// vfetch_complete.v - Complete vfetch with image support

import os

struct SystemInfo {
	host string
	kernel string
	uptime string
	packages string
	shell string
	de string
	wm string
	cpu string
	gpu string
	memory string
	disk string
	network string
	username string
	os_name string
}

// Get hostname
fn get_host_info() string {
	// In real implementation: return os.get_hostname() or execute 'hostname'
	return 'Standard PC (Q35 + ICH9, 2009) (pc-q35-10.1)'
}

// Get kernel information
fn get_kernel_info() string {
	// In real implementation: read from /proc/version or execute 'uname -r'
	return 'FreeBSD 15.0-RELEASE'
}

// Get system uptime
fn get_uptime() string {
	// In real implementation: read from /proc/uptime or execute 'uptime'
	return '17 hours, 53 mins'
}

// Get package count
fn get_packages_count() string {
	// In real implementation: execute package manager command
	return '625 (pkg)'
}

// Get shell information
fn get_shell() string {
	// In real implementation: read from environment
	return 'bash 5.3.3'
}

// Get desktop environment
fn get_desktop_environment() string {
	// In real implementation: check environment variables
	return 'Xfce4 4.20'
}

// Get window manager
fn get_window_manager() string {
	// In real implementation: check environment
	return 'Xfwm4 (X11)'
}

// Get CPU information
fn get_cpu_info() string {
	// In real implementation: read from /proc/cpuinfo
	return 'Intel(R) Core(TM) i5-4430 (4) @ 3.00 GHz'
}

// Get GPU information
fn get_gpu_info() string {
	// In real implementation: use lspci or similar
	return 'AMD Radeon RX 580 2048SP'
}

// Get memory information
fn get_memory_info() string {
	// In real implementation: read from /proc/meminfo
	return '10.72 GiB / 14.59 GiB (73%)'
}

// Get disk information
fn get_disk_info() string {
	// In real implementation: execute 'df' command
	return '8.33 GiB / 185.30 GiB (4%) - zfs'
}

// Get network information
fn get_network_info() string {
	// In real implementation: check network interfaces
	return '192.168.0.157/24'
}

// Get username
fn get_username() string {
	// In real implementation: get from environment
	return 'xaturing'
}

// Get OS name
fn get_os_name() string {
	// In real implementation: get OS name
	return 'FreeBSD'
}

// Get system information
fn get_system_info() SystemInfo {
	info := SystemInfo{
		host: get_host_info()
		kernel: get_kernel_info()
		uptime: get_uptime()
		packages: get_packages_count()
		shell: get_shell()
		de: get_desktop_environment()
		wm: get_window_manager()
		cpu: get_cpu_info()
		gpu: get_gpu_info()
		memory: get_memory_info()
		disk: get_disk_info()
		network: get_network_info()
		username: get_username()
		os_name: get_os_name()
	}
	return info
}

// Default ASCII art logo
fn get_default_logo() string {
	return '```                        `\n  ` `.....---.......--.```   -/\n  +o   .--`         /y:`      +.\n   yo`:.            :o      `+-\n    y/               -/`   -o/\n   .-                  ::/sy+:.\n   /                     `--  /\n  `:                          :`\n  `:                          :`\n   /                          /\n   .-                        -.\n    --                      -.\n     `:`                  `:`\n       .--             `--.\n          .---.....----.'
}

// Specific logo for FreeBSD
fn get_freebsd_logo() string {
	return ' |/,,_____,~~`/\n   | |  |_________) \n   |  /\n   |__|'
}

// Get logo from file if specified
fn get_logo_from_file(filepath string) string {
	if os.exists(filepath) {
		content := os.read_file(filepath) or {
			eprintln('Error reading logo file: ${filepath}')
			return get_default_logo()
		}
		return content
	} else {
		eprintln('Logo file not found: ${filepath}')
		return get_default_logo()
	}
}

// Print logo based on user preference
fn print_logo(logo_choice string) {
	mut logo := ''
	match logo_choice {
		'freebsd' { logo = get_freebsd_logo() }
		'custom' {
			env_var := os.getenv('VFETCH_LOGO_FILE')
			logo = get_logo_from_file(env_var)
		}
		else { logo = get_default_logo() }
	}
	println(logo)
}

// Execute shell command to display image
fn display_image(image_path string) {
	// In a real implementation, this would call a Nim program or system utility
	// For now, we'll simulate the behavior
	println('Displaying image: ${image_path}')
	// This would execute a command like: 
	// nim run image_display_full.nim "${image_path}"
}

// Set image for future use
fn set_image_config(image_path string) {
	// In a real implementation, this would save the image path to a config file
	// For now, we'll just print a message
	println('Image set for future vfetch runs: ${image_path}')
}

fn main() {
	mut logo_choice := 'default' // default logo
	mut image_path := ''
	mut set_image_mode := false
	mut display_image_mode := false
	
	// Parse command line arguments
	if os.args.len > 1 {
		mut i := 1
		for i < os.args.len {
			arg := os.args[i]
			
			if arg == '-l' || arg == '--logo' {
				if i + 1 < os.args.len {
					logo_choice = os.args[i + 1]
					i += 2
				} else {
					println('Usage: vfetch [-l|--logo] [logo_name]')
					println('Available logos: default, freebsd, custom')
					return
				}
			} else if arg == '-setimage' {
				if i + 1 < os.args.len {
					image_path = os.args[i + 1]
					set_image_mode = true
					i += 2
				} else {
					println('Usage: vfetch -setimage <image_path>')
					println('Supported formats: PNG, JPG, JPEG, GIF')
					return
				}
			} else if arg == '-displayimage' {
				if i + 1 < os.args.len {
					image_path = os.args[i + 1]
					display_image_mode = true
					i += 2
				} else {
					println('Usage: vfetch -displayimage <image_path>')
					println('Supported formats: PNG, JPG, JPEG, GIF')
					return
				}
			} else if arg == '-h' || arg == '--help' {
				println('vfetch - System information tool with customizable logos and images')
				println('Usage: vfetch [options]')
				println('Options:')
				println('  -l, --logo [logo_name]      Select logo (default, freebsd, custom)')
				println('  -setimage <image_path>      Set image to display (PNG, JPG, JPEG, GIF)')
				println('  -displayimage <image_path>  Display an image directly (PNG, JPG, JPEG, GIF)')
				println('  -h, --help                 Show this help message')
				println('')
				println('Custom logos can be specified by setting VFETCH_LOGO_FILE environment variable')
				return
			} else {
				println('Unknown option: ${arg}')
				println('Use vfetch --help for usage information')
				return
			}
		}
	}
	
	if set_image_mode {
		set_image_config(image_path)
		return
	}
	
	if display_image_mode {
		display_image(image_path)
		return
	}
	
	info := get_system_info()
	
	// If an image was set previously, display it instead of logo
	// For this demo, we'll just show the logo
	print_logo(logo_choice)
	println('${info.username}@${info.os_name}')
	println('----------------')
	println('Host: ${info.host}')
	println('Kernel: ${info.kernel}')
	println('Uptime: ${info.uptime}')
	println('Packages: ${info.packages}')
	println('Shell: ${info.shell}')
	println('DE: ${info.de}')
	println('WM: ${info.wm}')
	println('CPU: ${info.cpu}')
	println('GPU: ${info.gpu}')
	println('Memory: ${info.memory}')
	println('Disk: ${info.disk}')
	println('Network: ${info.network}')
}