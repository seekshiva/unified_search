require 'active_support/inflector'
require 'taglib'
require 'digest/sha1'

$audio = {}
$audio[:thumbnail_root] = "/srv/http"
$audio[:thumbnail] = "/cache/thumbnail"
$index_count = 0

class Numeric
  def pluralize str
    num = self.to_i
    if num == 1 or num == 0
      return "#{num} #{str} "
    else
      return "#{num} #{str.pluralize} "
    end
  end

  def duration
    if true
      secs  = self.to_i
      mins  = (secs / 60) % 60
      hours = (secs / (60 * 60)) % 24
      days  = secs / (24 * 60 * 60)
      secs  = secs % 60
      "#{days}:#{hours}:#{mins}:#{secs}"
    else
      secs  = self.to_i
      mins  = ((secs / 60) % 60).pluralize('minute')
      hours = ((secs / (60 * 60)) % 24).pluralize('hour')
      days  = (secs / (24 * 60 * 60)).pluralize('day')
      secs  = (secs % 60).pluralize('second')
      "#{days}#{hours}#{mins}#{secs}"
    end
  end
end


$root = Dir.pwd
puts "Root is taken as #{$root}\n"

$formats = {}

def add_dir d
  files = Dir.entries(d).sort
  files.slice!(0,2)

  File.open("/tmp/audio.sql", "a") {|log_file| 
    files.each do |f|
      if File.file? "#{d}/#{f}" and File.extname(f).downcase == ".mp3" # and f.downcase != f
        file = f.gsub('"',"'")
        dir = d[$root.length, d.length].gsub('"', "'")
        hex = "hex digest"
        hex = Digest::SHA1.file("#{d}/#{f}")
        
        if file.length > 3
          ext = File.extname(file)
          $formats.include?(ext) ? $formats[ext] += 1 : $formats[ext] = 1
        end
        
        #if File.extname(file).downcase != File.extname(file)
        #puts "#{hex} - #{$root} ... #{dir}/#{file}"
        #rename_capitalize file
        #end
        info = get_audio_info "#{$root}/#{dir}/#{file}", hex
        #puts "INSERT INTO `musics` (`sha1_sum`, `audio_name`,`audio_path`, `title`) VALUES (\"#{hex}\", \"#{file}\", \"#{dir}\", \"#{info[:title]}\");"
        
        if info[:album].nil?
          v_album = "Unknown"
        elsif info[:album].empty? 
          v_album = "Unknown"
        else
          v_album = info[:album].gsub('"', "'")
        end

        if info[:title].nil?
          v_title = file[0,file.length - File.extname(file).length]
        elsif info[:title].empty? 
          v_title = file[0,file.length - File.extname(file).length]
        else
          v_title = info[:title]
        end
        v_title = rename_capitalize(v_title) .gsub('"', "'")
        v_artist = info[:artist].gsub('"', "'")
        
        str = "INSERT IGNORE INTO `music` (`sha1_sum`, `file`, `title`, `album`, `artist`, `year`, `genre`,`duration`, `mime_type`, `thumbnail`) VALUES (\"#{hex}\", \"#{dir}/#{file}\", \"#{v_title}\", \"#{v_album}\", \"#{v_artist}\", \"#{info[:year]}\", \"#{info[:genre]}\", \"#{info[:duration]}\", \"#{info[:mime]}\", \"#{info[:thumb]}\");\n"
        puts str
        
        log_file.write str
        puts "."
      end
    end
  }
  
  files.each do |f|
    add_dir "#{d}/#{f}" unless File.file? "#{d}/#{f}" or f[0] == "."
  end
  
end

def rename_capitalize file
  newfile = file
  newfile = newfile.downcase.split(' ').each {|word| word[0] = word[0].upcase unless word.nil?; word }.join(' ')
  #newfile = newfile.downcase.split('-').each {|word| word[0] = word[0].upcase unless word.nil?; word }.join(' ')
  #newfile = newfile.downcase.split('_').each {|word| word[0] = word[0].upcase unless word.nil?; word }.join(' ')
  #puts "#{file} \t\t\t\tbecomes #{newfile}"
  return newfile
end

def show_founc_formats
  sum = $formats.values.inject {|sum,x| sum+x}
  puts "Total of #{sum} files were scanned.\n\n"
  
  formats = $formats.sort_by {|key,value| -1 * value}
  formats.each do |f|
    puts "#{f[0]} \t\t- #{f[1]} occurences"
  end
end

def get_audio_info file, hex
  info = {}
  
  TagLib::FileRef.open(file) do |fileref|
    tag  = fileref.tag
    info[:title] = tag.title
    info[:artist] = tag.artist
    info[:album] = tag.album
    info[:year] = tag.year
    info[:track] = "#{tag.track}/#{tag.track.size + 1}"
    info[:genre] = tag.genre
    info[:duration] = fileref.audio_properties.length.duration
  end
  
  TagLib::MPEG::File.open(file) do |f|
    tag = f.id3v2_tag
    track = tag.frame_list('TRCK').first
    cover = tag.frame_list('APIC').first
    
    if cover.nil?
      info[:mime] = "image/png"
      info[:thumb] = "#{$audio[:thumbnail]}/defaults/music.png"
    else
      info[:mime] = cover.mime_type
      File.open("#{$audio[:thumbnail_root]}#{$audio[:thumbnail]}/music/#{hex}.jpg", "wb") {|f| f.write(cover.picture)}
      info[:thumb] = "#{$audio[:thumbnail]}/music/#{hex}.jpg"
    end
  end
  return info
  
end

add_dir Dir.pwd

puts ""

show_founc_formats
