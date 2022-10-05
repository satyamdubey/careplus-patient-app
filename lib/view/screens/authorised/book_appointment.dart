import 'package:careplus_patient/constant/app_localization.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/appointment_controller.dart';
import 'package:careplus_patient/controller/family_member_controller.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:careplus_patient/view/screens/authorised/member_detail.dart';
import 'package:careplus_patient/view/screens/authorised/select_payment_mode.dart';
import 'package:careplus_patient/view/widgets/custom_app_bar.dart';
import 'package:careplus_patient/view/widgets/custom_check_box.dart';
import 'package:careplus_patient/view/widgets/custom_icon.dart';
import 'package:careplus_patient/view/widgets/custom_text_field.dart';
import 'package:careplus_patient/view/widgets/navigate_buttons.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';


class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _familyMemberController = Get.find<FamilyMemberController>();
  final _appointmentController = Get.find<AppointmentController>();

  final _nameController = TextEditingController(text: '${StorageHelper.getUserName()}');
  final _ageController = TextEditingController(text: '${StorageHelper.getUserAge()}');
  final _phoneController = TextEditingController(text: '${StorageHelper.getUserPhone()}');
  int _selectedMember = -1;

  @override
  void initState() {
    _familyMemberController.getFamilyMembers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0), child: StatusBar()
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              context: context,
              title: AppLocalization.patientDetails,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: HORIZONTAL_PADDING_LARGE,
                vertical: VERTICAL_PADDING_EXTRA_SMALL,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                 _patientDetail(),
                  const SizedBox(height: 20),
                  Text('Family Members', style: nunitoBold),
                 _patientFamilyMembers(),
                  SizedBox(height: VERTICAL_MARGIN_DEFAULT),
                 _actionButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _patientDetail() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            SizedBox(height: VERTICAL_MARGIN_DEFAULT),
            CustomTextField(
              enabled: false,
              controller: _nameController,
              labelText: AppLocalization.name,
              iconData: Icons.person,
            ),
            SizedBox(height: VERTICAL_MARGIN_DEFAULT),
            CustomTextField(
              enabled: false,
              controller: _ageController,
              labelText: AppLocalization.age,
              iconData: Icons.calendar_month_rounded,
            ),
            SizedBox(height: VERTICAL_MARGIN_DEFAULT),
            CustomTextField(
              enabled: false,
              controller: _phoneController,
              labelText: AppLocalization.phone,
              iconData: Icons.phone,
            ),
            SizedBox(height: VERTICAL_MARGIN_DEFAULT),
            Row(
              children: [
                const CustomIcon(iconData: Icons.group),
                SizedBox(width: HORIZONTAL_MARGIN_EXTRA_LARGE),
                Text(
                  AppLocalization.gender, style: nunitoBold.copyWith(
                  color: Colors.grey,
                  fontSize: FONT_SIZE_DEFAULT,
                  ),
                ),
                SizedBox(width: HORIZONTAL_MARGIN_EXTRA_LARGE),
                CustomCheckBox(
                  check: StorageHelper.getUserGender()=="male",
                  text: AppLocalization.male,
                ),
                const Spacer(),
                CustomCheckBox(
                  check: StorageHelper.getUserGender()=="female",
                  text: AppLocalization.female,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _patientFamilyMembers() {
    return GetBuilder<FamilyMemberController>(builder: (_) {
      return !_familyMemberController.familyMembersLoaded
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              height: SizeConfig.blockSizeVertical * 40,
              child: ListView.separated(
                itemCount: _familyMemberController.familyMembers.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  vertical: VERTICAL_PADDING_EXTRA_SMALL,
                ),
                separatorBuilder: (_, __) => 
                  SizedBox(height: VERTICAL_MARGIN_EXTRA_SMALL),
                itemBuilder: (context, index) {
                  return Container(
                    height: SizeConfig.blockSizeVertical * 7,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(RADIUS_SMALL),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: HORIZONTAL_MARGIN_DEFAULT),
                        Container(
                          padding: EdgeInsets.all(RADIUS_EXTRA_SMALL),
                          decoration: const BoxDecoration(
                            color: WHITE_COLOR,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: GRADIENT_COLOR,
                          ),
                        ),
                        SizedBox(width: HORIZONTAL_MARGIN_DEFAULT),
                        Text(
                          _familyMemberController.familyMembers[index].name,
                          style: robotoRegular.copyWith(
                            color: Colors.black54,
                            fontSize: FONT_SIZE_LARGE,
                          ),
                        ),
                        const Spacer(),
                        Checkbox(
                          value: _selectedMember == index,
                          onChanged: (bool? value) {
                            _selectedMember == index ? _selectedMember = -1 : _selectedMember = index;
                            setState(() {});
                          }),
                        index==0?const SizedBox():SizedBox(width: HORIZONTAL_MARGIN_DEFAULT),
                        index!=0?IconButton(
                          icon: Icon(
                            Icons.delete, color: Colors.red, size: ICON_SIZE_DEFAULT),
                          onPressed: () async {
                            EasyLoading.show(status: 'Removing member');
                            await _familyMemberController.removeFamilyMember(
                              _familyMemberController.familyMembers[index],
                            ).then((value) {
                              EasyLoading.dismiss();
                              if (value) {
                                EasyLoading.showToast('Member removed');
                              } else {
                                EasyLoading.showToast(
                                  'Some error occurred removing member'
                                );
                              }
                            });
                          },
                        ):const SizedBox()
                      ],
                    ),
                  );
                },
              ),
            );
    });
  }

  Widget _actionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ActionRowButtons(
          button1Name: "Add Family Member",
          button2Name: "Continue",
          button1Style: ActionRowButtonStyle.secondary,
          button2Style: ActionRowButtonStyle.secondary,
          onTapButton1: () async {
            await Get.to(() => const MemberDetailScreen());
            await _familyMemberController.getFamilyMembers();
          },
          onTapButton2: () async{
            if(_selectedMember!=-1){
              EasyLoading.show(status: 'Processing...');
              bool response = await _appointmentController.checkDiscount();
              EasyLoading.dismiss();
              if(response){
                Get.to(()=>SelectPaymentModeScreen(selectedMember: _selectedMember, free: true));
              }else{
                Get.to(()=>SelectPaymentModeScreen(selectedMember: _selectedMember));
              }
            }else{
              EasyLoading.showToast('Please select patient');
            }
          },
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
