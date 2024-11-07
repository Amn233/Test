import 'package:flutter_bloc/flutter_bloc.dart';
import '../model.dart';

/// Bloc class to manage the state of the complaint list
class ComplaintListBloc extends Cubit<ComplaintListState> {
  // Initializing the bloc with a state containing all complaints
  ComplaintListBloc() : super(ComplaintListState(filteredComplaints: allComplaints));

  // List of all complaints
  static List<Complaint> allComplaints = [
    Complaint('#000384309283', 'Pending', 'Talha Ahmad', 'March 30, 2024 | 14:33',
        'Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups...'),
    Complaint('#000384309284', 'Pending', 'Ahmad', 'March 30, 2024 | 14:33',
        'Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups...'),
    Complaint('#000384309285', 'Resolved', 'Ali Khan', 'March 29, 2024 | 12:45',
        'Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups...'),
    // Add more complaints as needed
  ];

  // Toggles the visibility of the dialog
  void toggleDialog() => emit(state.copyWith(isDialogOpen: !state.isDialogOpen));

  // Closes the dialog
  void closeDialog() => emit(state.copyWith(isDialogOpen: false));

  // Opens the dialog
  void openDialog() => emit(state.copyWith(isDialogOpen: true));

  // Searches and filters complaints based on the provided search text
  void searchComplaints(String searchText) {
    if (searchText.isEmpty) {
      // If search text is empty, show all complaints
      emit(state.copyWith(filteredComplaints: allComplaints));
    } else {
      // Filter complaints based on the search text
      List<Complaint> filtered = allComplaints.where((complaint) {
        return complaint.complaintNumber.contains(searchText) ||
            complaint.name.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
      emit(state.copyWith(filteredComplaints: filtered));
    }
  }
}

/// State class to represent the state of the complaint list
class ComplaintListState {
  final bool isDialogOpen; // Indicates if the dialog is open
  final List<Complaint> filteredComplaints; // List of complaints to display

  ComplaintListState({required this.filteredComplaints, this.isDialogOpen = false});

  // Creates a copy of the current state with optional new values
  ComplaintListState copyWith({bool? isDialogOpen, List<Complaint>? filteredComplaints}) {
    return ComplaintListState(
      filteredComplaints: filteredComplaints ?? this.filteredComplaints,
      isDialogOpen: isDialogOpen ?? this.isDialogOpen,
    );
  }
}