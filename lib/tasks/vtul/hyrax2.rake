require 'net/ldap'

namespace :data_science do
  desc 'Create default roles.'
  task add_roles: :environment do
    ['admin'].each do |role_name|
      Role.find_or_create_by({name: role_name})
      puts "Created role '#{role_name}'."
    end
  end

  desc 'Add initial users.'
  task  populate_users: :environment do
    ldap = Net::LDAP.new(host: 'directory.vt.edu')
    ldap.bind
    treebase = 'ou=People,dc=vt,dc=edu'
    ldap_attributes = {email: :mail, display_name: :displayname, department: :department}
    #Address is available as :postaladdress as well.

    IO.foreach('user_list.txt') do |email|
      email = email.strip
      filter = Net::LDAP::Filter.eq('mail', email)
      results = ldap.search(base: treebase, filter: filter)
      if results.count == 1
        user = User.find_or_initialize_by({email: email})

        result = results[0]
        ldap_attributes.each do |user_attr, ldap_attr|
          user_attr = user_attr.to_sym
          if result.respond_to?(ldap_attr)
            user[user_attr] = result[ldap_attr][0].force_encoding('UTF-8')
          end
        end
        user.password = "123456"
        new_user = user.id.nil?
        user.save!
        if new_user
          puts "Created '#{email}'."
        else
          puts "Updated '#{email}'."
        end
      elsif results.count > 1
        puts "Searching for '#{email}' did not return a unique result."
      else
        puts "Searching for '#{email}' did not return any results."
      end
    end
  end

  desc 'Upgrade users to admins.'
  task upgrade_users: :environment do
    admin_role = Role.find_by({name: 'admin'})

    IO.foreach('admin_list.txt') do |email|
      user = User.find_by({email: email})

      if !user.nil?
        user.roles << admin_role
        user.roles = user.roles.uniq
        user.save!
        puts "#{email} upgraded."
      else
        puts "#{email} user does not exist in system."
      end
    end
  end

end
