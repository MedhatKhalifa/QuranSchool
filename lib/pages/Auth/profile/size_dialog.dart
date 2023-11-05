import 'package:quranschool/core/size_config.dart';
import 'package:quranschool/pages/Auth/controller/currentUser_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SizeDialog extends StatefulWidget {
  const SizeDialog({Key? key}) : super(key: key);

  @override
  State<SizeDialog> createState() => _SizeDialogState();
}

class _SizeDialogState extends State<SizeDialog> {
  final CurrentUserController currentUserController =
      Get.put(CurrentUserController());
  String _size = "";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty || int.parse(value) < 20) {
                return 'less_size_100'.tr;
              }
              return null;
            },
            initialValue: currentUserController.currentUser.value.id.toString(),
            onChanged: ((value) {
              setState(() {
                _size = value;
              });
            }),
            keyboardType: TextInputType.number,
            maxLines: 1,
            decoration: InputDecoration(
                labelText: 'enter_size'.tr,
                hintMaxLines: 1,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 4.0))),
          ),
          SizedBox(
            height: h(2),
          ),
          ElevatedButton(
            onPressed: () {
              final form = _formKey.currentState;
              if (form!.validate()) {
                form.save();

                if (_size != "") {
                  currentUserController.currentUser.value.id = int.parse(_size);

                  currentUserController
                      .updateUserData(currentUserController.currentUser.value);
                  Navigator.of(context).pop();
                  // Get.to(() => const UserProfilePage());

                  setState(() {
                    currentUserController.currentUser.value.id =
                        int.parse(_size);
                  });

                  //Get.back();
                }
              }
            },
            child: Text('update_size'.tr),
          )
        ],
      ),
    );
  }
}
