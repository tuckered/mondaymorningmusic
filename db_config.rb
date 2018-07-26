require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'mondaymusic'
}

ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)