class Admin::ActivitiesController < Admin::MainController

  inherit_resources

  defaults :resource_class => Activity, :route_prefix => 'admin'

  def permitted_params
    {:activity => params.fetch(:activity, {}).permit(:name, :start_date, :end_date, :preferential_code, :from, product_ids: [])}
  end

  protected

  def collection
    end_of_association_chain.recent.page(params[:page])
  end
end

