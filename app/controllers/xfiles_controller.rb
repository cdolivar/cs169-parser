class XfilesController < ApplicationController

  require 'crack' # XML and JSON parsingrequire 'crack/json' # Only JSON parsing
  require 'crack/xml' # Only XML parsing

  def xfile_params
    params.require(:xfile).permit(:name, :content)
  end

  #To show the data fields and their relationships in a data file.
  def show
    id = params[:id] # retrieve movie ID from URI route
    @xfile = Xfile.find(id) # look up movie by unique ID
  end

  #To show the list of files uploaded to the application.
  def index
    @xfiles = Xfile.all
  end

  # default: render 'new' template
  def new
  end


  #To create the file and store it into our database.
  def create
    @xfile = params[:content].read
    @name = params[:content].original_filename
    @extension = @name.split('.').last
    if @extension == "json"
      @data = Crack::JSON.parse(@xfile)
      @xfile = Xfile.create!(xfile_params) do |xfile|
        xfile.content = @data
        if xfile.name.empty?
          xfile.name = params[:content].original_filename
        end
      end
    elsif @extension == "xml"
      @data = Crack::XML.parse(@xfile)
      @xfile = Xfile.create!(xfile_params) do |xfile|
        xfile.content = @data
        if xfile.name.empty?
          xfile.name = params[:content].original_filename
        end
      end
    end
    flash[:notice] = "#{@xfile.name} was successfully created."
    redirect_to xfiles_path
  end

  #To edit the file, but not really necessary at the moment.
  def edit
  end

  #To update the file, but also not necessary at the moment.
  def update
  end

  #To delete the file from database.
  def destroy
    @xfile = Xfile.find(params[:id])
    @xfile.destroy
    flash[:notice] = "File '#{@xfile.name}' deleted."
    redirect_to xfiles_path
  end

end
