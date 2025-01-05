module ColorableString
    RGB_COLOR_MAP = {

    }.freeze

    refine String do
        def fg_color(color_name)
            "\e[38;2;#{RGB_COLOR_MAP[color_name]}m#{self}\e[0m"
        end
    end
end