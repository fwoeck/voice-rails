if defined?(Spring)
  Spring.after_fork do
    AmqpManager.start
  end
else
  AmqpManager.start
end
