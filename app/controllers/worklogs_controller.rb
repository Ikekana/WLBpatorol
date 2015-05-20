class WorklogsController < ApplicationController
  before_action :set_worklog, only: [:show, :edit, :update, :destroy]

  # GET /worklogs
  # GET /worklogs.json
  def index 
    @search = Worklog.search(params[:q])
    @search.sorts = 'workday asc' if @search.sorts.empty?
    @worklogs = @search.result.order(:emp_id,:workday)
  end
  
  # get /worklogs/index_edit
  # 一か月分の就業実績の入力画面を表示する
  def index_edit
    @worklogs = Worklog.extractOneMonth(session[:year].to_i, session[:month].to_i, current_user.emp)
  end

  # get /worklogs/index_update
  # 一か月分の就業実績入力画面からのデータをDBに反映する
  def index_update
    params[:worklog].each do | id, worklog_params |
      worklog = Worklog.where(:id => id).first
      if worklog.nil?
        worklog = Worklog.new(worklog_params)
        worklog.save
      else
        worklog.update(worklog_params)
      end
    end
    redirect_to controller: 'worklogs', action: 'index_edit' and return
  end

  def edit_today
    res = Worklog.where(:workday => Date.today, :emp_code => current_user.emp.code)
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
      anArray.append([worklog.dept.name, worklog.emp.name].concat(worklog.wk_start_end_as_array))
    end
    gon.graph_data = anArray
    
    puts params.to_s
    
    if params[:option] == 'graph'
      render template: "worklogs/graph_index_oneday", layout: false and return
    end
    
  end

  # あるメンバーの一か月分の勤務状況を抽出する
  def index_one_member_one_month
   
    first = Date.new(session[:year].to_i, session[:month].to_i, 1)
    last  = Date.new(session[:year].to_i, session[:month].to_i, -1)  
    @worklogs = Worklog.where(:emp_code => params[:emp_code], :workday => first..last).order(:workday)
    anArray = Array.new()
    @worklogs.each do | worklog |
      anArray.append([ worklog.workday, worklog.work_minutes_in_day.to_s].concat(worklog.wk_start_end_as_array))
    end
    gon.graph_data = anArray
    
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
          @worklog.save
        end
        if params[:wk_end]
          @worklog.update_attribute(:wk_end, Time.zone.now)
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
          @worklog.save
        end
        if params[:wk_end]
          @worklog.update_attribute(:wk_end, Time.zone.now)
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
      params.require(:worklog).permit(:dept_code, :emp_code, :workday, :holidaytype_id, :worktype_id, :rc_start, :wk_start, :wk_end, :rc_end, :rest, :reason, :comment, :check)
    end
end
