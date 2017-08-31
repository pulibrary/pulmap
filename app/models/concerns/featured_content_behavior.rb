module FeaturedContentBehavior
  extend ActiveSupport::Concern

  def add_featured_content(solr_params)
    featured_content_params = send("#{blacklight_params[:featured]}_content_params")
    featured_content_params.each do |param|
      solr_params[:fq] ||= []
      solr_params[:fq] << param
    end

    solr_params
  rescue NoMethodError
    solr_params
  end

  private

  def sanborn_content_params
    [
      'dc_title_s:*Sanborn* OR dc_creator_sm:*Sanborn* OR dc_description_s:*Sanborn*',
      'layer_geom_type_s:Image OR layer_geom_type_s:Raster'
    ]
  end

  def scanned_maps_content_params
    [
      '-dc_title_s:*Sanborn* AND -dc_creator_sm:*Sanborn* AND -dc_description_s:*Sanborn*',
      'layer_geom_type_s:Image'
    ]
  end

  def raster_content_params
    ['layer_geom_type_s:Raster']
  end

  def vector_content_params
    ['layer_geom_type_s:Line OR layer_geom_type_s:Polygon OR layer_geom_type_s:Point']
  end
end
