class WorktypesController < ApplicationController
  before_action :set_worktype, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @worktypes = Worktype.all
    respond_with(@worktypes)
  end

  def show
    respond_with(@worktype)
  end

  def new
    @worktype = Worktype.new
    respond_with(@worktype)
  end

  def edit
  end

  def create
    @worktype = Worktype.new(worktype_params)
    @worktype.save
    respond_with(@worktype)
  end

  def update
    @worktype.update(worktype_params)
    respond_with(@worktype)
  end

  def destroy
    @worktype.destroy
    respond_with(@worktype)
  end

  private
    def set_worktype
      @worktype = Worktype.find(params[:id])
    end

    def worktype_params
      params.require(:worktype).permit(:name)
    end
end
