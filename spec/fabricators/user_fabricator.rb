Fabricator(:user) do
  email { Forgery(:internet).email_address }
  first_name 'First name'
  mid_name 'Middle name'
  last_name 'Last name'
end
