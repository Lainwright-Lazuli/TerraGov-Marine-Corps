/datum/codex_category/reagents/Initialize()

	for(var/thing in subtypesof(/datum/reagent))
		var/datum/reagent/reagent = thing
		if(initial(reagent.hidden_from_codex))
			continue
		var/chem_name = lowertext(initial(reagent.name))
		var/datum/codex_entry/entry = new( \
		 _display_name = "[chem_name] (chemical)", \
		 _associated_strings = list("[chem_name] pill"), \
		 _lore_text = "[initial(reagent.description)] It apparently tastes of [initial(reagent.taste_description)].")

		var/list/production_strings = list()
		for(var/react in GLOB.chemical_reactions_list[thing])

			var/datum/chemical_reaction/reaction = react

			if(reaction.hidden_from_codex)
				continue

			var/list/reactant_values = list()
			for(var/reactant_id in reaction.required_reagents)
				var/datum/reagent/reactant = reactant_id
				reactant_values += "[reaction.required_reagents[reactant_id]]u [lowertext(initial(reactant.name))]"

			if(!reactant_values.len)
				continue

			var/list/catalysts = list()
			for(var/catalyst_id in reaction.required_catalysts)
				var/datum/reagent/catalyst = catalyst_id
				catalysts += "[reaction.required_catalysts[catalyst_id]]u [lowertext(initial(catalyst.name))]"

			var/datum/reagent/result = reaction.results
			if(catalysts.len)
				production_strings += "- [jointext(reactant_values, " + ")] (catalysts: [jointext(catalysts, ", ")]): [reaction.results]u [lowertext(initial(result.name))]"
			else
				production_strings += "- [jointext(reactant_values, " + ")]: [reaction.results]u [lowertext(initial(result.name))]"

		if(production_strings.len)
			if(!entry.mechanics_text)
				entry.mechanics_text = "It can be produced as follows:<br>"
			else
				entry.mechanics_text += "<br><br>It can be produced as follows:<br>"
			entry.mechanics_text += jointext(production_strings, "<br>")

		SScodex.entries_by_string[entry.display_name] = entry