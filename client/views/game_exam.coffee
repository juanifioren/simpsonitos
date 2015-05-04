Template.GameExam.events

    'click #startGameExam': (event) ->

        event.preventDefault()

        # Show loading dimmer.
        $('#message .content .center').html(Blaze.toHTML(Template.GameExam_Loading))
        $('#message').fadeIn('slow')

        Meteor.apply 'startGameExam', [], wait: true, (error, result) ->

            if error
                $('#message').fadeOut('slow')
                alert(error.reason)
                return

            # Render the first question.
            renderTemplate Template.GameExam_Question,
                exam: Exam.addData(result.exam)
                question: result.question

            # Set the current exam id in the session.
            Session.set('examId', result.exam._id)

            Session.set('time', 90)
            Session.set('interval', Meteor.setInterval(timeLeft, 1000))

            # Now we can hide the dimmer.
            $('#message').fadeOut('slow')

Template.GameExam.helpers

    userDifficulty: () -> Session.get('userDifficulty')

Template.GameExam.created = () ->

    Meteor.call 'getUserDifficulty', Meteor.userId(), (error, result) ->
        if not error
            Session.set('userDifficulty', result)

Template.GameExam.destroyed = () ->

    $('#exam-container').remove()

    Meteor.clearInterval Session.get('interval')

Template.GameExam_Question.events

    'click .answer': (event) ->

        $(event.target).addClass('active')

        # Show loading dimmer.
        $('#message .content .center').html(Blaze.toHTML(Template.GameExam_Loading))
        $('#message').fadeIn('slow')

        # Data we need for sending the answer.
        examId = Session.get('examId')
        questionId = $('#question').data('questionid')
        answerNumber = parseInt($(event.target).data('answernumber'))

        Meteor.apply 'sendAnswerGameExam', [examId, questionId, answerNumber], wait: true, (error, result) ->

            if error
                $('#message').fadeOut('slow')
                alert(error.reason)
                return

            if result.isAnswerCorrect
                $('#message .content .center').html(Blaze.toHTML(Template.GameExam_CorrectAnswer))
            else
                $('#message .content .center').html(Blaze.toHTML(Template.GameExam_WrongAnswer))

            if result.question
                renderTemplate Template.GameExam_Question,
                    exam: Exam.addData(result.exam)
                    question: result.question
            else
                Meteor.clearInterval Session.get('interval')
                # Show results!. Last question was answered.
                renderTemplate Template.GameExam_Result,
                    exam: Exam.addData(result.exam)
                    timeIsOver: result.timeIsOver

            # Now we can hide the dimmer.
            $('#message').fadeOut('slow')

Template.GameExam_Question.helpers

    time: () -> Session.get('time')

Template.GameExam_Result.events

    'click #playAgain': (event) ->

        renderTemplate Template.GameExam

Template.GameExam_Result.destroyed = () ->

    $('#exam-container').remove()

renderTemplate = (template, data) ->
    # Re-render the template.
    $('#exam-container').remove()
    Blaze.renderWithData(template, data, $('#main-container')[0], $('#message')[0])

timeLeft = ->
    time = Session.get('time')
    if  time > 0
        time--
        Session.set('time', time)
    else
        Meteor.clearInterval Session.get('interval')

        renderTemplate Template.GameExam_Result,
            timeIsOver: true
