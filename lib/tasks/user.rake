namespace :user do
  desc "Create an initial admin user with id(0) and password 'Qu4Mund0'"
  task initial_admin_user: :environment do
    if User.where('id = ? AND nick = ?', 0, 'admin').blank?
      begin
        User.create!([{ id: 0,
                        nick: 'admin',
                        email: 'example@example.tld',
                        password: 'Qu4Mund0' }])
        p "Created user 'admin' with id '0'."
      rescue
        raise "\n\nUnable to ensure existence of adminuser with id 0!\n" +
          "Please check manually!\n\n"
      end
    end
    puts "Ensured there is a admin user with id 0."
  end

end
