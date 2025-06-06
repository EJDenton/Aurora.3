/*
	Badges are worn on the belt or neck, and can be used to show that the holder is an authorized
	Security agent - the user details can be imprinted on holobadges with a Security-access ID card,
	or they can be emagged to accept any ID for use in disguises.
*/

/obj/item/clothing/accessory/badge
	name = "badge"
	desc = "A corporate security badge, made from gold and set on false leather."
	icon_state = "badge"
	item_state = "marshalbadge"
	overlay_state = "marshalbadge"
	slot_flags = SLOT_BELT | SLOT_TIE

	var/stored_name
	var/badge_string = "Corporate Security"
	var/v_flippable = 1

	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/clothing/accessory/badge/press
	name = "corporate press pass"
	desc = "A corporate reporter's pass, emblazoned with the SCC logo."
	icon_state = "pressbadge"
	item_state = "pbadge"
	overlay_state = "pbadge"
	badge_string = "Corporate Reporter"
	w_class = WEIGHT_CLASS_TINY

	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'

/obj/item/clothing/accessory/badge/press/independent
	name = "press pass"
	desc = "A freelance journalist's pass."
	icon_state = "pressbadge-i"
	badge_string = "Freelance Journalist"

/obj/item/clothing/accessory/badge/press/plastic
	name = "plastic press pass"
	desc = "A journalist's 'pass' shaped, for whatever reason, like a security badge. It is made of plastic."
	icon_state = "pbadge"
	badge_string = "Sicurity Journelist"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/accessory/badge/old
	name = "faded badge"
	desc = "A faded security badge, backed with leather."
	icon_state = "badge_round"
	overlay_state = "badge_round"

/obj/item/clothing/accessory/badge/proc/set_name(var/new_name)
	stored_name = new_name
	desc += "\nThe name [stored_name] is written on it."

/obj/item/clothing/accessory/badge/attack_self(mob/user as mob)

	if(!stored_name)
		var/imprintID = alert(user,"Do you wish to imprint your name on \the [src.name]?","Imprint id","Yes", "No")
		if(imprintID == "Yes")
			to_chat(user, "You inspect your [src.name]. Everything seems to be in order and you give it a quick cleaning with your hand.")
			set_name(user.real_name)
		return

	if(isliving(user))
		if(badge_string)
			if(stored_name)
				user.visible_message(SPAN_NOTICE("[user] displays their [src.name].\nIt reads: [stored_name], [badge_string]."),
										SPAN_NOTICE("You display your [src.name].\nIt reads: [stored_name], [badge_string]."))
			else
				user.visible_message(SPAN_NOTICE("[user] displays their [src.name].\nIt reads: [badge_string]."),
										SPAN_NOTICE("You display your [src.name]. It reads: [badge_string]."))
		else
			if(stored_name)
				user.visible_message(SPAN_NOTICE("[user] displays their [src.name].\nIt reads: [stored_name]."),
										SPAN_NOTICE("You display your [src.name].\nIt reads: [stored_name]."))
			else
				user.visible_message(SPAN_NOTICE("[user] displays their [src.name]."),
										SPAN_NOTICE("You display your [src.name]."))

/obj/item/clothing/accessory/badge/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(isliving(user))
		user.visible_message(SPAN_DANGER("[user] invades [target_mob]'s personal space, thrusting [src] into their face insistently."),
								SPAN_DANGER("You invade [target_mob]'s personal space, thrusting [src] into their face insistently."))

/obj/item/clothing/accessory/badge/verb/flip_side()
	set category = "Object"
	set name = "Flip badge"
	set src in usr

	if (use_check_and_message(usr))
		return
	if (!v_flippable)
		to_chat(usr, "You cannot flip \the [src] as it is not a flippable item.")
		return

	src.flipped = !src.flipped
	if(src.flipped)
		if(!overlay_state)
			src.icon_state = "[icon_state]_flip"
		else
			src.overlay_state = "[overlay_state]_flip"
	else
		if(!overlay_state)
			src.icon_state = initial(icon_state)
		else
			src.overlay_state = initial(overlay_state)
	to_chat(usr, "You change \the [src] to be on your [src.flipped ? "right" : "left"] side.")
	update_clothing_icon()
	src.inv_overlay = null
	src.accessory_mob_overlay = null

