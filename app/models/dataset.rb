require 'json'

class Dataset

  include ActiveModel::Serialization
  attr_reader :dataset


  def id; 1; end

  def initialize
    @dataset = get_dataset
  end


  def active_call_count
    dataset.fetch('active_call_count', 0)
  end


  def pre_queued_call_count
    dataset.fetch('pre_queued_call_count', 0)
  end


  def queued_call_count
    dataset.fetch('queued_call_count', 0)
  end


  def dispatched_call_count
    dataset.fetch('dispatched_call_count', 0)
  end


  def queued_calls_delay_max
    dataset.fetch('queued_calls_delay_max', 0)
  end


  def queued_calls_delay_avg
    dataset.fetch('queued_calls_delay_avg', 0)
  end


  def queued_calls
    dataset.fetch('queued_calls', {})
  end


  def dispatched_calls
    dataset.fetch('dispatched_calls', {})
  end


  def max_delay
    dataset.fetch('max_delay', {})
  end


  def average_delay
    dataset.fetch('average_delay', {})
  end


  private

  def get_dataset
    JSON.parse(
      $redis.get("#{Rails.env}.numbers-dataset") || '{}'
    )
  end


  def self.all
    [Dataset.new]
  end
end
