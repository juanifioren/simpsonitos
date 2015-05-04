Accounts.onCreateUser (options, user) ->

    options =
        profile:
            facebookId: user.services.facebook.id
            firstName: user.services.facebook.first_name
            lastName: user.services.facebook.last_name
            email: user.services.facebook.email

    user.profile = options.profile
    user.experience = 0

    return user