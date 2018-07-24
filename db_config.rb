require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'mondaymusic'
}

ActiveRecord::Base.establish_connection(options)