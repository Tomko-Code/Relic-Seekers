extends Node

var artifacts = {
	test_active_artifact = TestActiveArtifact,
	test_passive_artifact = TestPassiveArtifact,
	golden_clock = GoldenClockArtifact,
	infinite_bag_of_goods = InfiniteBagOfGoods,
	mana_in_bottle = ManaInBottle,
	jar_of_fireflies = JarOfFireflies,
}

var random_pools = {
	random = [
		["infinite_bag_of_goods", 1],
		["jar_of_fireflies", 1],
		["golden_clock", 1],
		["mana_in_bottle", 1]
	]
}
