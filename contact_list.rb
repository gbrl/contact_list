
require 'pry'
require 'active_support/all'
require 'csv'
require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList
  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
end


@customers = CSV.read('contacts.csv')

# ARGV.each do |x|
#   puts x
# end

@action_name = ARGV[0]
# @action_id = ARGV[1]
# @first_name
# @last_name
# @email
# @phone_number 
# date_added
# last_modified


class Contact
  
end

def list_all
  CSV.foreach('contacts.csv') do |row|
    puts row.inspect
  end
end

method(@action_name).call


# validate email regex /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/
