json.set! :id, agency.id
json.set! :name, agency.name
json.set! :info_url, agency.info_url
if include_counts
  json.set! :mobile_app_count, agency.published_mobile_app_count
  json.set! :social_media_count, agency.published_outlet_count
  json.set! :gallery_count, agency.published_gallery_count
end