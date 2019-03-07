require "open3"

directory = "benchmarks"
benchmarks = [
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

results = {}


# reset for run
`git checkout #{directory}`
`git clean -f #{directory}`

# run
benchmarks.each do |benchmark|
  Dir.chdir("#{directory}/#{benchmark}/typed") do
    # copy dependencies
    `cp -r ../both/* .` if File.exists? "../both"

    # initialize results hash for this benchmark
    results[benchmark] = {}

    # consider all TR source files
    sources = `find . -name "*.rkt"`.split("\n")

    # generate contracts and record results
    #sources.each do |source|
      _, error, status = Open3.capture3("raco explicit-contracts -p -i #{sources.join(' ')}")
      sources.each do |source|
        result = results[benchmark][source] = {}
        print "#{benchmark}/#{source} (contracts): "
        puts(if status == 0 then
          result[:contract] = "Success"
        else
          result[:contract] = "Failure: #{error}"
        end)
      end
    #end

    # verify contracts
    sources.each do |source|
      result = results[benchmark][source]

      if result[:contract] != "Success" then
        result[:verify] = "Failure: no contracts"
        next
      end

      _, error, status = Open3.capture3("env Z3_LIB=/usr/lib raco scv #{source}")
      print "#{benchmark}/#{source} (verify): "
      puts(if status == 0 then
        result[:verify] = "Success"
      else
        result[:verify] = "Failure: \n```\n#{error}\n```\n"
      end)
    end
  end
end

def hash_to_csv(hash)
  #output = ["benchmark,file,contracts,verify"]
  output = []
  hash.each do |benchmark, files|
    output << "# #{benchmark}\n"
    files.each do |file, result|
      output << ["## `#{file}`", result[:verify]].join("\n")
    end
  end
  output.join("\n\n")
end

File.open("benchmarks.md", "w") do |handle|
  handle << hash_to_csv(results)
end
