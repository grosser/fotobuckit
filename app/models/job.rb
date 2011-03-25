class Job < ActiveRecord::Base
  validates :title, :length => 1..200
  validates :folder, :length => 1..200, :uniqueness => :user_id

  has_many :s3_files, :dependent => :destroy
end
