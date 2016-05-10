def is_a_unique_email?(thing)
  contact = Contact.search(thing)
  contact.nil?
end

def is_a_valid_email?(thing)
  thing =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
end