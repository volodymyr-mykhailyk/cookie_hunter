module ActiveRecord
  module Persistence

    # monkey patching
    # activerecord-4.0.0/lib/active_record/persistence.rb
    #def update_record(attribute_names = @attributes.keys)
    #  attributes_with_values = arel_attributes_with_values_for_update(attribute_names)
    #  if attributes_with_values.empty?
    #    0
    #  else
    #    klass = self.class
    #    column_hash = klass.connection.schema_cache.columns_hash klass.table_name
    #    db_columns_with_values = attributes_with_values.map { |attr,value|
    #      real_column = column_hash[attr.name]
    #      [real_column, value]
    #    }
    #    bind_attrs = attributes_with_values.dup
    #    bind_attrs.keys.each_with_index do |column, i|
    #      real_column = db_columns_with_values[i].first
    #      bind_attrs[column] = klass.connection.substitute_at(real_column, i)
    #    end
    #    stmt = klass.unscoped.where(klass.arel_table[klass.primary_key].eq(id_was || id)).arel.compile_update(bind_attrs)
    #    klass.connection.update stmt, 'SQL', db_columns_with_values
    #  end
    #end


    def update_record(attribute_names = @attributes.keys)
      attributes_with_values = arel_attributes_with_values_for_update(attribute_names)
      if attributes_with_values.empty?
        0
      else
        klass = self.class
        column_hash = klass.connection.schema_cache.columns_hash klass.table_name
        db_columns_with_values = attributes_with_values.map { |attr,value|
          real_column = column_hash[attr.name]

          # begin of monkey patching code
          v = value
          if self.class.respond_to?(:delta_attributes) && self.class.delta_attributes.include?(attr.name)
            if @changed_attributes.include?(attr.name)
              v = value - @changed_attributes[attr.name]
            end
          end
          [real_column, v]
          # end
        }
        bind_attrs = attributes_with_values.dup
        bind_attrs.keys.each_with_index do |column, i|
          real_column = db_columns_with_values[i].first
          bind_attrs[column] = klass.connection.substitute_at(real_column, i)
        end
        stmt = klass.unscoped.where(klass.arel_table[klass.primary_key].eq(id_was || id)).arel.compile_update(bind_attrs)
        klass.connection.update stmt, 'SQL', db_columns_with_values
      end
    end
  end
end