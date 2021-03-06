ENV["RAILS_ENV"] ||= 'test'

$: << File.dirname(__FILE__) + '/../lib'
require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require :default, :test

require 'active_support'
require 'active_record'
require 'active_record/fixtures'
require 'action_view'
require 'rspec'
require 'rspec/rails/adapters'
require 'rspec/rails/fixture_support'
require 'pivotable'

SPEC_DATABASE     = File.dirname(__FILE__) + '/tmp/test.sqlite3'
ActiveRecord::Base.time_zone_aware_attributes = true
ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.configurations["test"] = { 'adapter' => 'sqlite3', 'database' => ":memory:" }
ActiveRecord::Base.establish_connection :test

class String

  def clean_sql
    squish.gsub(/[`"]/, "").gsub(/\.0+/, "")
  end

end

RSpec.configure do |c|
  c.fixture_path = File.dirname(__FILE__) + '/fixtures'
  c.before(:all) do
    base = ActiveRecord::Base
    base.establish_connection(:test)
    base.connection.create_table :stats do |t|
      t.integer :period
      t.integer :website_id
      t.integer :page_id
      t.integer :views
      t.integer :visits
      t.decimal :bounce_rate
    end
    base.connection.create_table :websites do |t|
      t.string  :name
    end
    base.connection.create_table :pages do |t|
      t.integer  :website_id
      t.string   :name
      t.datetime :updated_at
    end
    base.connection.create_table :periods, :primary_key => :period do |t|
      t.integer :month_code
      t.date    :calendar_date
    end
  end
end

class Website < ActiveRecord::Base
end

class Page < ActiveRecord::Base
  belongs_to :website
end

class Period < ActiveRecord::Base
  self.primary_key = :period
end

class Stat < ActiveRecord::Base
  self.primary_key = :period

  belongs_to :website
  belongs_to :page
  belongs_to :date, :class_name => 'Period', :foreign_key => :period

  pivotable :base do
    sum     :views, :visits
    average :bounce_rate
  end

  pivotable :by_day => :base do
    by      :period
  end

  pivotable :by_month => :base do
    by      :month_code, :via => Period.arel_table[:month_code]
    joins   "RIGHT OUTER JOIN periods ON periods.period = stats.period"
  end

  pivotable :by_site => :base do
    by      :website_id
    by      :website_name, :via => Website.arel_table[:name]
    joins   :website
  end

  pivotable :by_page => :base do
    maximum :top_bounce_rate, :via => :bounce_rate
    by      :page_id
    by      :page_name, :via => Page.arel_table[:name]
    by      :page_updated_at, :via => Page.arel_table[:updated_at]

    joins   :page
  end

end

