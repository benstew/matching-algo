require 'pry'

class TestData
attr_accessor :pattern_data, :path_data

  def initialize
    create_input_file
  end

  def pattern_data
    @pattern_data = []
    1000.times do |value|
      test1 = rand(10).to_s.chars.map(&:to_i)
      index1 = rand(1)
      test2 = rand(100).to_s.chars.map(&:to_i)
      index2 = rand(3)
      test3 = rand(1000).to_s.chars.map(&:to_i)
      index3 = rand(4)
      test4 = rand(10000).to_s.chars.map(&:to_i)
      index4 = rand(5)
      test5 = rand(100000).to_s.chars.map(&:to_i)
      index5 = rand(6)

      @pattern_data << test1.insert(index1,'*').join(',')
      @pattern_data << test2.insert(index2,'*').join(',')
      @pattern_data << test3.insert(index3,'*').join(',')
      @pattern_data << test4.insert(index4,'*').join(',')
      @pattern_data << test5.insert(index5,'*').join(',')

    end
  end


  def path_data
    @path_data = []

    1000.times do |value|
      test1 = rand(10).to_s.chars.map(&:to_i)
      index1 = rand(1)
      test2 = rand(100).to_s.chars.map(&:to_i)
      index2 = rand(3)
      test3 = rand(1000).to_s.chars.map(&:to_i)
      index3 = rand(4)
      test4 = rand(10000).to_s.chars.map(&:to_i)
      index4 = rand(5)
      test5 = rand(100000).to_s.chars.map(&:to_i)
      index5 = rand(6)

      @path_data << test1.join('/') + '/'
      @path_data << test2.join('/') + '/'
      @path_data << test3.join('/') + '/'
      @path_data << test4.join('/') + '/'
      @path_data << test5.join('/') + '/'
    end
  end

  def create_input_file
    pattern_data
    path_data
    binding.pry

    input_file = File.new("input_test.txt", "w")
    input_file.puts('123456' + "\n")
    @pattern_data.uniq.each do |pattern|
      input_file.puts(pattern + "\n")
    end
    input_file.puts('123456789' + "\n")
    @path_data.each do |path|
      input_file.puts(path + "\n")
    end
    input_file.close
  end
end

test_data = TestData.new
