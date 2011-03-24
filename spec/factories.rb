Factory.define(:bucket) do |f|
  f.name 'test-bucket'
  f.access_key_id 'a' * 20
  f.secret_access_key 'a' * 40
end

Factory.define(:user) do |f|
  f.username{ "user_#{rand(999999)}" }
  f.email{ "user_#{rand(999999)}@dcxcc.de" }
  f.password 'my_password'
  f.association :bucket
end
