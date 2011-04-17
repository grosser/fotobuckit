module ApplicationHelper
  def force_escape(x)
    '' << x
  end

  def image_for(file, size)
    url = "/image/resize/#{UrlStore.encode("#{file.class}:#{file.id}:#{size}")}"
    image_tag url, :title => file.title
  end

  def select_options_tag(name, list, options={})
    select_tag name, options_for_select(list), options
  end
end
