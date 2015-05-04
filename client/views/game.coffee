Template.Game.events

    'click #startGameExam': (event) ->

        event.preventDefault()

        Router.go('GameExam')
