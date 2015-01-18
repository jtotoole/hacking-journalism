require 'spec_helper'
require 'shoulda/matchers'

describe CombineTrends do
  let(:fb1) {
    [
      {:topics=>["Peshawar", "Taliban"], :description=>"Taliban kills scores of students, takes others hostage in attack on Pakistani school", :contributors=>[{:vendor=>"facebook", :vendor_rank=>1, :value=>nil, :vendor_topics=>["Peshawar", "Taliban"]}]},
      {:topics=>["Vivek Murthy"], :description=>"Senate votes 51-43 to approve doctor as surgeon general despite gun group's opposition", :contributors=>[{:vendor=>"facebook", :vendor_rank=>2, :value=>nil, :vendor_topics=>["Vivek Murthy"]}]},
      {:topics=>["Montgomery County, Pennsylvania"], :description=>"Suspect identified and still at large in shootings that left 6 dead", :contributors=>[{:vendor=>"facebook", :vendor_rank=>3, :value=>nil, :vendor_topics=>["Montgomery County, Pennsylvania"]}]},
      {:topics=>["#illridewithyou", "Australia"], :description=>"Australians tell Muslims 'I'll ride with you' to show solidarity after Sydney siege", :contributors=>[{:vendor=>"facebook", :vendor_rank=>4, :value=>nil, :vendor_topics=>["#illridewithyou", "Australia"]}]},
      {:topics=>["D'Angelo"], :description=>"R&B singer releases 1st album in 14 years, 'Black Messiah'", :contributors=>[{:vendor=>"facebook", :vendor_rank=>5, :value=>nil, :vendor_topics=>["D'Angelo"]}]},
      {:topics=>["Thierry Henry"], :description=>"French striker announces retirement, will join Sky Sports as football analyst", :contributors=>[{:vendor=>"facebook", :vendor_rank=>6, :value=>nil, :vendor_topics=>["Thierry Henry"]}]},
      {:topics=>["Andrew Hawkins", "ESPN"], :description=>"Browns receiver wears T-shirt protesting Tamir Rice, John Crawford deaths", :contributors=>[{:vendor=>"facebook", :vendor_rank=>7, :value=>nil, :vendor_topics=>["Andrew Hawkins", "ESPN"]}]},
      {:topics=>["Wasted Love"], :description=>nil, :contributors=>[{:vendor=>"facebook", :vendor_rank=>8, :value=>nil, :vendor_topics=>["Wasted Love"]}]},
      {:topics=>["ESPN"], :description=>nil, :contributors=>[{:vendor=>"facebook", :vendor_rank=>9, :value=>nil, :vendor_topics=>["ESPN"]}]},
      {:topics=>["3 girls 1 cup"], :description=>nil, :contributors=>[{:vendor=>"facebook", :vendor_rank=>10, :value=>nil, :vendor_topics=>["3 girls 1 cup"]}]}
    ]
  }
  let(:tw1) {
    [
      {:topics=>["#PeshawarAttack"], :description=>nil, :contributors=>[{:vendor=>"twitter", :vendor_rank=>1, :value=>nil, :vendor_topics=>["#PeshawarAttack"]}]},
      {:topics=>["#XmasAMovie"], :description=>nil, :contributors=>[{:vendor=>"twitter", :vendor_rank=>2, :value=>nil, :vendor_topics=>["#XmasAMovie"]}]},
      {:topics=>["#illridewithyou"], :description=>nil, :contributors=>[{:vendor=>"twitter", :vendor_rank=>3, :value=>nil, :vendor_topics=>["#illridewithyou"]}]},
      {:topics=>["#WastedLove"], :description=>nil, :contributors=>[{:vendor=>"twitter", :vendor_rank=>4, :value=>nil, :vendor_topics=>["#WastedLove"]}]},
      {:topics=>["#obamacare"], :description=>nil, :contributors=>[{:vendor=>"twitter", :vendor_rank=>5, :value=>nil, :vendor_topics=>["#obamacare"]}]},
      {:topics=>["#VivekMurthy"], :description=>nil, :contributors=>[{:vendor=>"twitter", :vendor_rank=>6, :value=>nil, :vendor_topics=>["#VivekMurthy"]}]},
      {:topics=>["I love Henry", "#HenryIsTheBest"], :description=>nil, :contributors=>[{:vendor=>"twitter", :vendor_rank=>7, :value=>nil, :vendor_topics=>["I love Henry", "#HenryIsTheBest"]}]},
      {:topics=>["Thierry Henry"], :description=>nil, :contributors=>[{:vendor=>"twitter", :vendor_rank=>8, :value=>nil, :vendor_topics=>["Thierry Henry"]}]},
      {:topics=>["Happy Hanukkah 2015"], :description=>nil, :contributors=>[{:vendor=>"twitter", :vendor_rank=>9, :value=>nil, :vendor_topics=>["Happy Hanukkah 2015"]}]},
      {:topics=>["Cutler"], :description=>nil, :contributors=>[{:vendor=>"twitter", :vendor_rank=>10, :value=>nil, :vendor_topics=>["Cutler"]}]}
    ]
  }
  let(:go1) {
    [
      {:topics=>["Wassily Kandinsky"], :description=>"", :contributors=>[{:vendor=>"google", :vendor_rank=>1, :value=>nil, :vendor_topics=>["Wassily Kandinsky"]}]},
      {:topics=>["Detroit Lions"], :description=>"Lions", :contributors=>[{:vendor=>"google", :vendor_rank=>2, :value=>nil, :vendor_topics=>["Detroit Lions"]}]},
      {:topics=>["Kelly Clarkson"], :description=>"Reba McEntire", :contributors=>[{:vendor=>"google", :vendor_rank=>3, :value=>nil, :vendor_topics=>["Kelly Clarkson"]}]},
      {:topics=>["Jay Cutler"], :description=>"Bears", :contributors=>[{:vendor=>"google", :vendor_rank=>4, :value=>nil, :vendor_topics=>["Jay Cutler"]}]},
      {:topics=>["Luke Bryan"], :description=>"", :contributors=>[{:vendor=>"google", :vendor_rank=>5, :value=>nil, :vendor_topics=>["Luke Bryan"]}]},
      {:topics=>["Obamacare"], :description=>"", :contributors=>[{:vendor=>"google", :vendor_rank=>6, :value=>nil, :vendor_topics=>["Obamacare"]}]},
      {:topics=>["HealthCare.gov"], :description=>"", :contributors=>[{:vendor=>"google", :vendor_rank=>7, :value=>nil, :vendor_topics=>["HealthCare.gov"]}]},
      {:topics=>["wasted love's"], :description=>"", :contributors=>[{:vendor=>"google", :vendor_rank=>8, :value=>nil, :vendor_topics=>["wasted love's"]}]},
      {:topics=>["Odell Beckham Jr"], :description=>"", :contributors=>[{:vendor=>"google", :vendor_rank=>9, :value=>nil, :vendor_topics=>["Odell Beckham Jr"]}]},
      {:topics=>["Happy New Hanukkah 2015"], :description=>nil, :contributors=>[{:vendor=>"google", :vendor_rank=>10, :value=>nil, :vendor_topics=>["Happy New Hanukkah 2015"]}]}
    ]
  }
  let(:trends) {[fb1,tw1,go1]}
  let(:combined) { CombineTrends.new(trends).data }

  before do
    UnwantedTopic.create(name: "3 girls 1 cup")
  end

  it "combines trend if shares commonality" do
    expect(go1[9][:topics]).to eq(["Happy New Hanukkah 2015"])
    expect(tw1[8][:topics]).to eq(["Happy Hanukkah 2015"])
    combined_trend = combined.any? {|trend| trend[:topics] == ["Happy Hanukkah 2015", "Happy New Hanukkah 2015"]}
    expect(combined_trend).to eq(true)
  end

  it "doesn't combined trends that don't share commonality" do
    expect(tw1[6][:topics]).to eq(["I love Henry", "#HenryIsTheBest"])
    expect(fb1[5][:topics]).to eq(["Thierry Henry"])
    # both still exist
    original_exists1 = combined.any? {|trend| trend[:topics] == ["I love Henry", "#HenryIsTheBest"]}
    original_exists2 = combined.any? {|trend| trend[:topics] == ["Thierry Henry"]}
    # this shouldn't exist
    combined_exists1 = combined.any? {|trend| trend[:topics] == ["Thierry Henry", "I love Henry", "#HenryIsTheBest"]}
    # this shouldn't exist either
    combined_exists2 = combined.any? {|trend| trend[:topics] == ["I love Henry", "#HenryIsTheBest", "Thierry Henry"]}

    expect(original_exists1).to eq(true)
    expect(original_exists2).to eq(true)
    expect(combined_exists1).to eq(false)
    expect(combined_exists2).to eq(false)
  end

  it "removes duplicate trends if from same vendor" do
    contains_topic = combined.any? {|trend| trend[:topics] == ["Andrew Hawkins", "ESPN"]}
    contains_duplicate = combined.any? {|trend| trend[:topics] == ["ESPN"]}
    expect(contains_topic).to eq(true)
    expect(contains_duplicate).to eq(false)
  end

  it "combines 2 normalized trends" do
    combined_normalized = combined.any? {|trend| trend[:topics] == ["#obamacare", "Obamacare"]}
    original1 = combined.any? {|trend| trend[:topics] == ["#obamacare"]}
    original2 = combined.any? {|trend| trend[:topics] == ["Obamacare"]}
    expect(combined_normalized).to eq(true)
    expect(original1).to eq(false)
    expect(original2).to eq(false)
  end

  it "combines humanized hashtag with duplicate trend" do
    combined_normalized = combined.any? {|trend| trend[:topics] == ["Vivek Murthy", "#VivekMurthy"]}
    original1 = combined.any? {|trend| trend[:topics] == ["Vivek Murthy"]}
    original2 = combined.any? {|trend| trend[:topics] == ["#VivekMurthy"]}
    expect(combined_normalized).to eq(true)
    expect(original1).to eq(false)
    expect(original2).to eq(false)
  end

  it "combines trends if shared by all vendors" do
    combined_normalized = combined.any? {|trend| trend[:topics] == ["Wasted Love", "#WastedLove", "wasted love's"]}
    original1 = combined.any? {|trend| trend[:topics] == ["Wasted Love"]}
    original2 = combined.any? {|trend| trend[:topics] == ["#WastedLove"]}
    original3 = combined.any? {|trend| trend[:topics] == ["wasted love's"]}
    expect(combined_normalized).to eq(true)
    expect(original1).to eq(false)
    expect(original2).to eq(false)
    expect(original3).to eq(false)
  end
end
