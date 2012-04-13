module Navy
  class Renderer

    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper
    
    def initialize(context, options = {})
      @context = context
      @html_to_append = []
      @id_counter = 0
      @collapse = options[:collapse]
    end

    def next_id
      @id_counter += 1
    end


    def render_navigation(navigation)
      div_tag(:id => "navy-#{navigation.name}-navigation", :class => 'navy-navigation') do
        html = ''.html_safe
        html << render_section_container(navigation, 1)
        @html_to_append.each do |append|
          html << append
        end
        html
      end
    end


    private

    def append(html)
      @html_to_append << html
    end

    def render_section_containers
      html = ''.html_safe
      while @section_containers_to_render.any?
        html << render_section_container(*@section_containers_to_render.shift)
      end
      html
    end

    def render_section_container(section_container, level, parent_id = nil, parent_url = nil)
      sections = section_container.sections(@context)
      section_classes = ["navy-level-#{level}", "navy-navigation-bar"]
      section_classes << (section_container.active? ? 'navy-current' : 'navy-hidden')
      unless sections.size == 0 or (sections.size == 1 and sections.first.url == parent_url)
        div_tag(:class => section_classes.join(' '), :"data-navy-opened-by" => parent_id, :"data-navy-navigation-level" => level) do
          div_tag(:class => 'navy-inner-navigation-bar') do
            html = ''.html_safe
            html << div_tag(:class => "navy-layouted-sections") do
              inner_html = ''.html_safe
              sections.each do |section|
                inner_html << render_section(section, level, parent_id)
              end
              inner_html
            end 
            if level == 1 and !Rails.env.test? and !Rails.env.cucumber? and @collapse
              html << div_tag(:class => "navy-navigation-dropdown") do 
                inner_html = ''.html_safe
                inner_html << '<a class="navy-dropdown-expander" href="#">▾</a>'.html_safe 
                inner_html << '<div class="navy-dropdown-sections navy-hidden"></div>'.html_safe
                inner_html
              end
            end
            html << '<span class="navy-end"></span>'.html_safe
            html
          end
        end
      end
    end

    def render_section(section, level, parent_id)
      id = next_id
      link_classes = ['navy-section']
      link_classes << 'navy-current navy-active' if section.active?
      label = ''.html_safe
      if section.children?
        children_html = render_section_container(section, level + 1, id, section.url)
        if children_html.present?
          append(children_html)
          label << ' <span class="navy-section-expander">▾</span>'.html_safe
        end
      end
      label << section.label
      link_to(label, section.url, :class => link_classes.join(' '), :"data-navy-opens" => id)
    end

    
    def div_tag(options, &block)
      content_tag_string(:div, block.call, options, true)
    end

  end
end