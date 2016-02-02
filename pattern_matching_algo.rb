require 'pry'

class PatternFinder
  attr_accessor :patterns, :paths

  def initialize(input_file)
    data= open(input_file)

    self.patterns = {}
    self.paths = {}
    list_splitter(data)
  end

  def list_splitter(data)
    counter = 0

    data.each do |line|
      line = line.chomp
      if line.to_i.to_s != line && counter == 1
        pattern_hash_builder(line)
      elsif line.to_i.to_s != line && counter == 2
        path_hash_builder(line)
      else
        counter += 1
      end
    end
    # puts "Patterns: #{self.patterns}"
    # puts "Paths: #{self.paths}"
    best_match
    display
  end

  def pattern_hash_builder(line)
    line = line.split(',')
    line_length = line.length
    if @patterns[line_length]
      @patterns[line_length].push(line)
    else
      @patterns[line_length] = [line]
    end
  end

  def path_hash_builder(line)
    line = reformat(line)
    match_by_length(line)
  end

  def reformat(line)
    if line[0] == '/'
      line[0] = ''
    end
    return line.split('/')
  end

  def match_by_length(line)
    line_length = line.length
    paths_length = @paths.length

    if @patterns.has_key?(line_length)
      matching_patterns = @patterns[line_length]
      match_by_character(matching_patterns, line)
    else
      @paths[paths_length + 1] = {line_length => line, "matching" => "NO MATCHES", "best" => ""}
    end
  end

  def match_by_character(matching_patterns, line)
    line_length = line.length
    paths_length = @paths.length
    character_match_array = []

    matching_patterns.each do |array|
      score = 0
      array.each_with_index do |character, index|
        if character == line[index] || character == "*"
          score += 1
        end
      end
      score == array.length ? character_match_array << array : "false"
    end
    @paths[paths_length + 1] = {line_length => line, "matching" => character_match_array, "best" => ""}
  end

  def best_match
    @paths.each do |index, path|
      if path["matching"] == "NO MATCHES"
        path["best"] = "NO MATCH"
      elsif path["matching"].count == 1
        path["best"] = path["matching"]
      else
        path["best"] = multiple_matches(path)
      end
    end
  end

  def multiple_matches(path)
    leader = []
    best_count = 100

    path["matching"].each do |array|
      asterisk_count = array.count('*')
      if asterisk_count < best_count
        leader = array
        best_count = asterisk_count
      elsif asterisk_count == best_count
        # tie_breaker
      end
    end
    leader
  end

  def display
    @paths.each do |path, value|
      if value["best"] != "NO MATCH"
        puts value["best"].join(',')
      else
        puts value["best"]
      end
    end
  end


end

input_file = ARGV.first
results = PatternFinder.new(input_file)
