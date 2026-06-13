import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/domain/models/subject_model.dart';
import 'package:teacher_app/domain/usecases/get_subjects_use_case.dart';
import 'package:teacher_app/widgets/app_error_widget.dart';
import 'package:teacher_app/widgets/loading_widget.dart';
import 'package:teacher_app/localization/generated/app_strings_keys.dart';

class SubjectSelectionBottomSheet extends StatefulWidget {
  final SubjectModel? selected;

  const SubjectSelectionBottomSheet({super.key, this.selected});

  static Future<SubjectModel?> show(BuildContext context,
      {SubjectModel? selected}) {
    return showModalBottomSheet<SubjectModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SubjectSelectionBottomSheet(selected: selected),
    );
  }

  @override
  State<SubjectSelectionBottomSheet> createState() =>
      _SubjectSelectionBottomSheetState();
}

class _SubjectSelectionBottomSheetState
    extends State<SubjectSelectionBottomSheet> {
  final _useCase = GetSubjectsUseCase();

  List<SubjectModel> _subjects = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final result = await _useCase.execute();
    if (!mounted) return;
    if (result.isSuccess) {
      setState(() {
        _subjects = result.value ?? [];
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = result.error?.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.menu_book_outlined,
                      color: Theme.of(context).primaryColor, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    AppStringsKeys.selectSubject.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey[200]),
            Expanded(child: _buildContent(scrollController)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ScrollController scrollController) {
    if (_isLoading) return const LoadingWidget();
    if (_errorMessage != null) {
      return AppErrorWidget(message: _errorMessage!, onRetry: _load);
    }
    if (_subjects.isEmpty) {
      return Center(
        child: Text(
          AppStringsKeys.noSubjectsAvailable.tr,
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }
    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _subjects.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: Colors.grey[100]),
      itemBuilder: (_, index) {
        final subject = _subjects[index];
        final isSelected = widget.selected?.id == subject.id;
        return ListTile(
          title: Text(
            subject.name,
            style: TextStyle(
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[800],
            ),
          ),
          trailing: isSelected
              ? Icon(Icons.check, color: Theme.of(context).primaryColor)
              : null,
          onTap: () => Navigator.pop(context, subject),
        );
      },
    );
  }
}