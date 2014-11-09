namespace :voice do

  desc 'Create the main admin user'
  task seed_admin_user: :environment do
    User.seed_admin_user
  end
end
