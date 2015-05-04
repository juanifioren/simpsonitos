# Config

Router.configure
    layoutTemplate: 'Layout'
    loadingTemplate: 'Loading'
    notFoundTemplate: 'NotFoundError'

# Hooks

userMustBeLogin = () ->
    if not Meteor.user() and not Meteor.loggingIn()
        @render('UserNotLoginError')
    else
        @next()

# Add routes that don't need the user to be logged in
Router.onBeforeAction userMustBeLogin,
    except: [
        'Game'
        'Home'
        'Terms'
        'User'
    ]

Router.map ->

    @route 'Game',

        path: '/games'

    @route 'GameExam',

        path: '/games/exam'

        waitOn: () ->
            Meteor.subscribe('exams')
        
        onStop: () ->
            # Session variables cleanup.
            delete Session.keys['userDifficulty']

    @route 'Home',

        path: '/'

    @route 'Terms',

        path: '/terms'

    @route 'User',
        
        path: '/user/:facebookId'
        
        onBeforeAction: () ->
            Meteor.call 'getUserByFacebookId', @params.facebookId, (error, result) ->
                if error
                    Session.set('user', false)
                    return
                Session.set('user', result)
                
                Facebook.getPicture result.profile.facebookId, (error, result) ->
                    user = Session.get('user')
                    user.image = result.data.data
                    Session.set('user', user)
                
                Meteor.call 'getUserDifficulty', result._id, (error, result) ->
                    user = Session.get('user')
                    user.difficulty = result
                    Session.set('user', user)
                
                Meteor.call 'getUserLastExams', result._id, (error, result) ->
                    # Add extra info to the last exams.
                    for exam in result
                        exam = Exam.addData(exam)
                    user = Session.get('user')
                    user.lastExams = result
                    Session.set('user', user)
                
                Meteor.call 'getCurrentUserFriends', (error, result) ->
                    Session.set('currentUserFriends', result)
            
            @next()
        onStop: () ->
            # Session variables cleanup.
            delete Session.keys['user']
            # Enable all page tooltips.
            $('[data-toggle="tooltip"]').tooltip()

    @route 'Friends',
        
        path: '/friends'
        
        onBeforeAction: () ->
            Meteor.call 'getCurrentUserFriends', (error, result) ->
                
                if result
                    Session.set('currentUserFriends', result)
            
            @next()
        onStop: () ->
            # Session variables cleanup.
            delete Session.keys['user']
