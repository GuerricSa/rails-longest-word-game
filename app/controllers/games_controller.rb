require 'open-uri'
require 'json'

class GamesController < ApplicationController
  @start_time = 0
  def new
    # TODO: generate random grid of letters
    @letters = []
    (1..9).each do
      letter = ('a'..'z').to_a.sample
      @letters << letter
      @start_time = Time.now
    end
  end

  def score
    @result = 0
    # end_time = Time.now
    # chrono = (end_time.to_i - params[:start_time].to_i)
    @score = 0
    @grid = params[:letters]
    @attempt = params[:input].downcase
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    dictionary = JSON.parse(URI.open(url).read)
    @truc = test_attempt_grid(@attempt, @grid)
    if dictionary["found"] && test_attempt_grid(@attempt, @grid)
      @result = 3
    elsif test_attempt_grid(@attempt, @grid)
      @result = 1
    else
      # @score = dictionary['length'] + (60 - chrono)
      @result = 2
    end
    @result
  end

  private

  def test_attempt_grid(attempt, grid)
    attempt_hash = attempt.upcase.chars.to_h { |letter| [letter, attempt.upcase.count(letter)] }
    grid_hash = ("A".."Z").to_h { |letter| [letter, grid.chars.count(letter)] }
    attempt_hash.all? do |letter, count|
      grid_hash[letter] >= count
    end
  end
end
