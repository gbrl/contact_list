require 'pp'
require 'pry'
require 'active_support/all'
require_relative 'contact'
require_relative 'color'

def process_input(argv_input)
  @cli_input = argv_input
  @action_name = ""
  @id = nil
  @search_term = nil
  @contacts = []

  if @cli_input.length > 0 
    @action_name = @cli_input[0] 
    if @action_name == 'show'
      @id = @cli_input[1]
    else
      @search_term = @cli_input[1]
    end
  end
  start(@action_name, @id, @search_term)
end

def start(action,id,search_term)
  ContactList.new(action,id,search_term)
end

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList
  def initialize(action,id,search_term)
    if action.length > 0
      @id = id
      @search_term = search_term
      send(action)
    else
      list_actions
      get_action_name
    end
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
    if @search_term.nil?
      puts "Enter your search term:"
      term = STDIN.gets.chomp
    else
      term = @search_term
    end
    contact = Contact.search(term)
    unless contact.nil?
      puts contact[1].name
      puts contact[1].email
      puts contact[1].phone_primary
      puts contact[1].phone_secondary
    else
      puts "Sorry, we couldn't find anyone with that search term."
    end
  end

  def show
    if @id.nil?
      puts "Which ID?"
      id = STDIN.gets.chomp
    else
      id = @id
    end
    contact = Contact.find(id)
    if contact.nil?
      puts "Sorry, we couldn't find that person."
    else
      puts contact.name
      puts contact.email
      puts contact.phone_primary
      puts contact.phone_secondary unless contact.phone_secondary.nil?
    end
  end

  def self.display(id)
    contact = Contact.find(id)
    puts contact.name
    puts contact.email
    puts contact.phone_primary
    puts contact.phone_secondary unless contact.phone_secondary.nil?
  end


  def list
    contacts =  Contact.all
    contacts.each_with_index do |contact,index|
      puts "#{index+1}: #{contact.name} (#{contact.email})"
    end
    puts "---"
    puts "#{contacts.length} records total"
  end

  def new
    puts "What's the name of the new contact?"
    new_name = STDIN.gets.chomp
    puts "What's the email of the new contact?"
    new_email = STDIN.gets.chomp

    # VALIDATION
    is_a_valid_email?(new_email)
    is_a_unique_email?(new_email)
    
    puts "What's the primary phone number of the new contact?"
    new_phone = STDIN.gets.chomp
    puts "Wanna add a secondary phone number? (leave blank for 'no')"
    second_phone = STDIN.gets.chomp
    if new_contact_response.nil?
      puts "Sorry, that contact exists already."
    else
      new_id = Contact.all.length
      puts puts "Your new entry was added. The ID is #{new_id}."
    end
  end

  def is_a_unique_email?(email)
    duplicate = nil
    contacts = Contact.all
    contacts.each_with_index do |contact,index|
      duplicate = index if contact.email == email
    end
    if duplicate
      puts "This is a duplicate entry." 
      ContactList.display(duplicate+1)
      exit
    end
  end

  def is_a_valid_email?(email)
    unless (email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
      puts "The email address you entered is invalid."
      exit
    end
  end


process_input(ARGV)
