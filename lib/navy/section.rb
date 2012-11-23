# encoding: utf-8

module Navy
  class Section
    include SectionContainer

    attr_reader :name, :label, :link_to_options
    attr_accessor :url

    def initialize(name, label, url, link_to_options, active, &children)
      @name = name
      @label = label
      @url = url
      @active = active
      @children = children
      @link_to_options = link_to_options
    end

    def active?
      @active
    end

  end
end
