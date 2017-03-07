# encoding: utf-8

module Navy
  class SectionParser

    attr_reader :sections

    def initialize(context)
      @context = context
      @sections = []
    end

    def parse(block_args, &block)
      instance_exec(*block_args, &block)
      self
    end

    def section(name, label, url = nil, link_to_options = {}, &children)
      section = Navy::Section.new(name, label, url, link_to_options, @context.section_active?(name), &children)
      sections << section
    end

    def respond_to?(method, include_private = false)
      super || @context.respond_to?(method, false) # don't forward private messages
    end

    def method_missing(method, *args, &block)
      if @context.respond_to?(method, false)
        @context.send(method, *args, &block)
      else
        super
      end
    end

  end
end
