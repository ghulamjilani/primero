#TODO - The Service Referral options in each subform are all the same.  They need to be moved to a lookup
health_medical_referral_subform_fields = [
  Field.new({"name" => "service_medical_referral",
             "show_on_minify_form" => true,
             "mobile_visible" => true,
             "type" => "select_box",
             "display_name_all" => "Did you refer the client to Health/Medical Services?",
             "option_strings_source" => "lookup lookup-service-referred",
            }),
  Field.new({"name" => "service_medical_appointment_date",
             "mobile_visible" => false,
             "type" => "date_field",
             "display_name_all" => "Appointment Date"
            }),
  Field.new({"name" => "service_medical_appointment_time",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Appointment Time"
            }),
  Field.new({"name" => "service_medical_provider",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Service Provider"
            }),
  Field.new({"name" => "service_medical_location",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Service Location"
            }),
  Field.new({"name" => "service_medical_referral_notes",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Notes"
            })
]

health_medical_referral_subform_section = FormSection.create_or_update_form_section({
  "visible" => false,
  "is_nested" => true,
  :order_form_group => 100,
  :order => 10,
  :order_subform => 1,
  :unique_id => "health_medical_referral_subform_section",
  :parent_form=>"incident",
  "editable" => true,
  :fields => health_medical_referral_subform_fields,
  mobile_form: true,
  :initial_subforms => 1,
  "name_all" => "Nested Health/Medical Referral Subform",
  "description_all" => "Nested Health/Medical Referral Subform"
})

psychosocial_counseling_services_subform_fields = [
  Field.new({"name" => "service_psycho_referral",
             "show_on_minify_form" => true,
             "mobile_visible" => true,
             "type" => "select_box",
             "display_name_all" => "Did you refer the client to Psychosocial/Counseling services?",
             "option_strings_source" => "lookup lookup-service-referred",
            }),
  Field.new({"name" => "service_psycho_appointment_date",
             "mobile_visible" => false,
             "type" => "date_field",
             "display_name_all" => "Appointment Date"
            }),
  Field.new({"name" => "service_psycho_appointment_time",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Appointment Time"
            }),
  Field.new({"name" => "service_psycho_provider",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Service Provider"
            }),
  Field.new({"name" => "service_psycho_service_location",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Service Location"
            }),
  Field.new({"name" => "service_psycho_referral_notes",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Notes"
            })
]

psychosocial_counseling_services_subform_section = FormSection.create_or_update_form_section({
  "visible" => false,
  "is_nested" => true,
  :order_form_group => 100,
  :order => 10,
  :order_subform => 2,
  :unique_id => "psychosocial_counseling_services_subform_section",
  :parent_form=>"incident",
  "editable" => true,
  :fields => psychosocial_counseling_services_subform_fields,
  mobile_form: true,
  :initial_subforms => 1,
  "name_all" => "Nested Psychosocial/Counseling Services Subform",
  "description_all" => "Nested Psychosocial/Counseling Services Subform"
})

legal_assistance_services_subform_fields = [
  Field.new({"name" => "service_legal_referral",
             "show_on_minify_form" => true,
             "mobile_visible" => true,
             "type" => "select_box",
             "display_name_all" => "Did you refer the client to Legal services?",
             "option_strings_source" => "lookup lookup-service-referred",
            }),
  Field.new({"name" => "service_legal_appointment_date",
             "mobile_visible" => false,
             "type" => "date_field",
             "display_name_all" => "Appointment Date"
            }),
  Field.new({"name" => "service_legal_appointment_time",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Appointment Time"
            }),
  Field.new({"name" => "service_legal_provider",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Service Provider"
            }),
  Field.new({"name" => "service_legal_location",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Service Location"
            }),
  Field.new({"name" => "service_legal_referral_notes",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Notes"
            }),
  Field.new({"name" => "pursue_legal_action",
             "mobile_visible" => false,
             "type" => "radio_button",
             "display_name_all" => "Does the client want to pursue legal action?",
             "option_strings_source" => "lookup lookup-yes-no-undecided"
            })
]

legal_assistance_services_subform_section = FormSection.create_or_update_form_section({
  "visible" => false,
  "is_nested" => true,
  :order_form_group => 100,
  :order => 10,
  :order_subform => 3,
  :unique_id => "legal_assistance_services_subform_section",
  :parent_form=>"incident",
  "editable" => true,
  :fields => legal_assistance_services_subform_fields,
  mobile_form: true,
  :initial_subforms => 1,
  "name_all" => "Nested Legal Assistance Services Subform",
  "description_all" => "Nested Legal Assistance Services Subform"
})

