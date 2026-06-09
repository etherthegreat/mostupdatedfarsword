extends Control


var player = country

func buildSelf(playerNode):
	pendingBelief = ""
	pendingCost = 0
	$religionData.buildSelf()
	player = playerNode
	pass

var beliefButt = load("res://belief_button.tscn")
var beliefPD = load("res://purchased_doctrine.tscn")
func updateSelf():
	$BeliefPanel/PurchasePanel.visible = false
	pendingBelief = ""
	pendingCost = 0
	if $BeliefPanel/GodsScrollContainer/GodsContainer.get_children!=null:
		for beliefButton in $BeliefPanel/GodsScrollContainer/GodsContainer.get_children():
			$BeliefPanel/GodsScrollContainer/GodsContainer.remove_child(beliefButton)
			beliefButton.queue_free()
	if $BeliefPanel/DoctrineScrollContainer/DoctrineContainer.get_children() != null:
		for beliefButton in $BeliefPanel/DoctrineScrollContainer/DoctrineContainer.get_children():
			$BeliefPanel/DoctrineScrollContainer/DoctrineContainer.remove_child(beliefButton)
			beliefButton.queue_free()
	for String in player.availableDocs:
		var newBB = beliefButt.instantiate()
		match String:
			"Healing Waters":
				newBB.buildSelf("Healing Waters", $religionData.healingWatersIcon, $religionData.healingWatersBWIcon, false, 100, "We utilize the few fresh water resources to motivate our followers.", $religionData.border1)
			"Standing Stones":
				newBB.buildSelf("Standing Stones", $religionData.standingStonesIcon, $religionData.standingStonesBWIcon, false, 120, "What's up, we are indeed the Standing Stones, the famous band from Farsword.", $religionData.border1)
			"Valued Idolatry":
				newBB.buildSelf("Valued Idolatry", $religionData.valuedIdolatryIcon, $religionData.valuedIdolatryBWIcon, false, 20, "Gold and Silver Artifacts are utilized to show how rich our God is.", $religionData.border1)
			"Sacred Groves":
				newBB.buildSelf("Sacred Groves", $religionData.sacredGrovesIcon, $religionData.sacredGrovesBWIcon, false, 70, "These Groves be sacred as fuck.", $religionData.border1)
			"Midsummer Celebrations":
				newBB.buildSelf("Midsummer Celebrations", $religionData.midsummerCelebrationsIcon, $religionData.midsummerCelebrationsBWIcon, false, 35, "By partying super hard, our people will feel way better about themselvs.", $religionData.border1)
			"Tree of Life":
				newBB.buildSelf("Tree of Life", $religionData.treeOfLifeIcon, $religionData.treeOfLifeBWIcon, false, 160, "Trees are everything and everywhere and make perfect indoctrination imagery for dummies.", $religionData.border1)
			"Tower Control":
				newBB.buildSelf("Tower Control", $religionData.towerControlIcon, $religionData.towerControlBWIcon, false, 250, "The scholars have implemented strict controls over mystical practice, channeling all spiritual energy through state-sanctioned channels.", $religionData.border1)
			"Nature Sanctuaries":
				newBB.buildSelf("Nature Sanctuaries", $religionData.natureSanctuariesIcon, $religionData.natureSanctuariesIconBW, false, 100, "By harmonizing our churches with the natural world, we commune with the divine through unspoiled wilderness.", $religionData.border1)
			"Conservative Orthodoxy":
				newBB.buildSelf("Conservative Orthodoxy", $religionData.conservativeOrthodoxyIcon, $religionData.conservativeOrthodoxyIconBW, false, 200, "Our Church does not rely on modern revelation — all doctrine was divine at its founding and shall remain unchanged.", $religionData.border1)
			"Sanctioned Cadaver Research":
				newBB.buildSelf("Sanctioned Cadaver Research", $religionData.sanctionedCadaverResearchIcon, $religionData.sanctionedCadaverResearchIconBW, false, 200, "Our faith will not obstruct the necessary scientific pursuit of medicine and natural philosophy.", $religionData.border1)
			"Temple Height Restrictions":
				newBB.buildSelf("Temple Height Restrictions", $religionData.templeHeightLawsIcon, $religionData.templeHeightLawsIconBW, false, 120, "Our faith decrees no building shall surpass the height of our temples in any settlement.", $religionData.border1)
		$BeliefPanel/DoctrineScrollContainer/DoctrineContainer.add_child(newBB)
		newBB.LabelClicked.connect(purchasePanel)
	for String in player.availableGods:
		var newBB = beliefButt.instantiate()
		match String:
			"George Washington":
				newBB.buildSelf("George Washington", $religionData.washingtonIcon, $religionData.washingtonBWIcon, false, 200, "The Father of the Nation — or at least the one who showed up on time and didn't embezzle the treasury. Washington inspires military discipline and civic virtue, demanding excellence from every farm, forge, and frontier outpost.", $religionData.border2)
			"Benjamin Franklin":
				newBB.buildSelf("Benjamin Franklin", $religionData.franklinIcon, $religionData.franklinBWIcon, false, 150, "Scientist, diplomat, printer, rogue, and the only Founding Father to appear on a hundred dollar bill despite never being president. Franklin's restless curiosity boosts Libraries and Workshops — he never met an idea he couldn't improve.", $religionData.border3)
			"Abigail Adams":
				newBB.buildSelf("Abigail Adams", $religionData.abigailAdamsIcon, $religionData.abigailAdamsBWIcon, false, 120, "She told John to 'remember the ladies' and he absolutely did not listen. Nevertheless, Abigail's sharp political mind inspires dissent, scholarship, and the particular American art of telling power what it doesn't want to hear.", $religionData.border1)
			"Alexander Hamilton":
				newBB.buildSelf("Alexander Hamilton", $religionData.hamiltonIcon, $religionData.hamiltonBWIcon, false, 180, "The immigrant orphan who built America's financial system through sheer will and an inability to let anything go. Hamilton's patronage boosts Banks, Workshops, and any structure that turns ambition into wealth.", $religionData.border5)
			"Phillis Wheatley":
				newBB.buildSelf("Phillis Wheatley", $religionData.phillisWheatleyIcon, $religionData.phillisWheatleyBWIcon, false, 100, "The first enslaved African American to publish a book of poetry in the colonies — she proved that genius laughs at chains. Wheatley's patronage inspires Libraries and Temples wherever her memory is honored.", $religionData.border1)
			"Thomas Jefferson":
				newBB.buildSelf("Thomas Jefferson", $religionData.jeffersonIcon, $religionData.jeffersonBWIcon, false, 220, "A man of infinite contradiction who wrote that all men are created equal and then went home to his plantation. Jefferson's patronage is powerful but complicated: Libraries and Farms flourish, but Harmony costs extra. History contains multitudes.", $religionData.border4)
			"Abraham Lincoln":
				newBB.buildSelf("Abraham Lincoln", $religionData.lincolnIcon, $religionData.lincolnBWIcon, false, 250, "The rail-splitter who held the Union together with sheer stubbornness and a magnificent beard. Lincoln's patronage represents sacrifice and reconstruction — the long, costly work of living up to your nation's founding documents.", $religionData.border2)
			"Harriet Tubman":
				newBB.buildSelf("Harriet Tubman", $religionData.tubmanIcon, $religionData.tubmanBWIcon, false, 200, "Conductor of the Underground Railroad, spy for the Union Army, and the most dangerous person any tyrant could encounter. Tubman's patronage grants military bonuses and increases Manpower — freedom, it turns out, is a combat advantage.", $religionData.border4)
			"Frederick Douglass":
				newBB.buildSelf("Frederick Douglass", $religionData.douglassIcon, $religionData.douglassBWIcon, false, 180, "Escaped slavery and spent the rest of his life explaining to anyone who would listen why that was a bad system, using words so precise they still cut. Douglass's patronage elevates Libraries, Courthouses, and the uncomfortable power of truth.", $religionData.border3)
			"Sitting Bull":
				newBB.buildSelf("Sitting Bull", $religionData.sittingBullIcon, $religionData.sittingBullBWIcon, false, 200, "Hunkpapa Lakota war chief, holy man, and the figure who outlasted Custer. Sitting Bull's patronage honors the land itself — Nature Sanctuaries flourish, and buildings in wooded and river territories produce bonus resources.", $religionData.border5)
			"Sojourner Truth":
				newBB.buildSelf("Sojourner Truth", $religionData.sojournerTruthIcon, $religionData.sojournerTruthBWIcon, false, 130, "Ain't I a woman? She asked the question that exposed every hypocrite in the room. Truth's patronage uplifts Farms and Temples, and her presence grants a Harmony bonus to every province with diverse population.", $religionData.border1)
			"Chief Joseph":
				newBB.buildSelf("Chief Joseph", $religionData.chiefJosephIcon, $religionData.chiefJosephBWIcon, false, 150, "I will fight no more forever. Chief Joseph's dignity in impossible circumstance became a testament to resilience and the cost of empire. His patronage grants unusual bonuses to Courthouses and morale in occupied territories.", $religionData.border2)
			"Theodore Roosevelt":
				newBB.buildSelf("Theodore Roosevelt", $religionData.teddyRooseveltIcon, $religionData.teddyRooseveltBWIcon, false, 180, "BULLY! The cowboy president who busted trusts and invented conservation because he loved shooting things too much to let them go extinct. Roosevelt's patronage boosts Mines, Camps, and Barracks — the great strenuous life.", $religionData.border4)
			"Susan B. Anthony":
				newBB.buildSelf("Susan B. Anthony", $religionData.susanBAnthonyIcon, $religionData.susanBAnthonyBWIcon, false, 120, "Voted illegally in 1872, was arrested, and turned her trial into a lecture on democracy they never forgot. Anthony's patronage rewards civic action — Courthouses and Libraries thrive, and Mandate generation increases across all provinces.", $religionData.border1)
			"Ida B. Wells":
				newBB.buildSelf("Ida B. Wells", $religionData.idaBWellsIcon, $religionData.idaBWellsBWIcon, false, 140, "Investigative journalist who documented injustice when no one else would print it. Wells's patronage powers Libraries — the pen sharper than the sword, and considerably more damning.", $religionData.border3)
			"Eleanor Roosevelt":
				newBB.buildSelf("Eleanor Roosevelt", $religionData.eleanorRooseveltIcon, $religionData.eleanorRooseveltBWIcon, false, 200, "First Lady, diplomat, United Nations architect, and the only person FDR was afraid of. Eleanor's patronage rewards empathy in governance — social-tier buildings generate exceptional returns.", $religionData.border5)
			"Martin Luther King Jr.":
				newBB.buildSelf("Martin Luther King Jr.", $religionData.martinLutherKingIcon, $religionData.martinLutherKingBWIcon, false, 280, "The dream is expensive. King's patronage is the most powerful in the game and the most demanding — Harmony bonuses across all provinces, but only so long as your laws reflect justice. The moment they don't, expect consequences.", $religionData.border2)
			"Cesar Chavez":
				newBB.buildSelf("Cesar Chavez", $religionData.cesarChavezIcon, $religionData.cesarChavezBWIcon, false, 160, "Si se puede. Chavez organized farm workers when it was genuinely dangerous to do so, building a movement from sheer solidarity. His patronage supercharges Farms and grants Manpower bonuses proportional to how many labor laws your nation has passed.", $religionData.border4)
			"Jimmy Carter":
				newBB.buildSelf("Jimmy Carter", $religionData.jimmyCarterIcon, $religionData.jimmyCarterBWIcon, false, 120, "The peanut farmer who brokered peace between Egypt and Israel, then went home and built houses for the poor. Carter's patronage rewards humility — quiet, persistent bonuses to everything, nothing flashy, compounding forever.", $religionData.border1)
			"Dolores Huerta":
				newBB.buildSelf("Dolores Huerta", $religionData.doloresHuertaIcon, $religionData.doloresHuertaBWIcon, false, 140, "Co-founder of the United Farm Workers and proof that 'no' is not an acceptable final answer. Huerta's patronage amplifies Cesar Chavez's farm bonuses if both are selected, and adds exceptional Harmony in provinces with mixed labor.", $religionData.border3)
		$BeliefPanel/GodsScrollContainer/GodsContainer.add_child(newBB)
		newBB.LabelClicked.connect(purchasePanel)
	if $BeliefPanel/purchasedBeliefsGrid.get_children() != null:
		for purchasedDoctrine in $BeliefPanel/purchasedBeliefsGrid.get_children():
			$BeliefPanel/purchasedBeliefsGrid.remove_child(purchasedDoctrine)
			purchasedDoctrine.queue_free()
	if $BeliefPanel/purchasedGodsGrid.get_children() != null:
		for purchasedDoctrine in $BeliefPanel/purchasedGodsGrid.get_children():
			$BeliefPanel/purchasedGodsGrid.remove_child(purchasedDoctrine)
			purchasedDoctrine.queue_free()
	for belief in player.selectedBeliefs:
		buildPD(belief.beliefType)
	pass

