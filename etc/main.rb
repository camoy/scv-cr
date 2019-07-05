require "open3"

#################################################################################

directory = "~/wrk/gtp-benchmarks/benchmarks"
gtp_dir = "~/.local/share/gtp-measure"
fakebin = __dir__ + "/fakebin"
f = __dir__ + "/result.dat"
b = __dir__ + "/blames.dat"

all_benchmarks = [
  "acquire",
  "dungeon",
  "forth",
  "fsm",
  "fsmoo",
  "gregor",
  "jpeg",
  "kcfa",
  "mbta",
  "morsecode",
  "sieve",
  "snake",
  "suffixtree",
  "synth",
  "take5",
  "tetris",
  "zombie",
  "zordoz"
]

benchmarks = [
#  "forth",
#  "gregor",
#  "morsecode",
  "sieve"#,
#  "snake",
#  "suffixtree",
#  "synth",
#  "tetris",
#  "zombie"
]

#################################################################################

results = []

envs = { "PLTSTDERR" => "error info@gtp-measure",
         "PLT_COMPILED_FILE_CHECK" => "exists"
       }
env_str = envs.map { |k, v| "#{k}=\"#{v}\"" }.join " "

# clean
`rm -rf #{gtp_dir}`

# run
benchmarks.each_with_index do |benchmark, k|
  benchmark_dir = "#{directory}/#{benchmark}"
  puts "Starting #{benchmark}"
  File.open(b, "w") do |handle|
    handle.write(Marshal.dump([]))
  end
  `raco gtp-measure -c 0 -i 1 -S 1 -R 1 --bin #{fakebin} --setup #{benchmark_dir}`
  output, error, _ = Open3.capture3("#{env_str} raco gtp-measure --resume #{gtp_dir}/#{k+1}")
  result = {}
  result[:name] = benchmark
  result[:output] = output
  result[:error] = error
  result[:blames] = Marshal.load(File.read(b))
  results << result
  puts "Finished #{benchmark}"
  File.open(f, "w") do |handle|
    handle.write(Marshal.dump(results))
  end
end
