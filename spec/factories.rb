Factory.define(:user) do |f|
  f.username{ "user_#{rand(999999)}" }
  f.email{ "user_#{rand(999999)}@dcxcc.de" }
  f.password 'my_password'
  f.bucket{ "test-bucket-#{rand(999999)}" }
  f.access_key_id 'a' * 20
  f.secret_access_key 'a' * 40
end

Factory.define(:job) do |f|
  f.title{ "title_#{rand(999999)}" }
  f.folder{ "folder_#{rand(99999)}" }
  f.customer "Sony"
  f.description "asdas asd asd asdds"
  f.association :user
end
