Meteor.methods
    
    getUserByFacebookId: (facebookId) ->

        user = Meteor.users.findOne({ 'profile.facebookId': facebookId }, { fields: { 'profile.email': 0, services: 0 } })

        if not user
            throw new Meteor.Error(500, 'No existe el perfil de usuario.')

        # Add extra info to the user object.
        # NOTE: maybe add a helper for templates so it is calculated
        #       on client side.
        user.level = Experience.getLevelByExperience(user.experience)

        return user

    getUserDifficulty: (userId) ->
        
        if not userId
            throw new Meteor.Error('invalid_user_id', 'Se necesita en id del usuario para obtener su nivel.')

        # Find the last exam finished.
        lastExam = Exams.findOne({ userId: userId, finishedAt: { $exists: true } }, { sort: { createdAt: -1 } })

        if not lastExam
            difficulty = 1
        else
            difficulty = Difficulty.getByExam(lastExam)

        return difficulty

    getUserLastExams: (userId) ->

        exams = Exams.find({ userId: userId, finishedAt: { $exists: true } }, { limit: 5, sort: { createdAt: -1 } }).fetch()

        return exams

    getCurrentUserFriends: () ->

        user = Meteor.user()

        facebookId = user.services.facebook.id
        accessToken = user.services.facebook.accessToken

        friendList = Facebook.getFriends(facebookId, accessToken)

        for friend in friendList
            user = Meteor.users.findOne({ 'profile.facebookId': friend.id }, { fields: { 'experience': 1, 'services.resume.loginTokens': 1 } })
            lastLogin = user.services.resume.loginTokens.pop()

            # Add extra info to the friend object.
            friend.experience = user.experience
            friend.loginAt = if lastLogin then lastLogin.when else false

        return friendList
