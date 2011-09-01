class Pivotable::Expression::Generic < Pivotable::Expression::Abstract

  def to_select
    case via
    when String
      "#{via} AS #{name}"
    else
      via.as(name).to_sql.tap do |s|
        s.sub!(/AS .+$/, "AS #{name}") if Arel::VERSION < "2.1.0"
      end
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