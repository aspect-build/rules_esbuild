"""Info for the esbuild packages used"""

RULES_ESBUILD_VERSION = "$Format:%(describe:tags=true)$"  # Replaced during publishing, see .github/workflows/release_prep.sh

# This assignment is automatically updated by /scripts/mirror_release.sh.
# Versions should be descending order so TOOL_VERSIONS.keys()[0] is the latest version.
TOOL_VERSIONS = {
    "0.23.1": {
        "npm": "sha512-VVNz/9Sa0bs5SELtn3f7qhJCDPCF5oMEl5cO9/SSinpE9hbPVvxbd572HH5AKiP7WD8INO53GgfDDhRjkylHEg==",
        "darwin-x64": "sha512-aClqdgTDVPSEGgoCS8QDG37Gu8yc9lTHNAQlsztQ6ENetKEO//b8y31MMu2ZaPbn4kVsIABzVLXYLhCGekGDqw==",
        "darwin-arm64": "sha512-YsS2e3Wtgnw7Wq53XXBLcV6JhRsEq8hkfg91ESVadIrzr9wO6jJDMZnCQbHm1Guc5t/CdDiFSSfWP58FNuvT3Q==",
        "linux-x64": "sha512-EV6+ovTsEXCPAp58g2dD68LxoP/wK5pRvgy0J/HxPGB009omFPv3Yet0HiaqvrIrgPTBuC6wCH1LTOY91EO5hQ==",
        "linux-arm64": "sha512-/93bf2yxencYDnItMYV/v116zff6UyTjo4EtEQjUBeGiVpMmffDNUyD9UN2zV+V3LRV3/on4xdZ26NKzn6754g==",
        "win32-x64": "sha512-BHpFFeslkWrXWyUPnbKm+xYYVYruCinGcftSBaa8zoF9hZO4BcSCFUvHVTtzpIY6YzUnYtuEhZ+C9iEXjxnasg==",
    },
    "0.23.0": {
        "npm": "sha512-1lvV17H2bMYda/WaFb2jLPeHU3zml2k4/yagNMG8Q/YtfMjCwEUZa2eXXMgZTVSL5q1n4H7sQ0X6CdJDqqeCFA==",
        "darwin-x64": "sha512-IMQ6eme4AfznElesHUPDZ+teuGwoRmVuuixu7sv92ZkdQcPbsNHzutd+rAfaBKo8YK3IrBEi9SLLKWJdEvJniQ==",
        "darwin-arm64": "sha512-YLntie/IdS31H54Ogdn+v50NuoWF5BDkEUFpiOChVa9UnKpftgwzZRrI4J132ETIi+D8n6xh9IviFV3eXdxfow==",
        "linux-x64": "sha512-a3pMQhUEJkITgAw6e0bWA+F+vFtCciMjW/LPtoj99MhVt+Mfb6bbL9hu2wmTZgNd994qTAEw+U/r6k3qHWWaOQ==",
        "linux-arm64": "sha512-j1t5iG8jE7BhonbsEg5d9qOYcVZv/Rv6tghaXM/Ug9xahM0nX/H2gfu6X6z11QRTMT6+aywOMA8TDkhPo8aCGw==",
        "win32-x64": "sha512-Arm+WgUFLUATuoxCJcahGuk6Yj9Pzxd6l11Zb/2aAuv5kWWvvfhLFo2fni4uSK5vzlUdCGZ/BdV5tH8klj8p8g==",
    },
    "0.21.1": {
        "npm": "sha512-GPqx+FX7mdqulCeQ4TsGZQ3djBJkx5k7zBGtqt9ycVlWNg8llJ4RO9n2vciu8BN2zAEs6lPbPl0asZsAh7oWzg==",
        "darwin-x64": "sha512-D3h3wBQmeS/vp93O4B+SWsXB8HvRDwMyhTNhBd8yMbh5wN/2pPWRW5o/hM3EKgk9bdKd9594lMGoTCTiglQGRQ==",
        "darwin-arm64": "sha512-BLT7TDzqsVlQRmJfO/FirzKlzmDpBWwmCUlyggfzUwg1cAxVxeA4O6b1XkMInlxISdfPAOunV9zXjvh5x99Heg==",
        "linux-x64": "sha512-da4/1mBJwwgJkbj4fMH7SOXq2zapgTo0LKXX1VUZ0Dxr+e8N0WbS80nSZ5+zf3lvpf8qxrkZdqkOqFfm57gXwA==",
        "linux-arm64": "sha512-G65d08YoH00TL7Xg4LaL3gLV21bpoAhQ+r31NUu013YB7KK0fyXIt05VbsJtpqh/6wWxoLJZOvQHYnodRrnbUQ==",
        "win32-x64": "sha512-W9NttRZQR5ehAiqHGDnvfDaGmQOm6Fi4vSlce8mjM75x//XKuVAByohlEX6N17yZnVXxQFuh4fDRunP8ca6bfA==",
    },
    "0.20.2": {
        "npm": "sha512-WdOOppmUNU+IbZ0PaDiTst80zjnrOkyJNHoKupIcVyU8Lvla3Ugx94VzkQ32Ijqd7UhHJy75gNWDMUekcrSJ6g==",
        "darwin-x64": "sha512-tBcXp9KNphnNH0dfhv8KYkZhjc+H3XBkF5DKtswJblV7KlT9EI2+jeA8DgBjp908WEuYll6pF+UStUCfEpdysA==",
        "darwin-arm64": "sha512-4J6IRT+10J3aJH3l1yzEg9y3wkTDgDk7TSDFX+wKFiWjqWp/iCfLIYzGyasx9l0SAFPT1HwSCR+0w/h1ES/MjA==",
        "linux-x64": "sha512-1MdwI6OOTsfQfek8sLwgyjOXAu+wKhLEoaOLTjbijk6E2WONYpH9ZU2mNtR+lZ2B4uwr+usqGuVfFT9tMtGvGw==",
        "linux-arm64": "sha512-9pb6rBjGvTFNira2FLIWqDk/uaf42sSyLE8j1rnUpuzsODBq7FvpwHYZxQ/It/8b+QOS1RYfqgGFNLRI+qlq2A==",
        "win32-x64": "sha512-N49X4lJX27+l9jbLKSqZ6bKNjzQvHaT8IIFUy+YIqmXQdjYCToGWwOItDrfby14c78aDd5NHQl29xingXfCdLQ==",
    },
    "0.20.1": {
        "npm": "sha512-OJwEgrpWm/PCMsLVWXKqvcjme3bHNpOgN7Tb6cQnR5n0TPbQx1/Xrn7rqM+wn17bYeT6MGB5sn1Bh5YiGi70nA==",
        "darwin-x64": "sha512-pFIfj7U2w5sMp52wTY1XVOdoxw+GDwy9FsK3OFz4BpMAjvZVs0dT1VXs8aQm22nhwoIWUmIRaE+4xow8xfIDZA==",
        "darwin-arm64": "sha512-Ylk6rzgMD8klUklGPzS414UQLa5NPXZD5tf8JmQU8GQrj6BrFA/Ic9tb2zRe1kOZyCbGl+e8VMbDRazCEBqPvA==",
        "linux-x64": "sha512-5gRPk7pKuaIB+tmH+yKd2aQTRpqlf1E4f/mC+tawIm/CGJemZcHZpp2ic8oD83nKgUPMEd0fNanrnFljiruuyA==",
        "linux-arm64": "sha512-cX8WdlF6Cnvw/DO9/X7XLH2J6CkBnz7Twjpk56cshk9sjYVcuh4sXQBy5bmTwzBjNVZze2yaV1vtcJS04LbN8w==",
        "win32-x64": "sha512-0MBh53o6XtI6ctDnRMeQ+xoCN8kD2qI1rY1KgF/xdWQwoFeKou7puvDfV8/Wv4Ctx2rRpET/gGdz3YlNtNACSA==",
    },
    "0.20.0": {
        "npm": "sha512-6iwE3Y2RVYCME1jLpBqq7LQWK3MW6vjV2bZy6gt/WrqkY+WE74Spyc0ThAOYpMtITvnjX09CrC6ym7A/m9mebA==",
        "darwin-x64": "sha512-bsgTPoyYDnPv8ER0HqnJggXK6RyFy4PH4rtsId0V7Efa90u2+EifxytE9pZnsDgExgkARy24WUQGv9irVbTvIw==",
        "darwin-arm64": "sha512-AjEcivGAlPs3UAcJedMa9qYg9eSfU6FnGHJjT8s346HSKkrcWlYezGE8VaO2xKfvvlZkgAhyvl06OJOxiMgOYQ==",
        "linux-x64": "sha512-H9Eu6MGse++204XZcYsse1yFHmRXEWgadk2N58O/xd50P9EvFMLJTQLg+lB4E1cF2xhLZU5luSWtGTb0l9UeSg==",
        "linux-arm64": "sha512-uTtyYAP5veqi2z9b6Gr0NUoNv9F/rOzI8tOD5jKcCvRUn7T60Bb+42NDBCWNhMjkQzI0qqwXkQGo1SY41G52nw==",
        "win32-x64": "sha512-NgJnesu1RtWihtTtXGFMU5YSE6JyyHPMxCwBZK7a6/8d31GuSo9l0Ss7w1Jw5QnKUawG6UEehs883kcXf5fYwg==",
    },
    "0.19.11": {
        "npm": "sha512-HJ96Hev2hX/6i5cDVwcqiJBBtuo9+FeIJOtZ9W1kA5M6AMJRHUZlpYZ1/SbEwtO0ioNAW8rUooVpC/WehY2SfA==",
        "darwin-x64": "sha512-fkFUiS6IUK9WYUO/+22omwetaSNl5/A8giXvQlcinLIjVkxwTLSktbF5f/kJMftM2MJp9+fXqZ5ezS7+SALp4g==",
        "darwin-arm64": "sha512-ETp87DRWuSt9KdDVkqSoKoLFHYTrkyz2+65fj9nfXsaV3bMhTCjtQfw3y+um88vGRKRiF7erPrh/ZuIdLUIVxQ==",
        "linux-x64": "sha512-grbyMlVCvJSfxFQUndw5mCtWs5LO1gUlwP4CDi4iJBbVpZcqLVT29FxgGuBJGSzyOxotFG4LoO5X+M1350zmPA==",
        "linux-arm64": "sha512-LneLg3ypEeveBSMuoa0kwMpCGmpu8XQUh+mL8XXwoYZ6Be2qBnVtcDI5azSvh7vioMDhoJFZzp9GWp9IWpYoUg==",
        "win32-x64": "sha512-vfkhltrjCAb603XaFhqhAF4LGDi2M4OrCRrFusyQ+iTLQ/o60QQXxc9cZC/FFpihBI9N1Grn6SMKVJ4KP7Fuiw==",
    },
    "0.19.9": {
        "npm": "sha512-U9CHtKSy+EpPsEBa+/A2gMs/h3ylBC0H0KSqIg7tpztHerLi6nrrcoUJAkNCEPumx8yJ+Byic4BVwHgRbN0TBg==",
        "darwin-x64": "sha512-vE0VotmNTQaTdX0Q9dOHmMTao6ObjyPm58CHZr1UK7qpNleQyxlFlNCaHsHx6Uqv86VgPmR4o2wdNq3dP1qyDQ==",
        "darwin-arm64": "sha512-KBJ9S0AFyLVx2E5D8W0vExqRW01WqRtczUZ8NRu+Pi+87opZn5tL4Y0xT0mA4FtHctd0ZgwNoN639fUUGlNIWw==",
        "linux-x64": "sha512-JUjpystGFFmNrEHQnIVG8hKwvA2DN5o7RqiO1CVX8EN/F/gkCjkUMgVn6hzScpwnJtl2mPR6I9XV1oW8k9O+0A==",
        "linux-arm64": "sha512-PiPblfe1BjK7WDAKR1Cr9O7VVPqVNpwFcPWgfn4xu0eMemzRp442hXyzF/fSwgrufI66FpHOEJk0yYdPInsmyQ==",
        "win32-x64": "sha512-oxoQgglOP7RH6iasDrhY+R/3cHrfwIDvRlT4CGChflq6twk8iENeVvMJjmvBb94Ik1Z+93iGO27err7w6l54GQ==",
    },
    "0.19.8": {
        "npm": "sha512-l7iffQpT2OrZfH2rXIp7/FkmaeZM0vxbxN9KfiCwGYuZqzMg/JdvX26R31Zxn/Pxvsrg3Y9N6XTcnknqDyyv4w==",
        "darwin-x64": "sha512-3sur80OT9YdeZwIVgERAysAbwncom7b4bCI2XKLjMfPymTud7e/oY4y+ci1XVp5TfQp/bppn7xLw1n/oSQY3/Q==",
        "darwin-arm64": "sha512-RQw9DemMbIq35Bprbboyf8SmOr4UXsRVxJ97LgB55VKKeJOOdvsIPy0nFyF2l8U+h4PtBx/1kRf0BelOYCiQcw==",
        "linux-x64": "sha512-lytMAVOM3b1gPypL2TRmZ5rnXl7+6IIk8uB3eLsV1JwcizuolblXRrc5ShPrO9ls/b+RTp+E6gbsuLWHWi2zGg==",
        "linux-arm64": "sha512-z1zMZivxDLHWnyGOctT9JP70h0beY54xDDDJt4VpTX+iwA77IFsE1vCXWmprajJGa+ZYSqkSbRQ4eyLCpCmiCQ==",
        "win32-x64": "sha512-bfZ0cQ1uZs2PqpulNL5j/3w+GDhP36k1K5c38QdQg+Swy51jFZWWeIkteNsufkQxp986wnqRRsb/bHbY1WQ7TA==",
    },
    "0.19.2": {
        "npm": "sha512-G6hPax8UbFakEj3hWO0Vs52LQ8k3lnBhxZWomUJDxfz3rZTLqF5k/FCzuNdLx2RbpBiQQF9H9onlDDH1lZsnjg==",
        "darwin-x64": "sha512-tP+B5UuIbbFMj2hQaUr6EALlHOIOmlLM2FK7jeFBobPy2ERdohI4Ka6ZFjZ1ZYsrHE/hZimGuU90jusRE0pwDw==",
        "darwin-arm64": "sha512-Ora8JokrvrzEPEpZO18ZYXkH4asCdc1DLdcVy8TGf5eWtPO1Ie4WroEJzwI52ZGtpODy3+m0a2yEX9l+KUn0tA==",
        "linux-x64": "sha512-oxzHTEv6VPm3XXNaHPyUTTte+3wGv7qVQtqaZCrgstI16gCuhNOtBXLEBkBREP57YTd68P0VgDgG73jSD8bwXQ==",
        "linux-arm64": "sha512-ig2P7GeG//zWlU0AggA3pV1h5gdix0MA3wgB+NsnBXViwiGgY77fuN9Wr5uoCrs2YzaYfogXgsWZbm+HGr09xg==",
        "win32-x64": "sha512-tcuhV7ncXBqbt/Ybf0IyrMcwVOAPDckMK9rXNHtF17UTK18OKLpg08glminN06pt2WCoALhXdLfSPbVvK/6fxw==",
    },
    "0.17.18": {
        "npm": "sha512-z1lix43jBs6UKjcZVKOw2xx69ffE2aG0PygLL5qJ9OS/gy0Ewd1gW/PUQIOIQGXBHWNywSc0floSKoMFF8aK2w==",
        "darwin-x64": "sha512-Qq84ykvLvya3dO49wVC9FFCNUfSrQJLbxhoQk/TE1r6MjHo3sFF2tlJCwMjhkBVq3/ahUisj7+EpRSz0/+8+9A==",
        "darwin-arm64": "sha512-6tY+djEAdF48M1ONWnQb1C+6LiXrKjmqjzPNPWXhu/GzOHTHX2nh8Mo2ZAmBFg0kIodHhciEgUBtcYCAIjGbjQ==",
        "linux-x64": "sha512-66RmRsPlYy4jFl0vG80GcNRdirx4nVWAzJmXkevgphP1qf4dsLQCpSKGM3DUQCojwU1hnepI63gNZdrr02wHUA==",
        "linux-arm64": "sha512-R7pZvQZFOY2sxUG8P6A21eq6q+eBv7JPQYIybHVf1XkQYC+lT7nDBdC7wWKTrbvMXKRaGudp/dzZCwL/863mZQ==",
        "win32-x64": "sha512-qU25Ma1I3NqTSHJUOKi9sAH1/Mzuvlke0ioMJRthLXKm7JiSKVwFghlGbDLOO2sARECGhja4xYfRAZNPAkooYg==",
    },
    "0.17.10": {
        "npm": "sha512-n7V3v29IuZy5qgxx25TKJrEm0FHghAlS6QweUcyIgh/U0zYmQcvogWROitrTyZId1mHSkuhhuyEXtI9OXioq7A==",
        "darwin-x64": "sha512-J4MJzGchuCRG5n+B4EHpAMoJmBeAE1L3wGYDIN5oWNqX0tEr7VKOzw0ymSwpoeSpdCa030lagGUfnfhS7OvzrQ==",
        "darwin-arm64": "sha512-3HaGIowI+nMZlopqyW6+jxYr01KvNaLB5znXfbyyjuo4lE0VZfvFGcguIJapQeQMS4cX/NEispwOekJt3gr5Dg==",
        "linux-x64": "sha512-zJUfJLebCYzBdIz/Z9vqwFjIA7iSlLCFvVi7glMgnu2MK7XYigwsonXshy9wP9S7szF+nmwrelNaP3WGanstEg==",
        "linux-arm64": "sha512-g1EZJR1/c+MmCgVwpdZdKi4QAJ8DCLP5uTgLWSAVd9wlqk9GMscaNMEViG3aE1wS+cNMzXXgdWiW/VX4J+5nTA==",
        "win32-x64": "sha512-oP+zFUjYNaMNmjTwlFtWep85hvwUu19cZklB3QsBOcZSs6y7hmH4LNCJ7075bsqzYaNvZFXJlAVaQ2ApITDXtw==",
    },
    "0.17.4": {
        "npm": "sha512-zBn9MeCwT7W5F1a3lXClD61ip6vQM+H8Msb0w8zMT4ZKBpDg+rFAraNyWCDelB/2L6M3g6AXHPnsyvjMFnxtFw==",
        "darwin-x64": "sha512-phQuC2Imrb3TjOJwLN8EO50nb2FHe8Ew0OwgZDH1SV6asIPGudnwTQtighDF2EAYlXChLoMJwqjAp4vAaACq6w==",
        "darwin-arm64": "sha512-tTyJRM9dHvlMPt1KrBFVB5OW1kXOsRNvAPtbzoKazd5RhD5/wKlXk1qR2MpaZRYwf4WDMadt0Pv0GwxB41CVow==",
        "linux-x64": "sha512-+AsFBwKgQuhV2shfGgA9YloxLDVjXgUEWZum7glR5lLmV94IThu/u2JZGxTgjYby6kyXEx8lKOqP5rTEVBR0Rw==",
        "linux-arm64": "sha512-UkGfQvYlwOaeYJzZG4cLV0hCASzQZnKNktRXUo3/BMZvdau40AOz9GzmGA063n1piq6VrFFh43apRDQx8hMP2w==",
        "win32-x64": "sha512-0kLAjs+xN5OjhTt/aUA6t48SfENSCKgGPfExADYTOo/UCn0ivxos9/anUVeSfg+L+2O9xkFxvJXIJfG+Q4sYSg==",
    },
    "0.16.7": {
        "npm": "sha512-P6OBFYFSQOGzfApqCeYKqfKRRbCIRsdppTXFo4aAvtiW3o8TTyiIplBvHJI171saPAiy3WlawJHCveJVIOIx1A==",
        "darwin-x64": "sha512-duterlv3tit3HI9vhzMWnSVaB1B6YsXpFq1Ntd6Fou82BB1l4tucYy3FI9dHv3tvtDuS0NiGf/k6XsdBqPZ01w==",
        "darwin-arm64": "sha512-VUb9GK23z8jkosHU9yJNUgQpsfJn+7ZyBm6adi2Ec5/U241eR1tAn82QicnUzaFDaffeixiHwikjmnec/YXEZg==",
        "linux-x64": "sha512-xi/tbqCqvPIzU+zJVyrpz12xqciTAPMi2fXEWGnapZymoGhuL2GIWIRXg4O2v5BXaYA5TSaiKYE14L0QhUTuQg==",
        "linux-arm64": "sha512-2wv0xYDskk2+MzIm/AEprDip39a23Chptc4mL7hsHg26P0gD8RUhzmDu0KCH2vMThUI1sChXXoK9uH0KYQKaDg==",
        "win32-x64": "sha512-QaQ8IH0JLacfGf5cf0HCCPnQuCTd/dAI257vXBgb/cccKGbH/6pVtI1gwhdAQ0Y48QSpTIFrh9etVyNdZY+zzw==",
    },
    "0.15.13": {
        "npm": "sha512-Cu3SC84oyzzhrK/YyN4iEVy2jZu5t2fz66HEOShHURcjSkOSAVL8C/gfUT+lDJxkVHpg8GZ10DD0rMHRPqMFaQ==",
        "darwin-64": "sha512-WAx7c2DaOS6CrRcoYCgXgkXDliLnFv3pQLV6GeW1YcGEZq2Gnl8s9Pg7ahValZkpOa0iE/ojRVQ87sbUhF1Cbg==",
        "darwin-arm64": "sha512-U6jFsPfSSxC3V1CLiQqwvDuj3GGrtQNB3P3nNC3+q99EKf94UGpsG9l4CQ83zBs1NHrk1rtCSYT0+KfK5LsD8A==",
        "linux-64": "sha512-rXmnArVNio6yANSqDQlIO4WiP+Cv7+9EuAHNnag7rByAqFVuRusLbGi2697A5dFPNXoO//IiogVwi3AdcfPC6A==",
        "linux-arm64": "sha512-alEMGU4Z+d17U7KQQw2IV8tQycO6T+rOrgW8OS22Ua25x6kHxoG6Ngry6Aq6uranC+pNWNMB6aHFPh7aTQdORQ==",
        "windows-64": "sha512-Et6htEfGycjDrtqb2ng6nT+baesZPYQIW+HUEHK4D1ncggNrDNk3yoboYQ5KtiVrw/JaDMNttz8rrPubV/fvPQ==",
    },
    "0.14.51": {
        "npm": "sha512-+CvnDitD7Q5sT7F+FM65sWkF8wJRf+j9fPcprxYV4j+ohmzVj2W7caUqH2s5kCaCJAfcAICjSlKhDCcvDpU7nw==",
        "darwin-64": "sha512-YFmXPIOvuagDcwCejMRtCDjgPfnDu+bNeh5FU2Ryi68ADDVlWEpbtpAbrtf/lvFTWPexbgyKgzppNgsmLPr8PA==",
        "darwin-arm64": "sha512-juYD0QnSKwAMfzwKdIF6YbueXzS6N7y4GXPDeDkApz/1RzlT42mvX9jgNmyOlWKN7YzQAYbcUEJmZJYQGdf2ow==",
        "linux-64": "sha512-dxjhrqo5i7Rq6DXwz5v+MEHVs9VNFItJmHBe1CxROWNf4miOGoQhqSG8StStbDkQ1Mtobg6ng+4fwByOhoQoeA==",
        "linux-arm64": "sha512-D9rFxGutoqQX3xJPxqd6o+kvYKeIbM0ifW2y0bgKk5HPgQQOo2k9/2Vpto3ybGYaFPCE5qTGtqQta9PoP6ZEzw==",
        "windows-64": "sha512-HoN/5HGRXJpWODprGCgKbdMvrC3A2gqvzewu2eECRw2sYxOUoh2TV1tS+G7bHNapPGI79woQJGV6pFH7GH7qnA==",
    },
    "0.14.39": {
        "npm": "sha512-2kKujuzvRWYtwvNjYDY444LQIA3TyJhJIX3Yo4+qkFlDDtGlSicWgeHVJqMUP/2sSfH10PGwfsj+O2ro1m10xQ==",
        "darwin-64": "sha512-ImT6eUw3kcGcHoUxEcdBpi6LfTRWaV6+qf32iYYAfwOeV+XaQ/Xp5XQIBiijLeo+LpGci9M0FVec09nUw41a5g==",
        "darwin-arm64": "sha512-/fcQ5UhE05OiT+bW5v7/up1bDsnvaRZPJxXwzXsMRrr7rZqPa85vayrD723oWMT64dhrgWeA3FIneF8yER0XTw==",
        "linux-64": "sha512-4tcgFDYWdI+UbNMGlua9u1Zhu0N5R6u9tl5WOM8aVnNX143JZoBZLpCuUr5lCKhnD0SCO+5gUyMfupGrHtfggQ==",
        "linux-arm64": "sha512-23pc8MlD2D6Px1mV8GMglZlKgwgNKAO8gsgsLLcXWSs9lQsCYkIlMo/2Ycfo5JrDIbLdwgP8D2vpfH2KcBqrDQ==",
        "windows-64": "sha512-E2wm+5FwCcLpKsBHRw28bSYQw0Ikxb7zIMxw3OPAkiaQhLVr3dnVO8DofmbWhhf6b97bWzg37iSZ45ZDpLw7Ow==",
    },
    "0.14.36": {
        "npm": "sha512-HhFHPiRXGYOCRlrhpiVDYKcFJRdO0sBElZ668M4lh2ER0YgnkLxECuFe7uWCf23FrcLc59Pqr7dHkTqmRPDHmw==",
        "darwin-64": "sha512-kkl6qmV0dTpyIMKagluzYqlc1vO0ecgpviK/7jwPbRDEv5fejRTaBBEE2KxEQbTHcLhiiDbhG7d5UybZWo/1zQ==",
        "darwin-arm64": "sha512-q8fY4r2Sx6P0Pr3VUm//eFYKVk07C5MHcEinU1BjyFnuYz4IxR/03uBbDwluR6ILIHnZTE7AkTUWIdidRi1Jjw==",
        "linux-64": "sha512-vFVFS5ve7PuwlfgoWNyRccGDi2QTNkQo/2k5U5ttVD0jRFaMlc8UQee708fOZA6zTCDy5RWsT5MJw3sl2X6KDg==",
        "linux-arm64": "sha512-24Vq1M7FdpSmaTYuu1w0Hdhiqkbto1I5Pjyi+4Cdw5fJKGlwQuw+hWynTcRI/cOZxBcBpP21gND7W27gHAiftw==",
        "windows-64": "sha512-+p4MuRZekVChAeueT1Y9LGkxrT5x7YYJxYE8ZOTcEfeUUN43vktSn6hUNsvxzzATrSgq5QqRdllkVBxWZg7KqQ==",
    },
    "0.13.12": {
        "npm": "sha512-vTKKUt+yoz61U/BbrnmlG9XIjwpdIxmHB8DlPR0AAW6OdS+nBQBci6LUHU2q9WbBobMEIQxxDpKbkmOGYvxsow==",
        "darwin-64": "sha384-woLxKxTkXmKpJX7+ErVWT03Z7w5eRxBGtuowTxMN//liTsTBWV8VUYQJPMTaa4+7",
        "darwin-arm64": "sha384-F0PSGMGY7EufmExwWQT2U4XUAgl3/0+ad12MiozqVgbG8UP8mRLqeFTPZOIvx6Uj",
        "linux-64": "sha384-XNxpr9MuNX2YvacFpzrD+mE4oJp9pxFDvuqY9lZJG9gy5KCl2s0AyRRSXNM21nfN",
        "linux-arm64": "sha384-ObL7+oHS+UwJHdGgKdhmyEHghYYCZASyPM9u1ow5VgRLvwPM2ZUcCmLAC+H6wHXR",
        "windows-64": "sha384-PPbos4lVK1LDbtdVD74KvVv09AvSHbja5EDYtdRd33kV+Sb6dmPg9w/m5wzvBIvi",
    },
    "0.11.20": {
        "npm": "sha512-QOZrVpN/Yz74xfat0H6euSgn3RnwLevY1mJTEXneukz1ln9qB+ieaerRMzSeETpz/UJWsBMzRVR/andBht5WKw==",
        "darwin-64": "sha512-p1OH7glXN/ty1Vz9DzJqscV56Li7WvMAfAlqwEis9QlMZAmofYZZjmF+OoHNaz5gBmHX0LWsAhZLBRL1ZmNsIw==",
        "darwin-arm64": "sha512-xCEKJ9u2rvprrcIlA0GLr8cpvc+7cxZfUPcFbGsxyGSI+60Sp2LMgzkuT0ZbbrbJXU5lICRqNlRBo+UesRcR+w==",
        "linux-64": "sha512-SMRaWXR8CSzz6eFZkJ7749TAPWzDVx/y9GnxvxMNpJ6cIVHMDdB46zDEv6KBcRKvDXvUVWptlB0F2e7rgD74cA==",
        "linux-arm64": "sha512-Uh6Vv5L0TVAUprlxvIONMp+MDYUjvENEyStAV+/ahd9C6orTOPWNBDrKkLDGUgvBjQ9BHSfxxmrh/YyB9oMNww==",
        "windows-64": "sha512-NTZeBldPO86GA1iHgi/IyUy4g2gN1APgHSD5OCo1UBd8cQc6b62zjvvstTZnWrg7tBKoU4YrYHcbRkMXzjzBYg==",
    },
}
