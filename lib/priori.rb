require "priori/version"
require "record"

def output
  record = Record.new
  record.normalizeData.mergeData.splitArrayForSort

  puts "\nOutput 1:"
  record.sortGenderAndLastName
  puts record.result

  puts "\nOutput 2:"
  record.sortDob
  puts record.result

  puts "\nOutput 3:"
  record.sortLastName
  puts record.result
end
