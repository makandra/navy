module Navy
  module SectionActivator

    def self.included(base)
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
      base.helper_method :section_active? if base.respond_to?(:helper_method)
    end

    module ClassMethods

      def default_active_sections
        @default_active_sections
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
