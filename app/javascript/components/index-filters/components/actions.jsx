import PropTypes from "prop-types";

import { useI18n } from "../../i18n";
import DisableOffline from "../../disable-offline";
import ActionButton from "../../action-button";
import { ACTION_BUTTON_TYPES } from "../../action-button/constants";

import css from "./styles.css";

const Actions = ({ handleSave, handleClear }) => {
  const i18n = useI18n();

  const showSave = handleSave && (
    <DisableOffline button>
      <ActionButton
        text={i18n.t("filters.save_filters")}
        type={ACTION_BUTTON_TYPES.default}
        variant="outlined"
        fullWidth
        rest={{
          onClick: handleSave
        }}
      />
    </DisableOffline>
  );

  return (
    <div className={css.actionButtons}>
      <DisableOffline button>
        <ActionButton
          text={i18n.t("filters.apply_filters")}
          type={ACTION_BUTTON_TYPES.default}
          fullWidth
          rest={{ type: "submit" }}
        />
      </DisableOffline>
      {showSave}
      <DisableOffline button>
        <ActionButton
          text={i18n.t("filters.clear_filters")}
          type={ACTION_BUTTON_TYPES.default}
          variant="outlined"
          fullWidth
          rest={{
            onClick: handleClear
          }}
        />
      </DisableOffline>
    </div>
  );
};

Actions.propTypes = {
  handleClear: PropTypes.func.isRequired,
  handleSave: PropTypes.func
};

Actions.displayName = "Actions";

export default Actions;
