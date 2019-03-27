
#files to be added
#run this script in Q1>YEAR>Process1
#subdirectories should be 1-10
require 'date'

def remove_quotes(infile,outfile)
	quotedFile = File.read(infile)
	encQuotedFile = quotedFile.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
	unquotedFile = encQuotedFile.gsub /"/, ''
	outFile = open(outfile, "wb")
	outFile.write(unquotedFile)
	outFile.close
end

def tally_up(files)
	total = 0
	outfile = open("arl_tally.txt", "wb")
	outfile << "Tally run on " + Date.today.to_s + "\n"
	for file in files
		outfile << file + "\n"
		datum = File.read(file)
		datum = datum.split("\n")
		datum.each do |d|
			if d.include? "set1+set3" or  d.include? "set2" or d.include? "set3"
				outfile << d + "\n"
				d = d.split(" ")
				puts d[0].to_i
				total += d[0].to_i
			end
		end
	end
	outfile << total
	outfile.close
	total
end

def get_files()
	#for arl/YEARS/Q1/Process1 directory
	files = Dir["**/*17_18_q1_count.txt"]
	#for local machine
	#files = Dir["data/**/*15_16_q1_count.txt"]
	files
end

#begin procedure
puts "total: " + tally_up(get_files()).to_s
