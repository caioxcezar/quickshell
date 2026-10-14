const codes = {
  // 00-09: General conditions
  "00": "Clear sky",
  "01": "Clouds clearing",
  "02": "Sky unchanged",
  "03": "Clouds building",
  "04": "Smoky",
  "05": "Hazy",
  "06": "Dusty",
  "07": "Windblown dust",
  "08": "Dust whirls",
  "09": "Dust storm nearby",

  // 10-19: Mist, lightning, distant precipitation
  "10": "Misty",
  "11": "Patchy shallow fog",
  "12": "Shallow fog",
  "13": "Lightning nearby",
  "14": "Rain in the distance",
  "15": "Distant rain",
  "16": "Rain nearby",
  "17": "Thunder expected",
  "18": "Squalls",
  "19": "Funnel cloud",

  // 20-29: Recent weather (past hour, ended)
  "20": "Drizzle just ended",
  "21": "Rain just ended",
  "22": "Snow just ended",
  "23": "Sleet just ended",
  "24": "Freezing rain just ended",
  "25": "Showers just ended",
  "26": "Snow showers just ended",
  "27": "Hail just ended",
  "28": "Fog just cleared",
  "29": "Thunderstorm just ended",

  // 30-39: Dust, sand and blowing snow
  "30": "Dust storm",
  "31": "Dust storm",
  "32": "Dust storm building",
  "33": "Severe dust storm",
  "34": "Severe dust storm",
  "35": "Severe dust storm building",
  "36": "Light blowing snow",
  "37": "Heavy blowing snow",
  "38": "Light blowing snow",
  "39": "Heavy blowing snow",

  // 40-49: Fog
  "40": "Fog in the distance",
  "41": "Patchy fog",
  "42": "Fog thinning",
  "43": "Fog thinning",
  "44": "Fog",
  "45": "Dense fog",
  "46": "Fog thickening",
  "47": "Dense fog thickening",
  "48": "Freezing fog",
  "49": "Dense freezing fog",

  // 50-59: Drizzle
  "50": "Light drizzle",
  "51": "Light drizzle",
  "52": "Drizzle",
  "53": "Drizzle",
  "54": "Heavy drizzle",
  "55": "Heavy drizzle",
  "56": "Light freezing drizzle",
  "57": "Heavy freezing drizzle",
  "58": "Light drizzle and rain",
  "59": "Drizzle and rain",

  // 60-69: Rain
  "60": "Light rain",
  "61": "Light rain",
  "62": "Rain",
  "63": "Rain",
  "64": "Heavy rain",
  "65": "Heavy rain",
  "66": "Light freezing rain",
  "67": "Heavy freezing rain",
  "68": "Light rain and snow",
  "69": "Heavy rain and snow",

  // 70-79: Snow
  "70": "Light snow",
  "71": "Light snow",
  "72": "Snow",
  "73": "Snow",
  "74": "Heavy snow",
  "75": "Heavy snow",
  "76": "Ice crystals",
  "77": "Snow grains",
  "78": "Snow crystals",
  "79": "Ice pellets",

  // 80-90: Showers
  "80": "Light showers",
  "81": "Showers",
  "82": "Violent showers",
  "83": "Light rain and snow showers",
  "84": "Heavy rain and snow showers",
  "85": "Light snow showers",
  "86": "Heavy snow showers",
  "87": "Light hail showers",
  "88": "Heavy hail showers",
  "89": "Light hail",
  "90": "Heavy hail",

  // 91-99: Thunderstorms and recent precipitation
  "91": "Light rain after thunderstorm",
  "92": "Heavy rain after thunderstorm",
  "93": "Light snow or hail after thunderstorm",
  "94": "Heavy snow or hail after thunderstorm",
  "95": "Thunderstorm",
  "96": "Thunderstorm with hail",
  "97": "Heavy thunderstorm",
  "98": "Thunderstorm with dust storm",
  "99": "Heavy thunderstorm with hail",
};

function getWmoDescription(code) {
    var codeStr = code.toString().padStart(2, '0');
    return codes[codeStr] || "Unknown weather code";
}