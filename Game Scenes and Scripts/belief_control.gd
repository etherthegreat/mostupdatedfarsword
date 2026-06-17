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
			# ── American Doctrines ───────────────────────────────────────────────
			"Social Security Act":
				newBB.buildSelf("Social Security Act", $religionData.healingWatersIcon, $religionData.healingWatersBWIcon, false, 100, "Signed in 1935, the Social Security Act established federal old-age pensions and unemployment insurance. A safety net woven from public obligation.", $religionData.border1)
			"Landmark Heritage":
				newBB.buildSelf("Landmark Heritage", $religionData.standingStonesIcon, $religionData.standingStonesBWIcon, false, 120, "The Antiquities Act of 1906 gave the President authority to designate national monuments by executive order — the Republic's way of saying: this ground is not for sale.", $religionData.border1)
			"Sherman Antitrust Act":
				newBB.buildSelf("Sherman Antitrust Act", $religionData.valuedIdolatryIcon, $religionData.valuedIdolatryBWIcon, false, 20, "The first federal law to limit monopolies and cartels. Markets, like elections, require competition to be legitimate.", $religionData.border1)
			"Nature Conservationists":
				newBB.buildSelf("Nature Conservationists", $religionData.sacredGrovesIcon, $religionData.sacredGrovesBWIcon, false, 70, "From the Lacey Act to the Canada Wildlife Act, conservation law recognized that the land does not belong to the present alone. Camps yield culture; farms and wilderness both breathe easier.", $religionData.border1)
			"Civic Pride":
				newBB.buildSelf("Civic Pride", load("res://art assets/finishedAssets/lawIcons/accessible_canada_act.png"), $religionData.midsummerCelebrationsBWIcon, false, 35, "A Republic that invests in its arts invests in its identity. Civic Pride turns leisure into culture and monuments into authority.", $religionData.border1)
			"Pioneer Heritage":
				newBB.buildSelf("Pioneer Heritage", load("res://art assets/finishedAssets/lawIcons/homestead_act.png"), $religionData.treeOfLifeBWIcon, false, 100, "The frontier spirit lives in the land. Pioneer Heritage honors the communities that built from nothing — farms that feed the Republic and drive out the rot of environmental decay.", $religionData.border1)
			"Defense Production Act":
				newBB.buildSelf("Defense Production Act", $religionData.towerControlIcon, $religionData.towerControlBWIcon, false, 250, "Passed in 1950, the Defense Production Act gave the President sweeping authority to direct industrial production toward national security needs.", $religionData.border1)
			"Inland Maritime Expertise":
				newBB.buildSelf("Inland Maritime Expertise", load("res://art assets/finishedAssets/lawIcons/can_shipping_act.png"), $religionData.natureSanctuariesIconBW, false, 100, "Mastery of the inland waterways. Units starting a turn on Major River or Major Lake tiles gain +1 Movement — the currents work for those who know them.", $religionData.border1)
			"First Amendment":
				newBB.buildSelf("First Amendment", $religionData.conservativeOrthodoxyIcon, $religionData.conservativeOrthodoxyIconBW, false, 200, "Ratified in 1791, the First Amendment prohibits Congress from abridging freedom of speech, religion, the press, or assembly.", $religionData.border1)
			"National Research Act":
				newBB.buildSelf("National Research Act", $religionData.sanctionedCadaverResearchIcon, $religionData.sanctionedCadaverResearchIconBW, false, 200, "Passed in 1974 in the aftermath of the Tuskegee study, establishing the first federal framework for ethical oversight of biomedical research.", $religionData.border1)
			"Height of Buildings Act":
				newBB.buildSelf("Height of Buildings Act", $religionData.templeHeightLawsIcon, $religionData.templeHeightLawsIconBW, false, 120, "Enacted in 1910, the Height of Buildings Act permanently caps Washington D.C. buildings at 130 feet in deference to civic monuments.", $religionData.border1)
			# ── Canadian Doctrines ───────────────────────────────────────────────
			# Nature Conservationists covers CA as well — handled above
			"Canada Council for the Arts Act":
				newBB.buildSelf("Canada Council for the Arts Act", $religionData.midsummerCelebrationsIcon, $religionData.midsummerCelebrationsBWIcon, false, 35, "Founded in 1957, the Canada Council for the Arts has funded Canadian literature, music, visual art, and performance for generations.", $religionData.border1)
			"Republic Lands Act":
				newBB.buildSelf("Republic Lands Act", $religionData.treeOfLifeIcon, $religionData.treeOfLifeBWIcon, false, 160, "Passed in 1872, the Republic Lands Act opened the Canadian prairies to homestead settlement, offering 160-acre grants to settlers who would farm the land for three years.", $religionData.border1)
			"Historic Sites and Monuments Act":
				newBB.buildSelf("Historic Sites and Monuments Act", $religionData.standingStonesIcon, $religionData.standingStonesBWIcon, false, 120, "The Historic Sites and Monuments Act formalized federal commemoration of places, persons, and events significant to Canadian history.", $religionData.border1)
			"Combines Investigation Act":
				newBB.buildSelf("Combines Investigation Act", $religionData.valuedIdolatryIcon, $religionData.valuedIdolatryBWIcon, false, 20, "Canada's first competition law, enacted in 1889 — the Republic regulated markets before it had a central bank.", $religionData.border1)
			"Canada Health Act":
				newBB.buildSelf("Canada Health Act", $religionData.healingWatersIcon, $religionData.healingWatersBWIcon, false, 100, "Passed in 1984, the Canada Health Act established universality, comprehensiveness, accessibility, portability, and public administration as the pillars of Canadian health care.", $religionData.border1)
			"National Parks Act":
				newBB.buildSelf("National Parks Act", $religionData.natureSanctuariesIcon, $religionData.natureSanctuariesIconBW, false, 100, "Canada's national parks system preserves wilderness for the benefit of all Canadians — 'for all time,' in the Act's own words.", $religionData.border1)
			"Charter of Rights and Freedoms":
				newBB.buildSelf("Charter of Rights and Freedoms", $religionData.conservativeOrthodoxyIcon, $religionData.conservativeOrthodoxyIconBW, false, 200, "Entrenched in the Constitution Act of 1982, the Charter guarantees fundamental rights to every person in Canada.", $religionData.border1)
			"Medical Research Council Act":
				newBB.buildSelf("Medical Research Council Act", $religionData.sanctionedCadaverResearchIcon, $religionData.sanctionedCadaverResearchIconBW, false, 200, "The Medical Research Council of Canada funded biomedical science across the country for three decades, building a tradition of publicly funded discovery.", $religionData.border1)
			"National Building Code of Canada":
				newBB.buildSelf("National Building Code of Canada", $religionData.templeHeightLawsIcon, $religionData.templeHeightLawsIconBW, false, 120, "First published in 1941, the National Building Code sets minimum standards for construction safety across Canada.", $religionData.border1)
			"War Measures Act":
				newBB.buildSelf("War Measures Act", $religionData.towerControlIcon, $religionData.towerControlBWIcon, false, 250, "Enacted in 1914 and invoked three times, the War Measures Act granted the Cabinet sweeping emergency powers. Celebrated as decisive and condemned as despotic.", $religionData.border1)
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
				newBB.buildSelf("Abraham Lincoln", $religionData.lincolnIcon, $religionData.lincolnBWIcon, false, 250, "He held the Union together at the cost of 750,000 lives and his own. Lincoln's patronage fills every barracks and courthouse with the weight of that sacrifice — all units gain +2 Attack and +2 Defense permanently, and rifle units take 5% less manpower loss from every engagement.", $religionData.border2)
			"Harriet Tubman":
				newBB.buildSelf("Harriet Tubman", $religionData.tubmanIcon, $religionData.tubmanBWIcon, false, 200, "Conductor of the Underground Railroad, spy for the Union Army, and the most dangerous person any tyrant could encounter. Tubman's patronage grants military bonuses and increases Manpower — freedom, it turns out, is a combat advantage.", $religionData.border4)
			"Frederick Douglass":
				newBB.buildSelf("Frederick Douglass", $religionData.douglassIcon, $religionData.douglassBWIcon, false, 180, "Escaped slavery and spent the rest of his life explaining to anyone who would listen why that was a bad system, using words so precise they still cut. Douglass's patronage elevates Libraries, Courthouses, and the uncomfortable power of truth.", $religionData.border3)
			"Sitting Bull":
				newBB.buildSelf("Sitting Bull", $religionData.sittingBullIcon, $religionData.sittingBullBWIcon, false, 200, "Hunkpapa Lakota war chief, holy man, and the figure who outlasted Custer. Sitting Bull's patronage honors the land itself — inland waterways run free, and buildings in wooded and river territories produce bonus resources.", $religionData.border5)
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
			# ── Canadian Icons ───────────────────────────────────────────────────
			"John A. Macdonald":
				newBB.buildSelf("John A. Macdonald", $religionData.macdonaldIcon, $religionData.macdonaldBWIcon, false, 200, "The Father of Confederation and first Prime Minister of Canada. Built the Dominion through coalition, compromise, and the transcontinental railway.", $religionData.border2)
			"George-Étienne Cartier":
				newBB.buildSelf("George-Étienne Cartier", $religionData.cartierIcon, $religionData.cartierBWIcon, false, 180, "Macdonald's indispensable partner who brought French Canada into Confederation. Without him, there is no Canada.", $religionData.border3)
			"Wilfrid Laurier":
				newBB.buildSelf("Wilfrid Laurier", $religionData.laurierIcon, $religionData.laurierBWIcon, false, 200, "Canada's first francophone Prime Minister, who declared the twentieth century to be Canada's. His optimism built a country.", $religionData.border1)
			"Agnes Macphail":
				newBB.buildSelf("Agnes Macphail", $religionData.macphailIcon, $religionData.macphailBWIcon, false, 120, "The first woman elected to the Canadian House of Commons in 1921. She was told repeatedly that she did not belong in Parliament. She disagreed, repeatedly.", $religionData.border1)
			"Laura Secord":
				newBB.buildSelf("Laura Secord", $religionData.lauraSecordIcon, $religionData.lauraSecordBWIcon, false, 160, "In June 1813, Laura Secord walked 19 miles through enemy lines to warn British forces of an impending attack. The garrison held.", $religionData.border4)
			"Louis-Hippolyte LaFontaine":
				newBB.buildSelf("Louis-Hippolyte LaFontaine", $religionData.laFontaineIcon, $religionData.laFontaineBWIcon, false, 150, "The architect of responsible government in the Canadas. He proved that self-government was possible without revolution.", $religionData.border5)
			"Tommy Douglas":
				newBB.buildSelf("Tommy Douglas", $religionData.tommyDouglasIcon, $religionData.tommyDouglasBWIcon, false, 250, "Premier of Saskatchewan and father of Canadian Medicare. He introduced single-payer health insurance over furious opposition. He won. Repeatedly.", $religionData.border2)
			"Viola Desmond":
				newBB.buildSelf("Viola Desmond", $religionData.violaDesmondIcon, $religionData.violaDesmondBWIcon, false, 170, "A Black Nova Scotia businesswoman whose refusal to leave a segregated cinema section in 1946 became a landmark in Canadian civil rights history.", $religionData.border4)
			"Lester B. Pearson":
				newBB.buildSelf("Lester B. Pearson", $religionData.pearsonIcon, $religionData.pearsonBWIcon, false, 220, "Nobel Peace Prize laureate and architect of UN peacekeeping. The Prime Minister who gave Canada the Maple Leaf flag, universal health care, and the Canada Pension Plan.", $religionData.border3)
			"Louis Riel":
				newBB.buildSelf("Louis Riel", $religionData.louisRielIcon, $religionData.louisRielBWIcon, false, 200, "Leader of two Métis resistances and founder of Manitoba. Hanged for treason in 1885. Now considered a Father of Confederation by the Manitoba legislature.", $religionData.border5)
			"Emily Murphy":
				newBB.buildSelf("Emily Murphy", $religionData.emilyMurphyIcon, $religionData.emilyMurphyBWIcon, false, 130, "The first female magistrate in the British Empire. Led the Famous Five in the Persons Case of 1929, establishing that women were legally 'persons'.", $religionData.border1)
			"Nellie McClung":
				newBB.buildSelf("Nellie McClung", $religionData.nellieMcClungIcon, $religionData.nellieMcClungBWIcon, false, 120, "Author, suffragist, and member of the Famous Five. One of the most effective political communicators in Canadian history.", $religionData.border2)
			"Terry Fox":
				newBB.buildSelf("Terry Fox", $religionData.terryFoxIcon, $religionData.terryFoxBWIcon, false, 180, "In 1980, Terry Fox ran 5,373 kilometres across Canada on a prosthetic leg to raise money for cancer research. His Marathon of Hope continues without him.", $religionData.border4)
			"Chief Dan George":
				newBB.buildSelf("Chief Dan George", $religionData.chiefDanGeorgeIcon, $religionData.chiefDanGeorgeBWIcon, false, 150, "Chief of the Tsleil-Waututh Nation and Academy Award-nominated actor who used both platforms to speak with dignity about Indigenous dispossession.", $religionData.border5)
			"Buffy Sainte-Marie":
				newBB.buildSelf("Buffy Sainte-Marie", $religionData.buffySaintMarieIcon, $religionData.buffySaintMarieBWIcon, false, 160, "Cree musician and activist whose songs reached audiences that political speeches never could. She was blacklisted by both governments. She kept singing.", $religionData.border3)
			"David Suzuki":
				newBB.buildSelf("David Suzuki", $religionData.davidSuzukiIcon, $religionData.davidSuzukiBWIcon, false, 140, "Geneticist, broadcaster, and Canada's most prominent environmental voice. Spent five decades translating science into public urgency.", $religionData.border1)
			"Roméo Dallaire":
				newBB.buildSelf("Roméo Dallaire", $religionData.romeoDallaireIcon, $religionData.romeoDallaireBWIcon, false, 200, "Force Commander of UNAMIR during the Rwandan genocide. He watched 800,000 people die while the world looked away. He spent the rest of his life arguing that it need not have happened.", $religionData.border2)
			"Thérèse Casgrain":
				newBB.buildSelf("Thérèse Casgrain", $religionData.thereseCasgrainIcon, $religionData.thereseCasgrainBWIcon, false, 120, "Quebec suffragist and social reformer who led the campaign for women's provincial voting rights in Quebec — finally granted in 1940.", $religionData.border4)
			"Mary Two-Axe Earley":
				newBB.buildSelf("Mary Two-Axe Earley", $religionData.maryTwoAxeEarleyIcon, $religionData.maryTwoAxeEarleyBWIcon, false, 130, "Mohawk activist who spent decades fighting the discriminatory clause of the Indian Act that stripped Indigenous women of their status. Bill C-31 corrected it in 1985.", $religionData.border5)
			"Pierre Elliott Trudeau":
				newBB.buildSelf("Pierre Elliott Trudeau", $religionData.pierreTrudeauIcon, $religionData.pierreTrudeauBWIcon, false, 230, "Philosopher and Prime Minister who gave Canada the Official Languages Act, the Charter of Rights and Freedoms, and the Constitution Act of 1982.", $religionData.border3)
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
		# ── American Doctrines ───────────────────────────────────────────────────
		"Social Security Act":
			newPD.buildSelf("Social Security Act", $religionData.healingWatersIcon, "Signed in 1935, the Social Security Act established federal old-age pensions and unemployment insurance.", true, $religionData.border1)
		"Landmark Heritage":
			newPD.buildSelf("Landmark Heritage", $religionData.standingStonesIcon, "The Antiquities Act gave the President authority to designate national monuments. Sacred geography has never been more official.", true, $religionData.border1)
		"Sherman Antitrust Act":
			newPD.buildSelf("Sherman Antitrust Act", $religionData.valuedIdolatryIcon, "The first federal law to limit monopolies and cartels. Markets, like elections, require competition to be legitimate.", true, $religionData.border1)
		"Nature Conservationists":
			newPD.buildSelf("Nature Conservationists", $religionData.sacredGrovesIcon, "The land does not belong to the present alone. Camps yield culture; farms and wilderness both breathe easier under conservation law.", true, $religionData.border1)
		"Civic Pride":
			newPD.buildSelf("Civic Pride", load("res://art assets/finishedAssets/lawIcons/accessible_canada_act.png"), "A Republic that invests in its arts invests in its identity. Civic Pride turns leisure into culture and monuments into authority.", true, $religionData.border1)
		"Pioneer Heritage":
			newPD.buildSelf("Pioneer Heritage", load("res://art assets/finishedAssets/lawIcons/homestead_act.png"), "The frontier spirit lives in the land. Pioneer Heritage honors communities that built from nothing — farms that feed the Republic and drive out environmental decay.", true, $religionData.border1)
		"Defense Production Act":
			newPD.buildSelf("Defense Production Act", $religionData.towerControlIcon, "Passed in 1950, the Defense Production Act gave the President sweeping authority to direct industrial production toward national security needs.", true, $religionData.border1)
		"Inland Maritime Expertise":
			newPD.buildSelf("Inland Maritime Expertise", load("res://art assets/finishedAssets/lawIcons/can_shipping_act.png"), "Mastery of the inland waterways. Units starting a turn on Major River or Major Lake tiles gain +1 Movement — the currents work for those who know them.", true, $religionData.border1)
		"First Amendment":
			newPD.buildSelf("First Amendment", $religionData.conservativeOrthodoxyIcon, "Ratified in 1791, the First Amendment prohibits Congress from abridging freedom of speech, religion, the press, or assembly.", true, $religionData.border1)
		"National Research Act":
			newPD.buildSelf("National Research Act", $religionData.sanctionedCadaverResearchIcon, "Passed in 1974, establishing the first federal framework for ethical oversight of biomedical research.", true, $religionData.border1)
		"Height of Buildings Act":
			newPD.buildSelf("Height of Buildings Act", $religionData.templeHeightLawsIcon, "Enacted in 1910, permanently caps Washington D.C. buildings at 130 feet in deference to civic monuments.", true, $religionData.border1)
		# ── Canadian Doctrines ───────────────────────────────────────────────────
		# Nature Conservationists covers CA as well — handled above
		"Canada Council for the Arts Act":
			newPD.buildSelf("Canada Council for the Arts Act", $religionData.midsummerCelebrationsIcon, "Founded in 1957, the Canada Council for the Arts has funded Canadian literature, music, visual art, and performance for generations.", true, $religionData.border1)
		"Republic Lands Act":
			newPD.buildSelf("Republic Lands Act", $religionData.treeOfLifeIcon, "Passed in 1872, opened the Canadian prairies to homestead settlement with 160-acre grants for those willing to farm the land for three years.", true, $religionData.border1)
		"Historic Sites and Monuments Act":
			newPD.buildSelf("Historic Sites and Monuments Act", $religionData.standingStonesIcon, "Formalized federal commemoration of places, persons, and events significant to Canadian history. The law that decides what the Dominion chooses to remember.", true, $religionData.border1)
		"Combines Investigation Act":
			newPD.buildSelf("Combines Investigation Act", $religionData.valuedIdolatryIcon, "Canada's first competition law, enacted in 1889. The Republic regulated markets before it had a central bank.", true, $religionData.border1)
		"Canada Health Act":
			newPD.buildSelf("Canada Health Act", $religionData.healingWatersIcon, "Passed in 1984, established universality, comprehensiveness, accessibility, portability, and public administration as the pillars of Canadian health care.", true, $religionData.border1)
		"National Parks Act":
			newPD.buildSelf("National Parks Act", $religionData.natureSanctuariesIcon, "Canada's national parks system preserves wilderness for the benefit of all Canadians — 'for all time,' in the Act's own words.", true, $religionData.border1)
		"Charter of Rights and Freedoms":
			newPD.buildSelf("Charter of Rights and Freedoms", $religionData.conservativeOrthodoxyIcon, "Entrenched in the Constitution Act of 1982, guarantees fundamental rights to every person in Canada.", true, $religionData.border1)
		"Medical Research Council Act":
			newPD.buildSelf("Medical Research Council Act", $religionData.sanctionedCadaverResearchIcon, "The Medical Research Council funded biomedical science across Canada for three decades, building a tradition of publicly funded discovery.", true, $religionData.border1)
		"National Building Code of Canada":
			newPD.buildSelf("National Building Code of Canada", $religionData.templeHeightLawsIcon, "First published in 1941, sets minimum standards for construction safety across Canada.", true, $religionData.border1)
		"War Measures Act":
			newPD.buildSelf("War Measures Act", $religionData.towerControlIcon, "Enacted in 1914 and invoked three times, granted the Cabinet sweeping emergency powers. Celebrated as decisive and condemned as despotic.", true, $religionData.border1)
		# ── American Icons ───────────────────────────────────────────────────────
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
			newPD.buildSelf("Abraham Lincoln", $religionData.lincolnIcon, "He held the Union together at a cost no one wanted to count. All units: +2 Attack, +2 Defense permanently. Rifle units: −5% manpower loss from all combat. Barracks: +50 Manpower. Courthouse: +1 Mandate.", false, $religionData.border2)
		"Harriet Tubman":
			newPD.buildSelf("Harriet Tubman", $religionData.tubmanIcon, "Conductor of the Underground Railroad, spy for the Union Army. Tubman's patronage grants military bonuses and increases Manpower — freedom is a combat advantage.", false, $religionData.border4)
		"Frederick Douglass":
			newPD.buildSelf("Frederick Douglass", $religionData.douglassIcon, "Words so precise they still cut. Douglass's patronage elevates Libraries, Courthouses, and the uncomfortable power of truth.", false, $religionData.border3)
		"Sitting Bull":
			newPD.buildSelf("Sitting Bull", $religionData.sittingBullIcon, "Hunkpapa Lakota war chief and holy man. Inland waterways run free, and buildings in wooded and river territories produce bonus resources.", false, $religionData.border5)
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
		# ── Canadian Icons ───────────────────────────────────────────────────────
		"John A. Macdonald":
			newPD.buildSelf("John A. Macdonald", $religionData.macdonaldIcon, "Father of Confederation and first Prime Minister of Canada. Built the Dominion through coalition, compromise, and the transcontinental railway.", false, $religionData.border2)
		"George-Étienne Cartier":
			newPD.buildSelf("George-Étienne Cartier", $religionData.cartierIcon, "Macdonald's indispensable partner who brought French Canada into Confederation. Without him, there is no Canada.", false, $religionData.border3)
		"Wilfrid Laurier":
			newPD.buildSelf("Wilfrid Laurier", $religionData.laurierIcon, "Canada's first francophone Prime Minister. His optimism built a country; his compromises haunted it.", false, $religionData.border1)
		"Agnes Macphail":
			newPD.buildSelf("Agnes Macphail", $religionData.macphailIcon, "First woman elected to the Canadian House of Commons. She was told she didn't belong in Parliament. She disagreed, repeatedly.", false, $religionData.border1)
		"Laura Secord":
			newPD.buildSelf("Laura Secord", $religionData.lauraSecordIcon, "Walked 19 miles through enemy lines to warn British forces of an impending attack at Beaver Dams. The garrison held.", false, $religionData.border4)
		"Louis-Hippolyte LaFontaine":
			newPD.buildSelf("Louis-Hippolyte LaFontaine", $religionData.laFontaineIcon, "The architect of responsible government in the Canadas. Proved that self-government was possible without revolution.", false, $religionData.border5)
		"Tommy Douglas":
			newPD.buildSelf("Tommy Douglas", $religionData.tommyDouglasIcon, "Father of Canadian Medicare. Introduced single-payer health insurance over furious opposition. He won. Repeatedly.", false, $religionData.border2)
		"Viola Desmond":
			newPD.buildSelf("Viola Desmond", $religionData.violaDesmondIcon, "Her refusal to leave a segregated cinema section in 1946 became a landmark in Canadian civil rights history. She now appears on the ten-dollar bill.", false, $religionData.border4)
		"Lester B. Pearson":
			newPD.buildSelf("Lester B. Pearson", $religionData.pearsonIcon, "Nobel Peace Prize laureate and architect of UN peacekeeping. Gave Canada the Maple Leaf flag, universal health care, and the Canada Pension Plan.", false, $religionData.border3)
		"Louis Riel":
			newPD.buildSelf("Louis Riel", $religionData.louisRielIcon, "Leader of two Métis resistances and founder of Manitoba. Hanged for treason in 1885. Now considered a Father of Confederation by the Manitoba legislature.", false, $religionData.border5)
		"Emily Murphy":
			newPD.buildSelf("Emily Murphy", $religionData.emilyMurphyIcon, "First female magistrate in the British Empire. Led the Famous Five in the Persons Case of 1929, establishing that women were legally 'persons'.", false, $religionData.border1)
		"Nellie McClung":
			newPD.buildSelf("Nellie McClung", $religionData.nellieMcClungIcon, "Author, suffragist, and member of the Famous Five. One of the most effective political communicators in Canadian history.", false, $religionData.border2)
		"Terry Fox":
			newPD.buildSelf("Terry Fox", $religionData.terryFoxIcon, "Ran 5,373 kilometres across Canada on a prosthetic leg to raise money for cancer research. His Marathon of Hope continues without him.", false, $religionData.border4)
		"Chief Dan George":
			newPD.buildSelf("Chief Dan George", $religionData.chiefDanGeorgeIcon, "Chief of the Tsleil-Waututh Nation and actor who used both platforms to speak with dignity about Indigenous dispossession.", false, $religionData.border5)
		"Buffy Sainte-Marie":
			newPD.buildSelf("Buffy Sainte-Marie", $religionData.buffySaintMarieIcon, "Cree musician and activist whose songs reached audiences that political speeches never could. She was blacklisted by both governments. She kept singing.", false, $religionData.border3)
		"David Suzuki":
			newPD.buildSelf("David Suzuki", $religionData.davidSuzukiIcon, "Geneticist, broadcaster, and Canada's most prominent environmental voice. Five decades translating science into public urgency.", false, $religionData.border1)
		"Roméo Dallaire":
			newPD.buildSelf("Roméo Dallaire", $religionData.romeoDallaireIcon, "Force Commander of UNAMIR during the Rwandan genocide. He witnessed the worst of humanity and refused to stop fighting for peace.", false, $religionData.border2)
		"Thérèse Casgrain":
			newPD.buildSelf("Thérèse Casgrain", $religionData.thereseCasgrainIcon, "Quebec suffragist who led the campaign for women's provincial voting rights — finally granted in 1940. She accepted no timeline she had not agreed to.", false, $religionData.border4)
		"Mary Two-Axe Earley":
			newPD.buildSelf("Mary Two-Axe Earley", $religionData.maryTwoAxeEarleyIcon, "Mohawk activist who fought the discriminatory clause of the Indian Act stripping Indigenous women of status. Bill C-31 corrected it in 1985.", false, $religionData.border5)
		"Pierre Elliott Trudeau":
			newPD.buildSelf("Pierre Elliott Trudeau", $religionData.pierreTrudeauIcon, "Philosopher and Prime Minister who gave Canada the Official Languages Act, the Charter of Rights and Freedoms, and the Constitution Act of 1982.", false, $religionData.border3)
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
	for beliefButton in $BeliefPanel/DoctrineScrollContainer/DoctrineContainer.get_children():
		if beliefButton.bbPurchased != true:
			if beliefButton.bbCost <= player.TotalCulture:
				beliefButton.makePurchaseable()
			else:
				beliefButton.cantAfford()
		else:
			beliefButton.purchased()
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
		match player.churchLevel:
			3:  $BeliefPanel/testLabel.text = "Providence III"
			2:  $BeliefPanel/testLabel.text = "Providence II"
			1:  $BeliefPanel/testLabel.text = "Providence I"
			0:  $BeliefPanel/testLabel.text = "Balanced"
			-1: $BeliefPanel/testLabel.text = "Reason I"
			-2: $BeliefPanel/testLabel.text = "Reason II"
			-3: $BeliefPanel/testLabel.text = "Reason III"
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


