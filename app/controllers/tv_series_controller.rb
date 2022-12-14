class TvSeriesController < ApplicationController
  protect_from_forgery with: :null_session

  def get_all
    tv_series = TvSerie.all

    render json: tv_series, status: 200
  end

  def get_by_id
    if !params[:id] || params[:id] == ''
      render json: { "status" => "error", "message" => "No id provided" }, status: 400
    else
      tv_serie = TvSerie.find_by(id: params[:id])

      if tv_serie
        render json: tv_serie, status: 200
      else
        render json: { "status" => "error", "message" => "tv serie not found" }, status: 404
      end
    end
  end

  def exists
    if !params[:q] || params[:q] == ''
      render json: { "status" => "error", "message" => "No query provided" }, status: 400
    else
      # remove spaces from query
      query = params[:q].gsub(' ', '')

      endpoint = ENV['BASE_URL'] + "/SearchSeries/" + ENV['API_KEY'] + "/" + query

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

        # check if the tv serie already exists
        tv_serie = TvSerie.find_by(id: params[:id])

        if tv_serie
          render json: { "status" => "error", "message" => "tv serie already exists" }, status: 409
        else
          # create the tv serie
          tv_serie = TvSerie.new do |t|
            t.id = response_body["id"]
            t.title = response_body["title"]
            t.genre = response_body["genre"]
            t.description = response_body["plot"]
            t.image = response_body["image"]
          end

          if tv_serie.save
            render json: { "status" => "ok", "message" => "tv serie created" }, status: 201
          else
            render json: { "status" => "error", "message" => "tv serie not created" }, status: 500
          end
        end
      end
    end
  end

  def delete
    if !params[:id] || params[:id] == ''
      render json: { "status" => "error", "message" => "No id provided" }, status: 400
    else
      tv_serie = TvSerie.find_by(id: params[:id])

      if tv_serie
        tv_serie.destroy

        render json: { "status" => "ok", "message" => "tv serie deleted" }, status: 200
      else
        render json: { "status" => "error", "message" => "tv serie not found" }, status: 404
      end
    end
  end
end