//.Holobadges.
/obj/item/clothing/accessory/badge/holo
	name = "holobadge"
	desc = "This glowing blue badge marks the holder as a member of corporate security."
	icon_state = "holobadge"
	item_state = "holobadge"
	overlay_state = "holobadge"
	var/emagged //Emagging removes Sec check.

/obj/item/clothing/accessory/badge/holo/cord
	icon_state = "holobadge-cord"
	overlay_state = null
	slot_flags = SLOT_MASK | SLOT_TIE

	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/clothing/accessory/badge/holo/cord/get_mask_examine_text(mob/user)
	return "around [user.get_pronoun("his")] neck"

/obj/item/clothing/accessory/badge/holo/attack_self(mob/user as mob)
	if(!stored_name)
		to_chat(user, "Waving around a holobadge before swiping an ID would be pretty pointless.")
		return
	return ..()

/obj/item/clothing/accessory/badge/holo/emag_act(var/remaining_charges, var/mob/user)
	if (emagged)
		to_chat(user, SPAN_DANGER("\The [src] is already cracked."))
		return
	else
		emagged = 1
		to_chat(user, SPAN_DANGER("You crack the holobadge security checks."))
		return 1

/obj/item/clothing/accessory/badge/holo/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.GetID())

		var/obj/item/card/id/id_card = attacking_item.GetID()

		if(!istype(id_card))
			return

		if((ACCESS_SECURITY in id_card.access) || emagged)
			to_chat(user, "You imprint your ID details onto the badge.")
			set_name(user.real_name)
		else
			to_chat(user, "[src] rejects your insufficient access rights.")
		return
	..()

/obj/item/clothing/accessory/badge/officer
	name = "security officer's badge"
	desc = "A bronze security badge."
	icon_state = "bronzebadge"
	overlay_state = "bronzebadge"
	slot_flags = SLOT_TIE

/obj/item/clothing/accessory/badge/warden
	name = "warden's badge"
	desc = "A silver security badge."
	icon_state = "silverbadge"
	overlay_state = "silverbadge"
	slot_flags = SLOT_TIE

/obj/item/clothing/accessory/badge/hos
	name = "head of security's badge"
	desc = "An immaculately polished gold security badge."
	icon_state = "goldbadge"
	overlay_state = "goldbadge"
	slot_flags = SLOT_TIE

/obj/item/clothing/accessory/badge/bssb
	name = "\improper BSSB agent's badge"
	desc = "A silver badge, set in purple leather, denoting the wearer as an agent of the Biesel Security Services Bureau."
	desc_extended = "The overseeing authority of the domestic agencies that operate within the Republic of Biesel. In reality, the Biesel Security Services Bureau has become incredibly important to the enforcement of the Republic's laws. The BSSB was founded with the goal of monitoring the planetary policing forces within the Republic of Biesel and stepping in when needed. Most of the BSSB was sponsored by NanoTrasen, with even its headquarters having been constructed by the megacorporation. The agency quickly found its footing within the Republic and found itself being labelled as Biesel's most skilled law enforcement agency despite the accusation of bribery on behalf of NanoTrasen. Today, the BSSB has become an easily recognisable organization with several action movies and novels produced within the Republic of Biesel making it a centrepiece of the Republic's image. It is headed by Director Clarrise Lyon."
	icon_state = "badge_round_bssb"
	overlay_state = "badge_round_bssb"
	slot_flags = SLOT_TIE
	contained_sprite = TRUE
	icon = 'icons/obj/item/clothing/accessory/bssb_badge.dmi'

/obj/item/clothing/accessory/badge/bssb/senior
	name = "\improper BSSB senior agent's badge"
	desc = "A golden badge, set in purple leather, denoting the wearer as a senior agent of the Biesel Security Services Bureau."
	icon_state = "badge_round_bssb_sen"
	overlay_state = "badge_round_bssb_sen"

