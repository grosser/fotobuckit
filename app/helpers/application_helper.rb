module ApplicationHelper
  def image_for(file, size)
    image_tag resized_image_url(file.url, size), :title => file.title
  end

  def resized_image_url(url, size)
    account = CGI.escape('Michael Grosser')
    width, height = size.split('x',2)
    api_key = 'a65fe903338d83e3594e1211ef272cc4'
    url = "http://pixelcloud.duostack.net/crop/#{CGI.escape(url)}?width=#{width}&height=#{height}&account=#{account}"
    hash = Digest::MD5.hexdigest(url + api_key)
    url + "&hash=#{hash}"
  end
end
