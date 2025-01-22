import 'package:example/screens/admin/controllers/add_user_controller.dart';
import 'package:example/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../constant/custom_size.dart';
import '../../utils/dropdown.dart';

class AddUser extends StatelessWidget {
  const AddUser({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddUserController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Seluruh User'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
                onPressed: () {
                  Get.to(() => CreateUser());
                },
                child: Text('Tambah User')),
          )
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.userList.isEmpty) {
            return const Center(
              child: Text('Tidak ada data pengguna'),
            );
          }

          return ListView.builder(
            itemCount: controller.userList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final user = controller.userList[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.image),
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
              );
            },
          );
        }),
      ),
    );
  }
}

class CreateUser extends StatelessWidget {
  const CreateUser({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddUserController>();
    return Scaffold(
      body: Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                CustomSize.md, CustomSize.md, CustomSize.md, 0),
            children: [
              Obx(() => Center(
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: 150,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: CustomSize.md),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      OutlinedButton(
                                          onPressed: () => controller
                                              .pickImage(ImageSource.camera),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Iconsax.camera,
                                                color: AppColors.primary,
                                              ),
                                              const SizedBox(
                                                  width: CustomSize.xs),
                                              Text('Camera'),
                                            ],
                                          )),
                                      const SizedBox(height: CustomSize.md),
                                      ElevatedButton(
                                          onPressed: () => controller
                                              .pickImage(ImageSource.gallery),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Iconsax.image,
                                                color:
                                                    AppColors.primaryBackground,
                                              ),
                                              const SizedBox(
                                                  width: CustomSize.sm),
                                              Text('Gallery'),
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: controller.image.value != null
                                    ? FileImage(controller.image.value!)
                                    : const AssetImage(
                                            'assets/images/ajj_logo.png')
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(width: 4, color: Colors.black),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              shape: BoxShape.circle,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Colors.green,
                              ),
                              child:
                                  const Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: CustomSize.spaceBtwInputFields),
              TextFormField(
                controller: controller.nameC,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    label: Text(
                  'Nama',
                  style: Theme.of(context).textTheme.labelMedium,
                )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: CustomSize.spaceBtwInputFields),
              TextFormField(
                controller: controller.emailC,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    label: Text(
                  'Masukan Email',
                  style: Theme.of(context).textTheme.labelMedium,
                )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: CustomSize.spaceBtwInputFields),
              Obx(
                () => TextFormField(
                  controller: controller.passwordC,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.obscureText.value =
                            !(controller.obscureText.value);
                      },
                      icon: Icon(
                        (controller.obscureText.value != false)
                            ? Icons.lock
                            : Icons.lock_open,
                      ),
                    ),
                  ),
                  obscureText: controller.obscureText.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: CustomSize.spaceBtwInputFields),
              Text('Tipe User', style: Theme.of(context).textTheme.labelMedium),
              Obx(
                () => DropDownWidget(
                  value: controller.tipe.value,
                  items: const [
                    'driver',
                    'manajer',
                    'admin',
                  ],
                  onChanged: (String? value) {
                    controller.tipe.value = value!;
                    print('Tipe yang dipilih: ${controller.tipe.value}');
                    print(
                        'Nilai numerik yang dikirim: ${controller.tipeValue}');
                  },
                ),
              ),
              const SizedBox(height: CustomSize.spaceBtwInputFields),
              TextFormField(
                controller: controller.telpC,
                decoration: InputDecoration(
                  label: Text(
                    'No Telp',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No Telp is required';
                  }

                  return null;
                },
              ),
              const SizedBox(height: CustomSize.spaceBtwSections),
              ElevatedButton(
                  onPressed: () => controller.createNewUser(),
                  child: Text(
                    'Create New User',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.apply(color: Colors.white),
                  ))
            ],
          )),
    );
  }
}