/obj/item/clothing/accessory/badge/sol_visa
	name = "\improper ASSN visa recommendation slip"
	desc = "A compact piece of legal paperwork that can replace the enormous amounts of documents required to obtain a Sol Alliance visa."
	icon_state = "sol-visa"
	overlay_state = "sol-visa"
	slot_flags = SLOT_TIE
	badge_string = "Priority ASSN Visa Applicant"

	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'

/obj/item/clothing/accessory/badge/tcaf_papers
	name = "\improper TCAF enlistment"
	desc = "A compact piece of legal paperwork, making one an official recruit of the Tau Ceti Armed Forces. Go Biesel!"
	icon_state = "tc-visa"
	overlay_state = "tc-visa"
	slot_flags = SLOT_TIE
	badge_string = "Tau Ceti Armed Forces Recruit"

	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'

/obj/item/clothing/accessory/badge/tcaf_papers/service
	name = "\improper TCAF service card"
	desc = "A small card identifying one as a current member of the Tau Ceti Armed Forces. Often used to secure discounts in \
	Republic shops. Go Biesel!"
	badge_string = "Tau Ceti Armed Forces Service Member"

/obj/item/clothing/accessory/badge/tcaf_papers/service/veteran
	name = "\improper TCAF veteran's service card"
	desc = "A small card identifying one as a former member of the Tau Ceti Armed Forces. Often used to secure discounts in \
	Republic shops. Go Biesel!"
	badge_string = "Tau Ceti Armed Forces Veteran"

/obj/item/clothing/accessory/badge/tcaf_papers/service/reservist
	name = "\improper TCAF reservist's service card"
	desc = "A small card identifying one as a current reservist of the Tau Ceti Armed Forces. Often used to secure discounts in \
	Republic shops. Go Biesel!"
	badge_string = "Tau Ceti Armed Forces Reservist"

/obj/item/clothing/accessory/badge/sheriff
	name = "sheriff badge"
	desc = "A star-shaped brass badge denoting who the law is around these parts."
	icon_state = "sheriff"
	overlay_state = "sheriff"
	badge_string = "County Sheriff"

/obj/item/clothing/accessory/badge/marshal
	name = "marshal badge"
	desc = "A hefty gold-plated badge which tells you who's in charge."
	icon_state = "marshalbadge"
	badge_string = "Federal Marshal"

/obj/item/clothing/accessory/badge/investigator
	name = "\improper investigator badge"
	desc = "This badge marks the holder as an investigative agent."
	icon_state = "invbadge"
	overlay_state = "invbadge"
	badge_string = "Corporate Investigator"

/obj/item/clothing/accessory/badge/idbadge
	name = "\improper ID badge"
	desc = "A descriptive identification badge with the holder's credentials."
	icon_state = "solbadge"
	overlay_state = "solbadge"
	badge_string = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/clothing/accessory/badge/idbadge/nt
	name = "\improper NT ID badge"
	desc = "A descriptive identification badge with the holder's credentials. This one has red marks with the NanoTrasen logo on it."
	icon_state = "ntbadge"
	overlay_state = "ntbadge"
	badge_string = null

/obj/item/clothing/accessory/badge/idbadge/intel
	name = "electronic ID badge"
	desc = "A descriptive identification badge with the holder's credentials displayed with a harsh digital glow."
	icon_state = "intelbadge"
	overlay_state = "intelbadge"
	badge_string = null

/obj/item/clothing/accessory/badge/trinary
	name = "trinary perfection brooch"
	desc = "A metal brooch worn by those who serve or follow the beliefs of the Trinary Perfection. It resembles a gear with a triangle inside."
	icon_state = "trinary_badge"
	overlay_state = "trinary_badge"
	badge_string = null

// passcards

