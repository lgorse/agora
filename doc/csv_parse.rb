require 'csv'

file = File.read('/home/lgorse/www/agora/doc/new.csv')
csv = CSV.parse(file, :headers => false, :col_sep => "\t")
csv.each do |row|
	puts row[3]
	attribute = {:account_id => 1, :name => row[1], :email => row[3], :team => row[0], :admin => 0}
	
end