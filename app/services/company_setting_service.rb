class CompanySettingService
  attr_reader :vacation, :sick, :personal, :unpaid, :other

  def initialize(company_settings)
    @company_settings = company_settings
    @vacation = @company_settings.detect{ |cs| cs.is_a?(VacationCompanySetting) }
    @sick = @company_settings.detect{ |cs| cs.is_a?(SickCompanySetting) }
    @personal = @company_settings.detect{ |cs| cs.is_a?(PersonalCompanySetting) }
    @unpaid = @company_settings.detect{ |cs| cs.is_a?(UnpaidCompanySetting) }
    @other = @company_settings.detect{ |cs| cs.is_a?(OtherCompanySetting) }
  end
end