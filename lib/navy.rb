# encoding: utf-8

require 'navy/section_container'
require 'navy/description'
require 'navy/navigation'
require 'navy/renderer'
require 'navy/section'
require 'navy/section_activator'
require 'navy/section_parser'
require 'navy/renderer_helper'

ActionView::Base.send :include, Navy::RendererHelper
ActionController::Base.send :include, Navy::SectionActivator
