class Image < ActiveRecord::Base

  belongs_to :product

  validates :file_name, :presence => true

  after_create :copy_images
  after_destroy :del_images

  def sizes
    ['s', 'm', 'l']
  end

  private

  def copy_images
    self.sizes.each { |size|
      if File.exist?("#{Rails.root}/public/tmp/#{size + "/" + self.file_name}")
        File.copy("#{Rails.root}/public/tmp/#{size + "/" + self.file_name}", "#{Rails.root}/public/pictures/#{size + "/" + self.file_name}")
        File.delete("#{Rails.root}/public/tmp/#{size + "/" + self.file_name}")
      end
    }
  end

  def del_images
    self.sizes.each { |size|
      if File.exist?("#{Rails.root}/public/pictures/#{size + "/" + self.file_name}")
        File.delete("#{Rails.root}/public/pictures/#{size + "/" + self.file_name}")
      end
    }
  end

end
