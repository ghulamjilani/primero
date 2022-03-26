import { useEffect, useState } from "react";
import PropTypes from "prop-types";
import { useLocation, useParams } from "react-router-dom";
import { Hidden, IconButton, useMediaQuery } from "@material-ui/core";
import { MenuOpen } from "@material-ui/icons";

import { useI18n } from "../i18n";
import PageContainer, { PageContent, PageHeading } from "../page";
import { ROUTES } from "../../config";
import { useMemoizedSelector } from "../../libs";
import PageNavigation from "../page-navigation";
import ApplicationRoutes from "../application-routes";
import { getInsight } from "../insights-sub-report/selectors";
import ActionButton from "../action-button";
import { useDialog } from "../action-dialog";

import { INSIGHTS_CONFIG, NAME, INSIGHTS_EXPORTER_DIALOG } from "./constants";
import css from "./styles.css";
import InsightsExporter from "./components/insights-exporter";

const Component = ({ routes }) => {
  const { id } = useParams();
  const i18n = useI18n();
  const { pathname } = useLocation();
  const { moduleID } = useParams();
  const mobileDisplay = useMediaQuery(theme => theme.breakpoints.down("sm"));
  const { setDialog, pending, dialogOpen, setDialogPending, dialogClose } = useDialog(INSIGHTS_EXPORTER_DIALOG);

  const [toggleNav, setToggleNav] = useState(false);

  const handleToggleNav = () => setToggleNav(!toggleNav);

  useEffect(() => {
    setToggleNav(false);
  }, [pathname]);

  const insightType = INSIGHTS_CONFIG[moduleID];

  const insight = useMemoizedSelector(state => getInsight(state));

  const name = i18n.t(insight.get("name"));

  const menuList = insightType?.ids?.concat(["detention"]).map(subReportID => ({
    to: [ROUTES.insights, moduleID, id, subReportID].join("/"),
    text: i18n.t([...insightType.localeKeys, subReportID].join("."))
  }));

  const subReportTitle = menuList.find(item => item.to === pathname)?.text;

  const handleExport = () => {
    setDialog({ dialog: INSIGHTS_EXPORTER_DIALOG, open: true });
  };

  return (
    <PageContainer twoCol>
      <PageHeading title={name}>
        <ActionButton onClick={handleExport} text="buttons.export" />
        <InsightsExporter
          i18n={i18n}
          open={dialogOpen}
          pending={pending}
          close={dialogClose}
          setPending={setDialogPending}
        />
      </PageHeading>
      <PageContent hasNav>
        <Hidden smDown implementation="css">
          <div>
            <PageNavigation
              menuList={menuList}
              selected={pathname}
              mobileDisplay={mobileDisplay}
              handleToggleNav={handleToggleNav}
              toggleNav={toggleNav}
            />
          </div>
        </Hidden>
        <div>
          <div className={css.title}>
            <Hidden mdUp implementation="css">
              <div>
                <IconButton onClick={handleToggleNav}>
                  <MenuOpen />
                </IconButton>
              </div>
            </Hidden>
            <h2>{subReportTitle}</h2>
          </div>
          <ApplicationRoutes routes={routes} />
        </div>
      </PageContent>
    </PageContainer>
  );
};

Component.displayName = NAME;

Component.propTypes = {
  routes: PropTypes.arrayOf(PropTypes.object).isRequired
};

export default Component;
