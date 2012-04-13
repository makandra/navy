module Navy
  module Parser

    def navigation(name, &children)
      navigation = Navy::Navigation.new(name, &children)
      singleton_class.send(:define_method, name) { navigation }
    end

    def section(name, label, url)
      sections << Navy::Section.new()
    end

    def sections
      @sections ||= []
    end

  end
end