police_or_other_type_of_security_services_subform_fields = [
  Field.new({"name" => "service_police_referral",
             "show_on_minify_form" => true,
             "mobile_visible" => true,
             "type" => "select_box",
             "display_name_all" => "Did you refer the client to Police/Other services?",
             "option_strings_source" => "lookup lookup-service-referred",
            }),
  Field.new({"name" => "service_police_appointment_date",
             "mobile_visible" => false,
             "type" => "date_field",
             "display_name_all" => "Appointment Date"
            }),
  Field.new({"name" => "service_police_appointment_time",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Appointment Time"
            }),
  Field.new({"name" => "service_police_provider",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Service Provider"
            }),
  Field.new({"name" => "service_police_location",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Service Location"
            }),
  Field.new({"name" => "service_police_referral_notes",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Notes"
            })
]

police_or_other_type_of_security_services_subform_section = FormSection.create_or_update_form_section({
  "visible" => false,
  "is_nested" => true,
  :order_form_group => 100,
  :order => 10,
  :order_subform => 4,
  :unique_id => "police_or_other_type_of_security_services_subform_section",
  :parent_form=>"incident",
  "editable" => true,
  mobile_form: true,
  :fields => police_or_other_type_of_security_services_subform_fields,
  :initial_subforms => 1,
  "name_all" => "Nested Police or Other Type of Security Services Subform",
  "description_all" => "Nested Police or Other Type of Security Services Subform"
})

livelihoods_services_subform_fields = [
  Field.new({"name" => "service_livelihoods_referral",
             "show_on_minify_form" => true,
             "mobile_visible" => true,
             "type" => "select_box",
             "display_name_all" => "Did you refer the client to a livelihoods program?",
             "option_strings_source" => "lookup lookup-service-referred",
            }),
  Field.new({"name" => "service_livelihoods_appointment_date",
             "mobile_visible" => false,
             "type" => "date_field",
             "display_name_all" => "Appointment Date"
            }),
  Field.new({"name" => "service_livelihoods_appointment_time",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Appointment Time"
            }),
  Field.new({"name" => "service_livelihoods_provider",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Service Provider"
            }),
  Field.new({"name" => "service_livelihoods_location",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Service Location"
            }),
  Field.new({"name" => "service_livelihoods_referral_notes",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Notes"
            })
]

livelihoods_services_subform_section = FormSection.create_or_update_form_section({
  "visible" => false,
  "is_nested" => true,
  :order_form_group => 100,
  :order => 10,
  :order_subform => 5,
  :unique_id => "livelihoods_services_subform_section",
  :parent_form=>"incident",
  "editable" => true,
  :fields => livelihoods_services_subform_fields,
  mobile_form: true,
  :initial_subforms => 1,
  "name_all" => "Nested Livelihoods Services Subform",
  "description_all" => "Nested Livelihoods Services Subform"
})

child_protection_services_subform_fields = [
  Field.new({"name" => "service_protection_referral",
             "show_on_minify_form" => true,
             "mobile_visible" => true,
             "type" => "select_box",
             "display_name_all" => "Did you refer the client to Child Protection services?",
             "option_strings_source" => "lookup lookup-service-referred",
            }),
  Field.new({"name" => "service_protection_appointment_date",
             "mobile_visible" => false,
             "type" => "date_field",
             "display_name_all" => "Appointment Date"
            }),
  Field.new({"name" => "service_protection_appointment_time",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Appointment Time"
            }),
  Field.new({"name" => "service_protection_provider",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Service Provider"
            }),
  Field.new({"name" => "service_protection_location",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Service Location"
            }),
  Field.new({"name" => "service_protection_referral_notes",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Notes"
            })
]

child_protection_services_subform_section = FormSection.create_or_update_form_section({
  "visible" => false,
  "is_nested" => true,
  :order_form_group => 100,
  :order => 10,
  :order_subform => 6,
  :unique_id => "child_protection_services_subform_section",
  :parent_form=>"incident",
  "editable" => true,
  :fields => child_protection_services_subform_fields,
  mobile_form: true,
  :initial_subforms => 1,
  "name_all" => "Nested Child Protection Services Subform",
  "description_all" => "Nested Child Protection Services Subform"
})

