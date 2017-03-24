# Helper methods for per-User preferences
module PreferencesHelper
  def layout_choices
    [
        ['固定', :fixed],
        ['自适应', :fluid]
    ]
  end

  # Maps `dashboard` values to more user-friendly option text
  DASHBOARD_CHOICES = {
    projects: '你的项目 (默认)',
    stars:    '星标项目',
    project_activity: "你的项目活动",
    starred_project_activity: "星标项目活动",
    groups: "你的群组",
    todos: "你的代办事项"
  }.with_indifferent_access.freeze

  # Returns an Array usable by a select field for more user-friendly option text
  def dashboard_choices
    defined = User.dashboards

    if defined.size != DASHBOARD_CHOICES.size
      # Ensure that anyone adding new options updates this method too
      raise "`User` defines #{defined.size} dashboard choices," \
        " but `DASHBOARD_CHOICES` defined #{DASHBOARD_CHOICES.size}."
    else
      defined.map do |key, _|
        # Use `fetch` so `KeyError` gets raised when a key is missing
        [DASHBOARD_CHOICES.fetch(key), key]
      end
    end
  end

  def project_view_choices
    [
      ['文件和 Readme 视图(默认)', :files],
      ['活动视图', :activity]
    ]
  end

  def user_color_scheme
    Gitlab::ColorSchemes.for_user(current_user).css_class
  end

  def default_project_view
    return anonymous_project_view unless current_user

    user_view = current_user.project_view

    if @project.feature_available?(:repository, current_user)
      user_view
    elsif user_view == "activity"
      "activity"
    elsif @project.wiki_enabled?
      "wiki"
    elsif @project.feature_available?(:issues, current_user)
      "projects/issues/issues"
    else
      "customize_workflow"
    end
  end

  def anonymous_project_view
    @project.empty_repo? || !can?(current_user, :download_code, @project) ? 'activity' : 'readme'
  end
end
