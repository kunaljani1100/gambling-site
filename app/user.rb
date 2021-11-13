require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/user.db")

# User model
class User
  include DataMapper::Resource

  property :userId, String, key: true, unique_index: true
  property :password, String, required: true
  property :firstName, String, required:true
  property :lastName, String, required: true
  property :totalWinnings, Integer, required: true
  property :totalLosses, Integer, required: true
  property :totalProfit, Integer, required: true

end
DataMapper.finalize 
