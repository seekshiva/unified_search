class SearchController < ApplicationController
  def home
  end
  
  def index
    # @musics = Music.where("title = ?", params[:q])
    @query = params[:q]
    
    @title_checked = params[:title].nil? ? "" : 'checked="checked"'
    @album_checked = params[:album].nil? ? "" : 'checked="checked"'
    @artist_checked = params[:artist].nil? ? "" : 'checked="checked"'
    
    cond = []
    cond[cond.length] = "title like ?" unless @title_checked.empty?
    cond[cond.length] = "album like ?" unless @album_checked.empty?
    cond[cond.length] = "artist like ?" unless @artist_checked.empty?
    
    redirect_to :action => "index", :q => params[:q], :title => 1, :album => 1, :artist => 1 if cond.length == 0
    
    @musics = Music.find(:all, :conditions => [ cond.join(" or ") ] + [ "%" + @query + "%" ] * cond.length , :order => "album ASC")
    
    @albums = {}
    @musics.each do |music| 
      sym = music.album.to_sym
      if @albums[ sym ].nil?
        @albums[sym] = []
      end
      @albums[sym][@albums[sym].length] = music
    end
    
  end
end
