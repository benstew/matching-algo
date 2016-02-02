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
    puts "Patterns: #{self.patterns}"
    puts "Paths: #{self.paths}"
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
    best_pattern = {}
  end

  def star_counter(pattern)

  end


end

input_file = ARGV.first
results = PatternFinder.new(input_file)
