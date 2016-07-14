module Autochthon
  module ApplicationHelper
    def include_autochthon_script
      javascript_include_tag("autochthon") +
        content_tag(:div, '',
                    style: 'display: nothing',
                    id: 'autochthon-metadata',
                    data: {mount_point: Autochthon.mount_point})
    end
  end
end
