class SimpleDatePickerInput < SimpleForm::Inputs::StringInput
  def input_html_classes
    super.push('datePicker')
  end
end
