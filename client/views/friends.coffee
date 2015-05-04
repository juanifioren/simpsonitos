Template.Friends.events

    'click #inviteFacebookFriends': (event) ->

        event.preventDefault()

        FB.ui
            method: 'apprequests'
            message: '¿Te gustan Los Simpsons? Únete a Simpsonitos y diviertete con tus amigos!'
        , (response) ->
            # NOTE: Maybe show some message near the button.
            # Ex: "Le acabas de enviar una solicitud a ..."
            #console.log(response)

Template.Friends.helpers

    currentUserFriends: () -> Session.get('currentUserFriends')

    profilePictureUrl: (facebookId) ->

        Facebook.getPicture facebookId, (error, result) ->
            if result
                Session.set('picture_'+facebookId, result.data.data.url)

        return Session.get('picture_'+facebookId)