func buildPD(type):
	var newPD = beliefPD.instantiate()
	match type:
		"Healing Waters":
			newPD.buildSelf("Healing Waters", $religionData.healingWatersIcon, "We utilize the few fresh water resources to motivate our followers.", true, $religionData.border1)
		"Standing Stones":
			newPD.buildSelf("Standing Stones", $religionData.standingStonesIcon, "What's up, we are indeed the Standing Stones, the famous band from Farsword.", true,  $religionData.border1)
		"Valued Idolatry":
			newPD.buildSelf("Valued Idolatry", $religionData.valuedIdolatryIcon, "Gold and Silver Artifacts are utilized to show how rich our God is.", true, $religionData.border1)
		"Sacred Groves":
			newPD.buildSelf("Sacred Groves", $religionData.sacredGrovesIcon, "These Groves be sacred as fuck.", true, $religionData.border1)
		"Midsummer Celebrations":
			newPD.buildSelf("Midsummer Celebrations", $religionData.midsummerCelebrationsIcon, "By partying super hard, our people will feel way better about themselvs.", true, $religionData.border1)
		"Tree of Life":
			newPD.buildSelf("Tree of Life", $religionData.treeOfLifeIcon, "Trees are everything and everywhere and make perfect indoctrination imagery for dummies.", true, $religionData.border1)
		"Tower Control":
			newPD.buildSelf("Tower Control", $religionData.towerControlIcon, "The scholars have implemented strict controls over mystical practice, channeling all spiritual energy through state-sanctioned channels.", true, $religionData.border1)
		"Nature Sanctuaries":
			newPD.buildSelf("Nature Sanctuaries", $religionData.natureSanctuariesIcon, "By harmonizing our churches with the natural world, we commune with the divine through unspoiled wilderness.", true, $religionData.border1)
		"Conservative Orthodoxy":
			newPD.buildSelf("Conservative Orthodoxy", $religionData.conservativeOrthodoxyIcon, "Our Church does not rely on modern revelation — all doctrine was divine at its founding and shall remain unchanged.", true, $religionData.border1)
		"Sanctioned Cadaver Research":
			newPD.buildSelf("Sanctioned Cadaver Research", $religionData.sanctionedCadaverResearchIcon, "Our faith will not obstruct the necessary scientific pursuit of medicine and natural philosophy.", true, $religionData.border1)
		"Temple Height Restrictions":
			newPD.buildSelf("Temple Height Restrictions", $religionData.templeHeightLawsIcon, "Our faith decrees no building shall surpass the height of our temples in any settlement.", true, $religionData.border1)
		"George Washington":
			newPD.buildSelf("George Washington", $religionData.washingtonIcon, "The Father of the Nation — military discipline and civic virtue demand excellence from every farm, forge, and frontier outpost.", false, $religionData.border2)
		"Benjamin Franklin":
			newPD.buildSelf("Benjamin Franklin", $religionData.franklinIcon, "Scientist, diplomat, printer, rogue. Franklin's restless curiosity boosts Libraries and Workshops — he never met an idea he couldn't improve.", false, $religionData.border3)
		"Abigail Adams":
			newPD.buildSelf("Abigail Adams", $religionData.abigailAdamsIcon, "She told John to 'remember the ladies' and he absolutely did not listen. Abigail inspires dissent, scholarship, and telling power what it doesn't want to hear.", false, $religionData.border1)
		"Alexander Hamilton":
			newPD.buildSelf("Alexander Hamilton", $religionData.hamiltonIcon, "The immigrant orphan who built America's financial system through sheer will. Hamilton's patronage boosts Banks, Workshops, and any structure that turns ambition into wealth.", false, $religionData.border5)
		"Phillis Wheatley":
			newPD.buildSelf("Phillis Wheatley", $religionData.phillisWheatleyIcon, "The first enslaved African American to publish a book of poetry in the colonies. Genius laughs at chains — Libraries and Temples thrive wherever her memory is honored.", false, $religionData.border1)
		"Thomas Jefferson":
			newPD.buildSelf("Thomas Jefferson", $religionData.jeffersonIcon, "A man of infinite contradiction. Libraries and Farms flourish, but Harmony costs extra. History contains multitudes.", false, $religionData.border4)
		"Abraham Lincoln":
			newPD.buildSelf("Abraham Lincoln", $religionData.lincolnIcon, "The rail-splitter who held the Union together with sheer stubbornness. Lincoln's patronage represents sacrifice and the long, costly work of living up to your founding documents.", false, $religionData.border2)
		"Harriet Tubman":
			newPD.buildSelf("Harriet Tubman", $religionData.tubmanIcon, "Conductor of the Underground Railroad, spy for the Union Army. Tubman's patronage grants military bonuses and increases Manpower — freedom is a combat advantage.", false, $religionData.border4)
		"Frederick Douglass":
			newPD.buildSelf("Frederick Douglass", $religionData.douglassIcon, "Words so precise they still cut. Douglass's patronage elevates Libraries, Courthouses, and the uncomfortable power of truth.", false, $religionData.border3)
		"Sitting Bull":
			newPD.buildSelf("Sitting Bull", $religionData.sittingBullIcon, "Hunkpapa Lakota war chief and holy man. Nature Sanctuaries flourish, and buildings in wooded and river territories produce bonus resources.", false, $religionData.border5)
		"Sojourner Truth":
			newPD.buildSelf("Sojourner Truth", $religionData.sojournerTruthIcon, "Ain't I a woman? She asked the question that exposed every hypocrite in the room. Uplifts Farms and Temples, Harmony bonus in diverse provinces.", false, $religionData.border1)
		"Chief Joseph":
			newPD.buildSelf("Chief Joseph", $religionData.chiefJosephIcon, "I will fight no more forever. Dignity in impossible circumstance. Unusual bonuses to Courthouses and morale in occupied territories.", false, $religionData.border2)
		"Theodore Roosevelt":
			newPD.buildSelf("Theodore Roosevelt", $religionData.teddyRooseveltIcon, "BULLY! Conservation because he loved shooting things too much to let them go extinct. Boosts Mines, Camps, and Barracks — the great strenuous life.", false, $religionData.border4)
		"Susan B. Anthony":
			newPD.buildSelf("Susan B. Anthony", $religionData.susanBAnthonyIcon, "Voted illegally in 1872 and turned her trial into a lecture. Courthouses and Libraries thrive, Mandate generation increases across all provinces.", false, $religionData.border1)
		"Ida B. Wells":
			newPD.buildSelf("Ida B. Wells", $religionData.idaBWellsIcon, "Documented injustice when no one else would print it. The pen sharper than the sword, and considerably more damning. Powers Libraries.", false, $religionData.border3)
		"Eleanor Roosevelt":
			newPD.buildSelf("Eleanor Roosevelt", $religionData.eleanorRooseveltIcon, "First Lady, diplomat, UN architect, and the only person FDR was afraid of. Social-tier buildings generate exceptional returns.", false, $religionData.border5)
		"Martin Luther King Jr.":
			newPD.buildSelf("Martin Luther King Jr.", $religionData.martinLutherKingIcon, "The dream is expensive. Maximum Harmony bonuses — but only so long as your laws reflect justice. The moment they don't, expect consequences.", false, $religionData.border2)
		"Cesar Chavez":
			newPD.buildSelf("Cesar Chavez", $religionData.cesarChavezIcon, "Si se puede. Supercharges Farms and grants Manpower bonuses proportional to how many labor laws your nation has passed.", false, $religionData.border4)
		"Jimmy Carter":
			newPD.buildSelf("Jimmy Carter", $religionData.jimmyCarterIcon, "The peanut farmer who brokered peace and then went home and built houses for the poor. Quiet, persistent bonuses to everything, nothing flashy, compounding forever.", false, $religionData.border1)
		"Dolores Huerta":
			newPD.buildSelf("Dolores Huerta", $religionData.doloresHuertaIcon, "Co-founder of the United Farm Workers. Amplifies Cesar Chavez's farm bonuses if both are selected. Exceptional Harmony in provinces with mixed labor.", false, $religionData.border3)
	match newPD.doctrineType:
		true:
			$BeliefPanel/purchasedBeliefsGrid.add_child(newPD)
		false:
			$BeliefPanel/purchasedGodsGrid.add_child(newPD)
	newPD.purchasedDoctrineHover.connect(pdPanelUpdate)
	newPD.pdExited.connect(closePurchasePanel)
	pass
	
