module ApplicationHelper
  def force_escape(x)
    '' << x
  end

  def image_for(file, size)
    image_tag resized_image_url(file.url, size), :title => file.title
  end

  def resized_image_url(url, size)
    account = CGI.escape('Michael Grosser')
    width, height = size.split('x',2)
    api_key = CFG['PIXELCLOUD_API_KEY']
    url = "http://pixelcloud.duostack.net/crop/#{CGI.escape(url)}?width=#{width}&height=#{height}&account=#{account}"
    hash = Digest::MD5.hexdigest(url + api_key)
    url + "&hash=#{hash}"
  end

  def select_options_tag(name, list, options={})
    select_tag name, options_for_select(list), options
  end
end
