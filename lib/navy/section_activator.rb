module Navy
  module SectionActivator

    def self.included(base)
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
      base.helper_method :section_active?
      base.helper_method :active_sections
    end

    module ClassMethods

      def default_active_sections
        @default_active_sections_with_ancestors ||= begin
          sections = @default_active_sections || []
          if superclass.respond_to?(:default_active_sections)
            sections += superclass.default_active_sections
          end
          sections
        end
      end
      
      private

      def in_sections(*sections)
        @default_active_sections ||= []
        @default_active_sections += sections.collect(&:to_s)
      end

    end

    module InstanceMethods

      def active_sections
        sections = []
        sections += self.class.default_active_sections || []
        sections += @active_sections || []
        sections.uniq
      end

      def section_active?(section)
        active_sections.include?(section.to_s)
      end

      private

      def in_sections(*sections)
        @active_sections ||= []
        @active_sections += sections.collect(&:to_s)
      end

    end

  end
end
