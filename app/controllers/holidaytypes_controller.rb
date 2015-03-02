class HolidaytypesController < ApplicationController
  before_action :set_holidaytype, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @holidaytypes = Holidaytype.all
    respond_with(@holidaytypes)
  end

  def show
    respond_with(@holidaytype)
  end

  def new
    @holidaytype = Holidaytype.new
    respond_with(@holidaytype)
  end

  def edit
  end

  def create
    @holidaytype = Holidaytype.new(holidaytype_params)
    @holidaytype.save
    respond_with(@holidaytype)
  end

  def update
    @holidaytype.update(holidaytype_params)
    respond_with(@holidaytype)
  end

  def destroy
    @holidaytype.destroy
    respond_with(@holidaytype)
  end

  private
    def set_holidaytype
      @holidaytype = Holidaytype.find(params[:id])
    end

    def holidaytype_params
      params.require(:holidaytype).permit(:name)
    end
end
