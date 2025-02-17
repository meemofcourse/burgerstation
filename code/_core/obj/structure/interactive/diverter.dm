/obj/structure/interactive/diverter/
	name = "airjet diverter"
	desc = "Pssssh."
	desc_extended = "A special conveyor diverter that uses powerful jets of air to push objects off the conveyor belt based on the conditions."
	icon = 'icons/obj/structure/conveyor.dmi'
	icon_state = "diverter"

	collision_flags = FLAG_COLLISION_WALKING
	collision_bullet_flags = FLAG_COLLISION_BULLET_INORGANIC

	collision_dir = 0x0

	var/think_timer = 0

	var/list/atom/movable/tracked_movables = list()

	density = TRUE

/obj/structure/interactive/diverter/clicked_on_by_object(var/mob/caller,var/atom/object,location,control,params)

	INTERACT_CHECK
	INTERACT_CHECK_OBJECT
	INTERACT_DELAY(5)

	if(istype(object,/obj/item))
		var/obj/item/T = object
		if(T.flags_tool & FLAG_TOOL_WRENCH)
			if(anchored)
				caller.to_chat(span("notice","You un-anchor the diverter."))
				anchored = FALSE
			else
				caller.to_chat(span("notice","You anchor the diverter."))
				anchored = TRUE
	else
		caller.visible_message(span("notice","\The [caller.name] rotates \the [src.name]."),span("notice","You rotate \the [src.name]."))
		set_dir(turn(dir,90))

		update_sprite()

	return TRUE

/obj/structure/interactive/diverter/Initialize()

	if(.)
		collision_dir = turn(dir,180)

	return ..()

/obj/structure/interactive/diverter/PostInitialize()
	. = ..()
	update_sprite()

/obj/structure/interactive/diverter/update_icon()
	. = ..()
	icon_state = "diverter_on"

/obj/structure/interactive/diverter/proc/should_push(var/atom/movable/M)
	return anchored

/obj/structure/interactive/diverter/think()

	for(var/k in tracked_movables)
		var/v = tracked_movables[k]
		if(v > world.time)
			continue
		var/atom/movable/M = k
		if(!M.anchored && !M.grabbing_hand && should_push(M) && M.loc == src.loc)
			M.Move(get_step(src,dir))
		tracked_movables -= k

	think_timer--

	return think_timer

/obj/structure/interactive/diverter/Crossed(atom/movable/O,atom/OldLoc)

	tracked_movables[O] = world.time + 4

	if(!think_timer)
		START_THINKING(src)

	think_timer = 10

	return ..()


/obj/structure/interactive/diverter/high_value
	name = "airjet diverter (high value)"
	desc_extended = "A special conveyor diverter that uses powerful jets of air to push objects off the conveyor belt based on the conditions. This one scans the value of the object and pushes it if it exceeds a certain amount."
	var/value_threshold = 50

/obj/structure/interactive/diverter/high_value/should_push(var/atom/movable/M)
	if(is_item(M))
		var/obj/item/I = M
		return I.get_value() >= value_threshold

	return FALSE


/obj/structure/interactive/diverter/density
	name = "airjet diverter (density)"
	desc_extended = "A special conveyor diverter that uses powerful jets of air to push objects off the conveyor belt based on the conditions. This one measures the density of the object."

/obj/structure/interactive/diverter/density/should_push(var/atom/movable/M)
	return M.density && M.collision_flags != FLAG_COLLISION_NONE

/obj/structure/interactive/diverter/material
	name = "airjet diverter (material)"
	desc_extended = "A special conveyor diverter that uses powerful jets of air to push objects off the conveyor belt based on the conditions. This one checks whether or not the object is a raw material."

/obj/structure/interactive/diverter/material/should_push(var/atom/movable/M)
	return istype(M,/obj/item/material/) && !istype(M,/obj/item/material/shard)


/obj/structure/interactive/diverter/living
	name = "airjet diverter (living)"
	desc_extended = "A special conveyor diverter that uses powerful jets of air to push objects off the conveyor belt based on the conditions. This one checks whether or not the object is a living person or a creature, or is able to be revived."

/obj/structure/interactive/diverter/living/should_push(var/atom/movable/M)

	if(is_living(M))
		var/mob/living/L = M
		if(!L.dead || L.ckey_last)
			return TRUE

	return FALSE



/obj/structure/interactive/diverter/weapon
	name = "airjet diverter (weapon)"
	desc_extended = "A special conveyor diverter that uses powerful jets of air to push objects off the conveyor belt based on the conditions. This one checks if it's a weapon."

/obj/structure/interactive/diverter/weapon/should_push(var/atom/movable/M)
	return istype(M,/obj/item/weapon)

/obj/structure/interactive/diverter/butcherable
	name = "airjet diverter (butcherable)"
	desc_extended = "A special conveyor diverter that uses powerful jets of air to push objects off the conveyor belt based on the conditions. This one checks whether or not the object can be butchered for food."

/obj/structure/interactive/diverter/butcherable/should_push(var/atom/movable/M)

	if(is_living(M))
		var/mob/living/L = M
		if(L.override_butcher || length(L.butcher_contents))
			return TRUE

	return FALSE

/obj/structure/interactive/diverter/crate
	name = "airjet diverter (crate)"
	desc_extended = "A special conveyor diverter that uses powerful jets of air to push objects off the conveyor belt based on the conditions. This one checks if it's a crate."

/obj/structure/interactive/diverter/crate/should_push(var/atom/movable/M)
	return istype(M,/obj/structure/interactive/crate)
