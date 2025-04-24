import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final _personalInfoFormKey = GlobalKey<FormState>();
  final _shippingFormKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  final ImagePicker _picker = ImagePicker();
  bool _isEditing = false;
  late TabController _tabController;
  int _currentTabIndex = 0;

  // Mock payment data
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'type': 'UPI',
      'last4': '1111',
      'expiry': '12/25',
      'isDefault': true,
    },
    {
      'type': 'Rupay',
      'last4': '8888',
      'expiry': '06/25',
      'isDefault': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });

    final profile = Provider.of<UserProfile>(context, listen: false);
    if (profile.name.isEmpty) {
      profile.updateProfile(
        name: 'Ayush Deshmukh',
        email: 'ayushdeshmukh775@gmail.com',
        phone: '+91 8857092421',
        address: 'Trimurti Chowk, Dhankawadi, Pune',
        city: 'Pune',
        state: 'Maharashtra',
        zipCode: '411043',
      );
    }
    profile.initializeDefaultImage();

    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
    _addressController = TextEditingController(text: profile.address);
    _cityController = TextEditingController(text: profile.city);
    _stateController = TextEditingController(text: profile.state);
    _zipCodeController = TextEditingController(text: profile.zipCode);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        Provider.of<UserProfile>(context, listen: false).updateProfile(
          profileImagePath: image.path,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    if (_currentTabIndex == 0) {
      if (_personalInfoFormKey.currentState!.validate()) {
        Provider.of<UserProfile>(context, listen: false).updateProfile(
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
        );
        setState(() {
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Personal information updated successfully')),
        );
      }
    } else if (_currentTabIndex == 1) {
      if (_shippingFormKey.currentState!.validate()) {
        Provider.of<UserProfile>(context, listen: false).updateProfile(
          address: _addressController.text,
          city: _cityController.text,
          state: _stateController.text,
          zipCode: _zipCodeController.text,
        );
        setState(() {
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Shipping address updated successfully')),
        );
      }
    }
  }

  Widget _buildPersonalInfo(UserProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Name', profile.name),
        _buildInfoRow('Email', profile.email),
        _buildInfoRow('Phone', profile.phone),
      ],
    );
  }

  Widget _buildShippingAddress(UserProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Address', profile.address),
        _buildInfoRow('City', profile.city),
        _buildInfoRow('State', profile.state),
        _buildInfoRow('ZIP Code', profile.zipCode),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _paymentMethods.length,
      itemBuilder: (context, index) {
        final payment = _paymentMethods[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          payment['type'] == 'Visa'
                              ? Icons.credit_card
                              : Icons.payment,
                          color: payment['type'] == 'Visa'
                              ? Colors.blue
                              : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          payment['type'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (payment['isDefault'])
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '•••• •••• •••• ${payment['last4']}',
                  style: const TextStyle(
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Expires ${payment['expiry']}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderHistory() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Order History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'No orders yet',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (_currentTabIndex < 2)
            IconButton(
              icon: Icon(_isEditing ? Icons.close : Icons.edit),
              onPressed: _toggleEdit,
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Personal Info'),
            Tab(text: 'Shipping'),
            Tab(text: 'Payment'),
            Tab(text: 'Orders'),
          ],
        ),
      ),
      body: Consumer<UserProfile>(
        builder: (context, profile, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              // Personal Info Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _personalInfoFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: profile
                                      .profileImagePath.isNotEmpty
                                  ? FileImage(File(profile.profileImagePath))
                                  : null,
                              child: profile.profileImagePath.isEmpty
                                  ? const Icon(Icons.person, size: 50)
                                  : null,
                            ),
                            if (_isEditing)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: IconButton(
                                    icon: const Icon(Icons.camera_alt,
                                        color: Colors.white),
                                    onPressed: _pickImage,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_isEditing) ...[
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(labelText: 'Phone'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _saveProfile,
                          child: const Text('Save Personal Info'),
                        ),
                      ] else
                        _buildPersonalInfo(profile),
                    ],
                  ),
                ),
              ),
              // Shipping Address Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _shippingFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_isEditing) ...[
                        TextFormField(
                          controller: _addressController,
                          decoration:
                              const InputDecoration(labelText: 'Address'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(labelText: 'City'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your city';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _stateController,
                          decoration: const InputDecoration(labelText: 'State'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your state';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _zipCodeController,
                          decoration:
                              const InputDecoration(labelText: 'ZIP Code'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your ZIP code';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _saveProfile,
                          child: const Text('Save Shipping Address'),
                        ),
                      ] else
                        _buildShippingAddress(profile),
                    ],
                  ),
                ),
              ),
              // Payment Details Tab
              _buildPaymentDetails(),
              // Order History Tab
              _buildOrderHistory(),
            ],
          );
        },
      ),
    );
  }
}
