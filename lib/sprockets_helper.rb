module SprocketsHelper
  def sprockets_include_tag
    javascript_include_tag sprockets_path(:format => :js)
  end
end
