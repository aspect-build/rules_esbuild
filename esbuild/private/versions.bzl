"""Info for the esbuild packages used"""

# Use /scripts/mirror_release.sh to add a newer version below.
# Versions should be ascending order so TOOL_VERSIONS.keys()[-1] is the latest version.
TOOL_VERSIONS = {
    "0.11.20": {
        "darwin-64": "sha512-p1OH7glXN/ty1Vz9DzJqscV56Li7WvMAfAlqwEis9QlMZAmofYZZjmF+OoHNaz5gBmHX0LWsAhZLBRL1ZmNsIw==",
        "darwin-arm64": "sha512-xCEKJ9u2rvprrcIlA0GLr8cpvc+7cxZfUPcFbGsxyGSI+60Sp2LMgzkuT0ZbbrbJXU5lICRqNlRBo+UesRcR+w==",
        "linux-64": "sha512-SMRaWXR8CSzz6eFZkJ7749TAPWzDVx/y9GnxvxMNpJ6cIVHMDdB46zDEv6KBcRKvDXvUVWptlB0F2e7rgD74cA==",
        "linux-arm64": "sha512-Uh6Vv5L0TVAUprlxvIONMp+MDYUjvENEyStAV+/ahd9C6orTOPWNBDrKkLDGUgvBjQ9BHSfxxmrh/YyB9oMNww==",
        "windows-64": "sha512-NTZeBldPO86GA1iHgi/IyUy4g2gN1APgHSD5OCo1UBd8cQc6b62zjvvstTZnWrg7tBKoU4YrYHcbRkMXzjzBYg==",
    },
    "0.13.12": {
        "darwin-64": "sha384-woLxKxTkXmKpJX7+ErVWT03Z7w5eRxBGtuowTxMN//liTsTBWV8VUYQJPMTaa4+7",
        "darwin-arm64": "sha384-F0PSGMGY7EufmExwWQT2U4XUAgl3/0+ad12MiozqVgbG8UP8mRLqeFTPZOIvx6Uj",
        "linux-64": "sha384-XNxpr9MuNX2YvacFpzrD+mE4oJp9pxFDvuqY9lZJG9gy5KCl2s0AyRRSXNM21nfN",
        "linux-arm64": "sha384-ObL7+oHS+UwJHdGgKdhmyEHghYYCZASyPM9u1ow5VgRLvwPM2ZUcCmLAC+H6wHXR",
        "windows-64": "sha384-PPbos4lVK1LDbtdVD74KvVv09AvSHbja5EDYtdRd33kV+Sb6dmPg9w/m5wzvBIvi",
    },
    "0.14.36": {
        "darwin-64": "sha512-kkl6qmV0dTpyIMKagluzYqlc1vO0ecgpviK/7jwPbRDEv5fejRTaBBEE2KxEQbTHcLhiiDbhG7d5UybZWo/1zQ==",
        "darwin-arm64": "sha512-q8fY4r2Sx6P0Pr3VUm//eFYKVk07C5MHcEinU1BjyFnuYz4IxR/03uBbDwluR6ILIHnZTE7AkTUWIdidRi1Jjw==",
        "linux-64": "sha512-vFVFS5ve7PuwlfgoWNyRccGDi2QTNkQo/2k5U5ttVD0jRFaMlc8UQee708fOZA6zTCDy5RWsT5MJw3sl2X6KDg==",
        "linux-arm64": "sha512-24Vq1M7FdpSmaTYuu1w0Hdhiqkbto1I5Pjyi+4Cdw5fJKGlwQuw+hWynTcRI/cOZxBcBpP21gND7W27gHAiftw==",
        "windows-64": "sha512-+p4MuRZekVChAeueT1Y9LGkxrT5x7YYJxYE8ZOTcEfeUUN43vktSn6hUNsvxzzATrSgq5QqRdllkVBxWZg7KqQ==",
    },
    "0.14.39": {
        "darwin-64": "sha512-ImT6eUw3kcGcHoUxEcdBpi6LfTRWaV6+qf32iYYAfwOeV+XaQ/Xp5XQIBiijLeo+LpGci9M0FVec09nUw41a5g==",
        "darwin-arm64": "sha512-/fcQ5UhE05OiT+bW5v7/up1bDsnvaRZPJxXwzXsMRrr7rZqPa85vayrD723oWMT64dhrgWeA3FIneF8yER0XTw==",
        "linux-64": "sha512-4tcgFDYWdI+UbNMGlua9u1Zhu0N5R6u9tl5WOM8aVnNX143JZoBZLpCuUr5lCKhnD0SCO+5gUyMfupGrHtfggQ==",
        "linux-arm64": "sha512-23pc8MlD2D6Px1mV8GMglZlKgwgNKAO8gsgsLLcXWSs9lQsCYkIlMo/2Ycfo5JrDIbLdwgP8D2vpfH2KcBqrDQ==",
        "windows-64": "sha512-E2wm+5FwCcLpKsBHRw28bSYQw0Ikxb7zIMxw3OPAkiaQhLVr3dnVO8DofmbWhhf6b97bWzg37iSZ45ZDpLw7Ow==",
    },
    "0.14.51": {
        "darwin-64": "sha512-YFmXPIOvuagDcwCejMRtCDjgPfnDu+bNeh5FU2Ryi68ADDVlWEpbtpAbrtf/lvFTWPexbgyKgzppNgsmLPr8PA==",
        "darwin-arm64": "sha512-juYD0QnSKwAMfzwKdIF6YbueXzS6N7y4GXPDeDkApz/1RzlT42mvX9jgNmyOlWKN7YzQAYbcUEJmZJYQGdf2ow==",
        "linux-64": "sha512-dxjhrqo5i7Rq6DXwz5v+MEHVs9VNFItJmHBe1CxROWNf4miOGoQhqSG8StStbDkQ1Mtobg6ng+4fwByOhoQoeA==",
        "linux-arm64": "sha512-D9rFxGutoqQX3xJPxqd6o+kvYKeIbM0ifW2y0bgKk5HPgQQOo2k9/2Vpto3ybGYaFPCE5qTGtqQta9PoP6ZEzw==",
        "windows-64": "sha512-HoN/5HGRXJpWODprGCgKbdMvrC3A2gqvzewu2eECRw2sYxOUoh2TV1tS+G7bHNapPGI79woQJGV6pFH7GH7qnA==",
    },
    "0.15.13": {
        "darwin-64": "sha512-WAx7c2DaOS6CrRcoYCgXgkXDliLnFv3pQLV6GeW1YcGEZq2Gnl8s9Pg7ahValZkpOa0iE/ojRVQ87sbUhF1Cbg==",
        "darwin-arm64": "sha512-U6jFsPfSSxC3V1CLiQqwvDuj3GGrtQNB3P3nNC3+q99EKf94UGpsG9l4CQ83zBs1NHrk1rtCSYT0+KfK5LsD8A==",
        "linux-64": "sha512-rXmnArVNio6yANSqDQlIO4WiP+Cv7+9EuAHNnag7rByAqFVuRusLbGi2697A5dFPNXoO//IiogVwi3AdcfPC6A==",
        "linux-arm64": "sha512-alEMGU4Z+d17U7KQQw2IV8tQycO6T+rOrgW8OS22Ua25x6kHxoG6Ngry6Aq6uranC+pNWNMB6aHFPh7aTQdORQ==",
        "windows-64": "sha512-Et6htEfGycjDrtqb2ng6nT+baesZPYQIW+HUEHK4D1ncggNrDNk3yoboYQ5KtiVrw/JaDMNttz8rrPubV/fvPQ==",
    },
    "0.16.7": {
        "darwin-x64": "sha512-duterlv3tit3HI9vhzMWnSVaB1B6YsXpFq1Ntd6Fou82BB1l4tucYy3FI9dHv3tvtDuS0NiGf/k6XsdBqPZ01w==",
        "darwin-arm64": "sha512-VUb9GK23z8jkosHU9yJNUgQpsfJn+7ZyBm6adi2Ec5/U241eR1tAn82QicnUzaFDaffeixiHwikjmnec/YXEZg==",
        "linux-x64": "sha512-xi/tbqCqvPIzU+zJVyrpz12xqciTAPMi2fXEWGnapZymoGhuL2GIWIRXg4O2v5BXaYA5TSaiKYE14L0QhUTuQg==",
        "linux-arm64": "sha512-2wv0xYDskk2+MzIm/AEprDip39a23Chptc4mL7hsHg26P0gD8RUhzmDu0KCH2vMThUI1sChXXoK9uH0KYQKaDg==",
        "win32-x64": "sha512-QaQ8IH0JLacfGf5cf0HCCPnQuCTd/dAI257vXBgb/cccKGbH/6pVtI1gwhdAQ0Y48QSpTIFrh9etVyNdZY+zzw==",
    },
    "0.17.4": {
        "darwin-x64": "sha512-phQuC2Imrb3TjOJwLN8EO50nb2FHe8Ew0OwgZDH1SV6asIPGudnwTQtighDF2EAYlXChLoMJwqjAp4vAaACq6w==",
        "darwin-arm64": "sha512-tTyJRM9dHvlMPt1KrBFVB5OW1kXOsRNvAPtbzoKazd5RhD5/wKlXk1qR2MpaZRYwf4WDMadt0Pv0GwxB41CVow==",
        "linux-x64": "sha512-+AsFBwKgQuhV2shfGgA9YloxLDVjXgUEWZum7glR5lLmV94IThu/u2JZGxTgjYby6kyXEx8lKOqP5rTEVBR0Rw==",
        "linux-arm64": "sha512-UkGfQvYlwOaeYJzZG4cLV0hCASzQZnKNktRXUo3/BMZvdau40AOz9GzmGA063n1piq6VrFFh43apRDQx8hMP2w==",
        "win32-x64": "sha512-0kLAjs+xN5OjhTt/aUA6t48SfENSCKgGPfExADYTOo/UCn0ivxos9/anUVeSfg+L+2O9xkFxvJXIJfG+Q4sYSg==",
    },
    "0.17.10": {
        "darwin-x64": "sha512-J4MJzGchuCRG5n+B4EHpAMoJmBeAE1L3wGYDIN5oWNqX0tEr7VKOzw0ymSwpoeSpdCa030lagGUfnfhS7OvzrQ==",
        "darwin-arm64": "sha512-3HaGIowI+nMZlopqyW6+jxYr01KvNaLB5znXfbyyjuo4lE0VZfvFGcguIJapQeQMS4cX/NEispwOekJt3gr5Dg==",
        "linux-x64": "sha512-zJUfJLebCYzBdIz/Z9vqwFjIA7iSlLCFvVi7glMgnu2MK7XYigwsonXshy9wP9S7szF+nmwrelNaP3WGanstEg==",
        "linux-arm64": "sha512-g1EZJR1/c+MmCgVwpdZdKi4QAJ8DCLP5uTgLWSAVd9wlqk9GMscaNMEViG3aE1wS+cNMzXXgdWiW/VX4J+5nTA==",
        "win32-x64": "sha512-oP+zFUjYNaMNmjTwlFtWep85hvwUu19cZklB3QsBOcZSs6y7hmH4LNCJ7075bsqzYaNvZFXJlAVaQ2ApITDXtw==",
    },
}
