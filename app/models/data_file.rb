class DataFile < ActiveRecord::Base
    def self.save(name)
    directory = "public/data"
    # create the file path
    path = File.join(directory, name)
    # write the file
    @data = "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<license id=\"#{name}\"> 
  <permissions> 
    <restricted-activity> 
      <activity> view </activity> 
      <cre property=\"date\" function=\"After\">0000/00/00</cre> 
      <crs property=\"subject_id\" function=\"equals\">All</crs> 
      <crr property=\"resource_id\" function=\"equals\">#{name}</crr> 
    </restricted-activity> 
    <restricted-activity> 
      <activity> Merge </activity> 
      <cre property=\"date\" function=\"After\">0000/00/00</cre> 
      <crs property=\"subject_id\" function=\"equals\">All</crs> 
      <crr property=\"resource_id\" function=\"equals\">#{name}</crr> 
    </restricted-activity> 
  </permissions> 
  <context> 
    <environment property=\"date\"> #{Time.new} </environment> 
      <resource property=\"resource_id\"> All </resource> 
    <subject property=\"subject_id\">#{name}</subject> 
  </context> 
</license>
    "
    File.open("#{path}.xml", "wb") { |f| f.write(@data) }
  end
end
