require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = [*('A'..'Z')].sample(10).join
  end

  def score
    @guess = params[:guess]
    @letters = params[:letters].split

    if !english_word?(@guess)
      @answer = "Sorry, #{@guess} does not seem to be a valid English word..."
    elsif not_in_grid?(@guess, @letters)
      @answer = "Sorry, #{@guess} can't be built out of the letters: #{@letters.join(',')}"
    else
      @answer = "Congrats, #{@guess} is a valid english word"
    end
  end

  def english_word?(guess)
    response = open("https://wagon-dictionary.herokuapp.com/#{@guess}")
    word = JSON.parse(response.read)
    word['found']
  end

  def not_in_grid?(guess, letters)
    guess.each_char do |letter|
      if !letters.include?(letter)
        false
      end
    end
  end
end
