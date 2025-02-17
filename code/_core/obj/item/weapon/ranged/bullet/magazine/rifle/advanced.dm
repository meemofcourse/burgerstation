/obj/item/weapon/ranged/bullet/magazine/rifle/advanced
	name = "\improper 7.62mm SOL-15 battle rifle"
	desc = "HOORAH!."
	desc_extended = "An old rifle previously used by NanoTrasen when they were contractors of the SolGov army. The SOL-15 is an upgraded version of the SOL-14 rifle. This one features automatic fire capabilities and better recoil dampening."
	icon = 'icons/obj/item/weapons/ranged/rifle/nanotrasen/762_3.dmi'
	icon_state = "inventory"
	value = 3500

	company_type = "NanoTrasen"

	tier = 2

	firemodes = list("automatic","semi-automatic")

	damage_mod = 1.3

	shoot_delay = 3.8

	automatic = TRUE

	shoot_sounds = list('sound/weapons/ranged/rifle/service_rifle/shoot.ogg')

	can_wield = TRUE

	size = SIZE_4
	weight = 20

	heat_max = 0.08

	bullet_length_min = 46
	bullet_length_best = 51
	bullet_length_max = 52

	bullet_diameter_min = 7.6
	bullet_diameter_best = 7.62
	bullet_diameter_max = 7.7

	ai_heat_sensitivity = 1

	attachment_whitelist = list(
		/obj/item/attachment/barrel/charger = TRUE,
		/obj/item/attachment/barrel/charger/advanced = TRUE,
		/obj/item/attachment/barrel/compensator = TRUE,
		/obj/item/attachment/barrel/extended = TRUE,
		/obj/item/attachment/barrel/gyro = TRUE,
		/obj/item/attachment/barrel/laser_charger = FALSE,
		/obj/item/attachment/barrel/suppressor = TRUE,
		/obj/item/attachment/barrel_mod/reinforced_barrel = TRUE,
		/obj/item/attachment/stock_mod/reinforced_stock = TRUE,

		/obj/item/attachment/sight/laser_sight = TRUE,
		/obj/item/attachment/sight/quickfire_adapter = TRUE,
		/obj/item/attachment/sight/red_dot = TRUE,
		/obj/item/attachment/sight/scope = TRUE,
		/obj/item/attachment/sight/scope/large = TRUE,
		/obj/item/attachment/sight/targeting_computer = TRUE,



		/obj/item/attachment/undermount/angled_grip = TRUE,
		/obj/item/attachment/undermount/bipod = TRUE,
		/obj/item/attachment/undermount/burst_adapter = FALSE,
		/obj/item/attachment/undermount/vertical_grip = TRUE,
		/obj/item/attachment/undermount/gun/grenade_launcher = TRUE
	)

	attachment_barrel_offset_x = 31 - 16
	attachment_barrel_offset_y = 20 - 16

	attachment_sight_offset_x = 15 - 16
	attachment_sight_offset_y = 20 - 16

	attachment_undermount_offset_x = 23 - 16
	attachment_undermount_offset_y = 16 - 16

	movement_spread_base = 0.02
	inaccuracy_modifier = 0.25
	movement_inaccuracy_modifier = 1

	dan_mode = TRUE

	rarity = RARITY_UNCOMMON

/obj/item/weapon/ranged/bullet/magazine/rifle/advanced/get_static_spread()
	return 0.001

/obj/item/weapon/ranged/bullet/magazine/rifle/advanced/get_skill_spread(var/mob/living/L)
	return max(0,0.03 - (0.04 * L.get_skill_power(SKILL_RANGED)))