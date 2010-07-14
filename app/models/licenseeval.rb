require 'json'
require 'rexml/document'
include REXML
require 'net/http'

class Licenseeval < ActiveRecord::Base
  def self.eval(id1,id2)
    result1 = "x"
    data = {}
    licenses = Licenses.first(:conditions => ["ls_id = ?", id2])
    host = URI.parse(licenses[:domain]).host
    url = "http://ipinfodb.com/ip_query2_country.php?ip=#{host}&timezone=false"
    response =  Net::HTTP.get(URI.parse(url))
    responsedoc = Document.new(response)
    ip_C = responsedoc.elements["Locations"].elements["Location"].elements["Ip"].text
    date_C = Time.new
    location_C = responsedoc.elements["Locations"].elements["Location"].elements["CountryCode"].text
    currval = true
    tempval = true
    
    xmlfile1 = File.new("public/Licenses/#{id1}.xml")
    xmldoc1 = Document.new(xmlfile1)
    xmldoc1.elements.each("*/permissions/restricted-activity") { |level|
      level.elements.each("cre") { |level1|
        
        level1.elements.each {|level2|
          level2.elements.each{|level3|
            level3.elements.each{|restrictions|
              if restrictions.name == "restriction" then
                #The code below is to evaluate the operations, is too long -- could not write functions since I get errors in responses
                if restrictions.attributes["property"] == 'date' then
                  time2 = Time.parse(restrictions.text)
                  time1 = Time.new
                  timediff = (time1 - time2).to_i
                  #     return timediff
                  
                  if restrictions.attributes["function"] == 'on' then
                    if timediff == 0 then
                      tempval = true 
                    else
                      tempval = false 
                    end
                  end
                  if restrictions.attributes["function"] == 'before' then
                    if timediff < 0 then 
                      
                      tempval = true 
                    else
                      tempval = false 
                    end
                  end
                  if restrictions.attributes["function"] == 'after' then
                    if timediff > 0 then 
                      tempval = true 
                    else
                      tempval = false
                    end
                  end 
                end
                
                
                if restrictions.attributes["property"] == 'location' then
                  
                  if restrictions.attributes["function"] == 'in' then
                    if restrictions.text == location_C then 
                      
                      tempval = true
                    else 
                      tempval = false 
                    end
                  end
                  if restrictions.attributes["function"] == 'notin' then
                    if restrictions.text != location_C then 
                      tempval = true 
                    else
                      tempval = false 
                    end
                  end
                end
                
                
                
                if (restrictions.attributes["property"] == "geolocatable") || (restrictions.attributes["property"] == "commercial") || (restrictions.attributes["property"] == "adult") || (restrictions.attributes["property"] == "modifiable") || (restrictions.attributes["property"] == "political") then
                  xmlfile2 = File.new("public/Licenses/#{id2}.xml")
                  xmldoc2 = Document.new(xmlfile2)
                  xmldoc2.elements.each("*/context/environment/property") { |prop|
                    if prop.attributes["name"] == restrictions.attributes["property"] then
                      if prop.text ==  restrictions.text then
                        tempval = true
                      end
                      if prop.text != restrictions.text then
                        tempval = false
                      end
                      if restrictions.text == "yes" then
                        tempval = true
                      end
                    end
                    
                  }
                end
                
                if restrictions.text == 'All' then 
                  tempval = true 
                end
                if level3.name == "and" then 
                  
                  currval = tempval && currval
                  if tempval == false then
                    data["Error"] = "Error in property:#{restrictions.attributes["property"]}"
                  end
                end 
                if level3.name == "or" then 
                  currval = tempval || currval 
                end 
              end
            }
            
          }
        }
        
      }
      name = level.elements["activity"].text
      data[name] = currval
      currval = true;
    }
    return data
  end
  
  
end
