require_relative 'application_record'

class User < ApplicationRecord
  has_many :orders
end
