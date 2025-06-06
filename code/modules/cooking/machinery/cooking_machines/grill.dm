/obj/machinery/appliance/cooker/grill
	name = "grill"
	desc = "Backyard grilling, IN SPACE."
	icon_state = "grill_off"
	cook_type = "grilled"
	appliancetype = GRILL
	stat = POWEROFF
	food_color = "#a34719"
	on_icon = "grill_on"
	off_icon = "grill_off"
	finish_verb = "sizzles to completion!"
	cooked_sound = 'sound/effects/meatsizzle.ogg'
	min_temp = 100 + T0C
	optimal_temp = 150 + T0C
	temp_settings = 1
	max_contents = 1
	resistance = 500 // assuming it's a fired grill, it shouldn't take very long to heat

	idle_power_usage = 0
	active_power_usage = 0

	cooking_coeff = 0.3 // cook it nice and slow

	component_types = list(
		/obj/item/circuitboard/grill,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/micro_laser,
		/obj/item/stack/cable_coil = 5
	)

	starts_with = list(
		/obj/item/reagent_containers/cooking_container/grill_grate
	)

	var/datum/looping_sound/grill/grill_loop

/obj/machinery/appliance/cooker/grill/Initialize()
	. = ..()
	grill_loop = new(src)

/obj/machinery/appliance/cooker/grill/Destroy()
	QDEL_NULL(grill_loop)
	. = ..()

/obj/machinery/appliance/cooker/grill/RefreshParts()
	..()
	cooking_coeff = 0.3 // we will always cook nice and slow

/obj/machinery/appliance/cooker/grill/get_efficiency()
	return (temperature / optimal_temp) * 100

/obj/machinery/appliance/cooker/grill/activation_message(var/mob/user)
	user.visible_message("<b>[user]</b> [stat ? "turns off" : "fires up"] \the [src].", "You [stat ? "turn off" : "fire up"] \the [src].")

/obj/machinery/appliance/cooker/grill/has_space(var/obj/item/I)
	if(istype(I, /obj/item/reagent_containers/cooking_container))
		if(length(cooking_objs) < max_contents)
			return TRUE
	else
		if(length(cooking_objs))
			var/datum/cooking_item/CI = cooking_objs[1]
			var/obj/item/reagent_containers/cooking_container/grill_grate/G = CI.container
			if(G?.can_fit(I))
				return CI
	return FALSE

/// Grills do not require power to work.
/obj/machinery/appliance/cooker/grill/powered()
	return TRUE

/obj/machinery/appliance/cooker/grill/proc/update_grilling_audio()
	if(!grill_loop)
		return
	if(use_power)
		grill_loop.start()
	else
		grill_loop.stop()

/obj/machinery/appliance/cooker/grill/update_icon()
	ClearOverlays()
	update_grilling_audio()
	if(!stat)
		icon_state = on_icon
	else
		icon_state = off_icon
	if(length(cooking_objs))
		var/datum/cooking_item/CI = cooking_objs[1]
		var/obj/item/reagent_containers/cooking_container/grill_grate/G = CI.container
		if(G)
			AddOverlays(image('icons/obj/machinery/cooking_machines.dmi', "grill"))
			var/counter = 1
			for(var/thing in G.contents)
				if(istype(thing, /obj/item/reagent_containers/food/snacks/meat))
					var/image/food = overlay_image('icons/obj/machinery/cooking_machines.dmi', "meat")
					switch(counter)
						if(1)
							food.pixel_x -= 5
						if(3)
							food.pixel_x += 5
					var/matrix/M = matrix()
					M.Scale(0.5)
					food.transform = M
					AddOverlays(food)
				else if(istype(thing, /obj/item/reagent_containers/food/snacks/xenomeat))
					var/image/food = overlay_image('icons/obj/machinery/cooking_machines.dmi', "xenomeat")
					switch(counter)
						if(1)
							food.pixel_x -= 5
						if(3)
							food.pixel_x += 5
					var/matrix/M = matrix()
					M.Scale(0.5)
					food.transform = M
					AddOverlays(food)
				counter++
	..()

/obj/machinery/appliance/cooker/grill/stand
	name = "grill stand"
	icon_state = "grill_cart_off"
	on_icon = "grill_cart_on"
	off_icon = "grill_cart_off"
	desc = "A more commercialized version of your traditional grill. What happened to the good old days where people grilled with passion?"
	use_power = POWER_USE_OFF

/obj/machinery/appliance/cooker/grill/stand/update_icon()
	..()
	AddOverlays(image('icons/obj/machinery/cooking_machines.dmi', "front_bar"))
