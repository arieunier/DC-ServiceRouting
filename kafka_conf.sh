heroku kafka:consumer-groups:create my-consumer-group --app mb-mvp-cometdlistener
heroku kafka:topics:create accountscreation --app mb-mvp-cometdlistener
heroku kafka:topics:create notifications --app mb-mvp-cometdlistener
heroku kafka:topics:create bulkservice --app mb-mvp-cometdlistener