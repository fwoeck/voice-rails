require 'json'

class Dataset

  include ActiveModel::Serialization

  def id; 1; end


  def active_call_count
    40 + rand(30)
  end


  def self.all
    [Dataset.new]
  end
end
