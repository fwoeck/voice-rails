class CallSerializer < ActiveModel::Serializer

  attributes :channel1, :channel2, :id, :language, :skill, :hungup, :caller_id

  def id
    object.target_id
  end
end
