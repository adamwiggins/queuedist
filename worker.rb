require 'mq'

Signal.trap('INT') { AMQP.stop{ EM.stop }; exit }
Signal.trap('TERM'){ AMQP.stop{ EM.stop }; exit }
at_exit { AMQP.stop { EM.stop } }

worker = ARGV.shift.to_i

system "clear"
puts "=== Worker #{worker}"

AMQP.start(:host => 'localhost') do

	amq = MQ.new
	amq.queue('work').subscribe(:ack => true) do |h, msg|
		puts msg.to_i
		s = worker == 1 ? 1 : 10
		puts "sleeping for #{s}"
		sleep s
		puts "done, sending ack"
		h.ack
	end

end
