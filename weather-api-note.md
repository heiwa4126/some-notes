# 天気を取得する API のメモ

無料で認証認可が簡単なやつ(できれば不要なやつ)

## wttr.in

最も簡単 ⭐⭐⭐

- 認証: 不要
- 無料: 完全無料
- 制限: 特になし(常識的な範囲で)
- 特徴: シンプル、すぐ使える

参考リンク:

- 東京の天気: <https://wttr.in/tokyo> または `curl https://wttr.in/tokyo`
- HELP - [wttr.in/:help](https://wttr.in/:help)
- README - [chubin/wttr.in: :partly_sunny: The right way to check the weather](https://github.com/chubin/wttr.in?tab=readme-ov-file#readme)
- [JSON output](https://github.com/chubin/wttr.in?tab=readme-ov-file#json-output)
- [【wttr.in】ターミナル/VSCode から最速 3 秒で天気を確認する #Terminal - Qiita](https://qiita.com/shirokuma89dev/items/1d86d4caec2d3cd1402d)

欠点:

- なんかよく死んでる気がする。
- 東京の天気を要求すると、式根島の天気が返ってくる(間違ってはいないけどちがう)。

### 実装

とりあえず同期で。ネタは「現在気温を得る」

```python
def get_temperature_wttr(location: str) -> Optional[int]:
    """
    wttr.in APIを使用して気温を取得(認証不要)

    Args:
        location: 都市名(英語で入力。例: Tokyo, Osaka)

    Returns:
        気温(摂氏、整数値)またはNone
    """
    try:
        # JSON形式で取得
        url = f"https://wttr.in/{location}?format=j1"

        response = requests.get(url, timeout=10)
        response.raise_for_status()

        data = response.json()
        # 現在の気温を取得
        current_temp = data["current_condition"][0]["temp_C"]

        return int(current_temp)

    except Exception as e:
        print(f"wttr.in API エラー: {e}")
        return None
```

## OpenWeatherMap

最もおすすめ ⭐⭐⭐⭐⭐

- 認証: API キー(無料登録で取得)
- 無料枠: 1000 回/日、60 回/分
- 特徴: 高精度、詳細情報、信頼性が高い
- 登録: https://openweathermap.org/api

参考リンク:

- [Weather API - OpenWeatherMap](https://openweathermap.org/api)
- [Current weather and forecast - OpenWeatherMap](https://openweathermap.org/)
- [OpenWeatherMap - Wikipedia](https://ja.wikipedia.org/wiki/OpenWeatherMap)
- [FAQ](https://openweathermap.org/faq)の "How to get an API key" のところ
- [OpenWeatherMap API を使う](https://zenn.dev/shimpo/articles/open-weather-map-go-20250209)

### 実装例

api_key のとこは各自工夫してください

```python
def get_temperature_openweather(location: str, api_key: str) -> Optional[int]:
    """
    OpenWeatherMap APIを使用して気温を取得

    Args:
        location: 都市名(英語で入力。例: Tokyo, Osaka)
        api_key: OpenWeatherMapのAPIキー

    Returns:
        気温(摂氏、整数値)またはNone
    """
    try:
        url = "https://api.openweathermap.org/data/2.5/weather"
        params = {
            "q": f"{location},JP",  # 日本に限定
            "appid": api_key,
            "units": "metric"  # 摂氏
        }

        response = requests.get(url, params=params, timeout=10)
        response.raise_for_status()

        data = response.json()
        temperature = data["main"]["temp"]

        return round(temperature)  # 整数値で返す

    except Exception as e:
        print(f"OpenWeatherMap API エラー: {e}")
        return None
```

## WeatherAPI

代替案

- 認証: API キー
- 無料枠: 1000 回/日
- 特徴: 使いやすい API

参考リンク:

- [Weather and Geolocation API - Weather and Geolocation API JSON and XML - WeatherAPI.com](https://www.weatherapi.com/docs/)

### 実装例

(TODO)
