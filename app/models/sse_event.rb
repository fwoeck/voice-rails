class SseEvent

  def initialize(io)
    @io = io
  end

  def write(object, options = {})
    options.each { |k,v| @io.write "#{k}: #{v}\n" }
    @io.write "data: #{object}\n\n"
  end

  def close
    @io.close
  end
end
