@Question =  if Question? then Question else {}

@Question.getRandomQuestion = (difficulty) ->

    try
        questionsIds = Questions.find({ difficulty: difficulty }, { fields: { _id: 1 } }).fetch()
        question = questionsIds[Math.floor(Math.random() * questionsIds.length)]
        question = Questions.findOne(question, { fields: { correctAnswer: 0 } })

        # We also wants to disorder the answers.
        question.answers = _.shuffle(question.answers)
    catch
        question = undefined

    return question