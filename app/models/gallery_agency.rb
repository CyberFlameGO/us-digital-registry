# == Schema Information
#
# Table name: gallery_agencies
#
#  id         :integer          not null, primary key
#  gallery_id :integer
#  agency_id  :integer
#

class GalleryAgency < ActiveRecord::Base
  belongs_to :agency
  belongs_to :gallery


  after_save :update_counter_cache
  after_destroy :update_counter_cache
  
  def update_counter_cache
    self.agency.draft_gallery_count = self.agency.galleries.where(status: 1).count
    self.agency.published_gallery_count = self.agency.galleries.where(status: 1).count
    self.agency.save!
  end
end
