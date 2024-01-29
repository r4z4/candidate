### OpenSecrets

{"response":{"legislator":[
    {"@attributes":
        {"cid":"N00050145",
            "firstlast":"Mike Flood",
            "lastname":"Flood",
            "party":"R",
            "office":"NE01",
            "gender":"M",
            "first_elected":"2022",
            "exit_code":"0",
            "comments":"",
            "phone":"",
            "fax":"",
            "website":"",
            "webform":"",
            "congress_office":"",
            "bioguide_id":"F000474",
            "votesmart_id":"",
            "feccandid":"H2NE01118",
            "twitter_id":"",
            "youtube_url":"",
            "facebook_id":"",
            "birthdate":""}
        },
            {"@attributes":
                {"cid":"N00037049",
                    "firstlast":"Don Bacon","lastname":"Bacon","party":"R","office":"NE02","gender":"M","first_elected":"2016","exit_code":"0","comments":"","phone":"202-225-4155","fax":"","website":"https:\/\/bacon.house.gov","webform":"","congress_office":"1516 Longworth House Office Building","bioguide_id":"B001298","votesmart_id":"","feccandid":"H6NE02125","twitter_id":"RepDonBacon","youtube_url":"","facebook_id":"RepDonBacon","birthdate":"1963-08-16"}
                },
            {"@attributes":
                {"cid":"N00027623",
                    "firstlast":"Adrian Smith"
                    ...
                },
            ...
            }
        ]
    }
}



# CandidateSummary ->


{"response":{"summary":{"@attributes":{"cand_name":"Flood, Mike","cid":"N00050145","cycle":"2022","state":"","party":"R","chamber":"","first_elected":"","next_election":"2022","total":"2161515.04","spent":"2154643.28","cash_on_hand":"6871.76","debt":"280511.13","origin":"OpenSecrets","source":"https:\/\/www.opensecrets.org\/members-of-congress\/summary?cid=N00050145&cycle=2022","last_updated":"12\/31\/2022"}}}}


# Canddiate Contributions ->

{"response":
{"contributors":
{"@attributes":
  {"cand_name":"Mike Flood (R)",
    "cid":"N00050145",
    "cycle":"2022",
    "origin":"OpenSecrets",
    "source":"https:\/\/www.opensecrets.org\/members-of-congress\/contributors?cid=N00050145&cycle=2022",
    "notice":"The organizations themselves did not donate, rather the money came from the organization's PAC, its individual members or employees or owners, and those individuals' immediate families."},
    "contributor":
	[
        {"@attributes":{"org_name":"Crete Carrier Corp","total":"33850","pacs":"0","indivs":"33850"}},
        {"@attributes":{"org_name":"Tenaska Inc","total":"32800","pacs":"10000","indivs":"22800"}},
        {"@attributes":{"org_name":"Peter Kiewit Sons","total":"29000","pacs":"0","indivs":"29000"}},
        {"@attributes":{"org_name":"Dinkel Implement","total":"28600","pacs":"0","indivs":"28600"}},
        {"@attributes":{"org_name":"Norfolk Iron & Metal","total":"23500","pacs":"0","indivs":"23500"}},
        {"@attributes":{"org_name":"Baxter Auto Group","total":"22800","pacs":"0","indivs":"22800"}},
        {"@attributes":{"org_name":"Hawkins Construction","total":"21600","pacs":"0","indivs":"21600"}},
        {"@attributes":{"org_name":"Private Chef & Consultant","total":"20300","pacs":"0","indivs":"20300"}},
        {"@attributes":{"org_name":"Union Pacific Corp","total":"17500","pacs":"15000","indivs":"2500"}},
        {"@attributes":{"org_name":"Pillen Family Farms","total":"17400","pacs":"0","indivs":"17400"}}
	]
}}}

-------------

### LegiScan

# https://api.legiscan.com/?key=e9ed763702d52dcfdd76997f19bf1324&op=getSessionList&state=NE ->

{"status":"OK","sessions":[
  {"session_id":2028,
    "state_id":27,
    "year_start":2023,
    "year_end":2024,
    "prefile":0,
    "sine_die":0,
    "prior":0,
    "special":0,
    "session_tag":"Regular Session",
    "session_title":"2023-2024 Regular Session",
    "session_name":"108th Legislature",
    "dataset_hash":"8098674edcbf5a1d3d4fda7b5c07f162",
    "session_hash":"8098674edcbf5a1d3d4fda7b5c07f162",
    "name":"108th Legislature"},
    ...
  {"session_id":1810,
    "state_id":27,
    "year_start":2021,
    "year_end":2022,
    ...
    "name":"101st Legislature"}]}

# https://api.legiscan.com/?key=e9ed763702d52dcfdd76997f19bf1324&op=getSessionPeople&id=2028 ->


{"status":"OK","sessionpeople":
    {"session":
        {"session_id":2028,
        "state_id":27,
        "year_start":2023,
        "year_end":2024,
        "prefile":0,
        "sine_die":0,
        "prior":0,
        "special":0,
        "session_tag":"Regular Session",
        "session_title":"2023-2024 Regular Session",
        "session_name":"108th Legislature"},
        "people":[
          {"people_id":6952,
            "person_hash":"722fmdo6",
            "party_id":"6",
            "state_id":27,
            "party":"N",
            "role_id":2,
            "role":"Sen",
            "name":"Danielle Conrad",
            "first_name":"Danielle",
            "middle_name":"",
            "last_name":"Conrad",
            "suffix":"",
            "nickname":"",
            "district":"SD-046",
            "ftm_eid":6561877,
            "votesmart_id":56695,
            "opensecrets_id":"",
            "knowwho_pid":248942,
            "ballotpedia":"Danielle_Conrad",
            "bioguide_id":"",
            "committee_sponsor":0,
            "committee_id":0,
            "state_federal":0},
          {"people_id":6957,
          "person_hash":"xekn8d7a"
          ...}
        ]
    }
}