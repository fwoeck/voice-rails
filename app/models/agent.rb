class Agent

  attr_accessor :id, :name, :languages, :skills, :activity, :visibility, :call_id,
                :locked, :availability, :idle_since, :mutex, :unlock_scheduled


  def handle_message
    ActiveRecord::Base.connection_pool.with_connection {
      if user = User.where(name: name).first
        user.send_user_update_to_clients
      end
    }
  end


  def language=(langs)
    @languages = langs
  end


  def skill=(skills)
    @skills = skills
  end
end
