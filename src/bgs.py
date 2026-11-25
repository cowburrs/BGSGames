import requests
import json
from pathlib import Path

url = "https://raw.githubusercontent.com/ANUBGS/ANUBGS/main/BGdata.json"

resp = requests.get(url, timeout=10)
resp.raise_for_status()

games: list[dict] = resp.json()


# print(games[0].keys())


def filter_possible(games, n_players) -> list[dict]:
    return list(
        filter(
            lambda game: game["maxPC"] >= n_players and game["minPC"] <= n_players,
            games,
        )
    )


def filter_names(possible: list[dict]) -> list[str]:
    return list(map(lambda game: game["title"], possible))


for i in map(lambda n: n, range(21)):
    names = filter_names(filter_possible(games, i))
    json.dump(names, open(f"data/{i}Players.json", "w"), indent=2)
