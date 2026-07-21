import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/study_sentence.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> createParticipant({
    required String participantId,
    required int age,
    required String gender,
    required String motherTongue,
    required int trialCount,
    String? prolificPid,
    String? prolificStudyId,
    String? prolificSessionId,
  }) async {
    await _client.from('participants').insert({
      'id': participantId,
      'age': age,
      'gender': gender,
      'mother_tongue': motherTongue,
      'trial_count': trialCount,
      'prolific_pid': prolificPid,
      'prolific_study_id': prolificStudyId,
      'prolific_session_id': prolificSessionId,
    });
  }

  Future<void> saveResponse({
    required String participantId,
    required StudySentence sentence,
    required String? selectedEmotion,
    required int reactionTimeMs,
    required bool timedOut,
    required int trialNumber,
  }) async {
    await _client.from('responses').insert({
      'participant_id': participantId,
      'sentence_id': sentence.id,
      'sentence': sentence.sentence,
      'target_emotion': sentence.emotion,
      'selected_emotion': selectedEmotion,
      'reaction_time_ms': reactionTimeMs,
      'timed_out': timedOut,
      'is_control': sentence.isControl,
      'trial_number': trialNumber,
    });
  }
}
