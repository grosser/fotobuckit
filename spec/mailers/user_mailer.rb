require 'spec_helper'

describe UserMailer do
  it "can send registration_confirmation" do
    UserMailer.registration_confirmation(Factory(:user))
  end
end
