require 'json'

class Dataset

  include ActiveModel::Serialization

  def id; 1; end


  def active_call_count
    pre_queued_call_count + queued_call_count + dispatched_call_count
  end


  def pre_queued_call_count
    Dataset.pre_queued_calls.size
  end


  def queued_call_count
    Dataset.queued_calls.size
  end


  def dispatched_call_count
    Dataset.dispatched_call_pairs.keys.size
  end


  def self.all
    [Dataset.new]
  end


  def self.raw_calls
    $redis.keys("#{Rails.env}.call.*").map { |k|
      JSON.parse $redis.get(k) || '{}'
    }
  end


  def self.pre_queued_calls
    incoming_calls.select { |c| !c['Skill'] && !c['DispatchedAt'] }
  end


  def self.queued_calls
    incoming_calls.select { |c| c['Skill'] && !c['DispatchedAt'] }
  end


  def self.incoming_calls
    raw_calls.select { |c|
      !c['CallTag'] && !c['Hungup'] && (
        c['Extension'].blank? || c['Extension'] == '100'
      )
    }
  end


  def self.dispatched_calls
    raw_calls.select { |c| c['CallTag'] && !c['Hungup'] }
  end


  def self.dispatched_call_pairs
    dispatched_calls.group_by { |c| c['CallTag'] }
  end
end
