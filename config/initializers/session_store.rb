# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Mashup_session',
  :secret      => '59c3364447b783b4dc74d6e0be23f72c85695fefed3cd623cf2a355011f7e36686fcdf6462c3f9bab8be6122dccd8a48bc2091750f9c9252581c3392a19622ae'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
