gems = ARGV[0] 
raise "Error: Need to specify gems are first argument!" if gems.nil?
gems = gems.split(",")
gems.each do |gem|
  begin
    unless require gem
      print "#{gem}"
      exit 1
    end
  rescue => e
    puts "Probably attempted to require a gem that doesn't exist!: #{gem}"
  end 
end
exit 0
