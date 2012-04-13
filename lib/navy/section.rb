module Navy
  class Section
    include SectionContainer

    attr_reader :name, :label
    attr_accessor :url

    def initialize(name, label, url, active, &children)
      @name = name
      @label = label
      @url = url
      @active = active
      @children = children
    end

    def active?
      @active
    end

  end
end
