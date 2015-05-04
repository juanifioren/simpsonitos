@Facebook =  if Facebook? then Facebook else {}

@Facebook.getFriends = (facebookId, accessToken) ->

    url = Facebook.settings.GRAPH_URL+facebookId+'/friends?access_token='+accessToken

    result = HTTP.get(url)
    friendsList = result.data.data

    return friendsList
