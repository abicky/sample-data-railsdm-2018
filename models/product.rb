require_relative 'application_record'

class Product < ApplicationRecord
  has_many :orders
end
