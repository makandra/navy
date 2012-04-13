module Navy
  module RendererHelper

    def render_navigation(navigation, options = {})
      context = options.delete(:context) || self
      Navy::Renderer.new(context, options).render_navigation(navigation)
    end

  end
end
