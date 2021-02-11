import { fromJS } from "immutable";

import {
  FormSectionRecord,
  FieldRecord,
  LABEL_FIELD,
  ORDERABLE_OPTIONS_FIELD,
  SELECT_FIELD
} from "../../../../../../../form";

export const optionsTabs = (fieldName, i18n, mode, field, lookups) => {
  const optionStringsText = field?.get("option_strings_text", fromJS({}));
  const options = Array.isArray(optionStringsText) ? optionStringsText : optionStringsText?.toJS();

  return [
    {
      name: i18n.t("fields.predifined_lookups"),
      selected: Boolean(field.get("option_strings_source")),
      disabled: !mode.get("isNew") && !field.get("option_strings_source"),
      fields: fromJS([
        FieldRecord({
          display_name: i18n.t("fields.find_lookup"),
          name: `${fieldName}.option_strings_source`,
          type: SELECT_FIELD,
          option_strings_source: "Lookups",
          disabled: mode.get("isEdit"),
          clearDependentValues: [`${fieldName}.selected_value`],
          clearDependentReason: ["clear", "select-option"]
        }),
        FieldRecord({
          display_name: i18n.t("fields.default_value"),
          name: `${fieldName}.selected_value`,
          type: SELECT_FIELD,
          option_strings_source: "Lookups",
          watchedInputs: `${fieldName}.option_strings_source`,
          filterOptionSource: (watchedInputsValues, lookupOptions) => {
            const emptyOptions = [{ id: "", display_text: "" }];

            if (!watchedInputsValues) return [];

            const lookupSelected = lookupOptions.find(lookup => lookup.get("id") === watchedInputsValues);

            const newSelectOptions = lookupSelected ? emptyOptions.concat(lookupSelected.get("values").toJS()) : [];

            return newSelectOptions;
          }
        })
      ])
    },
    {
      name: i18n.t("fields.create_unique_values"),
      selected: Boolean(options?.length),
      disabled: !mode.get("isNew") && !options?.length,
      fields: fromJS([
        FieldRecord({
          display_name: i18n.t("fields.find_lookup"),
          name: `${fieldName}.option_strings_text`,
          type: ORDERABLE_OPTIONS_FIELD,
          disabled: mode.get("isEdit"),
          selected_value: field.get("selected_value"),
          option_strings_text: options
        })
      ])
    }
  ];
};

/* eslint-disable import/prefer-default-export */
export const optionsForm = ({ fieldName, i18n, formMode, field, lookups, css }) => {
  const optionsFormFields = [
    FieldRecord({
      display_name: i18n.t("fields.options_indications_lookup_values"),
      name: "options_indications",
      type: LABEL_FIELD
    }),
    FieldRecord({
      display_name: i18n.t("fields.options_indications_restrictions"),
      name: "options_indications_restrictions",
      inputClassname: css.boldLabel,
      type: LABEL_FIELD
    }),
    {
      tabs: optionsTabs(fieldName, i18n, formMode, field, lookups)
    }
  ];

  return FormSectionRecord({
    unique_id: "field_form_options",
    name: i18n.t("fields.option_strings_text"),
    fields: optionsFormFields
  });
};