func closePurchasePanel():
	$BeliefPanel/PurchasePanel.visible = false
	pass

func pdPanelUpdate(title, img, desc, border):
	$BeliefPanel/PurchasePanel/PPSprite.texture = img
	$BeliefPanel/PurchasePanel/RichTextLabel.clear()
	$BeliefPanel/PurchasePanel/RichTextLabel.append_text(desc)
	$BeliefPanel/PurchasePanel/PurchaseButton.visible = false
	$BeliefPanel/PurchasePanel/Price.visible = false
	$BeliefPanel/PurchasePanel/FaithIcon.visible = false
	$BeliefPanel/PurchasePanel/Label.text = title
	$BeliefPanel/PurchasePanel/PPBorderSprite.texture = border
	$BeliefPanel/PurchasePanel.visible = true
	pass

var pendingCost: int
var pendingBelief: String
func purchasePanel(bbName, bbCost, bbImage, beliefDesc, beliefBorder):
	$BeliefPanel/PurchasePanel/PPSprite.texture = bbImage
	$BeliefPanel/PurchasePanel/PurchaseButton.visible = true
	$BeliefPanel/PurchasePanel/Price.visible = true
	$BeliefPanel/PurchasePanel/FaithIcon.visible = true
	$BeliefPanel/PurchasePanel/RichTextLabel.clear()
	$BeliefPanel/PurchasePanel/RichTextLabel.append_text(beliefDesc)
	$BeliefPanel/PurchasePanel/Price.clear()
	$BeliefPanel/PurchasePanel/Price.append_text(str(bbCost))
	pendingCost = bbCost
	pendingBelief = bbName
	$BeliefPanel/PurchasePanel/PPBorderSprite.texture = beliefBorder
	$BeliefPanel/PurchasePanel.visible = true
	pass

