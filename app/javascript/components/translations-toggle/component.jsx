import Select from "@material-ui/core/Select";
import { withI18n } from "libs/i18n";
import PropTypes from "prop-types";
import React from "react";
import { withRouter } from "react-router-dom";
import { compose } from "redux";

const TranslationsToggle = ({ changeLocale, locale, i18n }) => {
  const handleChange = e => {
    changeLocale(e.target.value);
  };

  return (
    <Select native onChange={handleChange} value={locale}>
      <option value="" disabled>
        Locale
      </option>
      <option value="ar">{i18n.t("home.ar")}</option>
      <option value="en">{i18n.t("home.en")}</option>
    </Select>
  );
};

TranslationsToggle.propTypes = {
  changeLocale: PropTypes.func.isRequired,
  locale: PropTypes.string.isRequired,
  i18n: PropTypes.instanceOf(window.I18n).isRequired
};

export default compose(
  withRouter,
  withI18n
)(TranslationsToggle);
