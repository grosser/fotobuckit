Factory.define(:user) do |f|
  f.username{ "user_#{rand(999999)}" }
  f.email{ "user_#{rand(999999)}@dcxcc.de" }
  f.bucket{ "test-bucket-#{rand(999999)}" }
  f.access_key_id 'a' * 20
  f.secret_access_key 'a' * 40
  # my_password
  f.password_digest '$2a$10$MzV4HL/qF9/e3G2AOMw8Zes3o55x0vJqnb0thy4OHRp.htRGXnD4m'
end

Factory.define(:job) do |f|
  f.title{ "title_#{rand(999999)}" }
  f.folder{ "folder_#{rand(99999)}" }
  f.customer "Sony"
  f.description "asdas asd asd asdds"
  f.association :user
end
