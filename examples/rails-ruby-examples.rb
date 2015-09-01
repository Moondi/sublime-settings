class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include TrackerHelper
  include MemoryHelper
  include DomainHelper
  include LogragePayloadConcern
  after_filter :log_memory_usage
  A_CONST = "blahbha "

  # Enable CSRF protection but don't use Rails's default filter
  # We have our own filter that does different things for HTML and JSON (largely for mobile devices)
  protect_from_forgery with: :exception unless Rails.env.staging?
  skip_before_filter :verify_authenticity_token
  before_filter :custom_verify_authenticity_token

  helper_method :current_user
  helper_method :hijacker

  # App Urls
  helper_method :planboard_url, :campus_url

  before_filter :set_device_type
  def set_device_type
    request.variant = :phone  if browser.mobile?
    request.variant = :tablet if browser.tablet?
    request.variant = :native_ipad if request.user_agent =~ /Planboard-iPad/
  end

  before_filter do
    if params.has_key?(:profile) && current_user.has_role?(:god)
      Rack::MiniProfiler.authorize_request
    end
  end

  before_filter :set_view_path
  def set_view_path
    # MAGIC: Add the namespace of a controller to the view path
    #
    # Examples
    #
    # Site::SiteController will look for views under the /views/site dir
    # Planboard::DaysCOntroller will look for views under the /views/planboard dir
    class_name = "#{self.class.name.demodulize}"
    module_chain = "#{self.class.name.gsub(class_name, "")}".underscore

    unless module_chain.empty?
      prepend_view_path "#{Rails.root}/app/views/#{module_chain}"
    end
  end

  def force_html
    request.format = :html
  end

  def force_json
    request.format = :json
  end

  def not_found
    if request.format == :pdf
      request.format = :html
      render template: '404.html', status: 404, layout: false
    elsif request.format == :html
      render template: '404', status: 404, layout: false
    else
      head :not_found
    end
  end

  rescue_from 'ActionController::RoutingError', with: :not_found
  rescue_from 'ActionController::UnknownController', with: :not_found
  rescue_from 'ActionController::UnknownAction', with: :not_found
  rescue_from 'ActionController::UnknownFormat', with: :not_found
  rescue_from 'ActiveRecord::RecordNotFound', with: :not_found

  private

  def authenticate_current_user(app = nil)
    if current_user
      @current_user.extend UserDecorator
      @current_user.user_profile.extend UserProfileDecorator
    else
      redirect_to login_url(app: app, subdomain: false)
    end
  end

  # Method exposed to views/3rd party libraries
  def current_user
    if cookies.signed[:hijacked_user]
      @current_user ||= User.find_by_id cookies.signed[:hijacked_user]
    elsif cookies[:auth_token]
      @current_user ||= UserTokenAuthenticator.new(cookies[:auth_token]).user
    else
      token = request.headers['HTTP_AUTH_TOKEN']
      @current_user ||= UserTokenAuthenticator.new(token).user
    end
  end

  def hijacker
    if cookies.signed[:hijacked_user]
      @hijacker ||= UserTokenAuthenticator.new(cookies[:auth_token]).user
    end
  end

  def disable_for_hijackers
    if hijacker
      return render json: { errors: "You're not allowed to edit anything when viewing another account!" }, status: 403
    end
  end

  def custom_verify_authenticity_token
    verify_authenticity_token unless request.format.json?
  end
end

class Chalk::QuestionsController < Chalk::ApplicationController
  before_filter :authenticate_user
  before_filter :disable_for_hijackers

  def create
    return if (model = find_appropriate_model) && performed?
    @question = model.questions.build

    if model.field_type == 'questions' && @question.save
      render 'question'
    else
      render json: { errors: @question.errors.full_messages.to_sentence }, status: 403
    end
  end

  def update
    return if (model = find_appropriate_model) && performed?
    question = model.questions.find params[:id]
    @unit = model.unit

    # Newly added standard instances need to be added to the unit AND parent unit as well as the question
    if params[:standard_instances_attributes]
      standard_ids = []

      params[:standard_instances_attributes].each do |si|
        unless si[:id] || @unit.standard_instances.find_by_standard_id(si[:standard_id])
          @unit.standard_instances.create! standard_id: si[:standard_id]
        end
        if !si[:id] && @unit.unit && !@unit.unit.standard_instances.find_by_standard_id(si[:standard_id])
          @unit.unit.standard_instances.create! standard_id: si[:standard_id]

          # CSUSA prepopulated developmental scales
          if @unit.institution_id == 172057
            standard_ids << si['standard_id']
          end
        end
      end

      # CSUSA prepopulated developmental scales
      standard_ids.each do |sid|
        si = @unit.unit.standard_instances.find_by_standard_id sid
        si.objectives.create code: 4, color: '24C50F'
        si.objectives.create code: 3, color: 'EAC51B'
        si.objectives.create code: 2, color: 'F29D23'
        si.objectives.create code: 1, color: 'FF5454'
      end
    end

    if question.update_attributes question_params
      @unit = @unit.unit if @unit.unit # render the parent unit if needed
      render 'units/unit' # render unit b/c standard_instances may have been added to it
    else
      render json: { errors: question.errors.full_messages.to_sentence }, status: 403
    end
  end

  def destroy
    return if (model = find_appropriate_model) && performed?
    @question = model.questions.find params[:id]

    if @question.destroy
      head :no_content
    else
      render json: { errors: @question.errors.full_messages.to_sentence }, status: 403
    end
  end

  private

  def question_params
    params.permit :content, standard_instances_attributes: [:id, :standard_id, :_destroy]
  end

end
