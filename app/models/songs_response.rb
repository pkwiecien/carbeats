class SongsResponse

  @average_speed = 0
  @harsh_acceleration = 0
  @harsh_breaks = 0
  @weather = 0
  @playlist = {}
  @genre = ""

  def initialize
    @average_speed = 0
    @harsh_acceleration = 0
    @harsh_breaks = 0
    @weather = 0
    @genre = ""
  end

  attr_accessor :average_speed
  attr_accessor :harsh_acceleration
  attr_accessor :harsh_breaks
  attr_accessor :weather
  attr_accessor :playlist
  attr_accessor :genre
end