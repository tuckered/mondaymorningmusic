class User < ActiveRecord::Base
  has_secure_password
  has_many :likes
  has_many :songs, :through => :likes
end