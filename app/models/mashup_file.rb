class MashupFile < ActiveRecord::Base
   def self.save(name)
    directory = "public/LicensesMashups"
    # create the file path
    path = File.join(directory, name)
    # write the file
    @data = "<?xml version=\"1.0\" encoding=\"utf-8\"?><license id=\"#{name}\"></license>"
    File.open("#{path}.xml", "wb") { |f| f.write(@data) }
  end
end
