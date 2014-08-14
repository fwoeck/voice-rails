class StatsController < ApplicationController


  def index
    render json: Dataset.all, each_serializer: DatasetSerializer, root: :datasets
  end
end
