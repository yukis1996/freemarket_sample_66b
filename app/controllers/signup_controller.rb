# class SignupController < ApplicationController
class SignupController < Devise::RegistrationsController
  before_action :validates_registration_nickname, only: :registration_sms # step1のバリデーション
  before_action :validates_registration_sms, only: :registration_address # registration_addressのバリデーション
  before_action :validates_registration_address, only: :create # step3のバリデーション

  def index
    session[:id] = nil
    session[:nickname] = nil
    session[:email] = nil
    session[:password] = nil
    session[:password_confirmation] = nil
    session[:birthday_year] = nil
    session[:birthday_month] = nil
    session[:birthday_day] = nil
    session[:phonennumber] = nil
  end

  def registration_nickname
    @user = User.new # 新規インスタンス作成
  end

  def registration_sms
    @user = User.new # 新規インスタンス作成
  end

  def registration_address
    @user = User.new # 新規インスタンス作成
    @user.build_address
  end

  def create
    @user.save!
    session[:id] = @user.id
    session[:nickname] = nil
    session[:email] = nil
    session[:password] = nil
    session[:password_confirmation] = nil
    session[:birthday_year] = nil
    session[:birthday_month] = nil
    session[:birthday_day] = nil
    session[:phonennumber] = nil
    redirect_to registration_card_path
  end

  def registration_card
  end

  def registration_done
    sign_in User.find(session[:id]) unless user_signed_in?
    session[:id] = nil
  end


  private

  def user_params
    params.require(:user).permit(
      :nickname, 
      :email, 
      :password, 
      :password_confirmation,
      :family_name, 
      :first_name, 
      :j_family_name, 
      :j_first_name, 
      :birthday_year, 
      :birthday_month, 
      :birthday_day, 
      :phonennumber,
      address_attributes: [:postal_code, :prefectuer, :city_ward, :address, :building,:tel,:id]
  )
  end

  def validates_registration_nickname
    # step1で入力した値をsessionに保存
    session[:nickname] = user_params[:nickname]
    session[:email] = user_params[:email]
    session[:password] = user_params[:password]
    session[:password_confirmation] = user_params[:password_confirmation]
    session[:birthday_year] = user_params[:birthday_year]
    session[:birthday_month] = user_params[:birthday_month]
    session[:birthday_day] = user_params[:birthday_day]
    @user = User.new(
      nickname: session[:nickname], # sessionに保存された値をインスタンスに渡す
      email: session[:email],
      password: session[:password],
      password_confirmation: session[:password_confirmation],
      birthday_year: session[:birthday_year], 
      birthday_month: session[:birthday_month], 
      birthday_day: session[:birthday_day],
      phonennumber: 12345678901,
      family_name: "あ",
      first_name: "い",
      j_family_name: "ア",
      j_first_name: "イ",
    )
    render :registration_nickname unless @user.valid?
  end


  def validates_registration_sms
    # step2で入力した値をsessionに保存
    session[:phonennumber] = user_params[:phonennumber]
    @user = User.new(
      nickname: session[:nickname], # sessionに保存された値をインスタンスに渡す
      email: session[:email],
      password: session[:password],
      password_confirmation: session[:password_confirmation],
      birthday_year: session[:birthday_year], 
      birthday_month: session[:birthday_month], 
      birthday_day: session[:birthday_day],
      phonennumber: session[:phonennumber],
      family_name: "あ",
      first_name: "い",
      j_family_name: "ア",
      j_first_name: "イ",
    )
    render :registration_sms unless @user.valid?
  end


  def validates_registration_address
    @user = User.new(user_params)
    @user.nickname = session[:nickname]
    @user.email = session[:email]
    @user.password = session[:password]
    @user.password_confirmation = session[:password_confirmation]
    @user.birthday_year = session[:birthday_year]
    @user.birthday_month = session[:birthday_month]
    @user.birthday_day = session[:birthday_day]
    @user.phonennumber = session[:phonennumber]
    render :registration_address unless @user.valid?
  end
end
