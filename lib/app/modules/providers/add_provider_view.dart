import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'providers_controller.dart';

class AddProviderView extends StatelessWidget {
  final controller = Get.find<ProvidersController>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  AddProviderView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.selectedImage.value = null; // রিসেট

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add New Provider", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ইমেজ পিকার
            Center(
              child: Stack(
                children: [
                  Obx(() => Container(
                    height: 110, width: 110,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 2),
                      image: controller.selectedImage.value != null
                          ? DecorationImage(image: FileImage(controller.selectedImage.value!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: controller.selectedImage.value == null
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  )),
                  Positioned(
                    bottom: 0, right: 0,
                    child: InkWell(
                      onTap: controller.pickImage,
                      child: const CircleAvatar(
                        radius: 18, backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            _buildTextField(nameCtrl, "Full Name", Icons.person),
            const SizedBox(height: 15),
            _buildTextField(phoneCtrl, "Phone", Icons.phone, type: TextInputType.phone),
            const SizedBox(height: 15),
            _buildTextField(emailCtrl, "Email", Icons.email, type: TextInputType.emailAddress),
            const SizedBox(height: 15),
            _buildTextField(passCtrl, "Password", Icons.lock, isPass: true),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.saveProvider(
                    name: nameCtrl.text, email: emailCtrl.text,
                    phone: phoneCtrl.text, password: passCtrl.text),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Create Provider", style: TextStyle(fontWeight: FontWeight.bold)),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, {bool isPass = false, TextInputType type = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      obscureText: isPass,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true, fillColor: Colors.grey[50],
      ),
    );
  }
}