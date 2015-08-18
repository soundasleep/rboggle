require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the GameHelper. For example:
#
# describe GameHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe BoardHelper, type: :helper do

  context "#guess_classes" do
    let(:guess) { Guess.create args }
    let(:classes) { helper.guess_classes(guess) }

    context "a checked guess" do
      let(:args) { { checked: true } }

      it "returns classes" do
        expect(classes).to eq("guess checked")
      end
    end

    context "a checked guess in the dictionary" do
      let(:args) { { checked: true, in_dictionary: true } }

      it "returns classes" do
        expect(classes).to eq("guess checked in-dictionary")
      end
    end
  end

  context "#word_link" do
    it "returns a link to wiktionary" do
      expect(helper.word_link("word")).to include("wiktionary")
    end
  end

end
