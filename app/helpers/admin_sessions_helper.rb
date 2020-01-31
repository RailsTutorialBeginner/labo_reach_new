module AdminSessionsHelper
  # 渡されたユーザーでログインする
  def admin_log_in(admin)
    session[:admin_id] = admin.id
  end

  # 現在のユーザーとされているcurrent_adminと、引数のadminが同一人物か確認
  def current_admin?(admin)
    admin == current_admin
  end

  def current_admin
    if session[:admin_id]
      @current_admin ||= Admin.find_by(id: session[:admin_id])
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def admin_logged_in?
    !current_admin.nil?
  end

  def admin_log_out
    session.delete(:admin_id)
    @current_admin = nil
  end

  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
