# A yaml item (i.e. a single uploaded/pasted file)
class Item < ActiveRecord::Base
  serialize :value
  
  before_save :ensure_key
  
  def key
    key = read_attribute(:key)
    key ||= self.key = Item.random_key
  end
  
  def self.random_key
    SecureRandom.urlsafe_base64(8)
  end
  
  private
  def ensure_key
    self.key  # Forces assignment
  end
end
