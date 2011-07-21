class Pivotable::Expression::Abstract
  attr_reader :name, :model, :via

  def initialize(model, name, options = {})
    @name  = name.to_s
    @model = model
    @via   = process_via options[:via]

    raise ArgumentError, "Could not find DB attribute for '#{@name}', please specify a :via option" if via.blank?
  end

  def to_select
    not_implemented
  end

  def to_group
    not_implemented
  end

  protected

    def process_via(value)
      case value
      when String # Pure SQL string
        value
      when Symbol
        model.arel_table[value]
      else
        model.arel_table[name.to_sym]
      end
    end

end