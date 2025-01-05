module ColorableString
    RGB_COLOR_MAP = {
        red: "255;85;85",
        dark_red: "139;0;0",
        light_red: "255;182;193",
        
        green: "80;250;123",
        dark_green: "0;100;0",
        light_green: "144;238;144",
        
        blue: "0;112;221",
        dark_blue: "0;0;139",
        light_blue: "173;216;230",
        cyan: "139;233;253",
        
        yellow: "255;255;102",
        dark_yellow: "204;204;0",
        light_yellow: "255;255;224",
        
        purple: "128;0;128",
        dark_purple: "75;0;130",
        light_purple: "216;191;216",
        
        orange: "255;165;0",
        dark_orange: "255;140;0",
        light_orange: "255;200;124",
        
        pink: "255;192;203",
        dark_pink: "231;84;128",
        light_pink: "255;182;193",
        
        brown: "139;69;19",
        dark_brown: "101;67;33",
        light_brown: "181;101;29",
        
        gray: "128;128;128",
        dark_gray: "64;64;64",
        light_gray: "211;211;211",
        white: "255;255;255",
        black: "0;0;0",
        
        gold: "255;215;0",
        silver: "192;192;192",
        bronze: "205;127;50",
        teal: "0;128;128",
        olive: "128;128;0",
        navy: "0;0;128",
        maroon: "128;0;0"
    }.freeze

    refine String do
        def fg_color(color_name)
            "\e[38;2;#{RGB_COLOR_MAP[color_name]}m#{self}\e[0m"
        end
    end
end