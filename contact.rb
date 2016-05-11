require 'csv'
require 'pp'
require 'pg'
require 'active_record'

class Contact < ActiveRecord::Base
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates :email, presence: true

  ActiveRecord::Base.establish_connection(
    adapter:  "postgresql",
    host:     "ec2-54-163-230-90.compute-1.amazonaws.com",
    username: "ucmocwstzaxduv",
    password: "wfx8En3oykmS2__gOkW7j_zLBG",
    database: "d74a2i8lmqp2et"
  )  

  def self.search(term)
    results = 'none'
    if term =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      puts "Searching by email..."
      results = Contact.where("email LIKE '%#{term}%'")
    else
      puts "Searching by name..."
      results = Contact.where("name LIKE '%#{term}%'")
    end
    results
  end

end