# ── Reason side (more Icons than Doctrines → negative churchLevel) ──────────

func _on_faith_1_area_2d_mouse_entered() -> void:
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.append_text(
		"[b]Reason I — The Enlightened Republic[/b]\n\nCivic patronage begins to guide the republic. Icon veneration exceeds doctrinal study by one degree.\n\n[b]Temple output per level:[/b]\n[color=Green]+1[/color] Culture\n[color=Green]+1[/color] Gold\n[color=Green]+1[/color] Happiness"
	)
	$FaithPoints/FaithPointsInfoPanel.visible = true

func _on_faith_1_area_2d_mouse_exited() -> void:
	$FaithPoints/FaithPointsInfoPanel.visible = false


func _on_faith_2_area_2d_mouse_entered() -> void:
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.append_text(
		"[b]Reason II — The Civic Republic[/b]\n\nThe republic leans toward secular civic values. Icons dominate the public imagination over formal doctrine.\n\n[b]Temple output per level:[/b]\n[color=Green]+1[/color] Culture\n[color=Green]+1[/color] Happiness"
	)
	$FaithPoints/FaithPointsInfoPanel.visible = true

func _on_faith_2_area_2d_mouse_exited() -> void:
	$FaithPoints/FaithPointsInfoPanel.visible = false


