require 'rest_client'
require 'json'

class Api::V1::UsersController < ApiController
  respond_to :json

  # GET /api/v1/users/
  def index
    user_genre = params[:genre]


    resSong = getOBDData
    resSong.genre = "genre_#{user_genre}"
    songR = computePlaylist(resSong)

    render json: {songResult: songR}

  end


  def getOBDData
    response = RestClient.get 'http://hackathon.services-autoscout24.de/id.php?asset=357322040151927'
    @obd_data = JSON(response.body)
    count = 1
    speed = 0
    harsh_acceleration = 0
    harsh_breaks = 0
    latitude = 0
    longitude = 0


    songResponse = SongsResponse.new


    @obd_data.each do |item|
      begin

        if item["BEHAVE_ID"]
          if (item["BEHAVE_ID"]["1"] == 11)
            harsh_acceleration += 1
          else
            harsh_breaks += 1
          end
        end
        latitude = item["latitude"]
        longitude = item["longitude"]
        speed += (item["GPS_SPEED"]["1"] * 1.852) / 1000
      rescue
      end

      if count > 300
        break
      end
      count += 1
    end

    responseWeather = RestClient.get "http://api.wunderground.com/api/a91b53d3e8523df5/conditions/lang=EN/q/#{latitude},#{longitude}.json"
    @weatherData = JSON(responseWeather.body)

    songResponse.weather = @weatherData["current_observation"]["weather"]
    songResponse.average_speed = speed/300
    songResponse.harsh_breaks = harsh_breaks
    songResponse.harsh_acceleration = harsh_acceleration

    songResponse
  end

  def computePlaylist(songRes)

    # soong = SongsResponse.new
    # soong = songRes
    #dummydata
    songRes.average_speed = 20
    songRes.harsh_breaks = 1
    songRes.harsh_acceleration = 1
    songRes.weather = "Sunny"


    #Cool65326
    if(songRes.average_speed < 40 && (songRes.harsh_breaks < 2 || songRes.harsh_acceleration < 2) && songRes.weather == "Sunny"  )
      coolPlaylistResponse = RestClient::Request.execute(:url => "https://c11493376.web.cddbp.net/webapi/json/1.0/radio/create?client=11493376-2587743DFEA005B0AC22F8C40DB8A4AB&user=263552350177047583-9A591374B87F3A53E1A77FFDA20770A8&seed=mood_65326;#{songRes.genre}", :ssl_version => 'TLSv1', :method => 'get')
      @cool_res = JSON(coolPlaylistResponse.body)
      songRes.playlist = @cool_res["RESPONSE"]

    end

    #peacefull easygoing
    if(songRes.average_speed < 40 && (songRes.harsh_breaks < 2 || songRes.harsh_acceleration < 2) && songRes.weather == "Mostly Cloudy" && (Time.now.hour >= 6 && Time.now.hour <= 16) )
      peacefulPlaylist = RestClient::Request.execute(:url => "https://c11493376.web.cddbp.net/webapi/json/1.0/radio/create?client=11493376-2587743DFEA005B0AC22F8C40DB8A4AB&user=263552350177047583-9A591374B87F3A53E1A77FFDA20770A8&seed=mood_65322;#{songRes.genre}", :ssl_version => 'TLSv1', :method => 'get')
      @peace_res = JSON(peacefulPlaylist.body)
      songRes.playlist = @peace_res["RESPONSE"]

    end

    #melancholic
    if(songRes.average_speed > 40 && (songRes.harsh_breaks >= 2 || songRes.harsh_acceleration >= 2) && songRes.weather == "Rain" && (Time.now.hour >= 1 && Time.now.hour <= 6) )
      melanPlaylist = RestClient::Request.execute(:url => "https://c11493376.web.cddbp.net/webapi/json/1.0/radio/create?client=11493376-2587743DFEA005B0AC22F8C40DB8A4AB&user=263552350177047583-9A591374B87F3A53E1A77FFDA20770A8&seed=mood_42949;#{songRes.genre}", :ssl_version => 'TLSv1', :method => 'get')
      @melan_res = JSON(melanPlaylist.body)
      songRes.playlist = @melan_res["RESPONSE"]
    end

    #urgent
    if(songRes.average_speed > 40 && (songRes.harsh_breaks >= 2 || songRes.harsh_acceleration >= 2) && (songRes.weather == "Sunny" || songRes.weather == "Rain") && ((Time.now.hour >= 6 && Time.now.hour <= 10) || (Time.now.hour >= 16 && Time.now.hour <= 20)) )
      urgentPlaylist = RestClient::Request.execute(:url => "https://c11493376.web.cddbp.net/webapi/json/1.0/radio/create?client=11493376-2587743DFEA005B0AC22F8C40DB8A4AB&user=263552350177047583-9A591374B87F3A53E1A77FFDA20770A8&seed=mood_42955;#{songRes.genre}", :ssl_version => 'TLSv1', :method => 'get')
      @urgent_res = JSON(urgentPlaylist.body)
      songRes.playlist = @urgent_res["RESPONSE"]
    end


    songRes
  end



end