func _on_belief_button_mouse_entered() -> void:
	if $BeliefInfoPanel.visible == false:
		$BeliefInfoPanel.visible = true
	
	pass # Replace with function body.

func _on_belief_button_mouse_exited() -> void:
	if $BeliefInfoPanel.visible == true:
		$BeliefInfoPanel.visible = false
	pass # Replace with function body.

func _process(delta: float) -> void:
	if $BeliefPanel/DoctrineScrollContainer/DoctrineContainer.get_children != null:
		for beliefButton in $BeliefPanel/DoctrineScrollContainer/DoctrineContainer.get_children():
			if beliefButton.bbPurchased != true:
				if beliefButton.bbCost <= player.TotalCulture:
					beliefButton.makePurchaseable()
				else:
					beliefButton.cantAfford()
			else:
				beliefButton.purchased()
	if $BeliefPanel/GodsScrollContainer/GodsContainer.get_children != null:
		for beliefButton in $BeliefPanel/GodsScrollContainer/GodsContainer.get_children():
			if beliefButton.bbPurchased != true:
				if beliefButton.bbCost <= player.TotalCulture:
					beliefButton.makePurchaseable()
				else:
					beliefButton.cantAfford()
			else:
				beliefButton.purchased()
	if pendingBelief != "" && pendingCost != 0:
		if player.TotalCulture >= pendingCost:
			$BeliefPanel/PurchasePanel/PurchaseButton.disabled = false
		else:
			$BeliefPanel/PurchasePanel/PurchaseButton.disabled = true
	if self.visible == true:
		$BeliefPanel/testLabel.text = str(player.churchLevel)
		matchFaithPointsIcons()
	pass

