Meteor.startup () ->

    # Just ensure that we loaded the questions.
    if Questions.find().count() == 0
        console.log('NO SE HAN CARGADO LAS PREGUNTAS.')
