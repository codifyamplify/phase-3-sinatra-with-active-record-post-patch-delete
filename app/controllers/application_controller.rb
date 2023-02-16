require 'pry'

class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  get '/games' do
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  get '/games/:id' do
    game = Game.find(params[:id])

    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end

  get '/reviews' do
    reviews = Review.all
    reviews.to_json
  end

  get '/reviews/:id' do
    review = Review.find(params[:id])
    review.to_json
  end


#   {
#     "id": 2,
#     "score": 1,
#     "comment": "Quis ea corporis asperiores.",
#     "game_id": 1,
#     "created_at": "2023-02-15T01:55:17.614Z",
#     "updated_at": "2023-02-15T01:55:17.614Z",
#     "user_id": 1
# },


  delete '/reviews/:id' do
    # Find the review using the ID
    review = Review.find(params[:id])
    # Delete the review
    review.destroy
    # Send a response with the deleted review as JSON
    review.to_json
  end

  post '/reviews' do
    review = Review.create(
      score: params[:score],
      comment: params[:comment],
      game_id: params[:game_id],
      user_id: params[:user_id]
    )
    review.to_json
  end

  patch '/reviews/:id' do
    # Find the review using the ID
    review = Review.find(params[:id])
    # review
    review.update(
      score: params[:score],
      comment: params[:comment]
    )
    review.to_json
  end

end
