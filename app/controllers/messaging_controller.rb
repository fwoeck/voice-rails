class MessagingController < ApplicationController
  include ActionController::Live

  def events
    response.headers['Content-Type'] = 'text/event-stream'
    sse = Sse.new(response.stream)

    begin
      loop do
        sse.write({message: "#{params[:message]}"})
        sleep 1
      end
    rescue IOError
    ensure
      sse.close
    end
  end
end