/obj/item/clothing/accessory/badge/passcard
	name = "republic of biesel passcard"
	desc = "A passcard issued to citizens of the Republic of Biesel, typically from planets in Biesel proper and smaller territories."
	desc_extended = "A passcard is a modern evolution of the state-issued identification card, with all the functionality of a driver's license, birth certificate, passport, or other document, \
	updated as necessary or able by a central government. The concept was pioneered in the early days of the Sol Alliance, and continues in most human stellar nations to this day, owing to the availability \
	and price of consumer plastics and self-powered microholograms."
	icon = 'icons/obj/item/clothing/accessory/passcards.dmi'
	icon_state = "passcard_ceti"
	item_state = "passcard_ceti"
	contained_sprite = TRUE
	slot_flags = null
	w_class = WEIGHT_CLASS_TINY
	flippable = FALSE
	v_flippable = FALSE
	badge_string = null

	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'

/obj/item/clothing/accessory/badge/passcard/synthetic
	name = "synthetic residence card"
	desc = "A passcard issued to free IPCs within the Republic of Biesel, providing resident status and allowing the owning of property, among other things."
	desc_extended = "Working alongside IPC tags within the Republic of Biesel, the synthetic residence card has a small RFID chip embedded in it which allows governmental authorities to confirm whether or not an IPC \
	is free and taking residency within the system. They were recently introduced in order to provide streamlined documentation for IPCs that have attained freedom but are not citizens."
	icon_state = "passcard_ceti_m"
	item_state = "passcard_ceti_m"

/obj/item/clothing/accessory/badge/passcard/sol
	name = "\improper ASSN passcard"
	desc = "A passcard issued to citizens of the Alliance of Sovereign Solarian Nations, typically from planets such as the Jewel Worlds or smaller zones of authority."
	desc_extended = "A passcard is a modern evolution of the state-issued identification card, with all the functionality of a driver's license, birth certificate, passport, or other document, \
	updated as necessary or able by a central government. The concept was pioneered in the early days of the Sol Alliance, and continues in most human stellar nations to this day, owing to the availability \
	and price of consumer plastics and self-powered microholograms."
	icon_state = "passcard_sol"
	item_state = "passcard_sol"

/obj/item/clothing/accessory/badge/passcard/sol/pluto
	name = "plutonian passcard"
	desc = "A passcard issued to citizens of the Solarian planetoid, Pluto."
	desc_extended = "Plutonian passcards, in addition to the features of their cousins in the greater Sol Alliance, include details such as Party membership and occupation, available for viewing by personnel \
	with the appropriate scanning measures."
	icon_state = "passcard_pluto"
	item_state = "passcard_pluto"

/obj/item/clothing/accessory/badge/passcard/sol/jupiter
	name = "jovian passcard"
	desc = "A passcard issued to citizens of Sol Alliance, hailing from Jupiter or its moons."
	desc_extended = "Due to its status as a trading hub for the Jewel Worlds of the Sol system, Jovian Solarians are among the most populous type to exist outside Earth proper, numbering in the billions. \
	Originally given out as a celebration of fifty years of Jovian settlement, these passcards have since been introduced as a display of pride in their mutual orbit."
	icon_state = "passcard_jovian"
	item_state = "passcard_jovian"

/obj/item/clothing/accessory/badge/passcard/sol/europa
	name = "europan passcard"
	desc = "A passcard issued to citizens of the Alliance of Sovereign Solarian Nations, hailing from the murky Jovian moon of Europa."
	desc_extended = "The Europan passcard, boasting a difficult-to-align identification strip, fragile materials, and an unfortunate resemblance to the ZHS Abaddon research vessel legendary for its supposed \
	loss to the Cetus, is almost universally reviled by Europans, border agents, and choking sea creatures alike. To carry one aboard a submarine is said to bring bad luck so foul as to serve as a beacon \
	to the darkest forces known to sailors."
	icon_state = "passcard_europa"
	item_state = "passcard_europa"

