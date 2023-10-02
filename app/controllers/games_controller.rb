require 'open-uri'
require 'json'

class GamesController < ApplicationController
  @start_time = 0
  def new
    # TODO: generate random grid of letters
    @letters = []
    9.times do
      letter = ('a'..'z').to_a.sample
      @letters << letter
      @start_time = Time.now
    end
  end

  def score
    @result = 0
    @grid = params[:letters]
    @attempt = params[:input].downcase
    @truc = test_attempt_grid(@attempt, @grid)
    if check_dictionary(@attempt) && test_attempt_grid(@attempt, @grid)
      @result = 3
      session[:score].nil? ? session[:score] = @attempt.size : session[:score] += @attempt.size
    elsif test_attempt_grid(@attempt, @grid)
      @result = 2
    else
      @result = 1
    end
    @result
  end

  private

  def test_attempt_grid(attempt, grid)
    attempt_hash = attempt.upcase.chars.to_h { |letter| [letter, attempt.upcase.chars.count(letter)] }
    grid_hash = ('A'..'Z').to_h { |letter| [letter, grid.chars.count(letter)] }
    attempt_hash.all? do |letter, count|
      grid_hash[letter] <= count
    end
  end

  def check_dictionary(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt.strip}"
    dictionary = JSON.parse(URI.open(url).read)
    dictionary['found']
  end
end
