require 'rails_helper'

RSpec.describe ComplexScripts do
  describe "Tibetan Sorting" do
    context "Valid" do
      it "Sorts Tibetan using string extension" do
        x = ['ཆོས་', 'ཀ', 'དཀོན་','རྐ']
        expect(x.sort{ |a,b| a.bo_compare b }).to eq(['ཀ', 'དཀོན་','རྐ','ཆོས་'])
      end
    end
  end
end
