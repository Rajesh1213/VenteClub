class Image < ActiveRecord::Base

  belongs_to :product
  belongs_to :event
  belongs_to :flat_rate_product

  default_scope :order => "created_at DESC"

  validates :file_name, :presence => true

  after_create :copy_images
  after_update :copy_images
  after_destroy :del_images

  def product_sizes
    ['s', 'sm', 'm', 'l']
  end

  def event_sizes
    ['e', 'e_b']
  end

  def flat_rate_product_sizes
    ['frp']
  end

  def all_sizes
    product_sizes + event_sizes + flat_rate_product_sizes
  end

  def as_json(options = {})
    {
        :id => self.id,
        :file_name => self.file_name
    }
  end

  private

  def copy_images
    self.all_sizes.each { |size|
      if File.exist?("#{Rails.root}/public/tmp/#{size + "/" + self.file_name}")
        File.copy("#{Rails.root}/public/tmp/#{size + "/" + self.file_name}", "#{Rails.root}/public/pictures/#{size + "/" + self.file_name}")
        File.delete("#{Rails.root}/public/tmp/#{size + "/" + self.file_name}")
      end
    }
    if !self.file_name_was.nil? && self.file_name_changed?
      self.all_sizes.each { |size|
        if self.file_name && File.exist?("#{Rails.root}/public/pictures/#{size + "/" + self.file_name_was}")
          File.delete("#{Rails.root}/public/pictures/#{size + "/" + self.file_name_was}")
        end
      }
    end
  end

  def del_images
    self.all_sizes.each { |size|
      if self.file_name && File.exist?("#{Rails.root}/public/pictures/#{size + "/" + self.file_name}")
        File.delete("#{Rails.root}/public/pictures/#{size + "/" + self.file_name}")
      end
    }
  end

end
