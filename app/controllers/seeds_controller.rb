class SeedsController < ApplicationController

  skip_before_filter :authenticate_user!


  def agents
    count.times { Agent.create_fake }
    render text: 'OK'
  end


  def customers
    count.times { Customer.create_fake }
    render text: 'OK'
  end


  private

  def count
    @memo_count ||= (params[:count] || 1).to_i
  end
end
