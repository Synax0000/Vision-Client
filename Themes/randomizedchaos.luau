local Random = Random.new()

RandomFontPool = {
    Enum.Font.Arimo,
    Enum.Font.Arial,
    Enum.Font.ArialBold,
    Enum.Font.ArialBoldItalic,
    Enum.Font.ArialItalic,
    Enum.Font.Code,
    Enum.Font.Gotham,
    Enum.Font.GothamBold,
    Enum.Font.GothamSemibold,
    Enum.Font.SourceSans,
    Enum.Font.SourceSansBold
}

return {
    ThemeName = "RandomizedChaos",

    BackgroundColor = Color3.fromRGB(Random:NextInteger(0, 255), Random:NextInteger(0, 255), Random:NextInteger(0, 255)),
    DarkBackgroundColor = Color3.fromRGB(Random:NextInteger(0, 255), Random:NextInteger(0, 255), Random:NextInteger(0, 255)),
    LightBackgroundColor = Color3.fromRGB(Random:NextInteger(0, 255), Random:NextInteger(0, 255), Random:NextInteger(0, 255)),
    StrokeColor = Color3.fromRGB(Random:NextInteger(0, 255), Random:NextInteger(0, 255), Random:NextInteger(0, 255)),
    ScrollbarColor = Color3.fromRGB(Random:NextInteger(0, 255), Random:NextInteger(0, 255), Random:NextInteger(0, 255)),
    TextColor = Color3.fromRGB(Random:NextInteger(0, 255), Random:NextInteger(0, 255), Random:NextInteger(0, 255)),
    PlaceholderTextColor = Color3.fromRGB(Random:NextInteger(0, 255), Random:NextInteger(0, 255), Random:NextInteger(0, 255)),
    ButtonToggledColor = Color3.fromRGB(Random:NextInteger(0, 255), Random:NextInteger(0, 255), Random:NextInteger(0, 255)),
    SliderFillColor = Color3.fromRGB(Random:NextInteger(0, 255), Random:NextInteger(0, 255), Random:NextInteger(0, 255)),
    Font = RandomFontPool[Random:NextInteger(1, #RandomFontPool)],
    ScrollBarThickness = Random:NextInteger(1, 10),
    StrokeThickness = Random:NextInteger(1, 10),
    WindowBorderVisble = true
}