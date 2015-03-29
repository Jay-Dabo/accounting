class Admin::PlansController < Admin::BaseController
  
  # def index
  #  @plans = Plan.order("duration")
  #  @user = current_user
  # end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)
    respond_to do |format|
      if @plan.save
        format.html { redirect_to plans_path, notice: 'Plan was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def update
    @plan = Plan.find(params[:id])

    respond_to do |format|
      if @plan.update_attributes(plan_params)
        format.html { redirect_to plans_path , notice: 'Plan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end   
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    redirect_to plans_path
  end

  private

  def plan_params
    params.require(:plan).permit(:description, :duration, :name, :price)
  end  
end