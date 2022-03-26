# frozen_string_literal: true

require 'rails_helper'

describe ManagedReports::Indicators::DetentionStatus do
  before do
    clean_data(Incident, Violation, IndividualVictim, UserGroup, User, Agency, Role)

    permissions = [
      Permission.new(
        resource: Permission::MANAGED_REPORT,
        actions: [
          Permission::VIOLATION_REPORT
        ]
      )
    ]
    self_role = Role.create!(
      name: 'Self Role 1',
      unique_id: 'self-role-1',
      group_permission: Permission::SELF,
      permissions: permissions
    )

    group_role = Role.create!(
      name: 'Group Role 1',
      unique_id: 'group-role-1',
      group_permission: Permission::GROUP,
      permissions: permissions
    )

    agency_role = Role.create!(
      name: 'Agency Role 1',
      unique_id: 'agency-role-1',
      group_permission: Permission::AGENCY,
      permissions: permissions
    )

    all_role = Role.create!(
      name: 'All Role 1',
      unique_id: 'all-role-1',
      group_permission: Permission::ALL,
      permissions: permissions
    )

    agency_a = Agency.create!(name: 'Agency 1', agency_code: 'agency1', unique_id: 'agency1')
    agency_b = Agency.create!(name: 'Agency 2', agency_code: 'agency2', unique_id: 'agency2')

    group_a = UserGroup.create(unique_id: 'group-a', name: 'Group A')
    group_b = UserGroup.create(unique_id: 'group-b', name: 'Group B')

    @self_user = User.create!(
      full_name: 'Self User',
      user_name: 'self_user',
      email: 'self_user@localhost.com',
      agency_id: agency_a.id,
      user_groups: [group_a],
      role: self_role
    )

    @group_user = User.create!(
      full_name: 'Group User',
      user_name: 'group_user',
      email: 'group_user@localhost.com',
      agency_id: agency_b.id,
      user_groups: [group_b],
      role: group_role
    )

    @agency_user = User.create!(
      full_name: 'Agency User',
      user_name: 'agency_user',
      email: 'agency_user@localhost.com',
      agency_id: agency_b.id,
      user_groups: [group_b],
      role: agency_role
    )

    @all_user = User.create!(
      full_name: 'all User',
      user_name: 'all_user',
      email: 'all_user@localhost.com',
      agency_id: agency_a.id,
      user_groups: [group_a, group_b],
      role: all_role
    )

    incident1 = Incident.new_with_user(@self_user, { incident_date: Date.today, status: 'open' })
    incident1.save!
    incident2 = Incident.new_with_user(@group_user, { incident_date: Date.today, status: 'open' })
    incident2.save!
    incident3 = Incident.new_with_user(@agency_user, { incident_date: Date.today, status: 'open' })
    incident3.save!
    incident4 = Incident.new_with_user(@all_user, { incident_date: Date.today, status: 'open' })
    incident4.save!
    incident5 = Incident.new_with_user(@all_user, { incident_date: Date.today, status: 'open' })
    incident5.save!

    violation1 = Violation.create!(
      data: { type: 'killing', violation_tally: { 'boys': 1, 'girls': 2, 'unknown': 3, 'total': 6 } },
      incident_id: incident1.id
    )
    violation1.individual_victims = [
      IndividualVictim.create!(
        data: {
          victim_deprived_liberty_security_reasons: 'true',
          length_deprivation_liberty: Date.today.beginning_of_month - 1.week,
          deprivation_liberty_end: Date.today
        }
      )
    ]
    violation2 = Violation.create!(
      data: { type: 'killing', violation_tally: { 'boys': 1, 'girls': 1, 'unknown': 1, 'total': 3 } },
      incident_id: incident2.id
    )
    violation2.individual_victims = [
      IndividualVictim.create!(
        data: {
          victim_deprived_liberty_security_reasons: 'true',
          length_deprivation_liberty: Date.today.beginning_of_month - 1.month,
          deprivation_liberty_end: Date.today - 3.days
        }
      )
    ]
    violation3 = Violation.create!(
      data: { type: 'maiming', violation_tally: { 'boys': 2, 'girls': 1, 'unknown': 2, 'total': 5 } },
      incident_id: incident3.id
    )
    violation3.individual_victims = [
      IndividualVictim.create!(
        data: {
          victim_deprived_liberty_security_reasons: 'true',
          length_deprivation_liberty: Date.today.beginning_of_month
        }
      )
    ]
    violation4 = Violation.create!(
      data: { type: 'killing', violation_tally: { 'boys': 2, 'girls': 3, 'unknown': 2, 'total': 7 } },
      incident_id: incident4.id
    )
    violation4.individual_victims = [
      IndividualVictim.create!(
        data: {
          victim_deprived_liberty_security_reasons: 'true',
          length_deprivation_liberty: Date.today.beginning_of_month,
          deprivation_liberty_end: Date.today + 3.days
        }
      ),
      IndividualVictim.create!(
        data: {
          victim_deprived_liberty_security_reasons: 'true',
          length_deprivation_liberty: Date.today,
          deprivation_liberty_end: Date.today + 3.days
        }
      )
    ]
    violation5 = Violation.create!(
      data: { type: 'maiming', violation_tally: { 'boys': 2, 'girls': 3, 'unknown': 2, 'total': 7 } },
      incident_id: incident5.id
    )
    violation5.individual_victims = [
      IndividualVictim.create!(
        data: {
          victim_deprived_liberty_security_reasons: 'false',
          length_deprivation_liberty: Date.today.beginning_of_year
        }
      )
    ]
  end

  it 'returns data for violation tally indicator' do
    violation_tally_data = ManagedReports::Indicators::DetentionStatus.build(
      nil
    ).data

    expect(violation_tally_data).to match_array(
      [
        { 'total' => 3, 'id' => 'detention_detained' },
        { 'total' => 2, 'id' => 'detention_released' }
      ]
    )
  end

  describe 'records in scope' do
    it 'returns owned records for a self scope' do
      violation_tally_data = ManagedReports::Indicators::DetentionStatus.build(@self_user).data

      expect(violation_tally_data).to match_array(
        [
          { 'total' => 1, 'id' => 'detention_released' }
        ]
      )
    end

    it 'returns group records for a group scope' do
      violation_tally_data = ManagedReports::Indicators::DetentionStatus.build(@group_user).data

      expect(violation_tally_data).to match_array(
        [
          { 'total' => 3, 'id' => 'detention_detained' },
          { 'total' => 1, 'id' => 'detention_released' }
        ]
      )
    end

    it 'returns agency records for an agency scope' do
      violation_tally_data = ManagedReports::Indicators::DetentionStatus.build(@agency_user).data

      expect(violation_tally_data).to match_array(
        [
          { 'total' => 1, 'id' => 'detention_detained' },
          { 'total' => 1, 'id' => 'detention_released' }
        ]
      )
    end

    it 'returns all records for an all scope' do
      violation_tally_data = ManagedReports::Indicators::DetentionStatus.build(@all_user).data

      expect(violation_tally_data).to match_array(
        [
          { 'total' => 3, 'id' => 'detention_detained' },
          { 'total' => 2, 'id' => 'detention_released' }
        ]
      )
    end
  end
end
