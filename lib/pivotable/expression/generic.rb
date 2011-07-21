class Pivotable::Expression::Generic < Pivotable::Expression::Abstract

  def to_select
    case via
    when String
      "#{via} AS #{model.connection.quote(name)}"
    else
      via.as(name.to_sym)
    end
  end

  def to_group
    via.clone
  end

  protected

    def process_via(value)
      case value
      when Symbol
        model.arel_table[value]
      when Arel::Attribute
        value
      else
        super
      end
    end

end