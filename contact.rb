require 'csv'
require 'pp'
require 'pg'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email, :phone_primary, :phone_secondary
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name,email,phone_primary,phone_secondary,id=nil)
    @id              = id
    @name            = name
    @email           = email
    @phone_primary   = phone_primary
    @phone_secondary = phone_secondary
  end

  @@conn = PG.connect(
  host: 'ec2-54-163-230-90.compute-1.amazonaws.com',
  dbname: 'd74a2i8lmqp2et',
  user: 'ucmocwstzaxduv',
  password: 'wfx8En3oykmS2__gOkW7j_zLBG'
  )

  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all 
      all_contacts = []
      puts 'Finding contacts...'
      query_results = @@conn.exec('SELECT * FROM contacts;')
      # puts 'Closing the connection...'
      @@conn.close
      query_results.each do |contact|
        all_contacts << Contact.new(contact["name"], contact["email"], contact["phone_primary"], contact["phone_secondary"])
      end
      all_contacts
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email, phone_primary, phone_secondary)
      new_contact = Contact.create(name, email, phone_primary, phone_secondary)
      @@conn.exec_params('INSERT INTO contacts (name, email, phone_primary, phone_secondary) VALUES (1, $2, $3, $4) RETURNING id', [contact.name, contact.email, contact.phone_primary, contact.phone_secondary]) do |results|
        @id = results[0]["id"]
      end
      # puts 'Closing the connection...'
      @@conn.close
    end

    def validate_entry(name, email, phone_primary, phone_secondary)
      Contact.create(name, email, phone_primary, phone_secondary)
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
