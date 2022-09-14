require 'net/http'

class MoviesController < ApplicationController
  protect_from_forgery with: :null_session

  def get_all
    movies = Movie.all

    render json: movies, status: 200
  end

  def get_by_id
    if !params[:id] || params[:id] == ''
      render json: { "status" => "error", "message" => "No id provided" }, status: 400
    else
      movie = Movie.find_by(id: params[:id])

      if movie
        render json: movie, status: 200
      else
        render json: { "status" => "error", "message" => "movie not found" }, status: 404
      end
    end
  end

  def exists
    if !params[:q] || params[:q] == ''
      render json: { "status" => "error", "message" => "No query provided" }, status: 400
    else
      # remove spaces from query
      query = params[:q].gsub(' ', '')

      endpoint = ENV['BASE_URL'] + "/SearchMovie/" + ENV['API_KEY'] + "/" + query

      response = Net::HTTP.get_response(URI(endpoint))

      if response.code != "200"
        render json: { "status" => "error", "message" => response.body }, status: response.code
      else
        # convert the response to a object
        response_body = JSON.parse(response.body)

        response_body = response_body["results"][0]

        render json: { "status" => "ok", "founded" => "ok", "result" => response_body }, status: 200
      end
    end
  end

  def create
    if !params[:id] || params[:id] == ''
      render json: { "status" => "error", "message" => "No id provided" }, status: 400
    else
      endpoint = ENV['BASE_URL'] + "/Title/" + ENV['API_KEY'] + "/" + params[:id]

      response = Net::HTTP.get_response(URI(endpoint))

      if response.code != "200"
        render json: { "status" => "error", "message" => response.body }, status: response.code
      else
        # convert the response to a object
        response_body = JSON.parse(response.body)

        # add movie to db
        movie = Movie.new do |m|
          m.id = response_body["id"]
          m.title = response_body["title"]
          m.description = response_body["plot"]
          m.image_url = response_body["image"]
        end

        if movie.save
          render json: { "status" => "ok", "result" => "movie added successfully" }, status: 200
        else
          render json: { "status" => "error", "message" => movie.errors }, status: 500
        end
      end
    end
  end

  def delete
    if !params[:id] || params[:id] == ''
      render json: { "status" => "error", "message" => "No id provided" }, status: 400
    else
      movie = Movie.find_by(id: params[:id])

      if movie
        movie.destroy

        render json: { "status" => "ok", "result" => "movie deleted successfully" }, status: 200
      else
        render json: { "status" => "error", "message" => "movie not found" }, status: 404
      end
    end
  end
end
