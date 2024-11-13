user = User.find_by(id: 1)
if user
  user.password = 'adminadmin'
  user.password_confirmation = 'adminadmin'
  user.save!
  puts "Root password updated successfully."
else
  puts "Root user not found."
end
