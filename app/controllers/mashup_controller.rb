require 'rexml/document'
include REXML
class MashupController < ApplicationController
  #############################################################
  #
  #    Start of non-controller functions 
  #
  #############################################################
  
  require 'rexml/document'
  include REXML
  
  def pretty_print(parent_node, itab)
    buffer = ''
    
    parent_node.elements.each do |node|
      
      buffer += ' ' * itab + "<#{node.name}#{get_att_list(node)}"
      if node.to_a.length > 0
        buffer += ">"
        if node.text.nil?
          buffer += "\n"
          buffer += pretty_print(node,itab+2) 
          buffer += ' ' * itab + "</#{node.name}>\n"
        else
          node_text = node.text.strip
          if node_text != ''
            buffer += node_text 
            buffer += "</#{node.name}>\n"        
          else
            buffer += "\n" + pretty_print(node,itab+2) 
            buffer += ' ' * itab + "</#{node.name}>\n"        
          end
        end
      else
        buffer += "/>\n"
      end
      
    end
    buffer
  end
  
  def get_att_list(node)
    att_list = ''
    node.attributes.each { |attribute, val| att_list += " #{attribute}='#{val}'" }
    att_list
  end
  
  def pretty_xml(doc)
    buffer = ''
    xml_declaration = doc.to_s.match('<\?.*\?>').to_s
    buffer += "#{xml_declaration}\n" if not xml_declaration.nil?
    xml_doctype = doc.to_s.match('<\!.*\">').to_s
    buffer += "#{xml_doctype}\n" if not xml_doctype.nil?
    buffer += "<#{doc.root.name}#{get_att_list(doc.root)}"
    if doc.root.to_a.length > 0
      buffer +=">\n#{pretty_print(doc.root,2)}</#{doc.root.name}>"
    else
      buffer += "/>\n"
    end
  end
  
  
  def merge(xmldoc,xmldoc2)
    @activitylength = xmldoc.elements["*/permissions/restricted-activity"].size
    xmldoc.elements.each("*/permissions/restricted-activity") { |restricted_activity| 
      
      xmldoc2.elements.each("*/permissions/restricted-activity") { |restricted_activity2| 
        activity = restricted_activity.elements["activity"].text
        activity2 = restricted_activity2.elements["activity"].text
        
        if activity == activity2 then
          cre = restricted_activity.elements["cre"].elements["or"].elements["and"]
          cre2 = restricted_activity2.elements["cre"].elements["or"].elements["and"].each_element {|new|
         crex = cre.add(new)
        pretty_xml(cre)
         }
           
         
                crr = restricted_activity.elements["crr"].elements["or"].elements["and"]
          crr2 = restricted_activity2.elements["crr"].elements["or"].elements["and"].each_element {|new|
         crex = crr.add(new)
        pretty_xml(crr)
         }
          
                crs = restricted_activity.elements["crs"].elements["or"].elements["and"]
          crs2 = restricted_activity2.elements["crs"].elements["or"].elements["and"].each_element {|new|
         crex = crs.add(new)
        pretty_xml(crs)
         }
          @found = true;
        end
        
        
      }  
      if(@found = false) then
        @activitylength = @activitylength + 1
        restricted_activity2.add_attribute('num', @activitylength)
        xmldoc.elements["permissions"].add(restricted_activity2)
        
      end
      
    }  
    return xmldoc  
  end
  #xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  #    End of non-controller functions 
  #xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  
  #############################################################
  #
  #    Start of controller functions 
  #
  ############################################################# 
  
  def index
    if session[:auth] != true
      redirect_to :controller=>'users', :action=> 'index'
    end
    if session[:auth] == true
      redirect_to :controller=>'mashup', :action=> 'start'
    end
  end
  
  #----------------------------------------------------------------------------------------------
  
  def start
    if session[:auth] != true
      redirect_to :controller=>'users', :action=> 'index'
    end  
  end
  
  #----------------------------------------------------------------------------------------------
  
  def createlicense
    if session[:auth] != true
      redirect_to :controller=>'users', :action=> 'index'
    end
    @state = "#{Time.new} #{params[:source1]}"
    @key =  Digest::SHA1.hexdigest @state
    session[:licensekey] = @key
    session[:location] = params[:source1]
    @user = Licenses.new(:ls_id => @key, :user_id => session[:username], :domain => session[:location], :is_source => "Yes", :description => params[:desc], :source1 =>session[:location] )  
    if @user.save  
      @notice = 'The input has been fed into the database. Please continue building the license. '
      
    else  
      @notice = 'Oops ! Something went wrong! Please check if you gave all the needed inputs from the previous page by hitting the Back button. '  
    end
  end
  
  #=====================================================================
  #Code to create license - study license structure first to understand the code better. 
  #=====================================================================
  
  
  def createlicense2
    if session[:auth] != true
      @msg = " Not logged in ! "
      Process.exit
    end
    params[:C_Environment].each do |@envs|
      @str = "#{@str} + #{@envs}"
    end
    post = DataFile.save(session[:licensekey])
    @num = 1
    xmlfile = File.new("public/Licenses/#{session[:licensekey]}.xml")
    xmldoc = Document.new(xmlfile)
    xmldoc.elements.each("license") { |license| 
      params[:Activities].each do |@activeloop|
        permissions = license.add_element "permissions"
        restricted_activity = permissions.add_element "restricted-activity" , {"num" => @num}
        activity = restricted_activity.add_element "activity"
        activity.text = @activeloop
        cre = restricted_activity.add_element "cre"
        or_ = cre.add_element "or"
        and_ = or_.add_element "and"
        params[:C_Environment].each do |@looper|
          @sel = "Select_#{@activeloop}_#{@looper}"
          @creval = "#{@activeloop}_#{@looper}"
          restriction = and_.add_element "restriction" , {"property" => @looper , "function" => params[@sel], "type"=>"cre"}
          restriction.text = params[@creval]
        end
        crs = restricted_activity.add_element "crs"
        or_ = crs.add_element "or"
        and_ = or_.add_element "and"
        params[:C_Subject].each do |@looper|
          @sel = "Select_#{@activeloop}_#{@looper}"
          @creval = "#{@activeloop}_#{@looper}"
          restriction = and_.add_element "restriction" , {"property" => @looper , "function" => params[@sel], "type"=>"crs"}
          restriction.text = params[@creval]
        end
        crr = restricted_activity.add_element "crr"
        or_ = crr.add_element "or"
        and_ = or_.add_element "and"
        params[:C_Resource].each do |@looper|
          @sel = "Select_#{@activeloop}_#{@looper}"
          @creval = "#{@activeloop}_#{@looper}"
          restriction = and_.add_element "restriction" , {"property" => @looper , "function" => params[@sel], "type"=>"crr"}
          restriction.text = params[@creval]
        end
        @num = @num + 1
      end
      
      #Creating the context values ...
      context = license.add_element "context" 
      subject = context.add_element "subject"
      params[:C_Subject].each do |@looper|
        property = subject.add_element "property"
        property.attributes["name"] = @looper
      end
      resource = context.add_element "resource"
      params[:C_Resource].each do |@looper|
        property = resource.add_element "property"
        property.attributes["name"] = @looper
      end
      resource = context.add_element "environment"
      params[:C_Environment].each do |@looper|
        property = resource.add_element "property"
        property.attributes["name"] = @looper
      end
      
      
    }
    
    
    xmldoc = pretty_xml(xmldoc)
    
    @msg = xmldoc
    File.open("public/Licenses/#{session[:licensekey]}.xml", "wb") { |f| f.write(xmldoc) }
    
  end
  #----------------------------------------------------------------------------------------------
  
  #===============================================================================
  #Code to create mashup license - Takes the inputs from the start page. 
  #===============================================================================
  
  def createmashup
    
    if session[:auth] != true
      redirect_to :controller=>'users', :action=> 'index'
    end
    @state = "#{Time.new} #{params[:source]}"
    @key =  Digest::SHA1.hexdigest @state
    session[:licensekey] = @key
    session[:location] = params[:source]
    post = DataFile.save(session[:licensekey])
     @user = Licenses.new(:ls_id => @key, :user_id => session[:username], :domain => session[:location], :is_source => "No", :description => params[:desc], :source1 =>params[:source1],:source2 =>params[:source2],:source3 =>params[:source3],:source4 =>params[:source4],:source5 =>params[:source5] )  
    if @user.save  then
      @notice = 'The input has been fed into the database. Please continue building the license. '
      
    else  
      @notice = 'Oops ! Something went wrong! Please check if you gave all the needed inputs from the previous page by hitting the Back button. '  
    end
    #-----------------------------------------------------------
    # Just reading the sources, to check the number of sources -- Nothing much to it 
    #-------------------------------------------------------------
    if(params[:source1]!='') then
      xmlfile1 = File.new("public/Licenses/#{params[:source1]}.xml")
      xmldoc1 = Document.new(xmlfile1)
      @sources = 1
    end
    if(params[:source2]!='') then
      xmlfile2 = File.new("public/Licenses/#{params[:source2]}.xml")
      xmldoc2 = Document.new(xmlfile2)
      @sources = 2
    end
    if(params[:source3]!='') then
      xmlfile3 = File.new("public/Licenses/#{params[:source3]}.xml")
      xmldoc3 = Document.new(xmlfile3)
      @sources = 3
    end
    if(params[:source4]!='') then
      xmlfile4 = File.new("public/Licenses/#{params[:source4]}.xml")
      xmldoc4 = Document.new(xmlfile4)
      @sources = 4
    end
    if(params[:source5]!='') then
      xmlfile5 = File.new("public/Licenses/#{params[:source5]}.xml")
      xmldoc5 = Document.new(xmlfile5)
      @sources = 5
    end
    xmlfile = File.new("public/Licenses/#{session[:licensekey]}.xml")
    xmldoc = Document.new(xmlfile)
    xmldoc = xmldoc1
      
    # pretty_xml() and merge() functions can be found on top of this page. 
    
    xmldocadd =merge(xmldoc,xmldoc2); 
    xmldoc = pretty_xml(xmldocadd)
    
    
    @msg = xmldoc
    File.open("public/Licenses/#{session[:licensekey]}.xml", "wb") { |f| f.write(xmldocadd) }
    
    
    
  end
end


# Code to save the file ...................... 
# @state = "#{Time.new} #{params[:url]}"
#@key =  Digest::SHA1.hexdigest @state
#@msg = "Your Key = #{@key}"
#    post = DataFile.save(@key)
#@user = Mashup.new(:key => @key, :url => params[:url], :user => session[:username])  
#         if @user.save  
#           @notice = 'The License has been saved ... '
#           
#         else  
#           @notice = 'OoPs ! something went wrong!'  
#       end