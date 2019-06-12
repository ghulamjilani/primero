class Login
  include Validatable
  attr_accessor :errors
  attr_accessor :user_name
  attr_accessor :password

  def initialize(params)
    @user_name = params[:user_name]
    @password = params[:password]
    @imei = params[:imei]
    @mobile_number = params[:mobile_number]
  end

  def authenticate_user
    user = User.find_by_user_name(@user_name)
    session = nil

    if (user and user.authenticate(@password))
      session = Session.for_user(user, @imei) 
      LoginActivity.create!(user_name: @user_name, imei: @imei, mobile_number: @mobile_number)
    end
    
    session
  end

  def errors
    @errors ||= Errors.new
  end
end