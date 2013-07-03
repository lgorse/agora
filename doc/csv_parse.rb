require 'csv'

file = File.read('/home/lgorse/Desktop/sample.csv')
csv = CSV.parse(file, :headers => false)
csv.each do |row|
	puts row
	attribute = {:account_id => 1, :name => row[1], :email => row[3], :team => row[0], :admin => 0}
	
end