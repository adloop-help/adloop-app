import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController companyController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  List<TextEditingController> websiteControllers = [
    TextEditingController()
  ];

  String selectedCategory = "Select category";
  bool isChecked = false;

  final List<String> categories = [
    "Coupons & Promo Codes",
    "Clothing, Shoes & Jewellery",
    "Healthcare & Beauty",
    "Sports & Outdoors",
    "Electronics & Software",
    "Toys & Games",
    "Books & Ebooks",
    "Home & Kitchen",
    "Grocery & Gourmet Food",
    "Finance & Marketing",
    "Real Estate & Property",
    "Education & Training",
    "Professional Services",
    "Pet Supplies",
    "Patio, Lawn & Garden",
    "Arts, Crafts & Sewing",
    "Automotive Parts",
    "Musical Instruments",
    "Luggage & Travel Gear",
    "Tools & Furniture",
    "Logistics & Transportation",
    "Office Products",
    "Agricultural Products",
    "Construction Parts",
  ];

  /// 🔥 LIMIT TO 5 WEBSITES
  void addWebsiteField() {
    if (websiteControllers.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Maximum 5 websites allowed")),
      );
      return;
    }

    setState(() {
      websiteControllers.add(TextEditingController());
    });
  }

  /// 🔥 EMAIL + FIREBASE
  Future<void> sendEmailAndSave() async {

    String websites = websiteControllers
        .map((c) {
          String url = c.text.trim();
          if (!url.startsWith("http")) {
            url = "https://$url";
          }
          return url;
        })
        .where((w) => w.isNotEmpty)
        .join(", ");

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': 'service_ic5ymta',
        'template_id': 'template_rhdjtmh',
        'user_id': 'OB9_8S3mHXeEGmOwk',
        'template_params': {
          'company': companyController.text,
          'country': countryController.text,
          'category': selectedCategory,
          'website': websites,
          'description': descController.text,
        }
      }),
    );

    await FirebaseFirestore.instance.collection("registrations").add({
      "company": companyController.text,
      "country": countryController.text,
      "category": selectedCategory,
      "websites": websites,
      "description": descController.text,
      "created_at": Timestamp.now(),
    });
  }

  bool isValidUrl(String url) {
    final pattern = RegExp(
      r'^(https?:\/\/)?(www\.)?[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}.*$',
    );
    return pattern.hasMatch(url);
  }

  void showTerms() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Terms & Conditions"),
        content: const SingleChildScrollView(
          child: Text(
            "• All submissions will be reviewed before publishing.\n\n"
            "• AdLoop reserves the right to reject or modify listings.\n\n"
            "• No illegal, adult, or harmful content allowed.\n\n"
            "• Submitted data must be accurate.\n\n"
            "• By submitting, you agree to be contacted if needed.",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Form(
            key: _formKey,

            child: Column(
              children: [

                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10)
                    ],
                  ),

                  child: Column(
                    children: [

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          gradient: LinearGradient(
                            colors: [Color(0xFF00C853), Color(0xFF2E7D32)],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "AdLoop",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Register",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),

                        child: Column(
                          children: [

                            buildField("Company Name *", companyController),
                            buildField("Country *", countryController),

                            ...websiteControllers.map((controller) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: TextFormField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    hintText: "Website URL *",
                                    filled: true,
                                    fillColor: const Color(0xFFE8F5E9),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Color(0xFFB2DFDB)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Color(0xFF00C853), width: 2),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return "Required";
                                    if (!isValidUrl(value)) return "Invalid URL";
                                    return null;
                                  },
                                ),
                              );
                            }),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: addWebsiteField,
                                child: const Text("+ Add another website"),
                              ),
                            ),

                            DropdownButtonFormField<String>(
                              hint: const Text("Select Category *"),
                              items: categories.map((c) {
                                return DropdownMenuItem(value: c, child: Text(c));
                              }).toList(),
                              onChanged: (value) {
                                selectedCategory = value!;
                              },
                              validator: (value) {
                                if (value == null) return "Select category";
                                return null;
                              },
                            ),

                            const SizedBox(height: 10),

                            TextFormField(
                              controller: descController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: "Description *",
                                filled: true,
                                fillColor: const Color(0xFFE8F5E9),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFB2DFDB)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFF00C853), width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return "Required";
                                return null;
                              },
                            ),

                            Row(
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (v) {
                                    setState(() => isChecked = v!);
                                  },
                                ),
                                GestureDetector(
                                  onTap: showTerms,
                                  child: const Text(
                                    "I accept the Terms & Conditions",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            GestureDetector(
                              onTap: () async {

                                if (!_formKey.currentState!.validate()) return;

                                if (!isChecked) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Accept Terms")),
                                  );
                                  return;
                                }

                                await sendEmailAndSave();

                                Navigator.pushReplacementNamed(context, "/thankyou");
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF00C853), Color(0xFF2E7D32)],
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFE8F5E9),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFB2DFDB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF00C853), width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return "Required";
          return null;
        },
      ),
    );
  }
}
