class Episode < ApplicationRecord
  has_many :tv_series, dependent: :destroy
end
