module PositiveBasicSupport::Checker

  def should_be( var , variable_number: nil , variable_name: nil  )
    send( "should_be_#{var}" , variable_number: variable_number , variable_name: variable_name )
  end

  private

  def should_be_boolean( variable_number: nil , variable_name: nil )
    unless boolean?
      ::PositiveBasicSupport::Checker::ErrorFactory.change_paragraph_and_indent( "" )
    end
  end

end
