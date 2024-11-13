# Create or find the user
user = User.find_or_initialize_by(username: "ProjectOwner")
user.email = "projectowner@company.com"
user.name = "Project Owner"
user.password = "projectowner"
user.password_confirmation = "projectowner"
user.skip_confirmation!  # Skips email confirmation if needed
user.save!

# Check for errors in saving the user
if user.persisted?
  puts "User '#{user.username}' created or found successfully."
else
  puts "Error creating user: #{user.errors.full_messages.join(', ')}"
end

# Create a personal access token
if user.persisted?
  token = PersonalAccessToken.new(
    user: user,
    name: 'default',
    scopes: ['api']
  )
  
  # Set token string if needed, otherwise GitLab will auto-generate one
  token.set_token('ypCa3b2bz3o5nvsixwPP')  # Use only if a specific token is needed
  token.save!

  # Display token for verification
  if token.persisted?
    puts "Personal access token created: #{token.token}"
  else
    puts "Error creating token: #{token.errors.full_messages.join(', ')}"
  end
end

