require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample}
  end

  def english_word
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    word_dictionary = open(url).read
    word = JSON.parse(word_dictionary)
    return word['found']
  end

  def included?(letters, answer)
    answer.chars.all? do |letter|
      answer.count(letter) <= letters.count(letter)
    end    
  end
  
  def score
    @letters = params[:letters].split
    @answer = params[:word]
    included = included?(@letters, @answer)

    if !included
      @result = "#{@answer} can´t be built out of the original grid."
    elsif included && !english_word
      @result = "#{@answer} is valid according to the grid, but is not valid English word."
    else
      @result = "Congratulations!#{@answer} is a valid English word."
    end
  end
end
