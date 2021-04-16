module Admin::AdminHelper
  def activity_feed_link(activity)
    if activity.trackable
      case activity.trackable_type
      when "User"
      	link_to activity.trackable.email, admin_user_path(activity.trackable)
      when "Outlet"
      	link_to activity.trackable.organization, admin_outlet_path(activity.trackable)
      when "MobileApp"
      	link_to activity.trackable.name, admin_mobile_app_path(activity.trackable)
      when "Gallery"
        link_to activity.trackable.name, admin_gallery_path(activity.trackable)
      end
    else
      "Deleted"
    end
  end
  def activity_feed_badge_item(activity)
    case activity.trackable_type
    when "User"
      "fa fa-user"
    when "Outlet"
      "fa fa-share-alt"
    when "MobileApp"
      "fa fa-mobile"
    when "Gallery"
      "fa fa-mobile"
    end
  end
  def activity_feed_action_name(activity)
  	t(activity.key).downcase
  end

  def activity_feed_owner(activity)
  	if activity.owner
      user_list_format(activity.owner)
    else
    	"System"
    end
  end

  def user_list_format(user)
    if user
      if user.first_name && user.last_name
        "".html_safe + "#{user.try(:first_name)} #{user.try(:last_name)} -" + "<a href=\"mailto:".html_safe+"#{user.email}"+"\">".html_safe+"#{user.email}"+"</a>".html_safe
      else
        "".html_safe + "<a href=\"mailto:".html_safe+"#{user.email}"+"\">".html_safe+"#{user.email}"+"</a>".html_safe
      end
    else
      "Deleted User".html_safe
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.permit(:sort, :direction).merge({:sort => column, :direction => direction}), {:class => css_class}
  end

  def outlet_organization_name(outlet)
    if outlet.organization
      if outlet.organization.blank?
        outlet.service_url
      else
        outlet.organization
      end
    else
      outlet.service_url
    end
  end

end
