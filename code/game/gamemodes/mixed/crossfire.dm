/datum/game_mode/crossfire
	name = "Crossfire (Merc+Heist)"
	config_tag = "crossfire"
	required_players = 25
	required_enemies = 8
	antag_tags = list(MODE_RAIDER, MODE_MERCENARY)
	require_all_templates = 1

/datum/game_mode/crossfire/pre_setup()
	round_description = "Mercenaries and raiders are approaching the [SSatlas.current_map.station_type]."
	extended_round_description = "[SSatlas.current_map.company_short]'s wealth and success caught the attention of several enemies old and new,  \
		and many seek to undermine them using illegal ways. The SCC and their crown jewel research [SSatlas.current_map.station_type] is not safe from those \
		malicious activities."
	. = ..()
