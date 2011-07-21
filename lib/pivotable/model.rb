# Includable module, for ActiveRecord::Base
module Pivotable::Model
  extend ActiveSupport::Concern

  module ClassMethods

    # Pivotable definition for a model. Example:
    #
    #   class Stat < ActiveRecord::Base
    #
    #     # Add your rotations
    #     pivotable :overall do
    #       sum :visits
    #     end
    #
    #     # Rotations can in herit parent definitions
    #     pivotable :daily => :overall do
    #       by :day
    #     end
    #
    #     # Add "namespaced" rotations, e.g. for admins
    #     pivotable "admin:daily" => :daily do
    #       maximum :bounce_rate
    #     end
    #
    #     # Can be expressed as
    #     pivotable :admin, :extended => [:admin, :daily] do
    #       sum :bot_impressions
    #     end
    #
    #   end
    #
    def pivotable(*tokens, &block)
      name, parent = tokens.extract_options!.to_a.first
      name, parent = Pivotable.name(tokens, name), Pivotable.name(parent)
      raise ArgmentError, "A name must be provided" unless name

      _pivotable[name] = Pivotable::Rotation.new(self, name, parent, &block) if block
      _pivotable[name]
    end

    # Delegator to Relation#pivot
    def pivot(*args)
      scoped.pivot(*args)
    end

    def _pivotable
      @_pivotable ||= {}
    end

  end
end