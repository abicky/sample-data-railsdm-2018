require_relative 'application_record'

class Shop < ApplicationRecord
  has_many :products
end
