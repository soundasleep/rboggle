module BoardHelper
  def guess_classes(guess)
    classes = ["guess"]
    classes << "checked" if guess.checked?
    classes << "possible" if guess.possible?
    classes << "unique" if guess.unique?
    classes << "in-dictionary" if guess.in_dictionary?
    classes.join(" ")
  end
end
