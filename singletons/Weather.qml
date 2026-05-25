pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.singletons
import "../WmoCodes.js" as WmoCodes
import "../config.js" as Config

Singleton {
    id: root
    property var current
    property var currentUnits
    property var daily
    property var dailyUnits
    property bool mock: Global.dev

    function fetchWeather(latitude, longitude) {
        if (mock) {
            const mock = '{"latitude":-0.035149384,"longitude":0,"generationtime_ms":0.24247169494628906,"utc_offset_seconds":0,"timezone":"Etc/GMT","timezone_abbreviation":"GMT","elevation":0,"current_weather_units":{"time":"iso8601","interval":"seconds","temperature":"°C","windspeed":"km/h","winddirection":"°","is_day":"","weathercode":"wmo code"},"current_weather":{"time":"2026-05-24T23:30","interval":900,"temperature":27.9,"windspeed":25.6,"winddirection":143,"is_day":0,"weathercode":3},"daily_units":{"time":"iso8601","temperature_2m_max":"°C","temperature_2m_min":"°C","sunrise":"iso8601","sunset":"iso8601","weathercode":"wmo code"},"daily":{"time":["2026-05-24","2026-05-25","2026-05-26","2026-05-27","2026-05-28","2026-05-29","2026-05-30"],"temperature_2m_max":[28.1,27.8,27.5,27.4,27.6,27.3,27.5],"temperature_2m_min":[27.5,26,26.8,26.8,26.9,26.6,26.9],"sunrise":["2026-05-24T05:53","2026-05-25T05:53","2026-05-26T05:53","2026-05-27T05:53","2026-05-28T05:53","2026-05-29T05:53","2026-05-30T05:54"],"sunset":["2026-05-24T18:00","2026-05-25T18:00","2026-05-26T18:00","2026-05-27T18:00","2026-05-28T18:00","2026-05-29T18:00","2026-05-30T18:01"],"weathercode":[51,80,53,3,3,3,3]}}';
            weatherProcess.command = ["echo", mock];
            weatherProcess.running = true;
        } else {
            const url = `https://api.open-meteo.com/v1/forecast?latitude=${latitude}&longitude=${longitude}&current_weather=true&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,weathercode&timezone=auto&forecast_days=7`;
            weatherProcess.command = ["curl", "-s", url];
            weatherProcess.running = true;
        }
    }

    function updateWeatherValues(raw) {
        const json = JSON.parse(raw);
        if (json.error)
            console.error(json.reason);

        current = {
            "time": new Date(json.current_weather.time),
            "interval": json.current_weather.interval,
            "temperature": json.current_weather.temperature,
            "windSpeed": json.current_weather.windspeed,
            "windDirection": json.current_weather.winddirection,
            "isDay": json.current_weather.is_day,
            "weatherCode": json.current_weather.weathercode,
            "wmo": WmoCodes.getWmoDescription(json.current_weather.weathercode),
            "icon": weatherIcon(json.current_weather.is_day, json.current_weather.weathercode)
        };
        currentUnits = {
            "time": json.current_weather_units.time,
            "interval": json.current_weather_units.interval,
            "temperature": json.current_weather_units.temperature,
            "windSpeed": json.current_weather_units.windspeed,
            "windDirection": json.current_weather_units.winddirection,
            "isDay": json.current_weather_units.is_day,
            "weatherCode": json.current_weather_units.weathercode
        };
        const _daily = [];
        for (let i = 0; i < json.daily.time.length; i++) {
            _daily.push({
                "time": new Date(json.daily.time[i]),
                "temperature2mMax": json.daily.temperature_2m_max[i],
                "temperature2mMin": json.daily.temperature_2m_min[i],
                "sunrise": json.daily.sunrise[i],
                "sunset": json.daily.sunset[i],
                "weatherCode": json.daily.weathercode[i],
                "icon": weatherIcon(true, json.daily.weathercode[i])
            });
        }
        daily = _daily;
        dailyUnits = {
            "time": json.daily_units.time,
            "temperature2mMax": json.daily_units.temperature_2m_max,
            "temperature2mMin": json.daily_units.temperature_2m_min,
            "sunrise": json.daily_units.sunrise,
            "sunset": json.daily_units.sunset,
            "weatherCode": json.daily_units.weathercode
        };
    }

    function weatherIcon(isDay, code) {
        function getIcon(code) {
            if (code == 0)
                return "weather-clear";

            if (code == 1)
                return "weather-few-clouds";

            if (code == 2)
                return "weather-clouds";

            if (code == 3)
                return "weather-many-clouds";

            if ([4, 8].includes(code))
                return "weather-overcast";

            if (code == 10)
                return "weather-mist";

            if ([40, 41, 42, 43, 44, 45, 46, 47, 48, 49].includes(code))
                return "weather-fog";

            if ([50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 80, 81, 82, 91, 92].includes(code))
                return "weather-showers";

            if ([66, 67].includes(code))
                return "weather-freezing-rain";

            if ([68, 69, 83, 84].includes(code))
                return "weather-snow-rain";

            if ([70, 71, 72, 73, 74, 75, 77, 78].includes(code))
                return "weather-snow";

            if ([76, 79].includes(code))
                return "weather-snow-scattered";

            if ([85, 86, 93, 94].includes(code))
                return "weather-snow-storm";

            if ([87, 88, 89, 90].includes(code))
                return "weather-hail";

            if ([95, 96, 97, 98, 99].includes(code))
                return "weather-storm";

            return "weather-none-available";
        }

        const icon = getIcon(code);
        if (icon == "weather-none-available" || isDay)
            return icon;

        return `${icon}-night`;
    }

    Timer {
        id: delayTimer

        triggeredOnStart: true
        interval: 60000
        repeat: true
        running: true
        onTriggered: {
            root.fetchWeather(Config.latitude, Config.longitude);
        }
    }

    Process {
        id: weatherProcess

        running: false
        command: []

        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: root.updateWeatherValues(text)
        }
    }
}
