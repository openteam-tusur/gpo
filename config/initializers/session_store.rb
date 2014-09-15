Gpo::Application.config.session_store :redis_store, :servers => Settings['session_store.url'], :domain => Settings['app.domain']
