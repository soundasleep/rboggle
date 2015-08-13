# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

words = 0
loaded = []

# load the dictionary
# this can be updated from http://wordlist.aspell.net/
# compared to the system dictionary, this has plurals, weird words etc
Dir[File.dirname(__FILE__) + "/../dict/*"].map do |file|
  puts "Loading #{file}..."

  File.open(file, "r") do |f|
    f.each_line do |line|
      line.scrub!("_").strip!   # ignore invalid UTF characters as necessary
      if line.match(/^[a-z]+$/) && !loaded.include?(line)
        words += 1
        Dictionary.create!(word: line)
        loaded << line

        if words % 1000 == 0
          puts "Loaded #{words} words... (#{line})"
        end
      end
    end
  end
end
