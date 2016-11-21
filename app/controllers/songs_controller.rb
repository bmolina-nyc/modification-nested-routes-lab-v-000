class SongsController < ApplicationController
  def index
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist.nil?
        redirect_to artists_path, alert: "Artist not found"
      else
        @songs = @artist.songs
      end
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      @song = @artist.songs.find_by(id: params[:id])
      if @song.nil?
        redirect_to artist_songs_path(@artist), alert: "Song not found"
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    if params[:artist_id] && !Artist.exists?(params[:artist_id])
      redirect_to artists_path, alert: "Artist not found"
    else
      @song = Song.new(artist_id: params[:artist_id])
    end
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  # What we should do is check to make sure that 1) the author_id is valid and
  #  2) the post matches the author. 
  # the point here is the check if a song is in the database
  # we also need to check that the song is in the db of a valid artist
  def edit
    if params[:artist_id]
      @nested = true
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist.nil? 
        redirect_to artists_path, alert: "Artist not found." 
      else # no artist id so its just a /songs/1/edit path for example
        @song = @artist.songs.find_by(id: params[:id])
        redirect_to artist_songs_path(@artist), alert: "Song not found." if @song.nil?
      end
    else
      @song = Song.find(params[:id])
      @nested = false 
    end
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name, :artist_id)
  end
end

