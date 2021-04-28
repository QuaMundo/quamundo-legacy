# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create an initial admin user with id 0 and default password
if User.where('id = ? AND nick = ?', 0, 'admin').blank?
  begin
    User.create!([{ id: 0,
                    nick: 'admin',
                    email: 'example@example.tld',
                    password: 'Qu4Mund0' }])
    Rails.logger.info "Created user 'admin' with id '0'."
  rescue StandardError
    raise "\n\nUnable to ensure existence of adminuser with id 0!\n" \
          "Please check manually!\n\n"
  end
end
Rails.logger.info 'Ensured there is a admin user with id 0.'
