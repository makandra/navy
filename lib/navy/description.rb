# encoding: utf-8

module Navy
  module Description

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods

      def navigation(name, &children)
        navigation = Navy::Navigation.new(name, &children)
        singleton_class.send(:define_method, name) do |*args| 
          navigation.block_args = args
          navigation
        end
      end

    end

  end
end