/obj/item/clothing/accessory/badge/passcard/sol/cytherean
	name = "cytherean passcard"
	desc = "A passcard issued to citizens of the Alliance of Sovereign Solarian Nations from the Cytherean Venusian cloud-cities."
	desc_extended = "The luxuriant Cytherean lifestyle is represented no better than in its identification cards; gaudy, with built-in neon flashing lights and doubling as a business card. The font is infamous for \
	its illegibility."
	icon_state = "passcard_cytherean"
	item_state = "passcard_cytherean"

/obj/item/clothing/accessory/badge/passcard/sol/jintarian
	name = "jintarian passcard"
	desc = "A... 'passcard' manufactured by a Venusian living on the surface of their hostile Solarian world."
	desc_extended = "In sharp contrast to the passcards wielded in the skies of their world, the common Jintarian passcard is a cobbled-together mess of a stolen corporate identification card with an ID-strip \
	duct taped to the edge. Traditionally worn by free-runners on the back of their clothing, so that the people in their dust may know who it was that just outpaced them."
	icon_state = "passcard_jintarian"
	item_state = "passcard_jintarian"

/obj/item/clothing/accessory/badge/passcard/sol/silversun
	name = "silversun commemorative passcard"
	desc = "A passcard issued to Idris employees currently or formerly employed or residing on the planet Silversun."
	desc_extended = "While Silversun itself is a member of the Sol Alliance, Idris Incorporated has secured a number of obscure patents, permits, and bureaucratic channels that allows them to commemorate \
	faithful employees from the resort world with unique passcards that double as membership cards to some of the cheaper resorts on-world."
	icon_state = "passcard_silversun"
	item_state = "passcard_silversun"

/obj/item/clothing/accessory/badge/passcard/sol/luna
	name = "lunarian passcard"
	desc = "A passcard issued to Solarian citizens from the moon of Earth, Luna."
	desc_extended = "Not only does the Lunarian passcard bring power, prestige, and a heritage of grace; it also brings an invitation to almost every high society open gathering on the planet, and earns priority \
	in most reservations for the world's restaurants. If ever there was a silver spoon, it sits here."
	icon_state = "passcard_moon"
	item_state = "passcard_moon"

/obj/item/clothing/accessory/badge/passcard/sol/visegrad
	name = "visegradi passcard"
	desc = "A passcard issued to Solarian citizens from the outer ring planet Visegrad."
	desc_extended = "The Visegradi passcard is an unusual thing, as many Solarian outer ring planets did not issue passcards at all, especially high-quality holographic ones. Predominantly seen in the hands of the \
	urban population who could justify paying the government fee to acquire one, their manufacture is still undertaken by the Southern Solarian Military District that now controls Visegrad."
	icon_state = "passcard_visegrad"
	item_state = "passcard_visegrad"

/obj/item/clothing/accessory/badge/passcard/eridani
	name = "eridani passcard"
	desc = "A holographic passcard issued to residents of the Free Economic Zone of Epsilon Eridani."
	desc_extended = "Known with a number of unfavorable acronyms across the Republic, Eridani passcards tend to include unhelpful details such as credit score, personal debts, and insurance providers to those \
	equipped with the right equipment. Infamous across the Orion Spur for being the most sought-after passcards for counterfeiting."
	icon_state = "passcard_eridani"
	item_state = "passcard_eridani"

/obj/item/clothing/accessory/badge/passcard/elyra
	name = "elyran passcard"
	desc = "A passcard issued to citizens of the Serene Republic of Elyra."
	desc_extended = "Much like synthetics manufactured in the Serene Republic, Elyran passcards include high-grade anti-counterfeiting through a wafer of borosilicate reinforced with a randomly-chosen alloy. \
	Unlike other nations, however, Elyra allows for heavy personal customization of their passcards, with some of the most expensive government contractors offering brief musical messages or integration with \
	jewelry such as a bracelet or necklace."
	icon_state = "passcard_elyra"
	item_state = "passcard_elyra"

