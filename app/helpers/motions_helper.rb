module MotionsHelper

	def expiration_times
		from_time = Time.now
		expiration_times = [
			[distance_of_time_in_words(from_time, from_time + 1.minute), Time.now.since(1.minute)],
		 [distance_of_time_in_words(from_time, from_time + 1.hour), Time.now.since(1.hour)],
		 [distance_of_time_in_words(from_time, from_time + 6.hours), Time.now.since(6.hours)],
		 [distance_of_time_in_words(from_time, from_time + 1.day), Time.now.since(1.day)],
		 [distance_of_time_in_words(from_time, from_time + 3.days), Time.now.since(3.days)],
		 [distance_of_time_in_words(from_time, from_time + 1.week), Time.now.since(1.week)]
		]
	end
	
end
