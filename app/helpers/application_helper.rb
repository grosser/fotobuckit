module ApplicationHelper
  def resized_image_url(url, size)
    width, height = size.split('x',2)
    "http://image-resize.appspot.com/?url=#{url}&width=#{width}&height=#{height}"
  end
end
