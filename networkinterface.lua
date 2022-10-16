root_path      = "/"
paths 	       = { "lib": root_path + "lib" }
libs_to_import = ["crypto"] // Here add the libs to be imported that you want to use
libs           = {} // Here will be the lib's availables for use, and the key will be the same than above
net_card       = "wlan0"



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
user_bssid = user_input("Insert interface bssid: ")
user_essid = user_input("Insert interface essid: ")
libs.crypto.aireplay(user_bssid, user_essid, 10000)

monitor_mode(false)
