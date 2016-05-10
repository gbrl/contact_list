def is_a_unique_email?(thing)
  duplicate = nil
  contacts = Contact.all
  contacts.each_with_index do |contact,index|
    duplicate = index if contact.email == thing
  end
  if duplicate
    true
  else
    false
  end
end

def is_a_valid_email?(thing)
  if (thing =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
    true
  else
    false
  end
end