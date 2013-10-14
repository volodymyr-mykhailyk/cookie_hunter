module Arel
  module Visitors
    class ToSql
      private

      # monkey patching
      # arel-4.0.0/lib/arel/visitors/to_sql.rb
      # def visit_Arel_Nodes_Assignment o
      #   right = quote(o.right, column_for(o.left))
      #   "#{visit o.left} = #{right}"
      # end
      #
      def visit_Arel_Nodes_Assignment(o)
        if o.left && o.left.expr && o.left.expr.relation \
            && o.left.expr.relation.engine \
            && o.left.expr.relation.engine.respond_to?(:delta_attributes)  \
            && o.left.expr.relation.engine.delta_attributes.include?(o.left.name)
          l = visit o.left
          "#{l} = #{l} + #{visit o.right}"
        else
          right = quote(o.right, column_for(o.left))
          "#{visit o.left} = #{right}"
        end
      end

    end
  end
end
