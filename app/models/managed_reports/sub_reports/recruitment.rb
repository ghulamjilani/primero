# frozen_string_literal: true

# Describes Recruitment subreport in Primero.
class ManagedReports::SubReports::Recruitment < ManagedReports::SubReport
  def id
    'recruitment'
  end

  def indicators
    [
      ManagedReports::Indicators::ViolationTally,
      ManagedReports::Indicators::Perpetrators,
      ManagedReports::Indicators::ReportingLocation,
      ManagedReports::Indicators::TypeOfUse,
      ManagedReports::Indicators::FactorsOfRecruitment
    ]
  end

  def lookups
    {
      ManagedReports::Indicators::Perpetrators.id => 'lookup-armed-force-group-or-other-party',
      ManagedReports::Indicators::ReportingLocation.id => 'Location',
      ManagedReports::Indicators::TypeOfUse.id => 'lookup-combat-role-type',
      ManagedReports::Indicators::FactorsOfRecruitment.id => 'lookup-recruitment-factors'
    }
  end

  def build_report(current_user, params = [])
    super(current_user, params.merge('type' => SearchFilters::Value.new(field_name: 'type', value: id)))
  end
end