func _on_faith_3_area_2d_mouse_entered() -> void:
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/FaithPointsInfoPanel/FaithPointsInfoSprite/RichTextLabel.append_text(
		"[b]Reason III — The Secular Republic[/b]\n\nThe republic has embraced civic reason entirely. Icons are cultural heritage; doctrine has no political role.\n\n[b]Temple output per level:[/b]\n[color=Green]+1[/color] Culture"
	)
	$FaithPoints/FaithPointsInfoPanel.visible = true

func _on_faith_3_area_2d_mouse_exited() -> void:
	$FaithPoints/FaithPointsInfoPanel.visible = false


# ── Providence side (more Doctrines than Icons → positive churchLevel) ───────

func _on_church_1_area_2d_mouse_entered() -> void:
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.append_text(
		"[b]Providence I — The Faithful Republic[/b]\n\nFormal doctrine holds a modest lead over iconic devotion. The church counsels but does not command.\n\n[b]Temple output per level:[/b]\n[color=Green]+1[/color] Culture\n[color=Green]+1[/color] Gold\n[color=Green]+1[/color] Mandate"
	)
	$FaithPoints/ChurchPointsInfoPanel.visible = true

func _on_church_1_area_2d_mouse_exited() -> void:
	$FaithPoints/ChurchPointsInfoPanel.visible = false


