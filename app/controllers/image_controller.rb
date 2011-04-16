class ImageController < ActionController::Base
  def resize
    url = params[:url]
    size = params[:size]
    mime_type = mime_type_from_url(url)

    # injection prevention
    raise "wtf" if url.include?("'") or size.include?("'")

    cache = "tmp/img_cache_#{url.hash}.JPG"
    cmd = "convert '#{url}' -resize '#{size}' #{cache}"
    raise "convert error" unless system cmd

    expires_in 2.years, :public => true if params[:t]
    send_file cache, :type => mime_type, :disposition => 'inline', :stream => false
  end

  private

  def mime_type_from_url(url)
    extension = File.extname(url.split('?').first)[1..-1]
    mime_type = Mime::EXTENSION_LOOKUP[extension.downcase]
    raise "unknown mime-type for #{extension}" unless mime_type
    mime_type
  end
end
