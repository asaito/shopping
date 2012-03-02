1.upto(3) do |n|
  Stockm.create(:shopcode => "1", :stockcode => "#{n}", :stockname => "name #{n}")
end
