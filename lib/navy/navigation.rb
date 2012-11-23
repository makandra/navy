# encoding: utf-8

module Navy
  class Navigation
    include SectionContainer

    attr_reader :name, :children

    def initialize(name, &children)
      @name = name
      @children = children
    end

    def active?
      true
    end

  end
end
