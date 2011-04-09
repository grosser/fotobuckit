class ActiveRecord::Base
  def update_attribute_without_callbacks(attribute, value)
    update_attributes_without_callbacks(attribute=>value)
  end

  def update_attributes_without_callbacks(attributes)
    self.class.update(id, attributes)
    attributes.each{|k,v| send("#{k}=",v)}
  end
end
