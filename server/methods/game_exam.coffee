Meteor.methods

    startGameExam: () ->

        # Find an exam that has not been finished yet.
        unfinishedExam = Exams.findOne({ userId: @userId, finishedAt: { $exists: false } })
        
        if unfinishedExam
            Exams.remove({ _id: unfinishedExam._id })

        # Get the user level of difficulty.
        level = Meteor.call('getUserDifficulty', @userId)

        # Create the new exam.
        newExamObject =
            difficulty: level
            userId: @userId
            createdAt: new Date
            questionsAnswered: 0
            correctAnswers: 0
        examId = Exams.insert(newExamObject)
        exam = Exams.findOne(_id: examId)

        if not exam
            throw new Meteor.Error('invalid_exam', 'Hubo un error al crear un examen.')

        question = Question.getRandomQuestion(exam.difficulty)

        if not question
            throw new Meteor.Error('invalid_question', 'No se pudo cargar una pregunta.')

        return result =
            exam: exam
            question: question

    sendAnswerGameExam: (examId, questionId, answerNumber) ->

        exam = Exams.findOne({ _id: examId, userId: @userId }) 
        question = Questions.findOne({ _id: questionId }, { fields: { correctAnswer: 1 } })

        if not exam or not question
            throw new Meteor.Error('invalid_exam_or_question', 'Hubo un error enviando la respuesta. Examen y/o pregunta invalida.')

        isAnswerCorrect = (question.correctAnswer == answerNumber)
        timeIsOver = false

        if 0 <= exam.questionsAnswered < Exam.settings.QUESTIONS_PER_EXAM
            Exams.update({ _id: examId }, { $inc: { questionsAnswered: 1, correctAnswers: (if isAnswerCorrect then 1 else 0) } })
            # Was the last question?.
            if exam.questionsAnswered == (Exam.settings.QUESTIONS_PER_EXAM - 1)
                question = false
                seconds = moment().diff(moment(exam.createdAt), 'seconds')

                if not (seconds > 120)
                    # Finish the exam.
                    Exams.update({ _id: examId }, { $set: { finishedAt: new Date } })

                    exam.questionsAnswered += 1
                    exam.correctAnswers += if isAnswerCorrect then 1 else 0

                    # Increment user experience.
                    expToIncrement = 0
                    # Per answer correct.
                    expToIncrement += Experience.options.EXP_ANSWER_CORRECT * exam.correctAnswers
                    # If exam approved.
                    if Exam.settings.APPROVAL_NOTE <= Exam.getNote(exam)
                        expToIncrement += Experience.options.EXP_EXAM_APPROVED

                    Meteor.users.update({ _id: @userId }, { $inc: { experience: expToIncrement } })
                else
                    timeIsOver = true
            else 
                question = Question.getRandomQuestion(exam.difficulty)
            # Retrieve a new updated version of the exam.
            exam = Exams.findOne({ _id: examId, userId: @userId })
        else
            throw new Meteor.Error('invalid_exam', 'Hubo un error enviando la respuesta.')

        return result =
            exam: exam
            isAnswerCorrect: isAnswerCorrect
            question: question
            timeIsOver: timeIsOver
