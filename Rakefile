require 'bundler/setup'
require 'erb'
require 'yaml'
require 'mysql2'

CONFIG = YAML.load(ERB.new(File.read(File.join(__dir__, 'database.yml'))).result)['development']

namespace :db do
  task :create do
    client = Mysql2::Client.new(CONFIG.reject { |k, _| k == 'database' })
    client.query("CREATE DATABASE IF NOT EXISTS #{CONFIG['database']}")
  end

  task :migrate do
    sh %q{bundle exec ridgepole -c database.yml --table-options 'ENGINE=InnoDB DEFAULT CHARSET=utf8' --apply}
  end

  task :drop do
    client = Mysql2::Client.new(CONFIG.reject { |k, _| k == 'database' })
    client.query("DROP DATABASE IF EXISTS #{CONFIG['database']}")
  end

  task reset: %i[drop create migrate]

  task :insert do
    require 'faker'
    require 'active_record'
    require 'bulk_insert'
    Dir[File.join(__dir__, 'models', '**', '*.rb')].each do |file|
      require file
    end

    user_count    = 100
    shop_count    = 10
    product_count = 5000
    order_count   = 10000

    prng = Random.new(42)
    Faker::Config.random = prng

    ActiveRecord::Base.establish_connection(CONFIG)

    User.bulk_insert do |worker|
      user_count.times.each do
        worker.add([Faker::Name.unique.name])
      end
    end

    Shop.bulk_insert do |worker|
      shop_count.times.each do
        worker.add([Faker::Company.unique.name])
      end
    end

    Product.bulk_insert do |worker|
      product_count.times.each do
        shop_id = prng.rand(shop_count) + 1
        name = Faker::Book.title
        price = (prng.rand(30) + 1) * 100
        started_at = Faker::Time.between(Date.parse('2017-11-01'), Date.parse('2018-03-31'), :all)
        ended_at = started_at + 86400 * (prng.rand(7) + 1)
        worker.add([shop_id, name, price, started_at, ended_at])
      end
    end

    id_to_product = Product.all.index_by(&:id)
    Order.bulk_insert do |worker|
      order_count.times.each do
        user_id = prng.rand(user_count) + 1
        product_id = prng.rand(product_count) + 1
        count = (prng.rand(5) + 1)
        product = id_to_product[product_id]
        created_at = Faker::Time.between(product.started_at, product.ended_at, :all)
        worker.add([user_id, product_id, count, created_at, nil])
      end
    end
  end
end
