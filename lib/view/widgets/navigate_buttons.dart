import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/widgets/disabledButton.dart';
import 'package:careplus_patient/view/widgets/primary_button.dart';
import 'package:careplus_patient/view/widgets/secondary_button.dart';
import 'package:flutter/material.dart';

enum ActionRowButtonStyle { primary, secondary, disabled }

class ActionRowButtons extends StatelessWidget {
  final String button1Name;
  final String button2Name;
  final ActionRowButtonStyle button1Style;
  final ActionRowButtonStyle button2Style;
  final VoidCallback onTapButton1;
  final VoidCallback onTapButton2;

  const ActionRowButtons({
    Key? key,
    this.button1Name = "Back",
    this.button2Name = "Next",
    this.button1Style = ActionRowButtonStyle.primary,
    this.button2Style = ActionRowButtonStyle.primary,
    required this.onTapButton1,
    required this.onTapButton2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: button1Style == ActionRowButtonStyle.primary,
          child: PrimaryButton(
            onTap: onTapButton1,
            height: SizeConfig.blockSizeVertical * 5,
            width: SizeConfig.blockSizeHorizontal * 40,
            radius: RADIUS_LARGE,
            text: button1Name,
          ),
        ),
        Visibility(
          visible: button1Style == ActionRowButtonStyle.secondary,
          child: SecondaryButton(
            onTap: onTapButton1,
            height: SizeConfig.blockSizeVertical * 5,
            width: SizeConfig.blockSizeHorizontal * 40,
            radius: RADIUS_LARGE,
            text: button1Name,
          ),
        ),
        Visibility(
          visible: button1Style == ActionRowButtonStyle.disabled,
          child: DisabledButton(
            height: SizeConfig.blockSizeVertical * 5,
            width: SizeConfig.blockSizeHorizontal * 40,
            radius: RADIUS_LARGE,
            text: button1Name,
          ),
        ),
        SizedBox(width: SizeConfig.blockSizeHorizontal*5),
        Visibility(
          visible: button2Style == ActionRowButtonStyle.primary,
          child: PrimaryButton(
            onTap: onTapButton2,
            height: SizeConfig.blockSizeVertical * 5,
            width: SizeConfig.blockSizeHorizontal * 40,
            radius: RADIUS_LARGE,
            text: button2Name,
          ),
        ),
        Visibility(
          visible: button2Style == ActionRowButtonStyle.secondary,
          child: SecondaryButton(
            onTap: onTapButton2,
            height: SizeConfig.blockSizeVertical * 5,
            width: SizeConfig.blockSizeHorizontal * 40,
            radius: RADIUS_LARGE,
            text: button2Name,
          ),
        ),
        Visibility(
          visible: button2Style == ActionRowButtonStyle.disabled,
          child: DisabledButton(
            height: SizeConfig.blockSizeVertical * 5,
            width: SizeConfig.blockSizeHorizontal * 40,
            radius: RADIUS_LARGE,
            text: button2Name,
          ),
        ),
      ],
    );
  }
}
