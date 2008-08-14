Technoweenie::AttachmentFu::ClassMethods.module_eval do
  def validates_as_attachment
    validates_presence_of :filename
    validates_presence_of :size, :content_type, :if => proc { |model| !model.filename.blank? }
    validate              :attachment_attributes_valid_if_not_blank?
  end
end

Technoweenie::AttachmentFu::InstanceMethods.module_eval do
  def attachment_attributes_valid_if_not_blank?
    attachment_attributes_valid? unless self.filename.blank?
  end    
end