/obj/item/clothing/accessory/badge/passcard/dominia
	name = "dominian passcard"
	desc = "A passcard issued to citizens of the Empire of Dominia."
	desc_extended = "Dominian passcards, aside from the usual information, also include details such as one's House, their remaining Mo'ri'zal debt, their status as an Edict Breaker, or- most uniquely- their most recent \
	testing for status as a synthetic infiltrator."
	icon_state = "passcard_dominia"
	item_state = "passcard_dominia"

/obj/item/clothing/accessory/badge/passcard/coalition
	name = "coalition passcard"
	desc = "A passcard issued to a citizen of the Coalition of Colonies, typically from worlds like Xanu Prime or the 'wilder' frontier-ward planets lacking in strong central government."
	desc_extended = "Due to its terse relations with the Sol Alliance, the Coalition of Colonies has likewise refused to make their passcard software compatible with Alliance verification technology as a \
	whole. Those travelling from the Coalition to Sol space, for whatever reason, are thus likely to carry paper copies of their identity paperwork with them."
	icon_state = "passcard_coc"
	item_state = "passcard_coc"

/obj/item/clothing/accessory/badge/passcard/himeo
	name = "himean passcard"
	desc = "A passcard issued to a citizen of the planet Himeo."
	desc_extended = "Himean passcards are descended from a series of modifications made to the original design, meant to show the user had membership in a worker's syndicate without arousing suspicion from \
	overseers with paper union cards. These 'defaced' Solarian passcards often find their way into planetary museums, or private collections."
	icon_state = "passcard_himeo"
	item_state = "passcard_himeo"

/obj/item/clothing/accessory/badge/passcard/gad
	name = "gadpathurian passcard"
	desc = "A passcard issued to an active member of a Gadpathurian cadre."
	desc_extended = "While identification tabs remain the de facto proof of a Gadpathurian's pride to their cadre and nation, more recent innovations in identification-locked facilities and equipment have demanded \
	a temporary solution to the low-technology tabs until widespread reform can be made to their manufacturing. As such, Gadpathurian passcards are developed from the ground-up, and are notorious for including \
	hostile electronics that overheat Solarian examination equipment and can be easily destroyed in the event of capture."
	icon_state = "passcard_gad"
	item_state = "passcard_gad"

/obj/item/clothing/accessory/badge/passcard/vysoka
	name = "vysokan passcard"
	desc = "A passcard issued to a citizen of the planet Vysoka."
	desc_extended = "Vysokan passcards often include metals and plastics derived from the place of origin for their recipient, and may make small aesthetic changes to reflect family traditions. They are often \
	objects of incredible sentimental value to their bearer."
	icon_state = "passcard_vysoka"
	item_state = "passcard_vysoka"

/obj/item/clothing/accessory/badge/passcard/assu
	name = "assunzionii passcard"
	desc = "A passcard issued to a citizen of the planet Assunzione."
	desc_extended = "Assunzionii passcards, while unable to provide the same light as a warding sphere, are known for having light-absorbing compounds in their assembly, and thus glow in the dark for easy reading."
	icon_state = "passcard_assu"
	item_state = "passcard_assu"

/obj/item/clothing/accessory/badge/passcard/scarab
	name = "scarab passblade"
	desc = "A dagger issued as a writ of passage to Scarabs abroad."
	desc_extended = "By Scarab traditions, one should show their weapon to non-Scarabs upon first meeting. This dagger, sheathed in hakhma chitin, is often given to noncombatants, the Released, or the young, so they \
	may meet with outsiders with at least a blade between them. Despite this, the blade is sealed tightly within the scabbard."
	icon = 'icons/obj/item/clothing/accessory/offworlder.dmi'
	icon_state = "passblade_scarab"
	item_state = "passblade_scarab"
	worn_overlay = "over"
	contained_sprite = TRUE
	build_from_parts = TRUE
	slot_flags = SLOT_HOLSTER
	w_class = WEIGHT_CLASS_SMALL

	drop_sound = 'sound/items/drop/metalweapon.ogg'
	pickup_sound = 'sound/items/pickup/metalweapon.ogg'

