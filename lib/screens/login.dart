import 'package:example/constant/custom_size.dart';
import 'package:example/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
        children: [
          const Text("PT. Andestan Jadi Jaya",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          Form(
              key: controller.loginFromKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email Tidak Boleh Kosong';
                        }

                        final emailRegExp =
                            RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

                        if (!emailRegExp.hasMatch(value)) {
                          return 'Alamat email tidak valid';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.direct),
                        labelText: 'E-Mail',
                      ),
                    ),
                    const SizedBox(height: CustomSize.spaceBtwItems),
                    Obx(
                      () => TextFormField(
                        controller: controller.passwordController,
                        obscureText: controller.hidePassword.value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kata Sandi Tidak Boleh Kosong';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.password_check),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                              onPressed: () => controller.hidePassword.value =
                                  !controller.hidePassword.value,
                              icon: Icon(controller.hidePassword.value
                                  ? Iconsax.eye_slash
                                  : Iconsax.eye)),
                        ),
                      ),
                    ),
                    const SizedBox(height: CustomSize.sm),
                    // Ingat Saya & forgot pw
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Ingat Saya
                        Row(
                          children: [
                            Obx(
                              () => SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: controller.rememberMe.value,
                                  onChanged: (value) => controller.rememberMe
                                      .value = !controller.rememberMe.value,
                                ),
                              ),
                            ),
                            Text(
                              'Ingat Saya',
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: CustomSize.spaceBtwSections),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: controller.emailAndPasswordSignIn,
                          style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.blueAccent)),
                          child: const Text(
                            'Masuk',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              )),
        ],
      )),
    );
  }
}
