# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

words = 0

# load the dictioanry
File.open("/usr/share/dict/words", "r") do |f|
  f.each_line do |line|
    line.strip!
    if line.match(/^[a-z]+$/)
      words += 1
      Dictionary.create! word: line

      if words % 1000 == 0
        puts "Loaded #{words} words..."
      end
    end
  end
end
