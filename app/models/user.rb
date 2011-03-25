class User < ActiveRecord::Base
  validates :username, :uniqueness => true, :length => 4..20, :format => /^[-a-zA-Z_\d]+$/
  validates :email, :uniqueness => true, :length => 4..100, :format => /^.+@.+\..+$/
  validates :password, :length => 6..100

  belongs_to :bucket

  def self.authorize(name, password)
    user = find_by_username(name) || find_by_email(name)
    user if user and user.password == password
  end
end
