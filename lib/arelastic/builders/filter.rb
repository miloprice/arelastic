module Arelastic
  module Builders
    class Filter < Struct.new :field
      class << self
        def [](field)
          new(field)
        end

        def ids *ids
          Arelastic::Filters::Ids.new ids.flatten
        end

        def not expr
          Arelastic::Filters::Not.new expr
        end
      end

      def eq other
        Arelastic::Filters::Term.new field, other
      end

      def not_eq other
        self.class.not eq(other)
      end

      def in other, options = {}
        case other
        when Range
          if other.exclude_end?
            range 'gte' => other.begin, 'lt' => other.end
          else
            range 'gte' => other.begin, 'lte' => other.end
          end
        else
          Arelastic::Filters::Terms.new field, other, options
        end
      end

      def not_in other, options = {}
        self.class.not self.in(other, options)
      end

      def prefix other
        Arelastic::Filters::Prefix.new field, other
      end

      def exists
        Arelastic::Filters::Exists.new field
      end

      def missing(options = {})
        Arelastic::Filters::Missing.new field, options
      end

      def regexp other
        Arelastic::Filters::Regexp.new field, other
      end

      def gteq other
        range 'gte' => other
      end

      def gt other
        range 'gt' => other
      end

      def lteq other
        range 'lte' => other
      end

      def lt other
        range 'lt' => other
      end

      private
        def range options
          Arelastic::Filters::Range.new field, options
        end
    end
  end
end
