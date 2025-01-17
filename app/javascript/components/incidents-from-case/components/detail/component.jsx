import PropTypes from "prop-types";
import { Grid } from "@material-ui/core";
import VisibilityIcon from "@material-ui/icons/Visibility";
import CreateIcon from "@material-ui/icons/Create";

import { READ_RECORDS, RESOURCES, WRITE_RECORDS } from "../../../../libs/permissions";
import { usePermissions } from "../../../user";
import { useI18n } from "../../../i18n";
import { NAME_DETAIL } from "../../constants";
import DisplayData from "../../../display-data";
import ActionButton from "../../../action-button";
import { ACTION_BUTTON_TYPES } from "../../../action-button/constants";

import { EDIT, VIEW } from "./constants";

const Component = ({
  css,
  incidentDateInterview,
  incidentDate,
  incidentUniqueID,
  incidentType,
  handleCreateIncident,
  incidentAvailable,
  dirty = false
}) => {
  const i18n = useI18n();
  const canViewIncidents = usePermissions(RESOURCES.incidents, READ_RECORDS);
  const canEditIncidents = usePermissions(RESOURCES.incidents, WRITE_RECORDS);

  const incidentInterviewLabel = "incidents.date_of_interview";
  const incidentDateLabel = "incidents.date_of_incident";
  const incidentTypeLabel = "incidents.type_violence";

  const handleEvent = modeEvent => {
    handleCreateIncident(`/${RESOURCES.incidents}/${incidentUniqueID}${modeEvent === VIEW ? "" : `/${EDIT}`}`, dirty);
  };

  const handleClickViewIncident = () => handleEvent(VIEW);
  const handleClickEditIncident = () => handleEvent(EDIT);
  const tooltip = !incidentAvailable && i18n.t("unavailable_offline");

  const viewIncidentBtn = canViewIncidents && (
    <ActionButton
      icon={<VisibilityIcon />}
      text={`buttons.${VIEW}`}
      type={ACTION_BUTTON_TYPES.default}
      outlined
      tooltip={tooltip}
      rest={{
        disabled: !incidentAvailable,
        onClick: handleClickViewIncident,
        fullWidth: true
      }}
    />
  );
  const editIncidentBtn = canEditIncidents && (
    <ActionButton
      icon={<CreateIcon />}
      text={`buttons.${EDIT}`}
      type={ACTION_BUTTON_TYPES.default}
      outlined
      tooltip={tooltip}
      rest={{
        disabled: !incidentAvailable,
        onClick: handleClickEditIncident,
        fullWidth: true
      }}
    />
  );

  return (
    <>
      <Grid container spacing={2}>
        <Grid item container md={10} xs={12}>
          <Grid item md={6} xs={12}>
            <DisplayData label={incidentInterviewLabel} value={incidentDateInterview} />
          </Grid>
          <Grid item md={6} xs={12}>
            <DisplayData label={incidentDateLabel} value={incidentDate} />
          </Grid>
          <Grid item md={6} xs={12}>
            <DisplayData label={incidentTypeLabel} value={incidentType} />
          </Grid>
        </Grid>
        <Grid item md={2} xs={12}>
          <div className={css.buttonsActions}>
            {viewIncidentBtn}
            {editIncidentBtn}
          </div>
        </Grid>
      </Grid>
    </>
  );
};

Component.displayName = NAME_DETAIL;

Component.propTypes = {
  css: PropTypes.object.isRequired,
  dirty: PropTypes.bool,
  handleCreateIncident: PropTypes.func,
  incidentAvailable: PropTypes.bool,
  incidentDate: PropTypes.string,
  incidentDateInterview: PropTypes.string,
  incidentType: PropTypes.node,
  incidentUniqueID: PropTypes.string
};
export default Component;
