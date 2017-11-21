module ApplicationHelper

  def show_list_creators(options={})
    document = options[:document]
    creator_roles = document.fetch(:creator_role)
    options[:value].map.with_index do |creator, index|
      capture do 
        concat link_to "#{creator}", search_action_path(search_state.add_facet_params(options[:field], creator))
        unless creator_roles[index].nil?
          creator_role = creator_roles[index]
          if (creator_role != "n/a")
            concat " (#{creator_role})"
          end
        end
      end
    end.join('<br />').html_safe
  end

end
