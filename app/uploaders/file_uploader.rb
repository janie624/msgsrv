# encoding: utf-8
require 'carrierwave/processing/mime_types'

class FileUploader < CarrierWave::Uploader::Base

  include CarrierWave::MimeTypes
  include CarrierWave::RMagick

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  if Rails.env.eql? 'production'
      storage :file
     else
      storage :file
    end

 # File Versions
    version :thumb, :if => :image? do
       process :resize_to_fit => [100,100]
    end

  # URLs Filename
  #----------------------------------------------------------------------------
  def full_filename (for_file = model.photo.file)
    "#{for_file}"
  end

  # Database Filename
  #----------------------------------------------------------------------------
  def filename
    "#{original_filename}" if original_filename.present?
  end

  def image?(file)
    file.content_type.try {|x| x.include? 'image'}
  end
end
