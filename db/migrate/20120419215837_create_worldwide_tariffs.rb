class CreateWorldwideTariffs < ActiveRecord::Migration
  def change
    create_table :worldwide_tariffs do |t|
      t.string :country
      t.decimal :w_0_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_1_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_1_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_2_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_2_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_3_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_3_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_4_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_4_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_5_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_5_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_6_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_6_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_7_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_7_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_8_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_8_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_9_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_9_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_10_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_10_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_11_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_11_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_12_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_12_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_13_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_13_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_14_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_14_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_15_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_15_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_16_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_16_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_17_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_17_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_18_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_18_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_19_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_19_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_20_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_20_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_21_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_21_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_22_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_22_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_23_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_23_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_24_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_24_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_25_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_25_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_26_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_26_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_27_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_27_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_28_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_28_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_29_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_29_5, :precision => 15, :scale => 2, :default => 0
      t.decimal :w_30_0, :precision => 15, :scale => 2, :default => 0
      t.decimal :additional, :precision => 15, :scale => 2, :default => 0
      t.timestamps
    end
  end
end
