class WorldwideTariff < ActiveRecord::Base

  before_create :arr_to_attr

  default_scope :order => "country ASC"

  attr_accessor :arr_data

  #validates :additional, :numericality => {:greater_than => 0}, :on => :update
  #validate :changed_attr, :on => :update

  private

  def changed_attr
    self.attributes.each { |name, val|
      if name.index('w_')
        errors.add(name, "incorrect value") if val <= 0 || !is_a_number?(val)
      end
    }
  end

  def is_a_number?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

  def arr_to_attr
    self.country = self.arr_data[0]
    self.w_0_5 = self.arr_data[1]
    self.w_1_0 = self.arr_data[2]
    self.w_1_5 = self.arr_data[3]
    self.w_2_0 = self.arr_data[4]
    self.w_2_5 = self.arr_data[5]
    self.w_3_0 = self.arr_data[6]
    self.w_3_5 = self.arr_data[7]
    self.w_4_0 = self.arr_data[8]
    self.w_4_5 = self.arr_data[9]
    self.w_5_0 = self.arr_data[10]
    self.w_5_5 = self.arr_data[11]
    self.w_6_0 = self.arr_data[12]
    self.w_6_5 = self.arr_data[13]
    self.w_7_0 = self.arr_data[14]
    self.w_7_5 = self.arr_data[15]
    self.w_8_0 = self.arr_data[16]
    self.w_8_5 = self.arr_data[17]
    self.w_9_0 = self.arr_data[18]
    self.w_9_5 = self.arr_data[19]
    self.w_10_0 = self.arr_data[20]
    self.w_10_5 = self.arr_data[21]
    self.w_11_0 = self.arr_data[22]
    self.w_11_5 = self.arr_data[23]
    self.w_12_0 = self.arr_data[24]
    self.w_12_5 = self.arr_data[25]
    self.w_13_0 = self.arr_data[26]
    self.w_13_5 = self.arr_data[27]
    self.w_14_0 = self.arr_data[28]
    self.w_14_5 = self.arr_data[29]
    self.w_15_0 = self.arr_data[30]
    self.w_15_5 = self.arr_data[31]
    self.w_16_0 = self.arr_data[32]
    self.w_16_5 = self.arr_data[33]
    self.w_17_0 = self.arr_data[34]
    self.w_17_5 = self.arr_data[35]
    self.w_18_0 = self.arr_data[36]
    self.w_18_5 = self.arr_data[37]
    self.w_19_0 = self.arr_data[38]
    self.w_19_5 = self.arr_data[39]
    self.w_20_0 = self.arr_data[40]
    self.w_20_5 = self.arr_data[41]
    self.w_21_0 = self.arr_data[42]
    self.w_21_5 = self.arr_data[43]
    self.w_22_0 = self.arr_data[44]
    self.w_22_5 = self.arr_data[45]
    self.w_23_0 = self.arr_data[46]
    self.w_23_5 = self.arr_data[47]
    self.w_24_0 = self.arr_data[48]
    self.w_24_5 = self.arr_data[49]
    self.w_25_0 = self.arr_data[50]
    self.w_25_5 = self.arr_data[51]
    self.w_26_0 = self.arr_data[52]
    self.w_26_5 = self.arr_data[53]
    self.w_27_0 = self.arr_data[54]
    self.w_27_5 = self.arr_data[55]
    self.w_28_0 = self.arr_data[56]
    self.w_28_5 = self.arr_data[57]
    self.w_29_0 = self.arr_data[58]
    self.w_29_5 = self.arr_data[59]
    self.w_30_0 = self.arr_data[60]
    self.additional = self.arr_data[61]
  end

end
