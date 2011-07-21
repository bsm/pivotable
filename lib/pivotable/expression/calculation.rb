class Pivotable::Expression::Calculation < Pivotable::Expression::Abstract

  attr_reader :function

  def initialize(model, name, options = {})
    super
    @function = options[:function] if options[:function].is_a?(Symbol)

    if via.is_a?(Arel::Attribute)
      raise ArgumentError, "No calculation function provided for '#{@name}'. Please provide a :function option" unless function
      @via = via.send(function)
    end
  end

  def to_select
    case via
    when String
      "#{via} AS #{name}"
    else
      via.clone.as(name)
    end
  end

  def to_group
    raise RuntimeError, "Cannot group by calculation"
  end

  protected

    def process_via(value)
      case value
      when Arel::Expression
        value
      else
        super
      end
    end

end