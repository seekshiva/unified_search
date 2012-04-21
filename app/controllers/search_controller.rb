class SearchController < ApplicationController
  def index
  end
  
  def show
    # @musics = Music.where("title = ?", params[:q])
    @query = params[:q]
    
    @title_checked = params[:title].nil? ? "" : 'checked="checked"'
    @album_checked = params[:album].nil? ? "" : 'checked="checked"'
    @artist_checked = params[:artist].nil? ? "" : 'checked="checked"'
    
    cond = []
    cond[cond.length] = "title like ?" unless @title_checked.empty?
    cond[cond.length] = "album like ?" unless @album_checked.empty?
    cond[cond.length] = "artist like ?" unless @artist_checked.empty?
    
    @musics = Music.find(:all, :conditions => [ cond.join(" or ") ] + [ "%" + @query + "%" ] * cond.length , :order => "album ASC")

  end
end
