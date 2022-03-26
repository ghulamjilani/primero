# frozen_string_literal: true

# Class to export Subreports
class Exporters::SubreportExporter < ValueObject
  attr_accessor :id, :data, :workbook, :tab_color, :formats, :current_row,
                :worksheet, :managed_report, :locale, :lookups

  def export
    self.current_row ||= 0
    self.data = managed_report.data[id]
    self.worksheet = workbook.add_worksheet(build_worsheet_name)
    worksheet.tab_color = tab_color
    load_lookups
    write_export
  end

  def build_worsheet_name
    # Truncating in 31 allowed characters
    # Replacing invalid character
    I18n.t("managed_reports.#{managed_report.id}.reports.#{id}", locale: locale)
        .truncate(31)
        .gsub(%r{[\[\]\/:*?]}, ' ')
  end

  def write_export
    write_header
    write_params
    write_generated_on
    write_indicators
  end

  def write_header
    worksheet.set_column(current_row, 0, 80)
    worksheet.set_row(current_row, 40)
    write_header_title
    self.current_row += 1
  end

  def write_header_title
    worksheet.merge_range(
      current_row, 0, 0, 1,
      I18n.t("managed_reports.#{managed_report.id}.reports.#{id}", locale: locale),
      formats[:header]
    )
  end

  def write_params
    worksheet.set_row(current_row, 20)
    # TODO: Will this be problematic for arabic languages?
    params = date_range_param + filter_by_date_param + verification_status_param
    return unless params.present?

    params += [formats[:black]]
    worksheet.merge_range_type('rich_string', current_row, 0, current_row, 1, *params)
    self.current_row += 1
  end

  def date_range_param
    return [] unless date_range_display_text.present?

    [
      formats[:bold_blue], "#{I18n.t('fields.date_range_field', locale: locale)}: ",
      formats[:black], "#{date_range_display_text} / "
    ]
  end

  def filter_by_date_param
    return [] unless date_display_text.present?

    [
      formats[:bold_blue], "#{I18n.t('managed_reports.filter_by.date', locale: locale)}: ",
      formats[:black], "#{date_display_text} / "
    ]
  end

  def verification_status_param
    return [] unless verification_display_text.present?

    [
      formats[:bold_blue], "#{I18n.t('managed_reports.filter_by.verification_status', locale: locale)}: ",
      formats[:black], verification_display_text
    ]
  end

  def write_generated_on
    worksheet.merge_range_type(
      'rich_string',
      current_row, 0, current_row, 1,
      formats[:bold_blue], "#{I18n.t('managed_reports.generated_on', locale: locale)}: ",
      formats[:black], Time.now.strftime('%Y-%m-%d %H:%M:%S'),
      formats[:black]
    )
    self.current_row += 1
  end

  def write_table_header(indicator)
    write_grey_row

    worksheet.set_row(current_row, 30)
    worksheet.merge_range(
      current_row, 0, current_row, 1,
      I18n.t("managed_reports.#{managed_report.id}.sub_reports.#{indicator}", locale: locale),
      formats[:blue_header]
    )
    self.current_row += 1

    write_total_row
  end

  def write_grey_row
    worksheet.merge_range(current_row, 0, current_row, 1, '', formats[:grey_space])
    self.current_row += 1
  end

  def write_total_row
    worksheet.set_row(current_row, 40)
    worksheet.write(current_row, 1, I18n.t('managed_reports.total', locale: locale), formats[:bold_blue])
    self.current_row += 1
  end

  def write_graph(table_data_rows)
    return unless table_data_rows.present?

    chart = workbook.add_chart(type: 'column', embedded: 1, name: '')
    chart.add_series(build_series(table_data_rows))
    chart.set_size(height: 460, width: chart_width(table_data_rows))
    chart.set_legend(none: true)
    worksheet.insert_chart(current_row, 0, chart, 0, 0)
    # A row is 20px, chart height is 460 then 460 / 20 = 23
    self.current_row += 23
  end

  def build_series(table_data_rows)
    {
      categories: [worksheet.name] + table_data_rows + [0, 0],
      values: [worksheet.name] + table_data_rows + [1, 1],
      points: Exporters::ManagedReportExporter::CHART_COLORS.values.map { |color| { fill: { color: color } } }
    }
  end

  def chart_width(table_data_rows)
    row_count = table_data_rows.last - table_data_rows.first
    return 384 if row_count < 3

    # column width is 64px
    384 + (row_count * 64)
  end

  def transform_entries(entries)
    entries.reduce([]) do |acc, (key, value)|
      next(acc) if key == :lookups

      acc << [key, transform_indicator_values(value)]
    end
  end

  def write_indicators
    transform_entries(data.entries).each do |(indicator_key, indicator_values)|
      next unless indicator_values.is_a?(Array)

      indicator_lookups = lookups[indicator_key]
      write_table_header(indicator_key)
      start_row = current_row
      write_indicator(indicator_values, indicator_lookups)
      last_row = current_row - 1
      write_graph([start_row, last_row])
      self.current_row += 1
    end
  end

  def write_indicator(values, indicator_lookups)
    values.each do |elem|
      if elem == values.last
        write_indicator_last_row(elem, indicator_lookups)
      else
        write_indicator_row(elem, indicator_lookups)
      end
      self.current_row += 1
    end
  end

  def write_indicator_row(elem, indicator_lookups)
    display_text = value_display_text(elem, indicator_lookups)
    worksheet.write(current_row, 0, display_text, formats[:bold_black])
    worksheet.write(current_row, 1, elem['total'])
  end

  def write_indicator_last_row(elem, indicator_lookups)
    display_text = value_display_text(elem, indicator_lookups)
    worksheet.write(current_row, 0, display_text, formats[:bold_black_blue_bottom_border])
    worksheet.write(current_row, 1, elem['total'], formats[:blue_bottom_border])
  end

  def value_display_text(elem, indicator_lookups)
    if indicator_lookups.blank?
      return I18n.t("managed_reports.#{managed_report.id}.sub_reports.#{elem['id']}", default: elem['id'])
    end

    display_text_from_lookup(elem, indicator_lookups) || elem['id']
  end

  def display_text_from_lookup(elem, indicator_lookups)
    if indicator_lookups.is_a?(LocationService)
      return indicator_lookups.find_by_code(elem['id'])&.name_i18n&.dig(I18n.locale.to_s)
    end

    indicator_lookups.find { |lookup_value| lookup_value['id'] == elem['id'] }&.dig('display_text')
  end

  def transform_indicator_values(values)
    return values.map(&:with_indifferent_access) if values.is_a?(Array)
    return values unless values.is_a?(Hash)

    values.reduce([]) do |acc, (key, value)|
      acc << { id: key, total: value }.with_indifferent_access
    end
  end

  def load_lookups
    subreport_lookups = managed_report.data.with_indifferent_access.dig(id, 'lookups')
    self.lookups = subreport_lookups.reduce({}) do |acc, (key, value)|
      next acc.merge(key => LocationService.instance) if key == 'reporting_location'

      acc.merge(key => Lookup.values(value, nil, { locale: locale }))
    end
  end

  def date_display_text
    date_field_name = managed_report.date_field_name

    return unless date_field_name.present?

    I18n.t("managed_reports.#{managed_report.id}.filter_options.#{date_field_name}", locale: locale)
  end

  def date_range_display_text
    date_range_value = managed_report.date_range_value

    return I18n.t('managed_reports.date_range_options.custom', locale: locale) unless date_range_value.present?

    I18n.t("managed_reports.date_range_options.#{date_range_value}", locale: locale)
  end

  def verification_display_text
    verified_value = managed_report.verified_value

    return unless verified_value.present? && verified_value == 'verified'

    I18n.t('managed_reports.violations.filter_options.verified', locale: locale)
  end
end
