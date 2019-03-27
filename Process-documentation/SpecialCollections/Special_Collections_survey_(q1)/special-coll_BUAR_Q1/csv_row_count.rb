#run this script in the directory where the csv files live
#there should be no files ending in csv that you don't want included in the total

require 'date'
require 'csv'

dir_name = File.basename(Dir.getwd)

def tally_up(files, dir_name)
	total = 0
	outy = dir_name + "_count.txt"
	outfile = open(outy, "wb")
	outfile << "Tally run on " + Date.today.to_s + "\n"
	for file in files
		f = File.open(file, "r")
		count_int = f.readlines.uniq.size
		total += count_int
		outfile << file + " : " + count_int.to_s + "\n"
	end
	outfile << "total: " + total.to_s + "\n"
	outfile.close
	total
end

def get_files()
	files = Dir["*.csv"]
	files
end

#begin procedure

puts "total: " + tally_up(get_files(),dir_name).to_s
