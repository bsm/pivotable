require "active_support/core_ext"
require "active_record"
require "active_record/relation"

module Pivotable
  autoload :Model,      "pivotable/model"
  autoload :Pivoting,   "pivotable/pivoting"
  autoload :Rotation,   "pivotable/rotation"
  autoload :Column,     "pivotable/column"

  def self.name(*tokens)
    result = tokens.flatten.map {|i| i.to_s.strip }.reject(&:blank?).join(':')
    result unless result.blank?
  end

end

ActiveRecord::Base.class_eval do
  include ::Pivotable::Model
end

ActiveRecord::Relation.class_eval do
  include ::Pivotable::Pivoting
end
