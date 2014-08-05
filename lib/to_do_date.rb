class To_Do_Date(date)
  def initialize
    split_date = date.split("-")
    split_date[0].to_i > 2013 && split_date[1].length ==2 && split_date[1].to_i.between?(1,12) && split_date[2].to_i.between?(1,31) && split_date[2].length == 2
  end
end