/obj/item/clothing/accessory/badge/passcard/burzsia
	name = "burzsian passcard"
	desc = "A passcard issued to Burzsian Hephaestus employees and- owned IPCs- working abroad."
	desc_extended = "Despite protest from the Himean representatives in government, Hephaestus Industries- citing their 'Home is where the Hephaestus is' initiative- is permitted to issue up to five thousand \
	sponsored passcards to participating employees on a yearly basis, both to remind them of their home and to save on imported labor costs."
	icon_state = "passcard_burs"
	item_state = "passcard_burs"

/obj/item/clothing/accessory/badge/passcard/konyang
	name = "konyanger passcard"
	desc = "A passcard issued to residents of the planet Konyang."
	desc_extended = "The 'homeworld' of the human positronic intelligence, life on Konyang is a tightly-knit tapestry of organic-synthetic relations. The planet's unique conditions are reflected by a small piece of preserved moss stored in the card's plastic casing."
	icon_state = "passcard_konyang"
	item_state = "passcard_konyang"

/obj/item/clothing/accessory/badge/passcard/hegemony
	name = "hegemony passcard"
	desc = "A passcard issued to citizens of the Izweski Hegemony."
	desc_extended = "As the feudal citizenship standards of the Hegemony have changed to deal with the realities of an interstellar empire, human-inspired passcards have become a quick and easy method of identification for Unathi travelling abroad. This passcard is the most common design, seen throughout Hegemony space."
	icon_state = "passcard_hegemony"
	item_state = "passcard_hegemony"

/obj/item/clothing/accessory/badge/passcard/ouerea
	name = "ouerean passcard"
	desc = "A passcard issued to residents of the planet Ouerea."
	desc_extended = "Though not a fully independent state, the people of Ouerea have managed to win a great deal of autonomy from the Izweski Hegemony, which is reflected in the passcards that citizens of the Confederation carry."
	icon_state = "passcard_ouerea"
	item_state = "passcard_ouerea"

/obj/item/clothing/accessory/badge/passcard/tret
	name = "tret passcard"
	desc = "A passcard issued to residents of the planet Tret."
	desc_extended = "In recognition of the K'lax Hive's unique status and needs, the Hegemony has issued custom passcards for the planet Tret, for easy identification of K'laxan Vaurcae abroad. Many K'lax do not carry these, though those working in the Hegemony are likely to."
	icon_state = "passcard_tret"
	item_state = "passcard_tret"

// Work Visa
/obj/item/clothing/accessory/badge/passcard/workvisa
	name = "republic of biesel work visa"
	desc = "A work visa issued to those who work in the Republic of Biesel, but who do not have a Biesellite citizenship."
	desc_extended = "A work visa is required in the Republic of Biesel for those who do not have a Biesellite citizenship and who intend to hold legal employment. Those who most commonly lack a Biesellite citizenship \
	are those from the Alliance of Sovereign Solarian Nations, as the ASSN does not permit dual citizenships in combination with a Biesellite citizenship. Other individuals that may have a Republic of Biesel work \
	visa are those who intend to become citizens but have not yet resided for two years in order to apply for citizenship, or those who have not yet applied for a citizenship."
	icon_state = "workvisa"
	item_state = "workvisa"

//passports

#define CANT_OPEN -1
#define CLOSED 0
#define OPEN 1

/obj/item/clothing/accessory/badge/passport
	name = "biesellite passport"
	desc = "A passport issued to a citizen of the Republic of Biesel."
	icon = 'icons/obj/item/clothing/accessory/passcards.dmi'
	icon_state = "passport_ceti"
	item_state = "passport_ceti"
	contained_sprite = TRUE
	slot_flags = null
	w_class = WEIGHT_CLASS_TINY
	flippable = FALSE
	v_flippable = FALSE
	badge_string = null

	var/open = CANT_OPEN

	drop_sound = 'sound/items/drop/cloth.ogg'

	pickup_sound = 'sound/items/pickup/cloth.ogg'

