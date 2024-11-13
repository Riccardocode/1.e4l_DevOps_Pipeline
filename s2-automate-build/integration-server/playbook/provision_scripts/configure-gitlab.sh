# Replace external url
sudo sed -i "s|external_url 'http://gitlab.example.com'|external_url 'http://192.168.56.9/gitlab'|g" /etc/gitlab/gitlab.rb

# Replace port and uncomment the line
sudo sed -i "s|# unicorn\['port'\] = 8080|unicorn['port'] = 8088|g" /etc/gitlab/gitlab.rb

# Reconfigure and restart GitLab
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart unicorn
sudo gitlab-ctl restart

# Set root password (script that I created)
sudo gitlab-rails runner /home/vagrant/provision_scripts/gitlab-set-root-password.rb

# Create a second user (script that I created)
sudo gitlab-rails runner /home/vagrant/provision_scripts/gitlab-user-create.rb
