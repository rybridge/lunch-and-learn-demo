# config/initializers/view_component.rb
Rails.application.config.to_prepare do
  config = Rails.application.config
  if config.view_component.respond_to?(:preview_paths) && config.view_component.preview_paths
    config.view_component.preview_paths << Rails.root.join("app/components/previews")
  end
  if config.view_component.respond_to?(:default_preview_layout=)
    config.view_component.default_preview_layout = "component_preview"
  end
end
