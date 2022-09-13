require 'net/http'

class MoviesController < ApplicationController
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
end
