require 'json'
require 'rexml/document'
include REXML
    require 'net/http'

class ApiController < ApplicationController
  
#######################################################################################  
#  Non Controller functions
#######################################################################################  


def validateparams(id,xid,yid)
  data = {}
if xid =='validate'
  data = Licenseeval.eval(id,yid)
  
end
if xid =='actions'
    xmlfile = File.new("public/Licenses/#{id}.xml")
    xmldoc = Document.new(xmlfile)
    num = 1;
    data = {}

     xmldoc.elements.each("*/permissions/restricted-activity") { |ra|
     
    activity =  ra.elements["activity"].text
   name = "activity#{num}"
  data[name] = activity
    num = num + 1
   #data  = {"aswin" => "aswin"}
   
     }
     
end
if data.length == 0 then
  data["error"] = "IO error."
end
    return data
end
#######################################################################################  
#  Controller functions
#######################################################################################   
  def index
    print "Error"
  end
  
def license
  data={}

    if !params[:xid] then
    @lsid = params[:id]
    
    licenses = Licenses.first(:conditions => ["ls_id = ?", params[:id]])
    data = {"ls_id" => licenses[:ls_id],
        "domain" => licenses[:domain],
        "description" => licenses[:description],
        "is_source" => licenses[:is_source],
        "link_to_actions" => "http://0.0.0.0:3001/api/license/#{licenses[:ls_id]}/actions"
    }
    end
    if params[:xid] then
     data = validateparams(params[:id],params[:xid],params[:yid])
   end
   
#@msg = data.inspect
#@msg = data

if data.length == 0 then
  data["error"] = "IO error."
end  
@msg = JSON.pretty_generate(data)

  end
end
