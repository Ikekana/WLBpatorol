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
    params[:worklog].each do | id, data |
      worklog = Worklog.find(id)
      worklog.update(data)
    end
    redirect_to controller: 'worklogs', action: 'index_edit' and return
  end

  def edit_today
    res = Worklog.where(:workday => Date.today)
    if res.present?
      redirect_to("/worklogs/" + res.first.id.to_s + "/edit") and return
    end
    redirect_to("/worklogs/new")
  end
  
  # 一日分のメンバーの勤務状況を抽出する
  def index_oneday
    format = "%Y-%m-%d"
    if session[:date].nil?
      session[:date] = Date.today.strftime(format)
    end

    if params[:date] == 'yesterday'
      session[:date] = Date.strptime(session[:date], format) - 1
    else
      if params[:date] == 'tomorrow'
        session[:date] = Date.strptime(session[:date], format) + 1
      end
    end
    session[:date] = session[:date].strftime(format)

    @worklogs = Worklog.where(:dept_code => current_user.dept_range, :workday => session[:date]).order(:dept_code, :emp_code)

    anArray = Array.new()
    @worklogs.each do | worklog |
      anArray.append([worklog.dept.name, worklog.emp.name, worklog.wk_start.hour, worklog.wk_start.min, worklog.wk_start.sec, worklog.wk_end.hour, worklog.wk_end.min, worklog.wk_end.sec ])
    end
    gon.graph_data = anArray
    puts anArray

    
  end
  # GET /worklogs/1
  # GET /worklogs/1.json
  def show
  end

  # GET /worklogs/new
  def new
    # @worklog = Worklog.new
    today = Date.today
    @worklog = Worklog.new_on(today.year, today.month, today.day, current_user.emp)
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
        if params[:wk_start]
          @worklog.update_attribute(:wk_start, Time.zone.now)
          puts "*********** wk_start *********** " + @worklog.wk_start.to_s + '----' + @worklog.wk_end.to_s # + "zone hrs : " +  Time.zone.now.hour 
          @worklog.save
        end
        if params[:wk_end]
          @worklog.update_attribute(:wk_end, Time.zone.now)
          puts "***********  wk_end  *********** " + @worklog.wk_start.to_s + '----' + @worklog.wk_end.to_s + "zone hrs : " +  Time.zone.now.hour.to_s
          @worklog.save
        end
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
        if params[:wk_start]
          @worklog.update_attribute(:wk_start, Time.zone.now)
          puts "*********** wk_start *********** " + @worklog.wk_start.to_s + '----' + @worklog.wk_end.to_s # + "zone hrs : " +  Time.zone.now.hour 
          @worklog.save
        end
        if params[:wk_end]
          @worklog.update_attribute(:wk_end, Time.zone.now)
          puts "***********  wk_end  *********** " + @worklog.wk_start.to_s + '----' + @worklog.wk_end.to_s + "zone hrs : " +  Time.zone.now.hour.to_s
          @worklog.save
        end
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
      params.require(:worklog).permit(:dept_id, :emp_id, :workday, :holidaytype_id, :worktype_id, :rc_start, :wk_start, :wk_end, :rc_end, :rest, :reason, :comment, :check)
    end
end
