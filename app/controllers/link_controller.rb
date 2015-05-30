class LinkController < ApplicationController
  before_filter :find_link, only: [:view, :stats]
  skip_before_action :verify_authenticity_token

  rescue_from ActiveRecord::RecordInvalid, with: :validation_error
  rescue_from ActiveRecord::RecordNotFound, with: :notfound_error

  def create
    link = Link.create!(link_params)
    render json: link, status: 201
  end

  def view
    redirect_to @link.url, status: 302
  end

  def stats
    render json: {startDate: @link.created_at, lastSeenDate: @link.updated_at, redirectCount: @link.redirect_count}
  end

  def find_link
    @link = Link.find_by_shortcode!(params[:shortcode])
  end

  def link_params
    params.permit(:url, :shortcode)
  end

  def validation_error(exception)
    status_code = exception.record.errors.messages.map{|field, status_code| status_code }.flatten.min
    fields = exception.record.errors.messages.map{|field, status_codes| status_codes.include?(status_code) ? field : nil}.compact
    render json: {
      code: status_code,
      fields: fields,
      error: Rack::Utils::HTTP_STATUS_CODES.has_key?(status_code.to_i) ? Rack::Utils::HTTP_STATUS_CODES[status_code.to_i] : "no error message"
      }, status: status_code and return
  end

  def notfound_error
    render json: {error: Rack::Utils::HTTP_STATUS_CODES[404]}, status: 404
  end
end