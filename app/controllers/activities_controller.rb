class ActivitiesController < InheritedResources::Base
  def index
    @activities = Activity.all
    @activity = Activity.first

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @activies }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @activities = Activity.all
    @activity = Activity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @activity }
    end
  end
end
