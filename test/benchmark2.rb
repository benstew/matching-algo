#Second Benchmark test w/out character hash
require 'pry'

# Instructions to run file from Command Line: $ruby pattern_matching_paths.rb input_file

class PatternMatcher
  attr_accessor :patterns, :paths, :beginning_time, :end_time

  def initialize(input_file)
    self.beginning_time = Time.now
    input_data = open(input_file)
    self.patterns = []
    self.paths = {}
    process(input_data)
  end

  def process(input_data)
    parse(input_data)
    find_best_match
    puts "Time elapsed #{(@end_time - @beginning_time)*1000} milliseconds"
    # display_best_matches
  end

  def parse(input_data)
    # Separating Pattern and Path information from input file
    counter = 0
    input_data.each do |line_item|
      line_item = line_item.chomp
      if line_item.to_i.to_s != line_item && counter == 1
        create_pattern_array(line_item)
      elsif line_item.to_i.to_s != line_item && counter == 2
        create_path_hash(line_item)
      else
        counter += 1
      end
    end
  end

  def create_pattern_array(pattern)
    pattern = pattern.split(',')
    pattern_length = pattern.length
    @patterns << pattern
  end

  def create_path_hash(path)
    #Instance variable hash of all paths with patterns that match based on length and characters
    path = format(path)
    match_by_character(path)
  end

  def format(path)
    # Removing any leading/trailing slashes from path data
    if path[0] == '/'
      path[0] = ''
    end
    return path.split('/')
  end

  def match_by_character(path)
    #Iterating through patterns that have similar lengths and comparing characters
    length = @paths.length
    character_match_array = []

    @patterns.each do |pattern|
      score = 0
      pattern.each_with_index do |character, index|
        if character == path[index] || character == "*"
          score += 1
        end
      end
      score == pattern.length ? character_match_array << pattern : "False"
    end
    @paths[length] = {"matching" => character_match_array, "best" => ""}
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
    @end_time = Time.now
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
    if leader == nil
      return challenger

  elsif leader.length < challenger.length
      return leader
    elsif leader[counter] != '*' && challenger[counter] != '*'
      counter += 1
      tie_breaker(leader, challenger, counter)
    elsif leader[counter] != '*'
      return leader
    elsif challenger[counter] != '*'
      return challenger
    end
  end

end

input_file = ARGV.first
results = PatternMatcher.new(input_file)