/obj/item/clothing/accessory/badge/passport/Initialize()
	. = ..()
	if(open != CANT_OPEN)
		verbs += /obj/item/clothing/accessory/badge/passport/proc/open_passport

/obj/item/clothing/accessory/badge/passport/proc/open_passport()
	set name = "Open/Close Passport"
	set src in usr

	open = !open
	to_chat(usr, SPAN_NOTICE("You [open ? "open" : "close"] \the [src]."))
	update_icon()

/obj/item/clothing/accessory/badge/passport/update_icon()
	if(open != CANT_OPEN)
		icon_state = "[initial(icon_state)][open ? "_o" : ""]"

/obj/item/clothing/accessory/badge/passport/sol
	name = "solarian passport"
	desc = "A passport issued to a citizen of the Alliance of Sovereign Solarian Nations, or Sol Alliance. An outdated document for passage abroad."
	icon_state = "passport_sol"
	item_state = "passport_sol"

/obj/item/clothing/accessory/badge/passport/coc
	name = "coalition passport"
	desc = "A passport issued to a citizen of the Coalition of Colonies, typically from worlds like Xanu Prime or the 'wilder' frontier-ward planets lacking in strong central government."
	icon_state = "passport_coc"
	item_state = "passport_coc"

/obj/item/clothing/accessory/badge/passport/elyra
	name = "elyran passport"
	desc = "A passport issued to a citizen of the Serene Republic of Elyra. Vintage!"
	icon_state = "passport_elyra"
	item_state = "passport_elyra"

/obj/item/clothing/accessory/badge/passport/dominia
	name = "dominian passport"
	desc = "A passport issued to a resident of the Empire of Dominia. Popular among those whose debt is great but pockets light."
	icon_state = "passport_dominia"
	item_state = "passport_dominia"

/obj/item/clothing/accessory/badge/passport/nralakk
	name = "nralakk federation passport"
	desc = "A passport issued to citizens of the Nralakk Federation. Shiny, and compact, it's perfect to use on the go."
	icon_state = "passport_nralakk"
	item_state = "passport_nralakk"
	open = CLOSED
	var/compat_index = 5
	var/species_tag = ""

/obj/item/clothing/accessory/badge/passport/nralakk/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. +=  SPAN_NOTICE("The passport displays the owner's social compatibility index as: [compat_index].")

/obj/item/clothing/accessory/badge/passport/nralakk/update_icon()
	icon_state = "[initial(icon_state)][open ? "_o[species_tag]" : ""]"

/obj/item/clothing/accessory/badge/passport/hegemony
	name = "hegemony passport"
	desc = "A passport issued to a citizen of the Izweski Hegemony."
	icon_state = "passport_hegemony"
	item_state = "passport_hegemony"

/obj/item/clothing/accessory/badge/passport/goldendeep
	name = "golden deep passport"
	desc = "An electronic passport issued to a member of the Golden Deep Collective. This device lists and updates the owner's net worth in real time."
	icon_state = "passport_goldendeep"
	item_state = "passport_goldendeep"

/obj/item/clothing/accessory/badge/passport/consortium
	name = "consortium of hieroaetheria passport"
	desc = "A passport issued to a citizen of the Consortium of Hieroaetheria. A testament to inclusiveness anywhere its owner takes with it."
	icon_state = "passport_consortium"
	item_state = "passport_consortium"

/obj/item/clothing/accessory/badge/passport/dionaunion
	name = "union of gla'orr passport"
	desc = "A passport issued to a citizen of the Union of Gla'orr. Considered somewhat of an opposite of the Consortium passport in terms of what travel it enables."
	icon_state = "passport_dionaunion"
	item_state = "passport_dionaunion"

/obj/item/clothing/accessory/badge/passport/eternalrepublic
	name = "eternal republic of the ekane passport"
	desc = "A passport issued to a citizen of the Eternal Republic of the Ekane, a mark of having committed oneself to the Eternal wholly."
	icon_state = "passport_eternalrepublic"
	item_state = "passport_eternalrepublic"

#undef CANT_OPEN
#undef CLOSED
#undef OPEN
