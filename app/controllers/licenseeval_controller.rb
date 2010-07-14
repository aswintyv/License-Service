class LicenseevalController < ApplicationController
 def eval(id1,id2)
   #gettng the contexts first.
    licenses = Licenses.first(:conditions => ["ls_id = ?", id2])
    host = URI.parse(licenses[:domain]).host
    response =  Net::HTTP.get(URI.parse("http://ipinfodb.com/ip_query2_country.php?ip=#{host}&timezone=false"))
return response
  end
end
