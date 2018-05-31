class ErrorsController < ApplicationController
  def not_found
	render(:status => 404, template: "errors/not_found")
  end

  def unprocessable_entity
    render(:status => 422, template: "errors/unprocessable_entity")
  end

  def internal_server_error
    render(:status => 500, template: "errors/internal_server_error")
  end
end
