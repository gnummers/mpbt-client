class_name MapParser

## Parses the room-record table from an MPBT .MAP file.
##
## Binary layout (little-endian, confirmed by RE of MPBTWIN.EXE Map_LoadFile):
##   u16 count
##   repeated count times:
##     u16 room_id, u16 flags
##     u16 x, y, x_dup, y_dup   (x_dup==x and y_dup==y for all known rooms;
##                                x,y = top-left pixel on solaris_background.png)
##     u16 label_w, label_h, 0  (label bounding-box in pixels; label_h==29 for
##                                two-line labels, ==15 for single-line)
##     u16 name_len              (includes NUL terminator)
##     name_len bytes            (C string, Latin-1; all known names are ASCII)
##     u16 desc_len              (includes NUL terminator)
##     desc_len bytes            (C string, Latin-1)
##
## Trailing bytes after the room table belong to a picture record and are not
## parsed here; next_offset marks where they begin.
##
## Confirmed from Solaris.map (189312 bytes): 32 rooms — 6 sector meta-rooms
## (room_id 1–6) and 26 named locations.  Rooms end at offset 0x2126;
## trailing ~180 KB is the embedded map bitmap (proprietary format).
##
## flags field:
##   low byte  = district index: 0=IZ 1=Kobe 2=Silesia 3=Montenegro 4=Cathay 5=Black Hills
##   high byte = same value for IZ/Kobe/Silesia/Montenegro; Cathay↔Black Hills
##               swap (lore rivalry between House Liao and House Davion)
##
## Returns:
##   { ok: bool, error: String, rooms: Array[Dictionary], next_offset: int }
##   On partial failure, rooms contains records parsed before the error.

## Indexed by (flags & 0xFF): 0–5.
const DISTRICTS: Array[String] = [
	"International Zone", "Kobe", "Silesia", "Montenegro", "Cathay", "Black Hills",
]

## room_id values 1–6 are sector meta-rooms; 146–171 are named locations.
const SECTOR_IDS: Array[int] = [1, 2, 3, 4, 5, 6]


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
			"room_id":       file.get_16(),
			"flags":         file.get_16(),
		}
		room["x1"]      = file.get_16()
		room["y1"]      = file.get_16()
		room["x2"]      = file.get_16()  # always == x1
		room["y2"]      = file.get_16()  # always == y1
		room["x"]       = room["x1"]
		room["y"]       = room["y1"]
		room["label_w"] = file.get_16()  # aux0: pixel width of map label
		room["label_h"] = file.get_16()  # aux1: pixel height (15=single-line, 29=two-line)
		room["aux2"]    = file.get_16()  # always 0 in Solaris.map
		var dist_idx: int = room["flags"] & 0xFF
		room["district_index"] = dist_idx
		room["district_name"]  = DISTRICTS[dist_idx] if dist_idx < DISTRICTS.size() else ""
		room["is_sector"]      = room["room_id"] in SECTOR_IDS

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


## Extract terrain type from a sector room description, e.g.:
##   "The fixed arenas in Kobe use desert terrain." → "Desert"
##   "The fixed arenas in Cathay use temperate and tropical terrain." → "Temperate and Tropical"
##   Returns "" when no terrain is mentioned (International Zone).
static func terrain_from_description(desc: String) -> String:
	var idx := desc.find(" use ")
	if idx < 0:
		return ""
	var after := desc.substr(idx + 5)
	var end := after.find(" terrain")
	if end < 0:
		return ""
	var raw := after.substr(0, end).strip_edges()
	# Capitalise first letter only.
	if raw.length() > 0:
		raw = raw.substr(0, 1).to_upper() + raw.substr(1)
	return raw
