@Difficulty =  if Difficulty? then Difficulty else {}

@Difficulty.settings =
    
    DEGRADE_IN_DAYS: 15

@Difficulty.types =

    '1': 'Principiante'
    '2': 'Aficionado'
    '3': 'Fanático'
    '4': 'Experto'
    '5': 'Maniático'

@Difficulty.getByExam = (exam) ->

    result = Exam.getResult(exam)

    difficulty = Difficulty.controlValue(exam.difficulty + result)

    # Degrade the difficulty 1 level every N days.
    daysFromNow = moment().diff(moment(exam.finishedAt), 'days')
    levelsLosed = Math.floor(daysFromNow / Difficulty.settings.DEGRADE_IN_DAYS)

    difficulty = Difficulty.controlValue(difficulty - levelsLosed)

    return difficulty

@Difficulty.controlValue = (difficulty) ->

    if difficulty > 4
        difficulty = 4
    else if difficulty < 1
        difficulty = 1

    return difficulty
