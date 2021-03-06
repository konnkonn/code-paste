class PastesController < ApplicationController
  # GET /pastes
  # GET /pastes.xml
  def index
    @pastes = Paste.paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 10

    @all_pastes_count = Paste.all.length
    @lang_counts = Parser.lang_counts
    @day_count = Paste.within_last_day.count
    @week_count = Paste.within_last_week.count
    @this_month_count = Paste.this_month.count
    @last_month_count = Paste.last_month.count
    @this_year = Paste.this_year.count

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /pastes/1
  # GET /pastes/1.xml
  def show
    @paste = Paste.find_by_id(params[:id])

    respond_to do |format|
      if @paste
        format.html # show.html.erb
        format.text { render :text => @paste.code }
      else
        format.html { response_to_missing_id }
        format.text { response_to_missing_id }
      end
    end
  end

  # GET /pastes/new
  # GET /pastes/new.xml
  def new
    @paste = Paste.new
    @parsers = Parser.order('display_name desc')

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /pastes/1/edit
  def edit
    @paste = Paste.find_by_id(params[:id])
    @parsers = Parser.all(:order => 'display_name')

    respond_to do |format|
      if @paste
        format.html { render }
      else
        format.html { response_to_missing_id }
      end
    end
  end

  # POST /pastes
  # POST /pastes.xml
  def create
    @paste = Paste.new(params[:paste])
    @parsers = Parser.all(:order => 'display_name')

    respond_to do |format|
      if @paste.code.blank?
        format.html {
          render :action => "new"
        }
      else
        if @paste.save
          format.html { redirect_to(@paste) }
        else
          format.html { render :action => "new" }
        end
      end
    end
  end

  # PUT /pastes/1
  # PUT /pastes/1.xml
  def update
    @paste = Paste.find_by_id(params[:id])
    @parsers = Parser.all(:order => 'display_name')

    respond_to do |format|
      if @paste
        if params[:paste].keys.include?('code') && params[:paste]['code'] == ''
          format.html {
            render :action => "edit"
          }
        else
          if @paste.update_attributes(params[:paste])
            format.html { redirect_to(@paste) }
          else
            format.html { render :action => "edit" }
          end
        end
      else
        format.html { response_to_missing_id }
      end
    end
  end

  # DELETE /pastes/1
  # DELETE /pastes/1.xml
  def destroy
    @paste = Paste.find_by_id(params[:id])

    respond_to do |format|
      if @paste
        @paste.destroy
        format.html { redirect_to root_path }
      else
        format.html {
          response_to_missing_id
        }
      end
    end
  end

  private
  def response_to_missing_id
    flash[:notice] = "Whoops, it looks like that paste doesn't exist.  Perhaps you should create a new one."
    redirect_to root_path
  end
end