signal purchasedBelief
func _on_purchase_button_pressed() -> void:
	#print("purchasedBelief", pendingBelief, pendingCost)
	emit_signal("purchasedBelief", pendingBelief, pendingCost)
	pendingBelief = ""
	pendingCost = 0
	$BeliefPanel/PurchasePanel.visible = false
	pass # Replace with function body.

func matchFaithPointsIcons():
	match player.churchLevel:
		3:
			$"FaithPoints/1LevelSpriteBW".visible = false
			$"FaithPoints/2LevelSpriteBW".visible = false
			$"FaithPoints/3LevelSpriteBW".visible = false
			$FaithPoints/BalanceSpriteBW.visible = true
			$"FaithPoints/-1LevelSpriteBW".visible = true
			$"FaithPoints/-2LevelSpriteBW".visible = true
			$"FaithPoints/-3LevelSpriteBW".visible = true
		2:
			$"FaithPoints/1LevelSpriteBW".visible = false
			$"FaithPoints/2LevelSpriteBW".visible = false
			$"FaithPoints/3LevelSpriteBW".visible = true
			$FaithPoints/BalanceSpriteBW.visible = true
			$"FaithPoints/-1LevelSpriteBW".visible = true
			$"FaithPoints/-2LevelSpriteBW".visible = true
			$"FaithPoints/-3LevelSpriteBW".visible = true
		1:
			$"FaithPoints/1LevelSpriteBW".visible = false
			$"FaithPoints/2LevelSpriteBW".visible = true
			$"FaithPoints/3LevelSpriteBW".visible = true
			$FaithPoints/BalanceSpriteBW.visible = true
			$"FaithPoints/-1LevelSpriteBW".visible = true
			$"FaithPoints/-2LevelSpriteBW".visible = true
			$"FaithPoints/-3LevelSpriteBW".visible = true
		0:
			$"FaithPoints/1LevelSpriteBW".visible = true
			$"FaithPoints/2LevelSpriteBW".visible = true
			$"FaithPoints/3LevelSpriteBW".visible = true
			$FaithPoints/BalanceSpriteBW.visible = false
			$"FaithPoints/-1LevelSpriteBW".visible = true
			$"FaithPoints/-2LevelSpriteBW".visible = true
			$"FaithPoints/-3LevelSpriteBW".visible = true
		-1:
			$"FaithPoints/1LevelSpriteBW".visible = true
			$"FaithPoints/2LevelSpriteBW".visible = true
			$"FaithPoints/3LevelSpriteBW".visible = true
			$FaithPoints/BalanceSpriteBW.visible = true
			$"FaithPoints/-1LevelSpriteBW".visible = false
			$"FaithPoints/-2LevelSpriteBW".visible = true
			$"FaithPoints/-3LevelSpriteBW".visible = true
		-2:
			$"FaithPoints/1LevelSpriteBW".visible = true
			$"FaithPoints/2LevelSpriteBW".visible = true
			$"FaithPoints/3LevelSpriteBW".visible = true
			$FaithPoints/BalanceSpriteBW.visible = true
			$"FaithPoints/-1LevelSpriteBW".visible = false
			$"FaithPoints/-2LevelSpriteBW".visible = false
			$"FaithPoints/-3LevelSpriteBW".visible = true
		-3:
			$"FaithPoints/1LevelSpriteBW".visible = true
			$"FaithPoints/2LevelSpriteBW".visible = true
			$"FaithPoints/3LevelSpriteBW".visible = true
			$FaithPoints/BalanceSpriteBW.visible = true
			$"FaithPoints/-1LevelSpriteBW".visible = false
			$"FaithPoints/-2LevelSpriteBW".visible = false
			$"FaithPoints/-3LevelSpriteBW".visible = false
	pass


