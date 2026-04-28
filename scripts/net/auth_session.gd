extends Node

## Coordinates the account and character auth flow.
##
## Autoload — available as AuthSession throughout the client.
##
## Flow:
##   login(api_url, username, password)
##     → POST /auth/login (sets cookie)
##     → GET /characters/me
##     → emits login_complete(has_character: bool)
##
##   register(api_url, username, password, email)
##     → POST /auth/register
##     → POST /auth/login (auto)
##     → GET /characters/me
##     → emits login_complete(has_character: bool)
##
##   create_character(api_url, display_name, allegiance)
##     → POST /characters
##     → emits character_created(character)

signal login_complete(has_character: bool)
signal login_failed(reason: String)
signal character_created(character: Dictionary)
signal creation_failed(reason: String)

## True once the account has successfully authenticated.
var is_logged_in: bool = false

## Authenticated username.
var username: String = ""

## Active character dict; empty if no character exists yet.
var character: Dictionary = {}

## Pending match context set by the arena ready room before scene transition.
## Keys: arenaId (String), mode ("solo"|"pvp"), slots (Array).
var pending_match: Dictionary = {}

var _cookie: String = ""
var _busy: bool = false
var _api_url: String = ""
var _pending_register: Dictionary = {}
var _client  # AuthClient, instantiated via preload in _ready()

const _AuthClientScript := preload("res://scripts/net/auth_client.gd")


func _ready() -> void:
	_client = _AuthClientScript.new()
	add_child(_client)
	_client.login_done.connect(_on_login_done)
	_client.register_done.connect(_on_register_done)
	_client.character_fetched.connect(_on_character_fetched)
	_client.character_done.connect(_on_character_done)
	_client.failed.connect(_on_failed)


## Log in. Internally fetches the character and emits login_complete.
func login(api_url: String, p_username: String, p_password: String) -> void:
	if _busy:
		return
	_busy = true
	_api_url = api_url
	_client.post_login(api_url, p_username, p_password)


## Register then auto-login. Emits login_complete on success.
func register(api_url: String, p_username: String, p_password: String, p_email: String) -> void:
	if _busy:
		return
	_busy = true
	_api_url = api_url
	_pending_register = {"username": p_username, "password": p_password}
	_client.post_register(api_url, p_username, p_password, p_email)


## Create a character. Must only be called after login_complete(false).
func create_character(api_url: String, display_name: String, allegiance: String) -> void:
	if _busy or not is_logged_in:
		return
	_busy = true
	_api_url = api_url
	_client.post_character(api_url, display_name, allegiance, _cookie)


## Returns the cookie string for use in other authenticated requests.
func auth_cookie() -> String:
	return _cookie


func _on_login_done(p_username: String, p_cookie: String) -> void:
	is_logged_in = true
	username = p_username
	_cookie = p_cookie
	_client.get_character(_api_url, _cookie)


func _on_register_done(_p_username: String) -> void:
	if not _pending_register.is_empty():
		var pending := _pending_register
		_pending_register = {}
		_client.post_login(_api_url, pending["username"], pending["password"])
	else:
		_busy = false


func _on_character_fetched(char: Dictionary) -> void:
	_busy = false
	if char.is_empty():
		login_complete.emit(false)
	else:
		character = char
		login_complete.emit(true)


func _on_character_done(char: Dictionary) -> void:
	_busy = false
	character = char
	character_created.emit(character)


func _on_failed(op: String, reason: String) -> void:
	_busy = false
	match op:
		"login", "register":
			login_failed.emit(reason)
		"character_fetch":
			# Treat fetch failure as no-character so user can attempt creation.
			login_complete.emit(false)
		"character_create":
			creation_failed.emit(reason)
