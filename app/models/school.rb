class School < ActiveRecord::Base
  validates_presence_of :abbrev, :full, :region
  validates :abbrev, :uniqueness => {:scope => :full}
  # belongs_to :region
end