require File.expand_path(File.join(File.dirname(__FILE__), '.bundle/environment'))

require 'sinatra'
require 'open-uri'
require 'nokogiri'

Y = "http://news.ycombinator.com"

def url_for_y path
  "#{Y}#{path}"
end

def cache_it
  headers['Cache-Control'] = 'public, max-age=60'
  headers['Content-Type'] = 'text/html; charset=utf-8'
end

def remote_load url
  open(url).read
end

# Maybe use haml view for this?
def style_for_iphone text
  doc = Nokogiri::HTML(text)

  html =  '<html><head>'
  html << '<meta name="viewport" content="width=320; initial-scale=0.6; maximum-scale=1.0; user-scalable=0;"/>'
  html << '<style type="text/css" media="screen">@import "/iphonenav.css";</style>'
  html << '<title>Fixie Iphone for y-combinator</title>'
  html << '</head>'
  html << '<body>'

  html << '<h1 id="pageTitle"><a href="/">Y Combinator</a></h1>'

  html << '<ul selected="true">'
  doc.css('table tr td table tr').each do |row|
    if story_title = row.css('td.title > a').first
      html << '<li>'
      html << "<a href='#{story_title['href']}'>#{story_title.content}</a>"
    end
    if subtext = row.css('td.subtext').first
      comments_link = subtext.css('a').last
      html << "<a href='#{comments_link['href']}'>#{comments_link.content}\n"
      html << '</li>'
    end
  end
  html << '</ul>'
  html << '</body></html>'
  html
end

get '*' do
  cache_it
  content = remote_load(url_for_y(request.fullpath))
  if %w(/ /x).include?(request.path_info)
    style_for_iphone(content)
  else
    content
  end
end
