import 'package:fe_lab_clinicas_core/fe_lab_clinicas_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../models/patient_information_form_model.dart';
import '../../repositories/patient_information_form/patient_information_form_repository.dart';

class CheckinController with MessageStateMixin {
  CheckinController({
    required PatientInformationFormRepository patientInformationFormRepository,
  }) : _patientInformationFormRepository = patientInformationFormRepository;

  final informationForm = signal<PatientInformationFormModel?>(null);
  final PatientInformationFormRepository _patientInformationFormRepository;
  final endProcess = signal(false);

  Future<void> endCheckin() async {
    if (informationForm() != null) {
      final result = await _patientInformationFormRepository.updateStatus(
          informationForm.value!.id,
          PatientInformationFormStatus.beingAttended);
      switch (result) {
        case Left():
          showError('Erro ao atualizar status do formulário');
        case Right():
          endProcess.value = true;
      }
    } else {
      showError('Formulário não pode ser nulo');
    }
  }
}
