@Exam =  if Exam? then Exam else {}

@Exam.settings =
    
    QUESTIONS_PER_EXAM: 15
    APPROVAL_NOTE: 8
    REGULAR_NOTE: 6

@Exam.getNote = (exam) ->

    if exam.questionsAnswered == 0
        note = 0.0
    else
        note = (exam.correctAnswers / Exam.settings.QUESTIONS_PER_EXAM) * 10
        note = note.toFixed(1)

    return note

@Exam.getResult = (exam) ->

    # Return the result of a particular exam:
    #   (1)     is approved
    #   (0)     is regular
    #   (-1)    is disapproved

    note = Exam.getNote(exam)

    if Exam.settings.APPROVAL_NOTE <= note
        result = 1
    else if Exam.settings.REGULAR_NOTE <= note < Exam.settings.APPROVAL_NOTE
        result = 0
    else
        result = -1

    return result

@Exam.addData = (exam) ->

    exam.note = Exam.getNote(exam)
    # Show if the user level up or not.
    exam.result = Exam.getResult(exam)
    # Show the difficulty reached after the exam.
    exam.nextDifficulty = Difficulty.controlValue(exam.difficulty + exam.result)

    return exam
