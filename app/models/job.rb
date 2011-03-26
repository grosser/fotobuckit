class Job < ActiveRecord::Base
  validates :title, :length => 1..200, :uniqueness => {:scope => :user_id}
  validates :folder, :length => 1..200, :uniqueness => {:scope => :user_id}

  belongs_to :user
  has_many :s3_files, :dependent => :destroy
end
