Meteor.publish 'exams', () ->

    # Publish all the exams for the current user.
    return Exams.find(userId: @userId)