func _on_church_2_area_2d_mouse_entered() -> void:
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.append_text(
		"[b]Providence II — The Devout Republic[/b]\n\nDoctrinal authority shapes public life. The church's legitimacy reinforces governmental mandate.\n\n[b]Temple output per level:[/b]\n[color=Green]+1[/color] Gold\n[color=Green]+1[/color] Mandate"
	)
	$FaithPoints/ChurchPointsInfoPanel.visible = true

func _on_church_2_area_2d_mouse_exited() -> void:
	$FaithPoints/ChurchPointsInfoPanel.visible = false


func _on_church_3_area_2d_mouse_entered() -> void:
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.clear()
	$FaithPoints/ChurchPointsInfoPanel/ChurchPointsInfoSprite/RichTextLabel.append_text(
		"[b]Providence III — The Orthodox Republic[/b]\n\nThe republic is guided entirely by formal doctrine. Temples are centers of governance as much as worship.\n\n[b]Temple output per level:[/b]\n[color=Green]+1[/color] Gold"
	)
	$FaithPoints/ChurchPointsInfoPanel.visible = true

func _on_church_3_area_2d_mouse_exited() -> void:
	$FaithPoints/ChurchPointsInfoPanel.visible = false


# ── Balance (Doctrines equal Icons → churchLevel 0) ─────────────────────────

func _on_balance_area_2d_mouse_entered() -> void:
	$FaithPoints/BalancePointsInfoPanel/BalancePointsInfoPanel/RichTextLabel.clear()
	$FaithPoints/BalancePointsInfoPanel/BalancePointsInfoPanel/RichTextLabel.append_text(
		"[b]The Balanced Republic[/b]\n\nDoctrines and Icons are in equilibrium. Neither civic reason nor providential doctrine dominates — the republic draws strength from both traditions.\n\n[b]Temple output per level:[/b]\n[color=Green]+1[/color] Culture\n[color=Green]+1[/color] Gold\n[color=Green]+1[/color] Mandate\n[color=Green]+1[/color] Happiness"
	)
	$FaithPoints/BalancePointsInfoPanel.visible = true

func _on_balance_area_2d_mouse_exited() -> void:
	$FaithPoints/BalancePointsInfoPanel.visible = false
