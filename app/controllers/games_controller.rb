require 'open-uri'

class GamesController < ApplicationController
  def new
    @start_time = Time.now.to_s
    @letters = 10.times.map { ('A'...'Z').to_a.sample }
  end

  def score
    letters = params[:letters].split("");
    start_time = params[:start_time].to_i
    attempt = params[:text]
    end_time = Time.now.to_i
    @result = run_game(attempt, letters, start_time, end_time)
    # raise
  end

  def run_game(attempt, grid, start_time, end_time)
    result = {}
    result[:time] = end_time - start_time
    result[:score] = (attempt.length / (end_time - start_time)) * 10
    if word_in_grid?(attempt, grid)
      if json_hash(attempt)
        result[:message] = "Congratulation <b>#{attempt.upcase}<b> is a valid word"
      else
        result[:score] = 0
        result[:message] = "Sorry, but <b>#{attempt.upcase}</b> not an English word"
      end
    else
      result[:score] = 0
      result[:message] = "Sorry, but but <b>#{attempt.upcase}</b> can't build out of #{grid.join(', ')}"
    end
    result
  end

  def json_hash(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    json_data = open(url).read
    word_hash = JSON.parse(json_data)
    word_hash["found"]
  end

  def word_in_grid?(attemp, grid)
    a = Hash.new(0)
    b = Hash.new(0)
    flag = true
    grid.map { |x| b[x] += 1 }
    attemp.upcase.split("").map { |x| a[x] += 1 }
    a.each do |x, y|
      flag = b.key?(x) && y <= b[x]
      break if flag == false
    end
    flag
  end
end
