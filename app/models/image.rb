class Image < ActiveRecord::Base

  belongs_to :product
  belongs_to :event

  validates :file_name, :presence => true

  after_create :copy_images
  after_update :copy_images
  after_destroy :del_images

  def product_sizes
    ['s', 'm', 'l']
  end

  def event_sizes
    ['e']
  end

  def all_sizes
    product_sizes + event_sizes
  end

  private

  def copy_images
    self.all_sizes.each { |size|
      if File.exist?("#{Rails.root}/public/tmp/#{size + "/" + self.file_name}")
        File.copy("#{Rails.root}/public/tmp/#{size + "/" + self.file_name}", "#{Rails.root}/public/pictures/#{size + "/" + self.file_name}")
        File.delete("#{Rails.root}/public/tmp/#{size + "/" + self.file_name}")
      end
    }
  end

  def del_images
    self.all_sizes.each { |size|
      if File.exist?("#{Rails.root}/public/pictures/#{size + "/" + self.file_name}")
        File.delete("#{Rails.root}/public/pictures/#{size + "/" + self.file_name}")
      end
    }
  end

end
