import PropTypes from "prop-types";
import { Drawer } from "@material-ui/core";
import CloseIcon from "@material-ui/icons/Close";

import { useI18n } from "../../../../i18n";
import ActionButton from "../../../../action-button";
import { ACTION_BUTTON_TYPES } from "../../../../action-button/constants";

import { NAME } from "./constants";
import css from "./styles.css";

const Component = ({ open, cancelHandler, children, title }) => {
  const i18n = useI18n();

  return (
    <Drawer anchor="right" open={open} onClose={cancelHandler} classes={{ paper: css.subformDrawer }}>
      <div className={css.subformDrawerContent}>
        <div className={css.title}>
          <h1>{title}</h1>
          <div>
            <ActionButton
              icon={<CloseIcon />}
              text={i18n.t("cancel")}
              type={ACTION_BUTTON_TYPES.icon}
              isTransparent
              rest={{
                className: css.closeButton,
                onClick: cancelHandler
              }}
            />
          </div>
        </div>
        {children}
      </div>
    </Drawer>
  );
};

Component.propTypes = {
  cancelHandler: PropTypes.func,
  children: PropTypes.node.isRequired,
  open: PropTypes.bool,
  title: PropTypes.string
};

Component.displayName = NAME;

export default Component;
