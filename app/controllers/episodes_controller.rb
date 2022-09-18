class EpisodesController < ApplicationController
  protect_from_forgery with: :null_session

  def get_all
    episodes = Episode.all

    render json: episodes, status: 200
  end

  def get_by_id
    if !params[:id] || params[:id] == ''
      render json: { "status" => "error", "message" => "No id provided" }, status: 400
    else
      episode = Episode.find_by(id: params[:id])

      if episode
        render json: episode, status: 200
      else
        render json: { "status" => "error", "message" => "episode not found" }, status: 404
      end
    end
  end

  def exists
    if !params[:q] || params[:q] == ''
      render json: { "status" => "error", "message" => "No query provided" }, status: 400
    else
      # remove spaces from query
      query = params[:q].gsub(' ', '')

      endpoint = ENV['BASE_URL'] + "/Search/" + ENV['API_KEY'] + "/" + query

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

        # check if the episode already exists
        episode = Episode.find_by(id: params[:id])

        if episode
          render json: { "status" => "error", "message" => "episode already exists" }, status: 409
        else
          # create the episode
          episode = Episode.new do |e|
            e.id = params[:id]
            e.title = response_type["title"]
            e.season = response_type["season"]
            e.description = response_type["description"]
          end

          if episode.save
            render json: episode, status: 201
          else
            render json: { "status" => "error", "message" => "episode could not be created" }, status: 500
          end
        end
      end
    end
  end

  def delete
    if !params[:id] || params[:id] == ''
      render json: { "status" => "error", "message" => "No id provided" }, status: 400
    else
      episode = Episode.find_by(id: params[:id])

      if episode
        episode.destroy

        render json: { "status" => "ok", "message" => "episode deleted" }, status: 200
      else
        render json: { "status" => "error", "message" => "episode not found" }, status: 404
      end
    end
  end
end