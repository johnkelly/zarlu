require_relative '../../app/services/time_off_value'

describe TimeOffValue do
  describe "self.kinds" do
    it "returns an array with kind text and value" do
      TimeOffValue.kinds.should == [
        ["Vacation", TimeOffValue::VACATION],
        ["Sick", TimeOffValue::SICK],
        ["Personal", TimeOffValue::PERSONAL],
        ["Unpaid", TimeOffValue::UNPAID],
        ["Other", TimeOffValue::OTHER]
      ]
    end
  end

  describe "self.color" do
    context "vacation" do
      subject { TimeOffValue.color(TimeOffValue::VACATION) }
      it { should == "#0668C0" }
    end

    context "sick" do
      subject { TimeOffValue.color(TimeOffValue::SICK) }
      it { should == "green" }
    end

    context "Personal" do
      subject { TimeOffValue.color(TimeOffValue::PERSONAL) }
      it { should == "purple" }
    end

    context "Unpaid" do
      subject { TimeOffValue.color(TimeOffValue::UNPAID) }
      it { should == "red" }
    end

    context "Other" do
      subject { TimeOffValue.color(TimeOffValue::OTHER) }
      it { should == "black" }
    end
  end
end
