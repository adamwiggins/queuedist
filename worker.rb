require 'mq'

Signal.trap('INT') { AMQP.stop{ EM.stop }; exit }
Signal.trap('TERM'){ AMQP.stop{ EM.stop }; exit }
at_exit { AMQP.stop { EM.stop } }

worker = ARGV.shift.to_i

system "clear"
puts "=== Worker #{worker}"

AMQP.start(:host => 'localhost') do

	amq = MQ.new
	queue = amq.queue('work')

	EM.add_periodic_timer(1) do
		queue.pop(:nowait => false) do |msg|
			next unless msg
			puts "Got: #{msg}"
			s = worker == 1 ? 1 : 10
			puts "sleeping for #{s}"
			sleep s
			puts "done"
		end
	end

end
