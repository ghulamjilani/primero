import React from "react";
import PropTypes from "prop-types";
import clsx from "clsx";
import { Draggable } from "react-beautiful-dnd";
import { Controller, useWatch } from "react-hook-form";
import { makeStyles, Radio } from "@material-ui/core";
import get from "lodash/get";
import DeleteIcon from "@material-ui/icons/Delete";
import IconButton from "@material-ui/core/IconButton";

import TextInput from "../../fields/text-input";
import SwitchInput from "../../fields/switch-input";
import styles from "../../fields/styles.css";
import DragIndicator from "../../../pages/admin/forms-list/components/drag-indicator";
import { generateIdFromDisplayText, generateIdForNewOption } from "../../utils/handle-options";

import { NAME } from "./constants";

const Component = ({ defaultOptionId, index, name, option, onRemoveClick, formMethods, formMode }) => {
  const css = makeStyles(styles)();
  const {
    errors,
    setValue,
    formState: { isDirty },
    control
  } = formMethods;
  const displayTextFieldName = `${name}.option_strings_text[${index}].display_text.en`;
  const idFieldName = `${name}.option_strings_text[${index}].id`;
  const selectedValueFieldName = `${name}.selected_value`;

  const optionId = useWatch({ control, name: `${name}.option_strings_text[${index}].id`, defaultValue: option.id });
  const selectedValue = useWatch({ control, name: `${name}.selected_value`, defaultValue: defaultOptionId });

  const error = errors ? get(errors, displayTextFieldName) : undefined;

  const classes = makeStyles({
    disabled: {
      "&&&:before": {
        borderBottomStyle: "solid"
      },
      "&&:after": {
        borderBottomStyle: "solid"
      }
    }
  })();

  const handleChange = event => {
    const { value } = event.currentTarget;
    const newOptionId = generateIdFromDisplayText(value);

    if (isDirty && value && option.isNew) {
      setValue(idFieldName, newOptionId, { shouldDirty: true });

      if (selectedValue === optionId) {
        setValue(selectedValueFieldName, newOptionId, { shouldDirty: true });
      }
    }

    return value;
  };

  const renderCheckbox = formMode.get("isEdit") && (
    <SwitchInput
      commonInputProps={{ name: `${name}.option_strings_text[${index}].disabled` }}
      formMethods={formMethods}
    />
  );

  const renderRemoveButton = formMode.get("isNew") && (
    <IconButton aria-label="delete" className={css.removeIcon} onClick={() => onRemoveClick(index)}>
      <DeleteIcon />
    </IconButton>
  );

  return (
    <Draggable draggableId={option.fieldID} index={index}>
      {provided => (
        <div ref={provided.innerRef} {...provided.draggableProps}>
          <div className={css.fieldRow}>
            <div className={clsx([css.fieldColumn, css.dragIndicatorColumn])}>
              <DragIndicator {...provided.dragHandleProps} />
            </div>
            <div className={clsx([css.fieldColumn, css.fieldInput])}>
              <TextInput
                formMethods={formMethods}
                commonInputProps={{
                  name: displayTextFieldName,
                  className: css.inputOptionField,
                  error: typeof error !== "undefined",
                  helperText: error?.message,
                  InputProps: {
                    classes,
                    onBlur: event => handleChange(event, index)
                  }
                }}
              />
              <input
                className={css.displayNone}
                type="text"
                name={idFieldName}
                ref={formMethods.register}
                defaultValue={option.id}
              />
            </div>
            <div className={css.fieldColumn}>
              <Controller
                control={control}
                as={<Radio />}
                inputProps={{ value: optionId }}
                checked={optionId === selectedValue}
                name={`${name}.selected_value`}
                defaultValue={false}
              />
            </div>
            <div className={css.fieldColumn}>
              {renderCheckbox}
              {renderRemoveButton}
            </div>
          </div>
        </div>
      )}
    </Draggable>
  );
};

Component.defaultProps = {
  disabled: false
};

Component.propTypes = {
  defaultOptionId: PropTypes.string,
  disabled: PropTypes.bool,
  formMethods: PropTypes.object.isRequired,
  formMode: PropTypes.object.isRequired,
  index: PropTypes.number,
  name: PropTypes.string.isRequired,
  onRemoveClick: PropTypes.func,
  option: PropTypes.object
};

Component.displayName = NAME;

export default Component;
