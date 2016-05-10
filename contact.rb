require 'csv'
require 'pp'
require 'pg'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email, :phone_primary, :phone_secondary
  
  def initialize(name,email,phone_primary,phone_secondary,id=nil)
    @id              = id
    @name            = name
    @email           = email
    @phone_primary   = phone_primary
    @phone_secondary = phone_secondary
  end

  def self.connection
    PG.connect(
    host: 'ec2-54-163-230-90.compute-1.amazonaws.com',
    dbname: 'd74a2i8lmqp2et',
    user: 'ucmocwstzaxduv',
    password: 'wfx8En3oykmS2__gOkW7j_zLBG'
    )
  end

  def self.all 
    all_contacts = []
    puts 'Finding contacts...'
    query_results = Contact.connection.exec('SELECT * FROM contacts;')
    Contact.connection.close

    query_results.each do |contact|
      all_contacts << Contact.new(contact["name"], contact["email"], contact["phone_primary"], contact["phone_secondary"])
    end
    all_contacts
  end

  def self.create(name, email, phone_primary, phone_secondary)
    Contact.connection.exec_params('INSERT INTO contacts (name, email, phone_primary, phone_secondary) VALUES (1, $2, $3, $4) RETURNING id', [contact.name, contact.email, contact.phone_primary, contact.phone_secondary]) do |results|
      @id = results[0]["id"]
    end
    Contact.connection.close
  end

  def self.validate_entry(name, email, phone_primary, phone_secondary)
    Contact.create(name, email, phone_primary, phone_secondary)
  end


  def self.find(id)
    results = Contact.connection.exec_params('SELECT * FROM contacts WHERE id = $1;', [id])
    Contact.connection.close
    contact = results[0]
    contact = Contact.new(contact["name"],contact["email"],contact["phone_primary"],contact["phone_primary"])
  end
  

  def self.find_by_email(email)
    results = Contact.connection.exec_params('SELECT * FROM contacts WHERE email = $1;', [email])
    Contact.connection.close
    contact = results[0]
    contact = Contact.new(contact["name"],contact["email"],contact["phone_primary"],contact["phone_primary"])
  end
  

  def self.find_by_name(name)
    results = Contact.connection.exec_params('SELECT * FROM contacts WHERE name = $1;', [name])
    Contact.connection.close
    contact = results[0]
    contact = Contact.new(contact["name"],contact["email"],contact["phone_primary"],contact["phone_primary"])
  end
  

  def self.search(term)
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