func _on_faith_1_area_2d_mouse_entered() -> void:
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.append_text("[b]Zealous Communion: Pantheon Level 2

All temples provide [color= Green] +3[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png[/img][color=white] Faith[/color], [color= Green] +2[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/food.png[/img][color=pink] Food[/color], and [color= green] +1[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/wood.png[/img][color=brown] Wood[/color]

Unlocks Unit Ability: [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/divinity big.png[img] [color=purple] Big LaBIIA")
	$FaithPoints/FaithPointsInfoPanel.visible = true
	pass # Replace with function body.

func _on_faith_1_area_2d_mouse_exited() -> void:
	$FaithPoints/FaithPointsInfoPanel.visible = false
	pass # Replace with function body.

func _on_faith_2_area_2d_mouse_entered() -> void:
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.append_text("[b]Zealous Communion: Pantheon Level 2

All temples provide [color= Green] +3[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png[/img][color=white] Faith[/color], [color= Green] +2[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/food.png[/img][color=pink] Food[/color], and [color= green] +1[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/wood.png[/img][color=brown] Wood[/color]

Unlocks Unit Ability: [img]res://art assets/Placeholder Art/sword.png[img] [color=purple] Divine Charge")
	$FaithPoints/FaithPointsInfoPanel.visible = true
	pass # Replace with function body.

func _on_faith_2_area_2d_mouse_exited() -> void:
	$FaithPoints/FaithPointsInfoPanel.visible = false
	pass # Replace with function body.

func _on_faith_3_area_2d_mouse_entered() -> void:
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.append_text("[b]Zealous Communion: Pantheon Level 2

All temples provide [color= Green] +3[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png[/img][color=white] Faith[/color], [color= Green] +2[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/food.png[/img][color=pink] Food[/color], and [color= green] +1[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/wood.png[/img][color=brown] Wood[/color]

Unlocks Unit Ability: [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/food.png[img] [color=purple] Wiener Vacuum")
	$FaithPoints/FaithPointsInfoPanel.visible = true
	pass # Replace with function body.

func _on_faith_3_area_2d_mouse_exited() -> void:
	$FaithPoints/FaithPointsInfoPanel.visible = false
	pass # Replace with function body.


func _on_church_1_area_2d_mouse_entered() -> void:
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.append_text("[b]Zealous Communion: Church Level 1

All temples provide [color= Green] +3[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png[/img][color=white] Faith[/color], [color= Green] +2[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/food.png[/img][color=pink] Food[/color], and [color= green] +1[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/wood.png[/img][color=brown] Wood[/color]

Unlocks Unit Ability: [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/divinity big.png[img] [color=purple] Organized Faith")
	$FaithPoints/ChurchPointsInfoPanel.visible = true
	pass # Replace with function body.

func _on_church_1_area_2d_mouse_exited() -> void:
	$FaithPoints/ChurchPointsInfoPanel.visible = false
	pass # Replace with function body.

func _on_church_2_area_2d_mouse_entered() -> void:
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.append_text("[b]Zealous Communion: Church Level 2

All temples provide [color= Green] +3[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png[/img][color=white] Faith[/color], [color= Green] +2[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/food.png[/img][color=pink] Food[/color], and [color= green] +1[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/wood.png[/img][color=brown] Wood[/color]

Unlocks Unit Ability: [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/divinity big.png[img] [color=purple] Organized Priesthood")
	$FaithPoints/ChurchPointsInfoPanel.visible = true
	pass # Replace with function body.

func _on_church_2_area_2d_mouse_exited() -> void:
	$FaithPoints/ChurchPointsInfoPanel.visible = false
	pass # Replace with function body.


func _on_church_3_area_2d_mouse_entered() -> void:
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.append_text("[b]Zealous Communion: Church Level 3

All temples provide [color= Green] +3[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png[/img][color=white] Faith[/color], [color= Green] +2[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/food.png[/img][color=pink] Food[/color], and [color= green] +1[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/wood.png[/img][color=brown] Wood[/color]

Unlocks Unit Ability: [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/divinity big.png[img] [color=purple] Organized Religion")
	$FaithPoints/ChurchPointsInfoPanel.visible = true
	pass # Replace with function body.


func _on_church_3_area_2d_mouse_exited() -> void:
	$FaithPoints/ChurchPointsInfoPanel.visible = false
	pass # Replace with function body.


func _on_balance_area_2d_mouse_entered() -> void:
	$FaithPoints/BalancePointsInfoPanel/BalancePointsInfoPanel/RichTextLabel.clear()
	$FaithPoints/BalancePointsInfoPanel/BalancePointsInfoPanel/RichTextLabel.append_text("[b]Zealous Communion: Church Level 3

All temples provide [color= Green] +3[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/faith.png[/img][color=white] Faith[/color], [color= Green] +2[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/food.png[/img][color=pink] Food[/color], and [color= green] +1[/color] [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/wood.png[/img][color=brown] Wood[/color]

Unlocks Unit Ability: [img]res://art assets/Placeholder Art/UI Art/resources/Older Icons/divinity big.png[img] [color=purple] Perfectly Balanced")
	$FaithPoints/BalancePointsInfoPanel.visible = true
	pass # Replace with function body.


func _on_balance_area_2d_mouse_exited() -> void:
	$FaithPoints/BalancePointsInfoPanel.visible = false
	pass # Replace with function body.
