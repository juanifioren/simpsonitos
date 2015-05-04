@Facebook =  if Facebook? then Facebook else {}

# Load the Facebook JS SDK.
# https://developers.facebook.com/docs/javascript/quickstart/v2.2#loading
window.fbAsyncInit = () ->
    FB.init
        appId: Facebook.settings.APP_ID
        xfbml: true
        version: Facebook.settings.GRAPH_VERSION
`
(function(e,t,n){var r,i=e.getElementsByTagName(t)[0];if(e.getElementById(n))return;r=e.createElement(t);r.id=n;r.src="//connect.facebook.net/es_LA/sdk.js";i.parentNode.insertBefore(r,i)})(document,"script","facebook-jssdk")
`
