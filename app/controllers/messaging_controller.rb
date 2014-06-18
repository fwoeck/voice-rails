class MessagingController < ApplicationController
  include ActionController::Live

  def events
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SseEvent.new(response.stream)

    begin
      time_stamp = AmiEvent.last.try(:created_at) || Time.now

      loop do
        new_events = AmiEvent.where(:created_at.gt => time_stamp).to_a
        time_stamp = new_events.last.created_at unless new_events.empty?

        new_events.each { |evt| sse.write(evt.payload) }
        sleep 1
      end
    rescue IOError
    ensure
      sse.close
    end
  end
end
