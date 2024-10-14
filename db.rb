require 'dm-core'
require 'dm-migrations'
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/song.db")
#create a model (table will be call in plural)
class Song
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :lyrics, Text
  property :length, Integer
  property :release, Date
end
DataMapper.finalize 
