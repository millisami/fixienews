require 'rubygems'
require 'nokogiri'

#doc = Nokogiri::HTML(open('t.html'))

#doc.css('td.title > a').each do |link|
  #next if link['rel'] == 'nofollow'
  #puts link.content
#end

require 'news'

puts style_for_iphone(open('t.html').read)
