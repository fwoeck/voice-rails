class DatasetSerializer < ActiveModel::Serializer

  attributes :id, :active_call_count, :queued_call_count, :dispatched_call_count, :pre_queued_call_count,
                  :queued_calls_delay_max, :queued_calls_delay_avg, :queued_calls, :dispatched_calls,
                  :max_delay, :average_delay
end
