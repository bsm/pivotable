# Includable module, for ActiveRecord::Base
module Pivotable::Model
  extend ActiveSupport::Concern

  included do
    class_attribute :_pivotable
    self._pivotable = {}
  end

  module ClassMethods

    # Pivotable definition for a model. Example:
    #
    #   class Stat < ActiveRecord::Base
    #
    #     # Add your rotations
    #     pivotable do
    #
    #       rotation :overall do
    #         sum :visits
    #       end
    #
    #       # Rotations can in herit parent definitions
    #       rotation :by_day => :overall do
    #         by :day
    #       end
    #
    #     end
    #
    #     # Add your custom rotations, e.g. for admins
    #     pivotable :admin do
    #
    #       rotation :overall do
    #         sum :visits
    #         maximum :bounce_rate
    #       end
    #
    #     end
    #
    #   end
    #
    def pivotable(name = nil, &block)
      name = name.present? ? name.to_sym : :_default
      _pivotable[name] ||= Pivotable::Collection.new(self)
      _pivotable[name.to_sym].instance_eval(&block) if block
      _pivotable[name]
    end

    # Delegator to Relation#pivot
    def pivot(*args)
      scoped.pivot(*args)
    end

  end
end