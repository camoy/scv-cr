data = Marshal.load(File.read(ARGV[0]))

puts "# SCV *GT* Progress Report"

data.each_with_index do |h, k|
  puts "## #{h[:name]}"
  puts ""
  puts "### Performance"
  puts "```"
  puts (File.read((Dir.glob [Dir.home + "/.local/share/gtp-measure/#{k+1}/*.out"])[0]))
  puts "```"
  puts ""
  puts "### Errors"
  puts "```"
  puts h[:error]
  puts "```"
  puts "### Output"
  puts "```"
  puts h[:output]
  puts "```"
  puts ""
  puts "### Blames"
  puts "```"
  puts h[:blames]
  puts "```"
  puts ""
end
