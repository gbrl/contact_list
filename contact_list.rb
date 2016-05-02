require 'pp'
require 'pry'
require 'csv'
require 'active_support/all'
require_relative 'contact'
require_relative 'modules'

def start(action)
  ContactList.new(action)
end

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList
  def initialize(action)
    if action.length > 0
      send(action)
    else
      list_actions
      get_action_name
    end
  end

  def list_actions
    puts "Welcome to your Contact List Manager."
    puts "Here is a list of available commands: "
    puts "#{green('new')}    - Create a new contact"
    puts "#{green('list')}   - List all contacts"
    puts "#{green('show')}   - Show a contact"
    puts "#{green('search')} - Search for a contact"
  end


  def get_action_name
    puts "What would you like to do?"
    action = gets.chomp
    case action
    when "new"
      new
    when "list"
      list
    when "show"
      show
    when "search"
      search
    else
      puts "Sorry, we didn't understand your command. Please try again."
    end
  end

  def search
    puts "Which email or name?"
    term = gets.chomp
    contact = Contact.search(term)
    if contact.length > 1
      puts "#{contact[0]+1}. #{contact[1].name}"
    else
      puts contact[0]
    end
  end

  def show
    puts "Which ID?"
    id = gets.chomp
    contact = Contact.find(id)
    pp contact
  end

  def list
    puts "Listing..."
    contacts =  Contact.all
    contacts.each_with_index do |contact,index|
      puts "#{index+1}. #{contact.name} (#{contact.email})"
    end
    puts "#{contacts.length} records total."
  end

  def new
    puts "What's the name of the new contact?"
    new_name = gets.chomp
    puts "What's the email of the new contact?"
    new_email = gets.chomp
    puts "What's the phone-number of the new contact?"
    new_phone = gets.chomp
    new_contact = Contact.create(new_name,new_email,new_phone)
  end
  
end

cli_input = ARGV
action_name = ""
action_name = cli_input[0] if cli_input.length > 0 
@contacts = []
start(action_name)


# validate email regex /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/
