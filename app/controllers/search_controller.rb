class SearchController < ApplicationController
  def home
  end
  
  def index
    # @musics = Music.where("title = ?", params[:q])
    @query, cond = params[:q], []
    
    if params[:q] == ""
      redirect_to "/" 
      return
    end
    
    if params[:title].nil?
      @title_checked = ""
    else
      @title_checked = 'checked="checked"'
      cond[cond.length] = "title like ?" unless @title_checked.empty?
    end
    
    @album_checked = params[:album].nil? ? "" : 'checked="checked"'
    @artist_checked = params[:artist].nil? ? "" : 'checked="checked"'
    
    cond[cond.length] = "album like ?" unless @album_checked.empty?
    cond[cond.length] = "artist like ?" unless @artist_checked.empty?
    
    redirect_to :action => "index", :q => params[:q], :title => 1, :album => 1, :artist => 1 if cond.length == 0
    
    @musics = Music.find(:all, :conditions => [ cond.join(" or ") ] + [ "%" + @query + "%" ] * cond.length , :order => "album ASC")
    
    @albums = {}
    @musics.each do |music| 
      sym = music.album.to_sym
      if @albums[ sym ].nil?
        @albums[ sym ] = []
      end
      @albums[ sym ][ @albums[ sym ].length ] = music
    end
    
  end
end
