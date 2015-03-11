class WorklogsController < ApplicationController
  before_action :set_worklog, only: [:show, :edit, :update, :destroy]

  # GET /worklogs
  # GET /worklogs.json
  def index 
    @search = Worklog.search(params[:q])
    @search.sorts = 'workday asc' if @search.sorts.empty?
    @worklogs = @search.result.order(:emp_id,:workday)
  end
  
  def index_edit
    @worklogs = Worklog.extractOneMonth(session[:year].to_i, session[:month].to_i, current_user.emp)
  end

  def index_update
    puts params
    params[:worklog].each do | id, data |
      worklog = Worklog.find(id.to_i)
      worklog.update_attributes(data)
      worklog.save
    end
    redirect_to controller: 'worklogs', action: 'index_edit' and return
  end

  # GET /worklogs/1
  # GET /worklogs/1.json
  def show
  end

  # GET /worklogs/new
  def new
    @worklog = Worklog.new
    @holiday_list = ["a","b","c"]
  end

  # GET /worklogs/1/edit
  def edit
  end

  # POST /worklogs
  # POST /worklogs.json
  def create
    @worklog = Worklog.new(worklog_params)

    respond_to do |format|
      if @worklog.save
        format.html { redirect_to @worklog, notice: 'Worklog was successfully created.' }
        format.json { render :show, status: :created, location: @worklog }
      else
        format.html { render :new }
        format.json { render json: @worklog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /worklogs/1
  # PATCH/PUT /worklogs/1.json
  def update
    respond_to do |format|
      if @worklog.update(worklog_params)
        format.html { redirect_to @worklog, notice: 'Worklog was successfully updated.' }
        format.json { render :show, status: :ok, location: @worklog }
      else
        format.html { render :edit }
        format.json { render json: @worklog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /worklogs/1
  # DELETE /worklogs/1.json
  def destroy
    @worklog.destroy
    respond_to do |format|
      format.html { redirect_to worklogs_url, notice: 'Worklog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # CSV Upload /upload
  def upload
    require 'csv'
	  if !params[:upload_file].blank?
	    reader = params[:upload_file].read
	    CSV.parse(reader) do |row|
	      w = Worklog.from_csv(row)
	      w.save()
	    end
	  end
	  redirect_to :action => :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_worklog
      @worklog = Worklog.find(params[:id])
    end  
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def worklog_params
      params.require(:worklog).permit(:dept_id, :emp_id, :workday, :holiday, :worktype, :rc_start, :wk_start, :wk_end, :rc_end, :rest, :reason, :comment, :check, :holiday_id, :worktype_id)
    end
end
