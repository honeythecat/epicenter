class SubmissionsController < ApplicationController
  authorize_resource
  
  def index
    @assessment = Assessment.find(params[:assessment_id])
    @submissions = @assessment.submissions.needing_review
  end

  def create
    @assessment = Assessment.find(params[:assessment_id])
    @submission = @assessment.submissions.new(submission_params)
    if @submission.save
      redirect_to @assessment, notice: "Thank you for submitting."
    else
      render 'assessments/show'
    end
  end

  def update
    @assessment = Assessment.find(params[:assessment_id])
    @submission = @assessment.submission_for(current_student)
    if @submission.update(submission_params)
      redirect_to @assessment, notice: "Submission updated!"
    else
      render 'assessments/show'
    end
  end

private

  def submission_params
    params.require(:submission).permit(:link, :needs_review).merge(student_id: current_student.id)
  end

end
