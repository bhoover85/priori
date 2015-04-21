class Record
  attr_reader :result, :comma_delimited, :pipe_delimited, :space_delimited, :merged

  # Reads input files and splits on delimiter.
  def initialize
    @comma_delimited = File.foreach('./lib/data/comma_delimited.txt').map { |line| line.chomp.split(', ') }
    @pipe_delimited  = File.foreach('./lib/data/pipe_delimited.txt').map { |line| line.chomp.split(' | ') }
    @space_delimited = File.foreach('./lib/data/space_delimited.txt').map { |line| line.chomp.split(' ') }
  end

  # Converts all date strings to Date objects for future dob sort.
  # Formats records based on specified criteria: last first gender color dob
  # Example: Hingis Martina Female 4/2/1979 Green
  def normalizeData
    @comma_delimited.each_with_index do |(last, first, gender, color, dob), key|
      dob = Date.strptime(dob, '%m/%d/%Y').strftime("%m/%d/%Y")
      @comma_delimited[key] = "#{last} #{first} #{gender} #{dob} #{color}"
    end

    @pipe_delimited.each_with_index do |(last, first, middle, gender, color, dob), key|
      dob = Date.strptime(dob, '%m-%d-%Y').strftime("%m/%d/%Y")
      gender.gsub!("M", "Male")

      @pipe_delimited[key] = "#{last} #{first} #{gender} #{dob} #{color}"
    end

    @space_delimited.each_with_index do |(last, first, middle, gender, dob, color), key|
      dob = Date.strptime(dob, '%m-%d-%Y').strftime("%m/%d/%Y")
      gender.gsub!("F", "Female")

      @space_delimited[key] = "#{last} #{first} #{gender} #{dob} #{color}"
    end

    self
  end

  # Merges all input data into a single array.
  def mergeData
    @merged = (@comma_delimited << @pipe_delimited << @space_delimited).flatten

    self
  end

  # Splits merged data before calling sort methods.
  def splitArrayForSort
    @merged.map! { |record| record = record.split }

    self
  end

  # Sorts females before males followed by last name ascending.
  def sortGenderAndLastName
    @result = Array.new
    @merged.sort! { |a,b| [a[2], a[0]] <=> [b[2], b[0]] }

    @merged.each do |x|
      @result.push("#{x[0]} #{x[1]} #{x[2]} #{x[3]} #{x[4]}")
    end
  end

  # Sorts by date of birth ascending.
  def sortDob
    @result = Array.new
    @merged.sort! { |a,b| [a[3][6..9], a[0]] <=> [b[3][6..9], b[0]] }

    @merged.each do |x|
      @result.push("#{x[0]} #{x[1]} #{x[2]} #{x[3]} #{x[4]}")
    end
  end

  # Sorts by last name descending.
  def sortLastName
    @result = Array.new
    @merged.sort! { |a,b| b[0] <=> a[0] }

    @merged.each do |x|
      @result.push("#{x[0]} #{x[1]} #{x[2]} #{x[3]} #{x[4]}")
    end
  end

end
