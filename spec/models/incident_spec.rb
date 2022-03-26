# frozen_string_literal: true

require 'rails_helper'
require 'will_paginate'

describe Incident do
  before do
    clean_data(
      Agency, User, Child, PrimeroProgram, UserGroup, PrimeroModule, FormSection, Field,
      Incident, Violation, Response, IndividualVictim, Source, Perpetrator, GroupVictim
    )

    create(:agency)
  end

  describe 'save' do
    it 'should save with generated incident_id' do
      Incident.any_instance.stub(:field_definitions).and_return([])
      incident = create_incident_with_created_by('jdoe', 'description' => 'London')
      incident.save!
      incident.id.should_not be_nil
    end
  end

  describe 'new_with_user_name' do
    before(:all) { create(:agency) }
    before :each do
      Incident.any_instance.stub(:field_definitions).and_return([])
    end

    it 'should create regular incident fields' do
      incident = create_incident_with_created_by('jdoe', 'description' => 'London', 'age' => '6')
      expect(incident.data['description']).to eq('London')
      expect(incident.data['age'].to_s).to eq('6')
    end

    it 'should create a unique id' do
      SecureRandom.stub('uuid').and_return('bbfca678-18fc-44a4-9a0d-0764e0941316')
      incident = create_incident_with_created_by('jdoe')
      incident.save!
      incident.unique_identifier.should == 'bbfca678-18fc-44a4-9a0d-0764e0941316'
    end

    it 'should create a created_by field with the user name' do
      incident = create_incident_with_created_by('jdoe', 'some_field' => 'some_value')
      incident.data['created_by'].should == 'jdoe'
    end

    describe 'when the created at field is not supplied' do
      it 'should create a created_at field with time of creation' do
        DateTime.stub(:now).and_return(Time.utc(2010, 'jan', 14, 14, 5, 0))
        incident = create_incident_with_created_by('some_user', 'some_field' => 'some_value')
        incident.created_at.should == DateTime.parse('2010-01-14 14:05:00UTC')
      end
    end

    describe 'when the created at field is supplied' do
      it 'should use the supplied created at value' do
        incident = create_incident_with_created_by(
          'some_user', 'some_field' => 'some_value', 'created_at' => '2010-01-14 14:05:00UTC'
        )
        incident.data['created_at'].should == '2010-01-14 14:05:00UTC'
      end
    end

    describe 'when violations data is present' do
      let(:incident_data) do
        {
          'unique_id' => '790f958d-ac8e-414b-af64-e75831e3353a',
          'incident_code' => '0123456',
          'description' => 'this is a test',
          'recruitment' => [
            {
              'unique_id' => '8dccaf74-e9aa-452a-9b58-dc365b1062a2',
              'violation_tally': { 'boys': 3, 'girls': 1, 'unknown': 0, 'total': 4 },
              'name' => 'violation1'
            }
          ],
          'responses' => [
            {
              'unique_id' => '36c09588-5489-4d0f-a129-8f5868222cf2',
              'name' => 'intervention2',
              'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2']
            }
          ],
          'individual_victims' => [
            {
              'unique_id' => '53baed05-a012-42e9-ad8d-5c5660ac5159',
              'name' => 'individual1',
              'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2']
            }
          ],
          'sources' => [
            {
              'unique_id' => '7742b9db-2db2-4421-bff7-9aae6272fc4a',
              'name' => 'source1',
              'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2']
            }
          ],
          'perpetrators' => [
            {
              'unique_id' => 'ac4ea377-4223-453d-a8eb-01475c7dcec6',
              'name' => 'perpetrator1',
              'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2']
            }
          ],
          'group_victims' => [
            {
              'unique_id' => 'ae0de249-d8d9-44a6-9f7f-9dd316b46385',
              'name' => 'group1',
              'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2']
            }
          ]
        }
      end
      before :each do
        clean_data(Incident, Violation, Response, IndividualVictim, Source, Perpetrator, GroupVictim)
        incident_record = Incident.new_with_user(fake_user, incident_data)
        incident_record.save!
      end

      it 'creates a incident record' do
        incident = Incident.first
        expect(Incident.count).to eq(1)
        expect(incident.incident_code).to eq('0123456')
      end

      it 'creates a violation record' do
        violation = Violation.first
        expect(Violation.count).to eq(1)
        expect(violation.unique_id).to eq('8dccaf74-e9aa-452a-9b58-dc365b1062a2')
      end

      it 'creates a responses record' do
        response = Response.first
        expect(Response.count).to eq(1)
        expect(response.unique_id).to eq('36c09588-5489-4d0f-a129-8f5868222cf2')
      end

      it 'creates a individual_victims record' do
        individual_victim = IndividualVictim.first
        expect(IndividualVictim.count).to eq(1)
        expect(individual_victim.unique_id).to eq('53baed05-a012-42e9-ad8d-5c5660ac5159')
      end

      it 'creates a sources record' do
        source = Source.first
        expect(Source.count).to eq(1)
        expect(source.unique_id).to eq('7742b9db-2db2-4421-bff7-9aae6272fc4a')
      end

      it 'creates a perpetrators record' do
        perpetrator = Perpetrator.first
        expect(Perpetrator.count).to eq(1)
        expect(perpetrator.unique_id).to eq('ac4ea377-4223-453d-a8eb-01475c7dcec6')
      end

      it 'creates a group_victims record' do
        group_victim = GroupVictim.first
        expect(GroupVictim.count).to eq(1)
        expect(group_victim.unique_id).to eq('ae0de249-d8d9-44a6-9f7f-9dd316b46385')
      end
    end
  end

  describe 'unique id' do
    before :each do
      Incident.any_instance.stub(:field_definitions).and_return([])
    end

    it 'should create a unique id' do
      SecureRandom.stub('uuid').and_return('191fc236-71f4-4a76-be09-f2d8c442e1fd')
      incident = Incident.new
      incident.save!
      incident.unique_identifier.should == '191fc236-71f4-4a76-be09-f2d8c442e1fd'
    end

    it 'should return last 7 characters of unique id as short id' do
      SecureRandom.stub('uuid').and_return('191fc236-71f4-4a76-be09-f2d8c442e1fd')
      incident = Incident.new
      incident.save!
      incident.short_id.should == '442e1fd'
    end
  end

  describe 'organization' do
    it 'should get created user' do
      incident = Incident.new
      incident.created_by = 'test'

      User.should_receive(:find_by_user_name).with('test').and_return('test1')
      incident.created_by_user.should == 'test1'
    end

    it 'should be set from user' do
      User.stub(:find_by_user_name).with('mj').and_return(double(organization: double(unique_id: 'UNICEF')))
      incident = Incident.create 'description' => 'My Test Incident Description', :created_by => 'mj'

      incident.created_organization.should == 'UNICEF'
    end
  end

  describe '.copy_from_case' do
    before(:each) do
      clean_data(Incident, Child, PrimeroModule) && module_cp
      module_cp = PrimeroModule.new(
        unique_id: 'primeromodule-cp',
        field_map: {
          map_to: 'primeromodule-cp',
          fields: [
            { source: 'age', target: 'age' },
            { source: 'sex', target: 'sex' },
            { source: 'protection_concerns', target: 'protection_concerns' }
          ]
        }
      )
      module_cp.save(validate: false)
    end

    let(:case_cp) do
      Child.create!(
        name: 'Niall McPherson', age: 12, sex: 'male',
        protection_concerns: %w[unaccompanied separated], ethnicity: 'other',
        module_id: 'primeromodule-cp'
      )
    end

    it 'copies data from the linked case according to the configuration' do
      incident = Incident.new_with_user(
        nil,
        survivor_code: 'abc123', module_id: 'primeromodule-cp', incident_case_id: case_cp.id
      )
      incident.save!

      expect(incident.data['age']).to eq(case_cp.age)
      expect(incident.data['sex']).to eq(case_cp.sex)
      expect(incident.data['protection_concerns']).to eq(case_cp.protection_concerns)
      expect(incident.case.id).to eq(case_cp.id)
    end

    it 'does not copy data from the linked incident if the link already exists' do
      incident = Incident.new_with_user(
        nil,
        survivor_code: 'abc123', module_id: 'primeromodule-cp', incident_case_id: case_cp.id
      )
      incident.save!
      case_cp.age = 13
      case_cp.save!
      incident.survivor_code = 'xyz123'
      incident.save

      expect(incident.survivor_code).to eq('xyz123')
      expect(incident.data['age']).to eq(12)
    end
  end

  describe 'add_alert_on_case' do
    before(:each) do
      clean_data(Agency, SystemSettings, User, Incident, Child, PrimeroModule, Violation) && module_cp

      Agency.create!(unique_id: 'agency-1', agency_code: 'a1', name: 'Agency')

      SystemSettings.create!(changes_field_to_form: { incident_details: 'incident_from_case' })
    end

    let(:case_cp) do
      cp_user = User.new(user_name: 'cp_user', agency_id: Agency.last.id)
      cp_user.save(validate: false)

      case_cp = Child.new_with_user(
        cp_user,
        name: 'Niall McPherson', age: 12, sex: 'male',
        protection_concerns: %w[unaccompanied separated], ethnicity: 'other',
        module_id: 'primeromodule-cp'
      )
      case_cp.save!
      case_cp.reload
      case_cp
    end

    it 'should add an alert for the case if the incident creator is not the case owner' do
      incident = Incident.new_with_user(
        User.new(user_name: 'incident_user', agency_id: Agency.last.id),
        survivor_code: 'abc123', module_id: 'primeromodule-cp'
      )
      incident.case = case_cp
      incident.save!

      case_cp.reload

      expect(case_cp.alerts.size).to eq(1)
    end

    it 'should add a record history in the case after incident is created' do
      last_updated_at = case_cp.last_updated_at

      incident = Incident.new_with_user(
        User.new(user_name: 'incident_user', agency_id: Agency.last.id),
        survivor_code: 'abc123', module_id: 'primeromodule-cp'
      )
      incident.case = case_cp
      incident.save!

      case_cp.reload

      expect(
        case_cp.record_histories.map { |history| history.record_changes.keys }.flatten.include?('incidents')
      ).to be_truthy
      expect(case_cp.last_updated_at > last_updated_at).to be_truthy
    end
  end

  describe '#update_properties' do
    let(:incident) { Incident.create!(unique_id: '1a2b3c', incident_code: '0123456', description: 'this is a test') }

    before do
      data = incident.data.clone
      data['recruitment'] = [
        {
          'unique_id' => '8dccaf74-e9aa-452a-9b58-dc365b1062a2',
          'violation_tally': { 'boys': 3, 'girls': 1, 'unknown': 0, 'total': 4 },
          'name' => 'violation1'
        }
      ]
      data['responses'] = [
        {
          'unique_id' => '36c09588-5489-4d0f-a129-8f5868222cf2',
          'name' => 'intervention2',
          'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2']
        }
      ]
      data['individual_victims'] = [
        {
          'unique_id' => '53baed05-a012-42e9-ad8d-5c5660ac5159',
          'name' => 'individual1',
          'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2']
        }
      ]
      data['sources'] = [
        {
          'unique_id' => '7742b9db-2db2-4421-bff7-9aae6272fc4a',
          'name' => 'source1',
          'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2']
        }
      ]
      data['perpetrators'] = [
        {
          'unique_id' => 'ac4ea377-4223-453d-a8eb-01475c7dcec6',
          'name' => 'perpetrator1',
          'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2']
        }
      ]
      data['group_victims'] = [
        {
          'unique_id' => 'ae0de249-d8d9-44a6-9f7f-9dd316b46385',
          'name' => 'group1',
          'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2']
        }
      ]
      incident.update_properties(fake_user, data)
      incident.save!
    end

    it 'creates a violation record' do
      violation = Violation.first
      expect(Violation.count).to eq(1)
      expect(violation.unique_id).to eq('8dccaf74-e9aa-452a-9b58-dc365b1062a2')
    end

    it 'creates a responses record' do
      response = Response.first
      expect(Response.count).to eq(1)
      expect(response.unique_id).to eq('36c09588-5489-4d0f-a129-8f5868222cf2')
    end

    it 'creates a individual_victims record' do
      individual_victim = IndividualVictim.first
      expect(IndividualVictim.count).to eq(1)
      expect(individual_victim.unique_id).to eq('53baed05-a012-42e9-ad8d-5c5660ac5159')
    end

    it 'creates a sources record' do
      source = Source.first
      expect(Source.count).to eq(1)
      expect(source.unique_id).to eq('7742b9db-2db2-4421-bff7-9aae6272fc4a')
    end

    it 'creates a perpetrators record' do
      perpetrator = Perpetrator.first
      expect(Perpetrator.count).to eq(1)
      expect(perpetrator.unique_id).to eq('ac4ea377-4223-453d-a8eb-01475c7dcec6')
    end

    it 'creates a group_victims record' do
      group_victim = GroupVictim.first
      expect(GroupVictim.count).to eq(1)
      expect(group_victim.unique_id).to eq('ae0de249-d8d9-44a6-9f7f-9dd316b46385')
    end
  end

  describe '#associations_as_data' do
    let(:incident) { Incident.create!(unique_id: '1a2b3c', incident_code: '987654', description: 'this is a test') }

    before(:each) do
      clean_data(Incident, Violation, IndividualVictim)
      data = incident.data.clone
      data['recruitment'] = [
        {
          'unique_id' => '8dccaf74-e9aa-452a-9b58-dc365b1062a2',
          'violation_tally': { 'boys': 3, 'girls': 1, 'unknown': 0, 'total': 4 },
          'name' => 'violation1'
        }
      ]
      data['responses'] = [
        {
          'unique_id' => '36c09588-5489-4d0f-a129-8f5868222cf2',
          'name' => 'intervention2',
          'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2']
        }
      ]
      data['individual_victims'] = [
        {
          'unique_id' => '53baed05-a012-42e9-ad8d-5c5660ac5159',
          'name' => 'individual1',
          'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2']
        }
      ]
      data['sources'] = [
        {
          'unique_id' => '7742b9db-2db2-4421-bff7-9aae6272fc4a',
          'name' => 'source1',
          'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2']
        }
      ]
      data['perpetrators'] = [
        {
          'unique_id' => 'ac4ea377-4223-453d-a8eb-01475c7dcec6',
          'name' => 'perpetrator1',
          'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2']
        }
      ]
      data['group_victims'] = [
        {
          'unique_id' => 'ae0de249-d8d9-44a6-9f7f-9dd316b46385',
          'name' => 'group1',
          'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2']
        }
      ]
      incident.update_properties(fake_user, data)
      incident.save!
    end

    it 'creates a violation record' do
      incident_associations_as_data =
        {
          'killing' => [],
          'maiming' => [],
          'recruitment' => [
            {
              'name' => 'violation1',
              'type' => 'recruitment',
              'unique_id' => '8dccaf74-e9aa-452a-9b58-dc365b1062a2',
              'violation_tally' => { 'boys' => 3, 'girls' => 1, 'total' => 4, 'unknown' => 0 }
            }
          ],
          'sexual_violence' => [],
          'abduction' => [],
          'attack_on_hospitals' => [],
          'attack_on_schools' => [],
          'military_use' => [],
          'denial_humanitarian_access' => [],
          'sources' => [
            { 'name' => 'source1', 'unique_id' => '7742b9db-2db2-4421-bff7-9aae6272fc4a',
              'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2'] }
          ],
          'perpetrators' => [
            { 'name' => 'perpetrator1', 'unique_id' => 'ac4ea377-4223-453d-a8eb-01475c7dcec6',
              'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2'] }
          ],
          'individual_victims' => [
            { 'name' => 'individual1', 'unique_id' => '53baed05-a012-42e9-ad8d-5c5660ac5159',
              'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2'] }
          ],
          'group_victims' => [
            { 'name' => 'group1', 'unique_id' => 'ae0de249-d8d9-44a6-9f7f-9dd316b46385',
              'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2'] }
          ],
          'responses' => [
            { 'name' => 'intervention2', 'unique_id' => '36c09588-5489-4d0f-a129-8f5868222cf2',
              'violations_ids' => '8dccaf74-e9aa-452a-9b58-dc365b1062a2' }
          ]
        }
      expect(incident.incident_code).to eq('987654')
      expect(incident.associations_as_data('user')).to eq(incident_associations_as_data)
    end

    it 'adding a violation association' do
      data_to_update = {
        'individual_victims' => [
          {
            'id_number' => '1',
            'violations_ids' => ['8dccaf74-e9aa-452a-9b58-dc365b1062a2'],
            'individual_sex' => 'male',
            'nationality' => %w[nationality1],
            'unique_id' => '8d18d459-d75f-4a68-9862-3846b47ca3a0'
          }
        ]
      }
      incident.update_properties(fake_user, data_to_update)
      incident.save!
      individual_victims_result = incident.associations_as_data('user')['individual_victims']
      individual_victims_result_unique_id = individual_victims_result.map do |individual_victim|
        individual_victim['unique_id']
      end

      expect(individual_victims_result.count).to eq(2)
      expect(individual_victims_result_unique_id).to match_array(
        %w[8d18d459-d75f-4a68-9862-3846b47ca3a0 53baed05-a012-42e9-ad8d-5c5660ac5159]
      )
    end

    it 'updating a violation association' do
      data_to_update = {
        'individual_victims' => [
          {
            'name' => 'individual2',
            'unique_id' => '53baed05-a012-42e9-ad8d-5c5660ac5159'
          }
        ]
      }
      incident.update_properties(fake_user, data_to_update)
      incident.save!
      individual_victims_result = incident.associations_as_data('user')['individual_victims']
      individual_victim = individual_victims_result.find do |data|
        data['unique_id'] = '53baed05-a012-42e9-ad8d-5c5660ac5159'
      end
      expect(individual_victim['name']).to eq('individual2')
    end
  end

  describe 'elapsed_reporting_time' do
    before do
      @incident = Incident.create!(
        data: { incident_date: Date.new(2020, 8, 10), date_of_first_report: Date.new(2020, 8, 12) }
      )
    end

    it 'sets the elapsed reporting time when a incident is created' do
      expect(@incident.elapsed_reporting_time).to eq('0_3_days')
    end

    it 'clears the elapsed reporting time if the incident_date is removed' do
      @incident.incident_date = nil
      @incident.save!

      expect(@incident.elapsed_reporting_time).to be_nil
    end

    it 'clears the elapsed reporting time if the date_of_first_report is removed' do
      @incident.date_of_first_report = nil
      @incident.save!

      expect(@incident.elapsed_reporting_time).to be_nil
    end
  end

  describe '#verification_status_list', search: true do
    before do
      @incident = Incident.create!(data: { incident_date: Date.today, status: 'open' })
      @incident2 = Incident.create!(data: { incident_date: Date.today, status: 'open' })
      Violation.create!(
        data: {
          type: 'killing',
          ctfmr_verified: 'verified'
        },
        incident_id: @incident.id
      )
      Violation.create!(
        data: {
          type: 'maiming',
          ctfmr_verified: 'verified'
        },
        incident_id: @incident.id
      )
      Violation.create!(
        data: {
          type: 'killing',
          ctfmr_verified: 'not_mrm'
        },
        incident_id: @incident2.id
      )
      Incident.reindex
      Sunspot.commit
    end
    it 'can find an incident by verification_status' do
      search_result = SearchService.search(
        Incident,
        filters: [
          SearchFilters::Value.new(field_name: 'verification_status', value: 'not_mrm')
        ]
      ).results
      expect(search_result).to have(1).incident
      expect(search_result.first.incident_id).to eq(@incident2.incident_id)
      expect(search_result.first.incident_code).to eq(@incident2.incident_code)
    end
  end

  private

  def create_incident_with_created_by(created_by, options = {})
    user = User.new(user_name: created_by, agency_id: Agency.last.id)
    Incident.new_with_user(user, options)
  end

  after do
    clean_data(
      Agency, User, Child, PrimeroProgram, UserGroup, PrimeroModule, FormSection, Field,
      Incident, Violation, Response, IndividualVictim, Source, Perpetrator, GroupVictim
    )
  end
end
