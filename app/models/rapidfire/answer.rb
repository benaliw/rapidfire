module Rapidfire
  class Answer < ActiveRecord::Base
    belongs_to :question
    belongs_to :attempt, inverse_of: :answers

    validates :question, :attempt, presence: true
    validate  :verify_answer_text
    scope :for_user, -> (user){joins(:attempts).where("rapidfire_attempts.user_id=?",user.id) unless can_administer?}
    if Rails::VERSION::MAJOR == 3
      attr_accessible :question_id, :attempt, :answer_text
    end

    private
    def verify_answer_text
      return false unless question.present?
      question.validate_answer(self)
    end
  end
end
