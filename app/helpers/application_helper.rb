module ApplicationHelper

  def link_to_pid(options={})
    pid = options[:value].first
    link_to("#{pid}", "#{pid}")
  end

end
