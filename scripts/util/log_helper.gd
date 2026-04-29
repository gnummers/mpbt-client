class_name LogHelper

## Static helpers for surfacing log file paths and user data directory
## to players during error states or in the Settings screen.
##
## User data dir is platform-specific (set via project.godot
## application/config/custom_user_dir_name="mpbt-client"):
##   Windows: %APPDATA%\mpbt-client\
##   Linux:   ~/.local/share/mpbt-client/
##   macOS:   ~/Library/Application Support/mpbt-client/


## Returns the directory where Godot writes the project log file.
static func get_log_dir() -> String:
	return OS.get_user_data_dir().path_join("logs")


## Returns the full path to the current session log file.
static func get_log_path() -> String:
	return get_log_dir().path_join("godot.log")


## Returns the absolute filesystem path for a user:// URL.
## Use this when displaying paths to the player; user:// is not
## meaningful outside Godot's own file API.
static func globalize(user_path: String) -> String:
	return ProjectSettings.globalize_path(user_path)


## Sets a label's text to a short "Logs: <dir>" hint for error screens.
static func apply_log_hint(label: Label) -> void:
	label.text = "Logs: %s" % get_log_dir()
