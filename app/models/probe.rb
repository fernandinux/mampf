class Probe < ApplicationRecord
  connects_to database: { writing: :interactions, reading: :interactions }

  def self.finished_quizzes(quiz)
    Probe.where(quiz_id: quiz.id, progress: -1).count
  end

  def self.global_success_in_quiz(quiz)
    success = Probe.where(quiz_id: quiz, progress: -1).pluck(:success)
                   .compact
    if success.empty?
      return { median: nil,
               lower_quartile: nil,
               upper_quartile: nil }
    end
    { median: success.percentile(50),
      lower_quartile: success.percentile(25),
      upper_quartile: success.percentile(75) }
  end

  def self.global_success_details(quiz)
    Probe.where(quiz_id: quiz, progress: -1).pluck(:success)
         .compact.group_by(&:itself).transform_values(&:count)
  end

  def self.local_success_in_quiz(quiz)
    probes = Probe.where(quiz_id: quiz.id)
    results = {}
    quiz.question_ids.each do |q|
      correct = probes.where(question_id: q, correct: true).count
      incorrect = probes.where(question_id: q, correct: false).count
      total = correct + incorrect
      rel_correct = total.zero? ? nil : ((correct / total.to_f) * 100).ceil
      rel_incorrect = total.zero? ? nil : 100 - rel_correct
      results[q] = { correct: probes.where(question_id: q,
                                           correct: true).count,
                    incorrect: probes.where(question_id: q,
                                            correct: false).count,
                    rel_correct: rel_correct,
                    rel_incorrect: rel_incorrect }
    end
    results
  end
end
