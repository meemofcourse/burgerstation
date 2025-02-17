/atom/movable/lighting_overlay
	name          = "lighting overlay"
	anchored      = 2
	icon          = LIGHTING_ICON
	icon_state    = LIGHTING_BASE_ICON_STATE
	color         = null
	mouse_opacity = 0
	layer         = LAYER_LIGHTING
	plane         = PLANE_LIGHTING
	invisibility  = INVISIBILITY_LIGHTING
	//blend_mode    = BLEND_MULTIPLY

	var/needs_update = FALSE

	anchored = 2

/atom/movable/lighting_overlay/New()

	var/turf/T         = loc // If this runtimes atleast we'll know what's creating overlays in things that aren't turfs.
	T.lighting_overlay = src
	T.luminosity       = 0

	needs_update = TRUE
	SSlighting.overlay_queue += src

	color = LIGHTING_BASE_MATRIX

	. = ..()

	verbs.Cut()


/atom/movable/lighting_overlay/PreDestroy()
	var/turf/T = loc
	if(T && is_turf(T))
		T.lighting_overlay = null
		T.luminosity = 1
	. = ..()

/atom/movable/lighting_overlay/Destroy()
	. = ..()
	SSlighting.total_lighting_overlays -= 1


// This is a macro PURELY so that the if below is actually readable.
#define ALL_EQUAL ((rr == ar && gr == ar && br == ar) && (rg == ag && gg == ag && bg == ag) && (rb == ab && gb == ab && bb == ab))

/atom/movable/lighting_overlay/update_overlays()

	var/turf/T = loc
	if(!istype(T)) // Erm...
		if(loc)
			log_error("A lighting overlay realised its loc was NOT a turf (actual loc: [loc.get_debug_name()]) in update_overlay() and got deleted!")
		else
			log_error("A lighting overlay realised it was in nullspace in update_overlay() and got deleted!")
		qdel(src)
		return

	// See LIGHTING_CORNER_DIAGONAL in lighting_corner.dm for why these values are what they are.
	var/list/corners = T.corners
	var/lighting_corner/cr = dummy_lighting_corner
	var/lighting_corner/cg = dummy_lighting_corner
	var/lighting_corner/cb = dummy_lighting_corner
	var/lighting_corner/ca = dummy_lighting_corner
	if(corners)
		cr = corners[3] || dummy_lighting_corner
		cg = corners[2] || dummy_lighting_corner
		cb = corners[4] || dummy_lighting_corner
		ca = corners[1] || dummy_lighting_corner

	var/max = max(cr.cache_mx, cg.cache_mx, cb.cache_mx, ca.cache_mx)
	luminosity = 1

	var/rr = cr.cache_r
	var/rg = cr.cache_g
	var/rb = cr.cache_b

	var/gr = cg.cache_r
	var/gg = cg.cache_g
	var/gb = cg.cache_b

	var/br = cb.cache_r
	var/bg = cb.cache_g
	var/bb = cb.cache_b

	var/ar = ca.cache_r
	var/ag = ca.cache_g
	var/ab = ca.cache_b

	if((rr & gr & br & ar) && (rg + gg + bg + ag + rb + gb + bb + ab == 8))
		icon_state = LIGHTING_TRANSPARENT_ICON_STATE
		color = null
		alpha = 255
	else if (max <= LIGHTING_SOFT_THRESHOLD)
		icon_state = LIGHTING_DARKNESS_ICON_STATE
		color = null
		alpha = 255
	else if(ALL_EQUAL)
		icon_state = LIGHTING_TRANSPARENT_ICON_STATE
		color = rgb(cr.cache_r*255,cg.cache_g*255,cb.cache_b*255)
		alpha = 255
	else
		icon_state = LIGHTING_BASE_ICON_STATE
		if (islist(color))
			var/list/c_list = color
			c_list[CL_MATRIX_RR] = rr
			c_list[CL_MATRIX_RG] = rg
			c_list[CL_MATRIX_RB] = rb
			c_list[CL_MATRIX_GR] = gr
			c_list[CL_MATRIX_GG] = gg
			c_list[CL_MATRIX_GB] = gb
			c_list[CL_MATRIX_BR] = br
			c_list[CL_MATRIX_BG] = bg
			c_list[CL_MATRIX_BB] = bb
			c_list[CL_MATRIX_AR] = ar
			c_list[CL_MATRIX_AG] = ag
			c_list[CL_MATRIX_AB] = ab
			color = c_list
		else
			color = list(
				rr, rg, rb, 0,
				gr, gg, gb, 0,
				br, bg, bb, 0,
				ar, ag, ab, 0,
				0, 0, 0, 1
			)

	T.lightness = max

#undef ALL_EQUAL