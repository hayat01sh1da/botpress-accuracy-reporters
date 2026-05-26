# frozen_string_literal: true
# rbs_inline: enabled

# Form object validating the params for the training-data download flow.
class TrainingDataForm < ApplicationForm
  attr_accessor :training_data

  validates :training_data, presence: true
end
