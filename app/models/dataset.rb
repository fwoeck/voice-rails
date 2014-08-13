require 'json'

class Dataset

  include ActiveModel::Serialization

  def id; 1; end


  def initialize
  end


  def active_call_count
    pre_queued_call_count + queued_call_count + dispatched_call_count
  end


  def pre_queued_call_count
    pre_queued_calls.size
  end


  def queued_call_count
    queued_calls.size
  end


  def dispatched_call_count
    dispatched_call_pairs.keys.size
  end


  def raw_calls
    @memo_raw_calls ||= $redis.keys("#{Rails.env}.call.*").map { |k|
      JSON.parse $redis.get(k) || '{}'
    }
  end


  def pre_queued_calls
    incoming_calls.select { |c| !c['Skill'] && !c['DispatchedAt'] }
  end


  def queued_calls
    incoming_calls.select { |c| c['Skill'] && !c['DispatchedAt'] }
  end


  def incoming_calls
    raw_calls.select { |c|
      !c['CallTag'] && !c['Hungup'] && (
        c['Extension'].blank? || c['Extension'] == '100'
      )
    }
  end


  def dispatched_calls
    raw_calls.select { |c| c['CallTag'] && !c['Hungup'] }
  end


  def dispatched_call_pairs
    dispatched_calls.group_by { |c| c['CallTag'] }
  end


  def self.all
    [Dataset.new]
  end
end
