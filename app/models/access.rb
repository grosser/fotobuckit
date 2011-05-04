class Access < ActiveRecord::Base
  belongs_to :user
  belongs_to :job

  before_create :generate_token

  validate do
    errors.add(:job) if job and job.user_id != user_id
  end
  validates_presence_of :name

  def period=(time)
    if time.to_i == 0
      self.valid_to = self.valid_from = nil
    else
      self.valid_to = time.to_i.from_now
      self.valid_from = Time.now.utc
    end
  end

  def unlimited?
    not valid_to and not valid_from
  end

  private

  def generate_token
    self.token = ActiveSupport::SecureRandom.hex(20) # 20 -> 40 chars
  end
end
