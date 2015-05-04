@Facebook =  if Facebook? then Facebook else {}

@Facebook.settings =

    APP_ID: Meteor.settings.public.facebook.appid
    GRAPH_URL: 'https://graph.facebook.com/v2.2/'
    GRAPH_VERSION: 'v2.2'

@Facebook.getPicture = (facebookId, callback) ->

    url = 
        Facebook.settings.GRAPH_URL +
        facebookId +
        '/picture?format=json&redirect=false&width=200&height=200'

    return HTTP.get(url, callback)
