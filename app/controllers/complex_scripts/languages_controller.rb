module ComplexScripts
  class LanguagesController < AclController
    # GET /languages
    # GET /languages.xml
    def index
      @languages = Language.order('title')

      respond_to do |format|
        format.html # index.rhtml
        format.xml { render :xml => @languages.to_xml }
      end
    end

    # GET /languages/1
    # GET /languages/1.xml
    def show
      @language = Language.find(params[:id])

      respond_to do |format|
        format.html # show.rhtml
        format.xml { render :xml => @language.to_xml }
      end
    end

    # GET /languages/new
    def new
      @language = Language.new
    end

    # GET /languages/1;edit
    def edit
      @language = Language.find(params[:id])
    end

    # POST /languages
    # POST /languages.xml
    def create
      @language = Language.new(language_params)

      respond_to do |format|
        if @language.save
          flash[:notice] = ts('new.successful', :what => Language.model_name.human.capitalize)
          format.html { redirect_to authenticated_system_language_url(@language) }
          format.xml  { head :created, :location => authenticated_system_language_url(@language) }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @language.errors.to_xml }
        end
      end
    end

    # PUT /languages/1
    # PUT /languages/1.xml
    def update
      @language = Language.find(params[:id])

      respond_to do |format|
        if @language.update_attributes(language_params)
          flash[:notice] = ts('edit.successful', :what => Language.model_name.human.capitalize)
          format.html { redirect_to authenticated_system_language_url(@language) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @language.errors.to_xml }
        end
      end
    end

    # DELETE /languages/1
    # DELETE /languages/1.xml
    def destroy
      @language = Language.find(params[:id])
      @language.destroy
      respond_to do |format|
        format.html { redirect_to authenticated_system_languages_url }
        format.xml  { head :ok }
      end
    end
    
    private
    
    def language_params
      params.require(:language).permit(:title, :code, :locale, :use_for_interface, :unicode_codepoint_start, :unicode_codepoint_end)
    end
  end
end