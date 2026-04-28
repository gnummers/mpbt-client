class_name MapParser

## Parses the room-record table from an MPBT .MAP file.
##
## Binary layout (little-endian, confirmed by RE of MPBTWIN.EXE Map_LoadFile):
##   u16 count
##   repeated count times:
##     u16 room_id, u16 flags
##     u16 x1, y1, x2, y2  (pixel bounds on the visual travel-map bitmap)
##     u16 aux0, aux1, aux2
##     u16 name_len          (includes NUL terminator)
##     name_len bytes        (C string, Latin-1; all known names are ASCII)
##     u16 desc_len          (includes NUL terminator)
##     desc_len bytes        (C string, Latin-1)
##
## Trailing bytes after the room table belong to a picture record and are not
## parsed here; next_offset marks where they begin.
##
## Returns:
##   { ok: bool, error: String, rooms: Array[Dictionary], next_offset: int }
##   On partial failure, rooms contains records parsed before the error.


static func parse(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return _fail("cannot open '%s' (%s)" % [path, error_string(FileAccess.get_open_error())])

	var size := file.get_length()
	if size < 2:
		return _fail("file too short (%d bytes)" % size)

	var count := file.get_16()
	var rooms: Array = []

	for i in count:
		# 9 fixed u16 fields before the variable-length strings = 18 bytes.
		if not _can_read(file, size, 18):
			return _partial(
				"truncated at room %d/%d (fixed fields)" % [i + 1, count],
				rooms, file.get_position(),
			)

		var room := {
			"room_id": file.get_16(),
			"flags":   file.get_16(),
			"x1":      file.get_16(),
			"y1":      file.get_16(),
			"x2":      file.get_16(),
			"y2":      file.get_16(),
			"aux0":    file.get_16(),
			"aux1":    file.get_16(),
			"aux2":    file.get_16(),
		}

		# name_len u16 field
		if not _can_read(file, size, 2):
			return _partial("truncated before name_len at room %d" % (i + 1), rooms, file.get_position())
		var name_len := file.get_16()

		# name bytes + desc_len u16 field
		if not _can_read(file, size, name_len + 2):
			return _partial(
				"truncated reading name/desc_len at room %d (name_len=%d)" % [i + 1, name_len],
				rooms, file.get_position(),
			)
		room["name"] = _read_cstring(file, name_len)

		var desc_len := file.get_16()
		if not _can_read(file, size, desc_len):
			return _partial(
				"truncated reading description at room %d (desc_len=%d)" % [i + 1, desc_len],
				rooms, file.get_position(),
			)
		room["description"] = _read_cstring(file, desc_len)

		rooms.append(room)

	return { "ok": true, "error": "", "rooms": rooms, "next_offset": file.get_position() }


static func _fail(msg: String) -> Dictionary:
	return { "ok": false, "error": msg, "rooms": [], "next_offset": 0 }


static func _partial(msg: String, rooms: Array, offset: int) -> Dictionary:
	return { "ok": false, "error": msg, "rooms": rooms, "next_offset": offset }


static func _can_read(file: FileAccess, size: int, count: int) -> bool:
	return file.get_position() + count <= size


static func _read_cstring(file: FileAccess, length: int) -> String:
	if length <= 0:
		return ""
	var bytes := file.get_buffer(length)
	# Trim NUL terminator; all known MPBT room strings are ASCII (Latin-1 subset).
	var nul := bytes.find(0)
	if nul >= 0:
		bytes = bytes.slice(0, nul)
	return bytes.get_string_from_ascii()
