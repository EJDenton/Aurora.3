/datum/build_mode/edit
	name = "Edit"
	icon_state = "buildmode3"
	permission_requirement = R_ADMIN
	var/var_to_edit = "name"
	var/value_to_set = "derp"

/datum/build_mode/edit/Destroy()
	ClearValue()
	. = ..()

/datum/build_mode/edit/Help()
	to_chat(user, SPAN_NOTICE("***********************************************************"))
	to_chat(user, SPAN_NOTICE("Right Click on Build Mode Button = Select var & value"))
	to_chat(user, SPAN_NOTICE("Left Click                       = Sets the var's value"))
	to_chat(user, SPAN_NOTICE("Right Click                      = Reset the var's value"))
	to_chat(user, SPAN_NOTICE("***********************************************************"))

/datum/build_mode/edit/Configurate()
	var/var_name = input("Enter variable name:", "Name", var_to_edit) as text|null
	if(!var_name)
		return

	var/thetype = input("Select variable type:", "Type") as null|anything in list("text","number","mob-reference","obj-reference","turf-reference")
	if(!thetype) return

	var/new_value
	switch(thetype)
		if("text")
			new_value = input(usr,"Enter variable value:" ,"Value", value_to_set) as text|null
		if("number")
			new_value = input(usr,"Enter variable value:" ,"Value", value_to_set) as num|null
		if("mob-reference")
			new_value = input(usr,"Enter variable value:" ,"Value", value_to_set) as null|mob in GLOB.mob_list
		if("obj-reference")
			new_value = input(usr,"Enter variable value:" ,"Value", value_to_set) as null|obj in world
		if("turf-reference")
			new_value = input(usr,"Enter variable value:" ,"Value", value_to_set) as null|turf in world

	if(var_name && new_value)
		var_to_edit = var_name
		SetValue(new_value)

/datum/build_mode/edit/OnClick(var/atom/A, var/list/parameters)
	if(var_to_edit in VVlocked)
		if(!check_rights(R_DEBUG))	return
	if(var_to_edit in VVckey_edit)
		if(!check_rights(R_DEBUG)) return
	if(var_to_edit in VVicon_edit_lock)
		if(!check_rights(R_FUN|R_DEBUG)) return
	if(!(var_to_edit in A.vars))
		to_chat(user, SPAN_WARNING("\The [A] does not have a var '[var_to_edit]'"))
		return

	var/old_value = A.vars[var_to_edit]
	var/new_value
	if(parameters["left"])
		new_value = value_to_set
	if(parameters["right"])
		new_value = initial(A.vars[var_to_edit])

	if(old_value == new_value)
		return
	A.vars[var_to_edit] = new_value
	to_chat(user, SPAN_NOTICE("Changed the value of [var_to_edit] from '[old_value]' to '[new_value]'."))
	Log("[log_info_line(A)] - [var_to_edit] - [old_value] -> [new_value]")

/datum/build_mode/edit/proc/SetValue(var/new_value)
	if(value_to_set == new_value)
		return
	ClearValue()
	value_to_set = new_value
	RegisterSignal(value_to_set, COMSIG_QDELETING, /datum/build_mode/edit/proc/ClearValue)

/datum/build_mode/edit/proc/ClearValue(var/feedback)
	if(!istype(value_to_set, /datum))
		return

	UnregisterSignal(value_to_set, COMSIG_QDELETING)
	value_to_set = initial(value_to_set)
	if(feedback)
		Warn("The selected reference value was deleted. Default value restored.")
