Template.User.helpers

    user: () -> Session.get('user')

Template.User.rendered = () ->

    # Init all the tooltips of the page.
    $('[data-toggle="tooltip"]').tooltip()
