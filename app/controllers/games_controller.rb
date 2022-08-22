require 'open-uri'
require 'json'

class GamesController < ApplicationController


  def new
    # TODO: generate random grid of letters
    loop = (1..10).to_a
    @letters = []
    loop.each do |_k|
      @letters << ('a'..'z').to_a.sample[0]
    end
  end

  def score
    if check_on_grid(params[:question], params[:letters].split(""))
      @total = check_word_exist(params[:question].downcase)
      if @total == 0
        @message = "Sorry this word didn't exist"
      else
        @message = "Congratulation !#{params[:question]} is a valid English word !"
      end
    else
      @message = "You must use only provided letters #{params[:letters].split("")}"
    end
  end

  private

  def check_word_exist(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = URI.open(url).read
    result = JSON.parse(word_serialized)
    if result["found"]
      return result["length"].to_i
    else
      return 0
    end
  end

  def check_on_grid(a_word, a_grid)
    # vérifier que le mot proposé contient bien que des lettres de la grille et une seule fois
    a_grid_down = a_grid.map { |le| le.downcase }
    a_word.downcase.chars.each do |a_letter|
      index = a_grid_down.index(a_letter)
      if index.nil?
        return false
      else
        a_grid_down.delete_at(index)
      end
    end
    return true
  end
end
