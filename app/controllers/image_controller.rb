class ImageController < ActionController::Base
  def resize
    klass, id, size = UrlStore.decode(params[:data]).split(':')
    object = klass.constantize.find(id)

    url = object.url
    mime_type = mime_type_from_url(url)

    cache = "tmp/img_cache_#{url.hash}.JPG"
    cmd = "convert '#{url}' -resize '#{size}' #{cache}"
    raise "convert error" unless system cmd

    expires_in 2.years, :public => true
    send_data File.read(cache), :type => mime_type, :disposition => 'inline'
  end

  private

  def mime_type_from_url(url)
    extension = File.extname(url.split('?').first)[1..-1]
    mime_type = Mime::EXTENSION_LOOKUP[extension.downcase]
    raise "unknown mime-type for #{extension}" unless mime_type
    mime_type
  end
end
