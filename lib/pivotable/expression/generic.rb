class Pivotable::Expression::Generic < Pivotable::Expression::Abstract

  def to_select
    case via
    when String
      "#{via} AS #{name}"
    else
      sql = Arel::Visitors.visitor_for(model.arel_table.engine).accept via
      "#{sql} AS #{name}"
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