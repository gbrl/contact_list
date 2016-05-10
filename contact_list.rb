require 'pp'
require 'pry'
require 'active_support/all'
require_relative 'contact'
require_relative 'color'
require_relative 'validation'

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


  def search
    if @search_term.nil?
      puts "Enter your search term:"
      term = STDIN.gets.chomp
    else
      term = @search_term
    end
    puts "Searching for #{term}..."
    contact = Contact.search(term)
    unless contact.nil?
      puts contact.name
      puts contact.email
      puts contact.phone_primary
      puts contact.phone_secondary
    else
      puts "Sorry, we couldn't find anyone with that search term."
    end
  end


  def show
    if @id.nil?
      list
      puts "Which number would you like to see?"
      id = STDIN.gets.chomp.to_i
    else
      id = @id.to_i
    end
    contacts = Contact.all
    contact = contacts[id - 1]
    if contact.nil?
      puts "Sorry, we couldn't find that person."
    else
      puts contact.name
      puts contact.email
      puts contact.phone_primary
      puts contact.phone_secondary unless contact.phone_secondary.empty?
    end
  end


  def self.display(id)
    contact = Contact.find(id)
    puts contact.name
    puts contact.email
    puts contact.phone_primary
    puts contact.phone_secondary unless contact.phone_secondary.empty?
  end


  def update
    puts "What's the ID of the contact?"
    id = STDIN.gets.chomp
    contact = Contact.find(id)
    contact.update(id, collect_info) if contact
  end


  def list
    contacts = Contact.all
    contacts.each_with_index do |contact,index|
      puts "#{index+1}: #{contact.name} (#{contact.email})"
    end
    puts "---"
    puts "#{contacts.length} records total"
  end


  def collect_info
    info = []
    puts "What's the name of the contact?"
    new_name = STDIN.gets.chomp
    info << new_name
    puts "What's the email of the contact?"
    new_email = STDIN.gets.chomp
    info << new_email

    # EMAIL FORMAT VALIDATION
    unless is_a_valid_email?(new_email)
      puts "The email address is invalid"
      exit
    end

    # EMAIL UNIQUENESS VALIDATION 
    unless is_a_unique_email?(new_email)
      puts "This is a duplicate entry." 
      exit
    end
    
    puts "What's the primary phone number of the contact?"
    new_phone = STDIN.gets.chomp
    info << new_phone
    puts "Is there a secondary phone number? (leave blank for 'no')"
    new_second_phone = STDIN.gets.chomp
    info << new_second_phone
    info
  end


  def delete
    list
    puts "What's the number of the record you want to delete?"
    contact_position = STDIN.gets.chomp.to_i
    contacts = Contact.all
    contact_to_be_destroyed = contacts[contact_position - 1]
    id = contact_to_be_destroyed.id
    contact_to_be_destroyed.destroy(id)
    puts "Contact deleted."
    list
  end


  def new
    info = collect_info
    new_contact = Contact.new(info[0],info[1],info[2],info[3])
    new_contact.save
    new_id = Contact.all.length
    puts puts "Your new entry was added. The ID is #{new_id}."
  end
end

#  R E P L   M E T H O D S 

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


def list_actions
  puts "Welcome to your Contact List Manager."
  puts "Here is a list of available commands: "
  puts "#{green('list')}      - List all contacts"
  puts "#{green('new')}       - Create a new contact"
  puts "#{green('show')}      - Show a contact"
  puts "#{green('delete')}    - Delete a contact"
  puts "#{green('update')}    - Update a contact"
  puts "#{green('search')}    - Search for a contact"
end

def get_action_name
  puts "What would you like to do?"
  action = gets.chomp
  case action
  when "new"
    new
  when "list"
    list
  when "delete"
    delete
  when "update"
    update
  when "show"
    show
  when "find"
    show
  when "search"
    search
  else
    puts "Sorry, we didn't understand your command. Please try again."
  end
end

process_input(ARGV)
