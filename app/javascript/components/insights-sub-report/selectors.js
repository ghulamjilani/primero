/* eslint-disable import/prefer-default-export */

import { fromJS } from "immutable";

import NAMESPACE from "./namespace";

export const getInsight = state => {
  return state.getIn(["records", NAMESPACE, "selectedReport"], fromJS({}));
};
