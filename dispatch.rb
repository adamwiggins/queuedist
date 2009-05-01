require 'mq'

Signal.trap('INT') { AMQP.stop{ EM.stop } }
Signal.trap('TERM'){ AMQP.stop{ EM.stop } }
at_exit { AMQP.stop { EM.stop } }

AMQP.start(:host => 'localhost') do

	amq = MQ.new
	EM.add_periodic_timer(0.1) do
		if $run
			AMQP.stop
			EM.stop
		end

		(1..10).each do |count|
			amq.queue('work').publish(count.to_s)
		end

		$run = 1
	end

end
