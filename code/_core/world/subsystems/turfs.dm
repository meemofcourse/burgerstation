

SUBSYSTEM_DEF(turfs)
	name = "Turfs Subsystem"
	desc = "Initialize Turfs after they are made."
	priority = SS_ORDER_TURFS
	tick_rate = DECISECONDS_TO_TICKS(1)

	var/list/queued_edges = list()
	var/list/wet_turfs = list()

	cpu_usage_max = 50
	tick_usage_max = 50

	var/list/seeds = list() //id = value

/subsystem/turfs/unclog(var/mob/caller)

	for(var/k in wet_turfs)
		wet_turfs -= k

	for(var/k in queued_edges)
		queued_edges -= k

	broadcast_to_clients(span("danger","Removed all wet turfs and queued edges."))

	return ..()

/subsystem/turfs/Initialize()

	set background = 1 //Needed because it thinks it's doing an infinite loop.

	for(var/i=1,i<=10,i++) //Generate 10 seeds.
		seeds += rand(1,99999)

	var/found_turfs = 0
	var/turf_generation_count = 0
	var/object_generation_count = 0

	for(var/turf/simulated/T in world)
		sleep(-1)
		T.world_spawn = TRUE
		found_turfs++

	log_subsystem(name,"Found [found_turfs] simulated turfs.")

	for(var/turf/unsimulated/generation/G in world)
		sleep(-1)
		G.pre_generate()

	for(var/turf/unsimulated/generation/G in world)
		sleep(-1)
		G.generate()
		turf_generation_count++

	log_subsystem(name,"Randomly Generated [turf_generation_count] turfs.")

	var/list/generations = list()

	for(var/obj/marker/generation/G in world)
		generations += G

	sortMerge(generations, /proc/cmp_generation_priority)

	for(var/k in generations)
		var/obj/marker/generation/G = k
		G.generate_marker()
		object_generation_count += 1

	log_subsystem(name,"Randomly Generated [object_generation_count] random turf islands.")

	var/turf_count = 0

	for(var/turf/simulated/S in world)
		sleep(-1)
		INITIALIZE(S)
		turf_count++

	log_subsystem(name,"Initialized [turf_count] turfs.")
	turf_count = 0

	for(var/turf/simulated/S in world)
		sleep(-1)
		FINALIZE(S)
		turf_count++

	log_subsystem(name,"Finalized [turf_count] turfs.")

	log_subsystem(name,"Stored [length(turf_icon_cache)] icons and saved [saved_icons] redundent icons.")

	return ..()

/subsystem/turfs/proc/process_queued_edge(var/turf/T)
	CHECK_TICK(75,FPS_SERVER*3)
	T.update_sprite()
	queued_edges -= T
	return TRUE

/subsystem/turfs/proc/process_wet_turf(var/turf/simulated/T)
	CHECK_TICK(75,FPS_SERVER*3)
	T.wet_level = max(0, T.wet_level - T.wet_level*T.drying_mul - T.drying_add)
	if(T.wet_level <= 0)
		wet_turfs -= T
		T.overlays.Cut()
		T.update_overlays()
	return TRUE

/subsystem/turfs/proc/process_edges()

	for(var/k in queued_edges)
		var/turf/T = k
		if(process_queued_edge(T) == null)
			queued_edges -= k

/subsystem/turfs/proc/process_wet_turfs()

	for(var/k in wet_turfs)
		var/turf/simulated/T = k
		if(process_wet_turf(T) == null)
			wet_turfs -= k


/subsystem/turfs/on_life()

	process_edges()
	process_wet_turfs()


	return TRUE

/proc/queue_update_turf_edges(var/turf/T)

	SSturfs.queued_edges |= T

	for(var/direction in DIRECTIONS_ALL)
		var/turf/T2 = get_step(T,direction)
		SSturfs.queued_edges |= T2

	return TRUE