require 'csv'
require 'pp'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name,email,phone)
    @name = name
    @email = email
    @phone = phone
    # TODO: Assign parameter values to instance variables.
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      @return = []
      contacts = CSV.read('contacts.csv')
      contacts.each_with_index do |contact,index|
        next if index == 0
        new_contact = Contact.new(contact[0],contact[1],contact[2])
        @return << new_contact
      end
      @return
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email, phone)
      CSV.open("contacts.csv", "ab+") do |csv|
        csv << [name,email,phone]
      end
      puts "Thank you! Your contact was added."
    end
    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      id = id.to_i
      contact = "Sorry, we couldn't find that person."
      contacts = Contact.all
      contact = contacts[id-1] unless contacts[id-1].nil?
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
    end

  end
end