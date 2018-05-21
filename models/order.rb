require_relative 'application_record'

class Order < ApplicationRecord
  belongs_to :user
  belongs_to :product
end
