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

  task :migrate do |t, args|
    command = %q{bundle exec ridgepole -c database.yml --table-options 'ENGINE=InnoDB DEFAULT CHARSET=utf8' --apply}
    if ENV['DRY_RUN'] == 'true' || ENV['DRY_RUN'] == '1'
      command << ' --dry-run'
    end
    sh command
  end

  task :drop do
    client = Mysql2::Client.new(CONFIG.reject { |k, _| k == 'database' })
    client.query("DROP DATABASE IF EXISTS #{CONFIG['database']}")
  end

  task reset: %i[drop create migrate]

  task :insert do
    require 'faker'
    require 'active_record'
    Dir[File.join(__dir__, 'models', '**', '*.rb')].each do |file|
      require file
    end

    user_count    = 100
    shop_count    = 10
    product_count = 5_000
    order_count   = 10_000

    prng = Random.new(42)
    Faker::Config.random = prng

    ActiveRecord::Base.establish_connection(CONFIG)

    User.insert_all!(user_count.times.map { { name: Faker::Name.unique.name } })

    Shop.insert_all!(shop_count.times.map { { name: Faker::Company.unique.name } })

    products = product_count.times.map do
      # Don't change the order of generating random values to keep the results
      shop_id = prng.rand(shop_count) + 1
      name = Faker::Book.title
      price = (prng.rand(30) + 1) * 100
      started_at = Faker::Time.between_dates(from: Date.parse('2017-11-01'), to: Date.parse('2018-03-31'))
      {
        shop_id: shop_id,
        name: name,
        price: price,
        started_at: started_at,
        ended_at: started_at + 86400 * (prng.rand(7) + 1),
      }
    end
    Product.insert_all!(products)

    id_to_product = Product.all.index_by(&:id)
    orders = []
    order_count.times do
      # Don't change the order of generating random values to keep the results
      user_id = prng.rand(user_count) + 1
      product_id = prng.rand(product_count) + 1
      count = (prng.rand(5) + 1)
      product = id_to_product[product_id]
      orders << {
        user_id: user_id,
        product_id: product_id,
        count: count,
        created_at: Faker::Time.between_dates(from: product.started_at, to: product.ended_at),
      }
      if orders.size == 1_000
        Order.insert_all!(orders)
        orders.clear
      end
    end
    Order.insert_all!(orders) unless orders.empty?
  end
end
