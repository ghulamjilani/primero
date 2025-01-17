import { Record, fromJS } from "immutable";

import { SELECT_CHANGE_REASON } from "./constants";

export const FieldRecord = Record({
  internalFormFieldID: null,
  id: null,
  name: "",
  type: "",
  editable: true,
  disabled: null,
  visible: null,
  display_name: fromJS({}),
  subform_section_id: null,
  subform_section_temp_id: null,
  help_text: fromJS({}),
  multi_select: null,
  option_strings_source: null,
  option_strings_text: null,
  option_strings_condition: null,
  guiding_questions: "",
  required: false,
  date_validation: null,
  hide_on_view_page: false,
  date_include_time: false,
  selected_value: "",
  subform_sort_by: "",
  show_on_minify_form: false,
  autoFocus: false,
  password: false,
  hideOnShow: false,
  inputClassname: null,
  inlineCheckboxes: false,
  freeSolo: false,
  watchedInputs: null,
  handleWatchedInputs: null,
  showIf: null,
  forceShowIf: false,
  multipleLimitOne: false,
  check_errors: fromJS([]),
  hint: "",
  groupBy: null,
  tooltip: "",
  tick_box_label: fromJS({}),
  numeric: false,
  onChange: null,
  mobile_visible: false,
  on_collapsed_subform: false,
  order: null,
  disableClearable: false,
  onBlur: null,
  subform_section_unique_id: null,
  asyncOptions: false,
  asyncParams: {},
  asyncParamsFromWatched: {},
  asyncOptionsLoadingPath: null,
  asyncAction: () => {},
  option_strings_source_id_key: null,
  clearDependentValues: null,
  clearDependentReason: [SELECT_CHANGE_REASON.selectOption, SELECT_CHANGE_REASON.clear],
  form_section_id: null,
  subform_section_configuration: null,
  setOtherFieldValues: null,
  wrapWithComponent: null,
  onClick: null,
  placeholder: "",
  maxSelectedOptions: null,
  onKeyPress: null,
  currRecord: null,
  extraSelectorOptions: {},
  href: null,
  fileFormat: "",
  filterOptionSource: null,
  rawOptions: false,
  renderDownloadButton: false,
  downloadButtonLabel: "",
  i18nName: false,
  i18nDescription: false,
  renderChildren: true,
  max_length: null,
  display_conditions_record: [],
  display_conditions_subform: []
});

export const FormSectionRecord = Record({
  id: "",
  temp_id: null,
  description: fromJS({}),
  unique_id: "",
  name: fromJS({}),
  visible: null,
  is_first_tab: null,
  order: null,
  order_form_group: null,
  parent_form: "",
  editable: null,
  module_ids: fromJS([]),
  form_group_id: "",
  form_group_name: "",
  fields: fromJS([]),
  is_nested: null,
  subform_append_only: false,
  subform_prevent_item_removal: false,
  initial_subforms: 0,
  collapsed_field_names: fromJS([]),
  check_errors: fromJS([]),
  expandable: false,
  expanded: false,
  tooltip: "",
  actions: null,
  core_form: false
});

export const Option = Record({
  type: "",
  options: fromJS([])
});
