class SearchController < ApplicationController
  def index
  end
  
  def show
    # @musics = Music.where("title = ?", params[:q])
    @query = params[:q]
    @musics = Music.find(:all, :conditions => ["title like ? or album like ?", @query + "%", @query])

    
    @title_checked = params[:title].nil? ? "" : 'checked="checked"'
    @album_checked = params[:album].nil? ? "" : 'checked="checked"'
    @artist_checked = params[:artist].nil? ? "" : 'checked="checked"'
  end
end
