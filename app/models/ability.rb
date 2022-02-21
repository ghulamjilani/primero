# frozen_string_literal: true

# TODO: Refactor this!!! Write some tests!

# Class for Ability
class Ability
  include CanCan::Ability

  # rubocop:disable Metrics/MethodLength
  def initialize(user)
    alias_user_actions
    @user = user
    can_index
    can_access_self(user)
    can_search(user)
    can_read_reports
    can_show_user
    can_edit_user
    initialize_permissions(user)
    configure_exports
    baseline_permissions
    configure_record_attachments
    configure_flags
  end
  # rubocop:enable Metrics/MethodLength

  def baseline_permissions
    can [:read, :write, :create], SavedSearch do |search|
      user.user_name == search.user.user_name
    end
  end

  def user_permissions(actions)
    can actions, User do |instance|
      permitted_to_access_user?(instance)
    end
  end

  def permitted_to_access_user?(instance)
    return true if user.super_user? || user.user_admin?

    return false if instance.super_user? || instance.user_admin?

    return true if user.permission_by_permission_type?(Permission::USER, Permission::AGENCY_READ) &
                   user.agency == instance.agency

    if !user.permission_by_permission_type?(Permission::USER, Permission::AGENCY_READ) &&
       user.group_permission?(Permission::GROUP)
      # TODO-permission: Add check that the current user has the ability to edit the uzer's role
      # True if, The user's role's associated_role_ids include the uzer's role_id
      return (user.user_group_ids & instance.user_group_ids).present?
    end

    return true if user.group_permission?(Permission::ALL)

    instance.user_name == user.user_name
  end

  def user_group_permissions(actions)
    can actions, UserGroup do |instance|
      # TODO-permission: replace the if staemnet with the super_user? and user_admin? functions
      if user.group_permission?(Permission::ALL) || user.group_permission?(Permission::ADMIN_ONLY)
        true
      elsif user.group_permission?(Permission::GROUP)
        user.user_group_ids.include? instance.id
      else
        false
      end
    end
  end

  def role_permissions(permission)
    actions = permission.action_symbols
    can actions, Role do |instance|
      permitted_to_access_role?(instance, actions, permission)
    end
  end

  def permitted_to_access_role?(instance, actions, permission)
    return false if instance.super_user_role? || instance.user_admin_role? && !user.super_user?

    if ([Permission::ASSIGN, Permission::READ, Permission::WRITE].map(&:to_sym) & actions).present?
      return permission.role_unique_ids.present? ? (permission.role_unique_ids.include? instance.unique_id) : true
      # TODO-permission: This if statement should prevent a role from editing itself, but it should be evaluated before
      # the previous elsif to be effective
      # TODO-permission: I do not believe that the second part of the if statement is helpful or accurate:
      # Not even the super user is allowed to edit their own role, consider removing.
    end

    return false if user.role_id == instance.id && !user.group_permission?(Permission::ALL)

    # TODO-permission: This else statements should default to false, not 'true' when the conditions are not met
    true
  end

  def agency_permissions(permission)
    actions = permission.action_symbols
    can actions, Agency do |instance|
      if ([Permission::ASSIGN, Permission::READ, Permission::WRITE].map(&:to_sym) & actions).present?
        permission.agency_unique_ids.present? ? (permission.agency_unique_ids.include? instance.unique_id) : true
      else
        true
      end
    end
  end

  def metadata_permissions
    [FormSection, Field, Location, Lookup, PrimeroProgram, PrimeroModule].each do |resource|
      can :manage, resource
    end
  end

  def system_permissions
    [ContactInformation, SystemSettings].each do |resource|
      can :manage, resource
    end
  end

  attr_reader :user

  def configure_resource(resource, actions, is_record = false)
    if is_record
      can actions, resource do |instance|
        permitted_to_access_record?(user, instance)
      end
      can(:index, Task) if (resource == Child) && user.permission?(Permission::DASH_TASKS)
      can(:index, Flag) if user.permission?(Permission::DASH_FLAGS)
    else
      can actions, resource
    end
  end

  def configure_tracing_request(actions)
    can(actions, TracingRequest) do |instance|
      permitted_to_access_record?(user, instance)
    end
    can(actions, Trace) do |instance|
      permitted_to_access_record?(user, instance.tracing_request)
    end
  end

  def configure_flag(resource)
    can [:flag_record], resource do |instance|
      can?(:read, instance) && can?(:flag, instance)
    end
  end

  def configure_exports
    return unless user.role.permitted_to_export?

    can [:index, :create, :read, :destroy], BulkExport do |instance|
      instance.owned_by == user.user_name
    end
  end

  def configure_record_attachments
    can(%i[read write destroy], Attachment) do |instance|
      permitted_to_access_record?(user, instance.record)
    end
  end

  def permitted_to_access_record?(user, record)
    if user.group_permission? Permission::ALL
      true
    elsif user.group_permission? Permission::AGENCY
      record.associated_user_agencies.include?(user.agency.unique_id)
    elsif user.group_permission? Permission::GROUP
      # TODO: This may need to be record&.owned_by_groups
      (user.user_group_unique_ids & record&.associated_user_groups).present?
    else
      record&.associated_user_names&.include?(user.user_name)
    end
  end

  def can(action = nil, subject = nil, *conditions, &block)
    add_rule(CanCan::CustomRule.new(true, action, subject, *conditions, &block))
  end

  def cannot(action = nil, subject = nil, *conditions, &block)
    add_rule(CanCan::CustomRule.new(true, action, subject, *conditions, &block))
  end

  def alias_user_actions
    alias_action :index, :view, :list, :export, to: :read
    alias_action :edit, :update, :destroy, :disable, to: :write
    alias_action new: :create
    alias_action destroy: :delete
  end

  def can_index
    can [:index], SystemSettings
    can :index, FormSection
    can [:index], Lookup
    can [:index], Location
    can :index, Report
  end

  def can_access_self(user)
    can [:read_self, :write_self], User do |uzer|
      uzer.user_name == user.user_name
    end
  end

  def can_search(user)
    can :search, User if user.permission_by_permission_type?(Permission::CASE, Permission::TRANSFER) ||
                         user.permission_by_permission_type?(Permission::CASE, Permission::ASSIGN) ||
                         user.permission_by_permission_type?(Permission::CASE, Permission::REFERRAL)
  end

  def can_read_reports
    can [:read_reports], Report do |report|
      can?(:read, report) || can?(:group_read, report)
    end
  end

  def can_show_user
    can [:show_user], User do |uzer|
      can?(:read_self, uzer) || can?(:read, uzer)
    end
  end

  def can_edit_user
    can [:edit_user], User do |uzer|
      can?(:write_self, uzer) || can?(:edit, uzer)
    end
  end

  def initialize_permissions(user)
    user.role.permissions.each do |permission|
      initialize_permission(permission)
    end
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/CyclomaticComplexity
  def initialize_permission(permission)
    case permission.resource
    when Permission::USER
      user_permissions(permission.action_symbols)
    when Permission::USER_GROUP
      user_group_permissions(permission.action_symbols)
    when Permission::ROLE
      role_permissions(permission)
    when Permission::AGENCY
      agency_permissions(permission)
    when Permission::METADATA
      metadata_permissions
    when Permission::SYSTEM
      system_permissions
    when Permission::TRACING_REQUEST
      configure_tracing_request(permission.action_symbols)
    else
      configure_resource(permission.resource_class, permission.action_symbols, permission.record?)
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/CyclomaticComplexity

  def configure_flags
    [Child, TracingRequest, Incident, RegistryRecord].each do |model|
      configure_flag(model)
    end
  end
end
