class AssetsController < ApplicationController
  
  before_filter :find_asset_by_id, :only => [:destroy]
  
  def destroy
    @asset.destroy
    flash[:notice] = "bilde dzēsta"
    redirect_to edit_product_path(@asset.product)
  end
  
  
  protected

  def find_asset_by_id
    @asset = Asset.find(params[:id])
  end
  
end
