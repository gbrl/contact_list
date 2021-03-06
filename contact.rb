require 'csv'
require 'pp'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email, :phone, :second_phone
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name,email,phone,second_phone)
    @name         = name
    @email        = email
    @phone        = phone
    @second_phone = second_phone
  end

  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      contacts = []
      csv_data = CSV.read('contacts.csv')
      csv_data.each_with_index do |entry,index|
        contacts << Contact.new(entry[0],entry[1],entry[2],entry[3])
      end
      contacts
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email, *phones)
      new_id = nil
      CSV.open("contacts.csv", "ab+") do |csv|
          csv << [name,email,phones[0],phones[1]]
          new_id = Contact.all.length
      end
      new_id
    end

    def validate_entry(name, email, *phones)
      Contact.create(name, email, *phones)
    end

    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      id = id.to_i
      contacts = Contact.all
      contact = nil
      contact = contacts[id-1] unless contacts[id-1].nil?
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      contacts = Contact.all
      person_data = nil
      contacts.each_with_index do |contact,index|
        if (contact.name.include? term) || (contact.email.include? term)
          person_data = []
          person_data[0] = index
          person_data[1] = contact 
        end
      end
      person_data
    end



  end
end
