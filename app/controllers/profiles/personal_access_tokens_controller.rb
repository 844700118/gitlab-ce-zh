class Profiles::PersonalAccessTokensController < Profiles::ApplicationController
  def index
    set_index_vars
    @personal_access_token = finder.build
  end

  def create
    @personal_access_token = finder.build(personal_access_token_params)

    if @personal_access_token.save
      flash[:personal_access_token] = @personal_access_token.token
      redirect_to profile_personal_access_tokens_path, notice: "您已创建新的个人访问令牌。"
    else
      set_index_vars
      render :index
    end
  end

  def revoke
    @personal_access_token = finder.find(params[:id])

    if @personal_access_token.revoke!
      flash[:notice] = "撤销个人访问令牌 #{@personal_access_token.name}!"
    else
      flash[:alert] = "无法撤销个人访问令牌 #{@personal_access_token.name}."
    end

    redirect_to profile_personal_access_tokens_path
  end

  private

  def finder(options = {})
    PersonalAccessTokensFinder.new({ user: current_user, impersonation: false }.merge(options))
  end

  def personal_access_token_params
    params.require(:personal_access_token).permit(:name, :expires_at, scopes: [])
  end

  def set_index_vars
    @scopes = Gitlab::Auth.available_scopes

    @inactive_personal_access_tokens = finder(state: 'inactive').execute
    @active_personal_access_tokens = finder(state: 'active').execute.order(:expires_at)
  end
end
