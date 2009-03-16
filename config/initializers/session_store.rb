# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_lockout_session',
  :secret      => '7fe9ed65eb65d9e4e8a60bb2a6ece5cb6c44914ea982b17f3e935192ad5890452fa9a8e28ac0e6fb1f0e1bb706e1b3ac8464a0a8da5fd56b74f8fecb396f8545'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
