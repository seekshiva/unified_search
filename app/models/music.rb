class Music < ActiveRecord::Base
  validates_presence_of :sha1_sum
  validates_presence_of :title
  validates_presence_of :album
  validates_numericality_of :year, :message => "Year should be given an integral value."
end
