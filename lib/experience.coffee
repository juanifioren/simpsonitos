@Experience =  if Experience? then Experience else {}

@Experience.options =

    EXP_ANSWER_CORRECT: 10
    EXP_EXAM_APPROVED: 50
    
@Experience.getExperienceByLevel = (level) ->

    level = if level > 100 then 100 else Math.floor(level)
    experience = Math.pow(level, 2) * 500

    return experience

@Experience.getLevelByExperience = (experience) ->

        level = Math.floor(Math.sqrt(experience / 500))
        level = if level > 100 then 100 else level

        return level

@Experience.getNextLevelByExperience = (experience) ->

        userLevel = Experience.getLevelByExperience(experience)

        nextLevel = if userLevel == 100 then 100 else userLevel + 1

        return nextLevel