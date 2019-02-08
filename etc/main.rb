benchmarks = [
  "acquire",
  "dungeon",
  # "forth",
  "fsm",
  "fsmoo",
  "gregor",
  # "jpeg",
  "kcfa",
  # "lnm",
  # "mbta",
  # "morsecode",
  # "quadT",
  # "quadU",
  "sieve" ,
  "snake",
  "suffixtree",
  "synth",
  "take5",
  "tetris",
  "zombie"#,
  # "zordoz"
]

benchmarks = ["sieve"]
results = {}

benchmarks.each do |benchmark|
  Dir.chdir("benchmarks/#{benchmark}/typed") do
    # copy dependencies
    `cp -r ../both/* .` if File.exists? "../both"

    # initialize results hash for this benchmark
    results[benchmark] = {}

    # consider all TR source files
    sources = `grep "#lang typed/racket" * -rl`.split("\n") 

    # generate contracts and record results
    sources.each do |source|
      result = results[benchmark][source] = {}
      error = `raco explicit-contracts -i #{source}`
      print "#{source} (contract): "
      puts(if $?.success? then
        result[:contract] = "Success"
      else
        result[:contract] = "Failure: #{error}"
      end)
    end

    # verify contracts
    sources.each do |source|
      result = results[benchmark][source]

      if result[:contract] != "Success" then
        result[:verify] = "Failure: no contracts"
        next
      end

      error = `env Z3_LIB=/usr/lib raco scv #{source}`
      print "#{source} (verify): "
      puts(if $?.success? then
        result[:verify] = "Success"
      else
        result[:verify] = "Failure: #{error}"
      end)
    end
  end
end

# reset for another run
`git checkout benchmarks`

def hash_to_csv(hash)
  output = ["benchmark,file,contracts,verify"]
  hash.each do |benchmark, files|
    files.each do |file, result|
      output << [benchmark, file, result[:contract], result[:verify]].join(",")
    end
  end
  output.join("\n")
end

File.open("benchmarks.csv", "w") do |handle|
  handle << hash_to_csv(results)
end
