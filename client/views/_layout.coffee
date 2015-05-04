Template.Layout.events

    'click #loginWithFacebook': (event) ->

        event.preventDefault()

        Meteor.loginWithFacebook
            requestPermissions: ['email', 'user_friends']
            , (error) ->
                # NOTE: Maybe show some message.

    'click #logout': (event) ->

        event.preventDefault()

        Meteor.logout (error) ->
            # NOTE: Maybe show some message.