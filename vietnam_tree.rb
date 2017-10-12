require 'json'

File.open( 'tree.json', "r" ) do |f|
  tmp = JSON.load( f )

  tmp.each do |province|
    p = Hash[province["name"], nil]
    province["quan-huyen"].each do |t|
    end
  end
end
