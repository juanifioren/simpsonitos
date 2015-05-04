Template.registerHelper 'date', (date, format) ->

	return moment(date).format(format)

Template.registerHelper 'dateFrom', (date) ->

	return moment(date).fromNow(true)

Template.registerHelper 'difficultyToString', (number) ->

    name = Difficulty.types[number]

    return name

Template.registerHelper 'experienceForNextLevel', (experience) ->

	nextLevel = Experience.getNextLevelByExperience(experience)

	nextLevelExp = Experience.getExperienceByLevel(nextLevel)

	expNeeded = nextLevelExp - experience

	return expNeeded

Template.registerHelper 'examResultIcon', (result) ->

	if result == 1
		return 'arrow-up'
	else if result == 0
		return 'minus'
	else
		return 'arrow-down'

Template.registerHelper 'examResultText', (result) ->

	if result == 1
		return 'Has Aprobado'
	else if result == 0
		return 'Mantienes tu nivel'
	else
		return 'Has Desaprobado'
	