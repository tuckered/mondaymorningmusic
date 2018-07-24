class Song < ActiveRecord::Base
  has_many :comments
end