services_fields = [
  Field.new({"name" => "service_referred_from",
             "show_on_minify_form" => true,
             "mobile_visible" => true,
             "type" => "select_box",
             "display_name_all" => "Who referred the client to you?",
             "option_strings_text_all" => [
                "Health / Medical Services",
                "Psychosocial / Counseling Services",
                "Police / Other Security Actor",
                "Legal Assistance Services",
                "Livelihoods Program",
                "Self Referral / First Point of Contact",
                "Teacher / School Official",
                "Community or Camp Leader",
                "Safe House / Shelter",
                "Other Humanitarian or Development Actor",
                "Other Government Service",
                "Other"].join("\n")
            }),
  Field.new({"name" => "service_referred_from_other",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "If survivor referred from Other, please specify."
            }),
  Field.new({"name" => "safe_house_safe_shelter_referral",
             "show_on_minify_form" => true,
             "mobile_visible" => true,
             "type" => "separator",
             "display_name_all" => "Safe House/Safe Shelter Referral"
            }),
  Field.new({"name" => "service_safehouse_referral",
             "show_on_minify_form" => true,
             "mobile_visible" => true,
             "type" => "select_box",
             "display_name_all" => "Did you refer the client to a safe house/safe shelter?",
             "option_strings_source" => "lookup lookup-service-referred",
            }),
  Field.new({"name" => "service_safehouse_appointment_date",
             "mobile_visible" => false,
             "type" => "date_field",
             "display_name_all" => "Appointment Date"
            }),
  Field.new({"name" => "service_safehouse_appointment_time",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Appointment Time"
            }),
  Field.new({"name" => "service_safehouse_provider",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Service Provider"
            }),
  Field.new({"name" => "service_safehouse_location",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Service Location"
            }),
  Field.new({"name" => "service_safehouse_referral_notes",
             "mobile_visible" => false,
             "type" => "text_field",
             "display_name_all" => "Notes"
            }),
  Field.new({"name" => "health_medical_referral_subform_section",
             "mobile_visible" => true,
             "show_on_minify_form" => true,
             "type" => "subform",
             "editable" => true,
             "subform_section_id" => health_medical_referral_subform_section.unique_id,
             "display_name_all" => "Health/Medical Referral"
            }),
  Field.new({"name" => "psychosocial_counseling_services_subform_section",
             "mobile_visible" => true,
             "show_on_minify_form" => true,
             "type" => "subform", "editable" => true,
             "subform_section_id" => psychosocial_counseling_services_subform_section.unique_id,
             "display_name_all" => "Psychosocial/Counseling Services"
            }),
  Field.new({"name" => "legal_assistance_services_subform_section",
             "mobile_visible" => true,
             "show_on_minify_form" => true,
             "type" => "subform", "editable" => true,
             "subform_section_id" => legal_assistance_services_subform_section.unique_id,
             "display_name_all" => "Legal Assistance Services"
            }),
  Field.new({"name" => "police_or_other_type_of_security_services_subform_section",
             "mobile_visible" => true,
             "show_on_minify_form" => true,
             "type" => "subform", "editable" => true,
             "subform_section_id" => police_or_other_type_of_security_services_subform_section.unique_id,
             "display_name_all" => "Police or Other Type of Security Services"
           }),
  Field.new({"name" => "livelihoods_services_subform_section",
             "mobile_visible" => true,
             "show_on_minify_form" => true,
             "type" => "subform", "editable" => true,
             "subform_section_id" => livelihoods_services_subform_section.unique_id,
             "display_name_all" => "Livelihoods Services"
            }),
  Field.new({"name" => "child_protection_services_subform_section",
             "mobile_visible" => true,
             "show_on_minify_form" => true,
             "type" => "subform", "editable" => true,
             "subform_section_id" => child_protection_services_subform_section.unique_id,
             "display_name_all" => "Child Protection Services"
            })
]

FormSection.create_or_update_form_section({
  :unique_id => "incident_service_referrals",
  :parent_form=>"incident",
  "visible" => true,
  :order_form_group => 100,
  :order => 10,
  :order_subform => 0,
  :form_group_name => "Service Referral",
  "editable" => true,
  :fields => services_fields,
  :mobile_form => true,
  "name_all" => "Service Referrals",
  "description_all" => "Service Referrals"
})