class FileManipulation

  def self.to_file(filename, data)
    File.open(filename, 'wb') do |f|
      f.write data
      f.close
    end
  end

  def self.from_file(filename)
    data = ""
    if File.exist?(filename)
      File.open(filename, 'r') do |f|
        data = f.read
        f.close
      end
    end
    data
  end


end