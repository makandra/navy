# encoding: utf-8

module Navy
  class Renderer

    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper
    
    def initialize(context, options = {})
      @context = context
      @html_to_append = []
      @id_counter = 0
      @collapse = options[:collapse]
      @name = options[:name]
    end

    def next_id
      @id_counter += 1
    end


    def render_navigation(navigation)
      name = @name || navigation.name
      html = ''.html_safe
      html << render_section_container(navigation, navigation.sections(@context), 1)
      @html_to_append.each do |append|
        html << append
      end
      klasses = []
      klasses << 'navy-navigation'
      klasses << 'navy-empty' if html.strip.blank?
      content_tag(:div, html, :id => "navy-#{name}-navigation", :class => klasses.join(' '))
    end

    private

    def append(html)
      @html_to_append << html
    end

    def render_section_container(section_container, sections, level, parent_id = nil, parent_url = nil)
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
      link_to_options = section.link_to_options.dup
      link_classes = ['navy-section', link_to_options.delete(:class)].compact
      link_classes << 'navy-current navy-active' if section.active?
      label = ''.html_safe
      url = section.url
      if section.children?
        children_sections = section.sections(@context)
        if (first_child = children_sections.first)
          url ||= first_child.url
        else
          url ||= '#'
        end
        children_html = render_section_container(section, children_sections, level + 1, id, url)
        if children_html.present?
          append(children_html)
          label << ' <span class="navy-section-expander">▾</span>'.html_safe
        end
      end
      label << section.label
      label = content_tag(:span, label, :class => 'navy-section-inner')
      link_to(label, url, link_to_options.merge(:class => link_classes.join(' '), :"data-navy-opens" => id, 'data-navy-section' => section.name))
    end

    
    def div_tag(options, &block)
      if ActionPack::VERSION::MAJOR.to_s < '5'
        content_tag_string(:div, block.call, options, true)
      else
        # Rails 5 moved this method to the tag_builder and will raise a NameError
        tag_builder.content_tag_string(:div, block.call, options, true)
      end
    end

  end
end
