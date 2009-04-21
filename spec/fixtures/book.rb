class Book
  include DataMapper::Resource

  property :id,      Serial
  property :title,   String

  belongs_to      :library
#  has 1,          :author
#  has n,          :borrowings
#  has n,          :borrowers,         :through => :borrowings

end
