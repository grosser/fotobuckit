class User < ActiveRecord::Base
  validates :username, :uniqueness => true, :length => 4..20, :format => /^[-a-zA-Z_\d]+$/
  validates :email, :uniqueness => true, :length => 4..100, :format => /^.+@.+\..+$/
  validates :password, :length => 6..100

  belongs_to :bucket
end
