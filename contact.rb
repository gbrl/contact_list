require 'csv'
require 'pp'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email, :phone
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name,email,phone)
    @name = name
    @email = email
    @phone = phone
  end

  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      contacts = []
      csv_data = CSV.read('contacts.csv')
      csv_data.each_with_index do |entry,index|
        contacts << Contact.new(entry[0],entry[1],entry[2])
      end
      contacts
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email, phone)
      CSV.open("contacts.csv", "ab+") do |csv|
        csv << [name,email,phone]
      end
    end
    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      id = id.to_i
      contact = "Sorry, we couldn't find that person."
      contacts = Contact.all
      contact = contacts[id-1] unless contacts[id-1].nil?
      contact
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      contacts = Contact.all
      person_data = []
      contacts.each_with_index do |contact,index|
        if contact.name.match(term) || contact.email.match(term)
          person_data[0] = index
          person_data[1] = contact 
        else 
          person_data[0] = "Sorry, we couldn't find anyone with that search term."
        end
      end
      person_data
    end

  end
end
