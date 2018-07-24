# pry session with your data models loaded
# each of the tables you've got in the sql file

require 'pry'
require_relative 'db_config'
require_relative 'models/song'
require_relative 'models/comment'
require_relative 'models/user'

binding.pry