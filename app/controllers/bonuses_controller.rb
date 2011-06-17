class BonusesController < ApplicationController
  before_filter :authenticate_admin
  
  def index
    @bonuses = Bonus.all
  end

  def show
    @bonus = Bonus.find(params[:id])
  end

  def new
    @bonus = Bonus.new
  end

  def create
    @bonus = Bonus.new(params[:bonus])
    if @bonus.save
      redirect_to @bonus, :notice => "Successfully created bonus."
    else
      render :action => 'new'
    end
  end

  def edit
    @bonus = Bonus.find(params[:id])
  end

  def update
    @bonus = Bonus.find(params[:id])
    if @bonus.update_attributes(params[:bonus])
      redirect_to @bonus, :notice  => "Successfully updated bonus."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @bonus = Bonus.find(params[:id])
    @bonus.destroy
    redirect_to bonuses_url, :notice => "Successfully destroyed bonus."
  end
end
