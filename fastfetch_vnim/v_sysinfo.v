// v_sysinfo.v - V module for gathering system information
// This module will gather system information similar to FastFetch

struct SystemInfo {
mut:
	host &u8
	kernel &u8
	uptime &u8
	packages &u8
	shell &u8
	de &u8
	wm &u8
	cpu &u8
	gpu &u8
	memory &u8
	disk &u8
	network &u8
	username &u8
	os_name &u8
}

// Export function to gather system information
@[export: 'get_system_info']
fn get_system_info() &SystemInfo {
	// Create and initialize SystemInfo struct
	info := &SystemInfo{
		host: get_host_info().str
		kernel: get_kernel_info().str
		uptime: get_uptime().str
		packages: get_packages_count().str
		shell: get_shell().str
		de: get_desktop_environment().str
		wm: get_window_manager().str
		cpu: get_cpu_info().str
		gpu: get_gpu_info().str
		memory: get_memory_info().str
		disk: get_disk_info().str
		network: get_network_info().str
		username: get_username().str
		os_name: get_os_name().str
	}

	return info
}

// Helper function to execute shell commands
fn exec_cmd(cmd string) string {
	// In a real implementation, we would use V's os module
	// For now, we'll return mock data for demonstration
	return cmd
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

// Free the SystemInfo struct
@[export: 'free_system_info']
fn free_system_info(info &SystemInfo) {
	// For static allocation, no need to free
}