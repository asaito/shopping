class Mallshopm < ActiveRecord::Base
  belongs_to :malladmin
  scope :latest, order('updated_at desc')
end
