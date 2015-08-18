module BoardHelper
  def guess_classes(guess)
    classes = ["guess"]
    classes << "checked" if guess.checked?
    classes << "possible" if guess.possible?
    classes << "unique" if guess.unique?
    classes << "in-dictionary" if guess.in_dictionary?
    classes.join(" ")
  end

  def word_link(word)
    link_to word, "https://en.wiktionary.org/wiki/#{word}", title: "View '#{word}' on Wiktionary"
  end
end
