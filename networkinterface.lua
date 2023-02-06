root_path      = "/"
paths 	       = { "lib": root_path + "lib", "home": root_path + "home" }
libs_to_import = ["crypto"]
libs           = {}
net_card       = "wlan0"
computer 	   = get_shell.host_computer



import_lib = function(lib)
	lib_extension = ".so"
	libs[lib]     = include_lib(paths.lib + "/" + lib + lib_extension)
	
	if libs[lib] then
		return libs[lib]
	else
		return null
	end if
end function

monitor_mode = function(bool)
	monitor_mode_value = null

	if bool then
		monitor_mode_value = "start"
	else
		monitor_mode_value = "stop"
	end if
		
	initializing_monitor = libs.crypto.airmon(monitor_mode_value, net_card)
	
	if initializing_monitor then
		return 1
	else
		return 0
	end if
end function

handle_error = function(item, message)
	if message == 1 then
		message = "imported"
	else if message == 2 then
		message = "initialized"
	else
		message = "loaded"
	end if

	if item then
		print("Successfully " + message)
	else
		exit("Item could not be " + message + ", leaving")
	end if
end function

terminal_space = function()
	print(" ")
end function
										
										
										
terminal_space
for lib_to_import in libs_to_import
	print("Trying to import lib: " + lib_to_import)
	imported_lib = import_lib(lib_to_import)
	
	handle_error(imported_lib, 1)
end for

terminal_space
print("Initializing monitor mode in " + net_card + "...")
initied_monitor = monitor_mode(true)
handle_error(initied_monitor, 2)

terminal_space
networks = computer.wifi_networks(net_card)

info = "ID BSSID PWR ESSID"
counter = 1
for network in networks
	info = info + "\n" + counter + " " + network
	counter = counter + 1
end for
print(format_columns(info))
terminal_space

interface_id = user_input("Select interface (Press ID number): ", false, true)
interface_splitted = networks[interface_id.val - 1].split(" ")
print("Desired network: " + interface_splitted[2] + ", preparing to send packets")

terminal_space

packets_info = "PRESS STRENGTH\n1 7.000\n2 8.000\n3 9.000\n4 10.000"
print(format_columns(packets_info))
packet_strength_input = user_input("Select strength of network packets (Press ID number): ", false, true)
packet_strength = 0

if packet_strength_input == "1" then
	packet_strength = 7000
else if packet_strength_input == "2" then
	packet_strength = 8000
else if packet_strength_input == "3" then
	packet_strength = 9000
else if packet_strength_input == "4" then
	packet_strength = 10000
end if

print("Selected strength: " + packet_strength)

terminal_space

print("Sending packets to desired network, please wait, it will end automatically")
libs.crypto.aireplay(interface_splitted[0], interface_splitted[2], packet_strength)

terminal_space

network_password = libs.crypto.aircrack(paths.home + "/file.cap")
print("Succesfully cracked, password is: ", network_password)

monitor_mode(false)
