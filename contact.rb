require 'csv'
require 'pp'
require 'pg'
require_relative 'validation'

class Contact
  attr_accessor :id, :name, :email, :phone_primary, :phone_secondary
  
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
    password: 'wfx8En3oykmS2__gOkW7j_zLBG')
  end


  def self.all 
    all_contacts = []
    puts 'Working...'
    query_results = Contact.connection.exec('SELECT * FROM contacts;')
    query_results.each do |contact|
      all_contacts << Contact.new(contact["name"], contact["email"], contact["phone_primary"], contact["phone_secondary"], contact["id"])
    end
    all_contacts
  end


  def save
    Contact.connection.exec_params('INSERT INTO contacts (name, email, phone_primary, phone_secondary) VALUES ($1, $2, $3, $4) RETURNING id', [@name, @email, @phone_primary, @phone_secondary])
  end


  def update(id, attributes)
    Contact.connection.exec_params("UPDATE contacts SET name = $1, email = $2, phone_primary = $3, phone_secondary = $4 WHERE id = $5::int;", [attributes[0].to_s, attributes[1].to_s, attributes[2].to_s, attributes[3].to_s, id])
  end


  def destroy(id)
    results = Contact.connection.exec_params('DELETE FROM contacts WHERE id = $1::int;', [id])
  end


  def self.validate_entry(name, email, phone_primary, phone_secondary)
    Contact.create(name, email, phone_primary, phone_secondary)
  end


  def self.find(id)
    results = Contact.connection.exec_params('SELECT * FROM contacts WHERE id = $1::int;', [id])
    unless results.num_tuples.zero?
      contact = results[0]
      contact = Contact.new(contact["name"],contact["email"],contact["phone_primary"],contact["phone_primary"])
      contact.id = id
      contact
    else
      return
    end
  end
  

  def self.search(term)
    if is_a_valid_email?(term)
      results = Contact.connection.exec_params('SELECT * FROM contacts WHERE email = $1 ;', [term])
    elsif term.is_a? Integer
      results = Contact.connection.exec_params('SELECT * FROM contacts WHERE id = $1 ;', [term])
    else
      results = Contact.connection.exec_params('SELECT * FROM contacts WHERE name LIKE (\'%\' || $1 || \'%\');', [term])
    end
    unless results.num_tuples.zero?
      contact = results[0]
      contact = Contact.new(contact["name"],contact["email"],contact["phone_primary"],contact["phone_primary"])
    else
      puts "No pre-existing records found in database..."
    end
  end

end
