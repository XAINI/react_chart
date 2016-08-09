class LineChartExampleController < ApplicationController
  def index
    @component_name = "LineChartExample"
    @component_data = {
      bottom_name: "时间",
      height_name: "温度（单位：摄氏度）",
      items: [
        { bottom_value: "0:00", height_value: 16 },
        { bottom_value: "3:00", height_value: 22 },
        { bottom_value: "4:00", height_value: 24 },
        { bottom_value: "10:00", height_value: 28 },
        { bottom_value: "11:00", height_value: 28 },
        { bottom_value: "12:00", height_value: 29 },
        { bottom_value: "13:00", height_value: 30 },
        { bottom_value: "14:00", height_value: 29 },
        { bottom_value: "15:00", height_value: 32 },
        { bottom_value: "16:00", height_value: 38 },
        { bottom_value: "17:00", height_value: 35 },
        { bottom_value: "18:00", height_value: 40 },
        { bottom_value: "19:00", height_value: 24 },
        { bottom_value: "20:00", height_value: 20 },
        { bottom_value: "21:00", height_value: 15 }
      ]
    }
    
  end
end
