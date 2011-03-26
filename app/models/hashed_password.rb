module HashedPassword
  def self.included(base)
    base.class_eval do
      attr_accessor :password, :password_confirmation
      validates :password, :length => 6..100, :confirmation => true, :allow_blank => true, :if => :password_validation_required?
      before_save :hash_password, :if => :password_validation_required?

      def self.authorize(name, password)
        user = find_by_username(name) || find_by_email(name)
        user if user and user.hash_string(password) == user.hashed_password
      end
    end
  end

  def hash_password
    self.hashed_password = hash_string(password)
  end

  def password_validation_required?
    new_record? or password.present?
  end

  def hash_string(string)
    salt_length = 40
    self.salt ||= ActiveSupport::SecureRandom.hex(salt_length).first(salt_length)
    Digest::SHA2.hexdigest("#{salt}--#{string}")
  end
end
