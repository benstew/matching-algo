#Pattern Matching Path program
#Ben Stewart 2/4/2016
#Written in Ruby 2.2.1p85

require 'pry'
# Instructions to run file from Command Line: $ruby pattern_matching_paths.rb input_file

class PatternMatcher
  attr_accessor :patterns, :paths

  def initialize(input_file)
    input_data = open(input_file)
    self.patterns = {}
    self.paths = {}
    process(input_data)
  end

  def process(input_data)
    # Parse data, find best pattern match for each path, display results, print results to output file
    parse(input_data)
    find_best_match
    display_best_matches
    create_output_file
  end

  def parse(input_data)
    # Separating Pattern and Path information from input file
    counter = 0
    input_data.each do |line_item|
      line_item = line_item.chomp
      if line_item.to_i.to_s != line_item && counter == 1
        create_pattern_hash(line_item)
      elsif line_item.to_i.to_s != line_item && counter == 2
        create_path_hash(line_item)
      else
        counter += 1
      end
    end
  end

  def create_pattern_hash(pattern)
    # Creating instance variable hash of all patterns from input file
    pattern = pattern.split(',')
    pattern_length = pattern.length
    if @patterns[pattern_length]
      @patterns[pattern_length].push(pattern)
    else
      @patterns[pattern_length] = [pattern]
    end
  end

  def create_path_hash(path)
    #Instance variable hash of all paths with patterns that match based on length and characters
    path = format(path)
    match_by_length(path)
  end

  def format(path)
    # Removing any leading/trailing slashes from path data
    if path[0] == '/'
      path[0] = ''
    end
    return path.split('/')
  end

  def match_by_length(path)
    # Finding matching patterns based on length
    path_length = path.length
    path_hash_length = @paths.length

    if @patterns.has_key?(path_length)
      matching_patterns = @patterns[path_length]
      match_by_character(matching_patterns, path)
    else
      @paths[path_hash_length + 1] = {path_length => path, "matching" => "NO MATCHES", "best" => ""}
    end
  end

  def match_by_character(matching_patterns, path)
    #Iterating through patterns that have similar lengths and comparing characters
    path_length = path.length
    path_hash_length = @paths.length
    character_match_array = []

    matching_patterns.each do |array|
      score = 0
      array.each_with_index do |character, index|
        if character == path[index] || character == "*"
          score += 1
        end
      end
      score == array.length ? character_match_array << array : "False"
    end
    @paths[path_hash_length + 1] = {path_hash_length => path, "matching" => character_match_array, "best" => ""}
  end

  def find_best_match
    @paths.each do |index, path_hash|
      if path_hash["matching"] == "NO MATCHES"
        path_hash["best"] = "NO MATCH"
      elsif path_hash["matching"].empty?
        path_hash["best"] = "NO MATCH"
      elsif path_hash["matching"].count == 1
        path_hash["best"] = path_hash["matching"]
      else
        path_hash["best"] = multiple_matches(path_hash)
      end
    end
  end

  def multiple_matches(path_hash)
    best_match = []
    best_count = ''
    path_hash["matching"].each do |matching_array|
      asterisk_count = matching_array.count('*')
      if best_count == '' || asterisk_count < best_count
        best_match = matching_array
        best_count = asterisk_count
      elsif asterisk_count == best_count
        best_match = tie_breaker(best_match, matching_array, 0)
      end
    end
    best_match
  end

  def tie_breaker(leader, challenger, counter)
    # Recursive tie breaker to determine the best matching pattern
    if leader[counter] != '*' && challenger[counter] != '*'
      counter += 1
      tie_breaker(leader, challenger, counter)
    elsif leader[counter] != '*'
      return leader
    elsif challenger[counter] != '*'
      return challenger
    end
  end

  def display_best_matches
    @paths.each do |path, path_hash|
      if path_hash["best"] != "NO MATCH"
        puts path_hash["best"].join(',') + "\n"
      else
        puts path_hash["best"] + "\n"
      end
    end
  end

  def create_output_file
    output_file = File.new("output.txt", "w")
    @paths.each do |path, path_hash|
      if path_hash["best"] != "NO MATCH"
        output_file.puts(path_hash["best"].join(',') + "\n")
      else
        output_file.puts(path_hash["best"] + "\n")
      end
    end
    output_file.close
  end

end

input_file = ARGV.first
results = PatternMatcher.new(input_file)
