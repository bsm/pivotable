require "active_support/core_ext"
require "active_record"
require "active_record/relation"

module Pivotable
  autoload :Model,      "pivotable/model"
  autoload :Pivoting,   "pivotable/pivoting"
  autoload :Rotation,   "pivotable/rotation"
  autoload :Column,     "pivotable/column"
  autoload :Collection, "pivotable/collection"
end

ActiveRecord::Base.class_eval do
  include ::Pivotable::Model
end

ActiveRecord::Relation.class_eval do
  include ::Pivotable::Pivoting
end
