import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/CustomWidget/complaintCard.dart';
import 'package:untitled/CustomWidget/customText.dart';
import '../Bloc/ComplaintListBloc.dart';

class ComplaintListScreen extends StatelessWidget {
  const ComplaintListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ComplaintListBloc(),
      child: const ComplaintListScreenContent(),
    );
  }
}

class ComplaintListScreenContent extends StatefulWidget {
  const ComplaintListScreenContent({super.key});

  @override
  _ComplaintListScreenContentState createState() => _ComplaintListScreenContentState();
}

class _ComplaintListScreenContentState extends State<ComplaintListScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch() {
    context.read<ComplaintListBloc>().searchComplaints(_searchController.text);
    _searchFocusNode.unfocus(); // Hide the keyboard after search
  }

  @override
  Widget build(BuildContext context) {
    // Store the screen size
    final appSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(appSize),
              Expanded(child: _buildComplaintList()),
            ],
          ),
          _buildDialogOverlay(),
          _buildDialog(),
        ],
      ),
    );
  }

  Widget _buildHeader(Size appSize) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(70)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDE7A72).withOpacity(0.7), Color(0xFFDE7A72)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(appSize.width * 0.09),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: appSize.width * 0.08),
            _buildHeaderTitle(appSize),
            SizedBox(height: appSize.width * 0.02),
            _buildHeaderSubtitle(),
            SizedBox(height: appSize.width * 0.05),
            _buildSearchField(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTitle(Size appSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Create your\n',
                style: TextStyle(fontFamily: "Plus", color: Colors.white, fontSize: appSize.width * 0.07),
              ),
              TextSpan(
                text: 'Complaints',
                style: TextStyle(color: Colors.white, fontSize: appSize.width * 0.08, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        Transform.translate(
          offset: const Offset(0, 20),
          child: FloatingActionButton(
            onPressed: () {
              context.read<ComplaintListBloc>().toggleDialog();
            },
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: Icon(Icons.add, color: Colors.red[300] ?? Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSubtitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: CustomText(
        text: 'Have something to rant about?',
        fontFamily: "Plus",
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSearchField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: IconButton(
                icon: const Icon(Icons.search, color: Colors.black, size: 21),
                onPressed: _performSearch,
              ),
              hintStyle: const TextStyle(color: Colors.black),
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComplaintList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          _buildSortBySection(),
          Expanded(child: _buildComplaintListView()),
        ],
      ),
    );
  }

  Widget _buildSortBySection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(text: 'SORT BY ', style: TextStyle(color: Color(0xFFDE7A72))),
                TextSpan(text: 'DATE ADDED', style: TextStyle(color: Color(0xFFDE7A72), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 4),
          SvgPicture.asset(
            "assets/Svgs/arrow.svg", height: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintListView() {
    return BlocBuilder<ComplaintListBloc, ComplaintListState>(
      builder: (context, state) {
        if (state.filteredComplaints.isEmpty) {
          return const Center(
            child: CustomText(
              text: 'No results found. Please search.',
              fontFamily: "Plus",
              color: Colors.grey,
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.only(top: 3,left: 7,right: 7),
          itemCount: state.filteredComplaints.length,
          itemBuilder: (context, index) {
            final complaint = state.filteredComplaints[index];
            return ComplaintCard(
              complaintNumber: complaint.complaintNumber,
              status: complaint.status,
              statusColor: complaint.status == 'Pending' ? const Color(0xFFDE7A72) : const Color(0xFF53B175),
              statusTextColor: Colors.white,
              name: complaint.name,
              date: complaint.date,
              description: complaint.description,
            );
          },
        );
      },
    );
  }

  Widget _buildDialogOverlay() {
    return BlocBuilder<ComplaintListBloc, ComplaintListState>(
      builder: (context, state) {
        if (state.isDialogOpen) {
          return GestureDetector(
            onTap: () => context.read<ComplaintListBloc>().closeDialog(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDialog() {
    return BlocBuilder<ComplaintListBloc, ComplaintListState>(
      builder: (context, state) {
        if (state.isDialogOpen) {
          return Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildDialogContainer(),
                _buildDialogTitle(),
                _buildDialogCloseButton(),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDialogContainer() {
    return Container(
      width: 350,
      height: 501,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          _buildDialogCategoryField(),
          const SizedBox(height: 16),
          _buildDialogDetailsField(),
          const SizedBox(height: 16),
          _buildDialogAttachmentsSection(),
          const SizedBox(height: 24),
          _buildDialogSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildDialogCategoryField() {
    return TextField(
      decoration: InputDecoration(
        labelText: "Complaint Category",
        labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFDE7A72), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFDE7A72), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFDE7A72), width: 1.5),
        ),
        suffixIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15, color: Color(0xFFDE7A72)),
        hintText: 'Payment',
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.all(8),
      ),
    );
  }

  Widget _buildDialogDetailsField() {
    return TextField(
      maxLines: 6,
      decoration: InputDecoration(
        labelText: "Details",
        labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFDE7A72), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFDE7A72), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFDE7A72), width: 1.5),
        ),
        hintText: 'Write your complaint ...',
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.all(8),
      ),
    );
  }

  Widget _buildDialogAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Attachments',
          fontFamily: "Plus",
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontSize: 14,
        ),
        const SizedBox(height: 8),
        Container(
          width: 64,
          height: 68,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
          ),
          child: Center(
            child: Icon(Icons.add, color: Color(0xFFDE7A72)),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFDE7A72),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () {

          },
          child: const CustomText(
            text: 'Submit',
            fontFamily: "Plus",
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildDialogTitle() {
    return Positioned(
      top: -20,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          height: 45,
          width: 140,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFFDE7A72),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: CustomText(
              text: 'New Complaint',
              fontFamily: "Plus",
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogCloseButton() {
    return Positioned(
      top: 0,
      right: 0,
      child: IconButton(
        icon: const Icon(Icons.close, color: Colors.black),
        onPressed: () {
          context.read<ComplaintListBloc>().closeDialog();
        },
      ),
    );
  }
}